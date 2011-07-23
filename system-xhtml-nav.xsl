<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml">

  <!--
      This xslt file creates a XHTML 1.1 file with a bread crumb, a
      dynamic menu and the content from the data element of the xml
      file.
  -->

  <xsl:output method="xml" version="1.0" encoding="utf-8" 
	      doctype-public="-//W3C//DTD XHTML 1.1//EN"
	      doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
	      omit-xml-declaration="no"
	      indent="yes"/>

  <xsl:variable name="filename" select="/*[1][name()='data']/@filename"/>
  <xsl:template match="/">
    <html version="-//W3C//DTD XHTML 1.1//EN"
	  xml:lang="en"
	  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	  xsi:schemaLocation="http://www.w3.org/1999/xhtml
                              http://www.w3.org/MarkUp/SCHEMA/xhtml11.xsd"
	  >
      <head>
	<title>My Website</title>
	<meta name="author" content="Author"/>
	<meta name="description" content="My Website"/>
	<meta name="keywords" content="XSLT"/>
	<meta http-equiv="content-type" content="application/xhtml+xml; charset=UTF-8"/>
	<link rel="stylesheet" href="style.css" type="text/css"/>
      </head>
      <body>
	<div id="head">
	  <h1 id="headline"><xsl:text>My Website</xsl:text></h1>
	</div>

	<!-- Create bread crumb -->
	<div id="breadcrumb">
	  <xsl:text>you are here: </xsl:text>
	  <xsl:for-each select="document('menu.xml')//item[@href = $filename]/ancestor::item">
	    <a href="{@href}"><xsl:value-of select="@text"/></a>
	    <xsl:text> : </xsl:text>
	  </xsl:for-each>
	  <xsl:value-of select="document('menu.xml')//item[@href = $filename]/@text"/>
	</div>

	<!-- Create the menu -->
	<div id="menu">
	  <h2 id="nav-headline">Navigation:</h2>
	  <ul id="navigation">
	    <xsl:apply-templates select="document('menu.xml')/menu/item"/>
	  </ul>
	</div>

	<!-- Copy the content in the data element here -->
	<div id="content">
	  <xsl:copy-of select="/*[1][name()='data']/*"/>
	</div>

	<!-- Create the menu -->
	<div id="foot">
	  <p>written by Author</p>
	</div>

      </body>
    </html>
  </xsl:template>

  <!-- menu template -->
  <xsl:template match="item">
    <xsl:choose>
      <xsl:when test="descendant::item[@href = $filename]">
	<li class="item">
	  <a href="{@href}"><xsl:value-of select="@text"/></a>
	  <ul>
	    <xsl:apply-templates select="*"/>
	  </ul>
	</li>
      </xsl:when>
      <xsl:when test="@href = $filename">
	<li id="selected-item">
	  <xsl:value-of select="@text"/>
	  <!-- if this node contains child nodes, apply the template
	  to the child nodes -->
	  <xsl:if test="node()">
	    <ul>
	      <xsl:apply-templates select="*"/>
	    </ul>
	  </xsl:if>
	</li>
      </xsl:when>
      <xsl:otherwise>
	<li class="item">
	  <a href="{@href}"><xsl:value-of select="@text"/></a>
	</li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
