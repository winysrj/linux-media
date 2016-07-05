Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbcGESkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 14:40:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/12] doc-rst: remove Documentation/linux_tv/conf.py file
Date: Tue,  5 Jul 2016 14:59:22 -0300
Message-Id: <5d55cd2ee7a869bbe2d2f9d9bd496b630cd1c847.1467743704.git.mchehab@s-opensource.com>
In-Reply-To: <47d23e363fb034f32551f5fe85add77ceba98d3b.1467740686.git.mchehab@s-opensource.com>
References: <47d23e363fb034f32551f5fe85add77ceba98d3b.1467740686.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467743704.git.mchehab@s-opensource.com>
References: <cover.1467743704.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is actually not used to build the media uAPI docbook.
So, remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/conf.py | 221 -----------------------------------------
 1 file changed, 221 deletions(-)
 delete mode 100644 Documentation/linux_tv/conf.py

diff --git a/Documentation/linux_tv/conf.py b/Documentation/linux_tv/conf.py
deleted file mode 100644
index ea5f6ef25d6b..000000000000
--- a/Documentation/linux_tv/conf.py
+++ /dev/null
@@ -1,221 +0,0 @@
-# -*- coding: utf-8; mode: python -*-
-#
-# This is the project specific sphinx-build configuration, which is loaded from
-# the base configuration file (``../conf.py``). About config values consult:
-#
-# * http://www.sphinx-doc.org/en/stable/config.html
-#
-# While setting values here, please take care to not overwrite common needed
-# configurations. This means, do not *overwrite* composite values (e.g. the
-# list- or dictionary-value of "latex_elements" resp. "extensions") by
-# thoughtless assignments. Manipulate composite values always by *update*
-# (dict-values) or extend (list-values). Nevertheless, if you know what you are
-# doing, you are free to *overwrite* values to your needs.
-#
-# useful preset names:
-#
-# * BASE_FOLDER: the folder where the top conf.py is located
-# * main_name:   the basename of this project-folder
-
-# Set parser's default kernel-doc mode ``reST|kernel-doc``.
-kernel_doc_mode = "kernel-doc"
-
-# ------------------------------------------------------------------------------
-# General configuration
-# ------------------------------------------------------------------------------
-
-project   = u'LINUX MEDIA INFRASTRUCTURE API'
-copyright = u'2009-2016 : LinuxTV Developers'
-author    = u'The LinuxTV Developers'
-
-# The version info for the project you're documenting, acts as replacement for
-# |version| and |release|, also used in various other places throughout the
-# built documents.
-#
-# The short X.Y version.
-#version   = 'v4.7'
-# The full version, including alpha/beta/rc tags.
-#release   = 'v4.7-rc2'
-
-# extlinks["man"] = ('http://manpages.ubuntu.com/cgi-bin/search.py?q=%s', ' ')
-
-# intersphinx_mapping['kernel-doc'] = ('http://return42.github.io/sphkerneldoc/books/kernel-doc-HOWTO/', None)
-
-extensions.extend([
-    # 'sphinx.ext.pngmath'
-    #, 'sphinx.ext.mathjax'
-])
-
-# ------------------------------------------------------------------------------
-# Options for HTML output
-# ------------------------------------------------------------------------------
-
-# The name for this set of Sphinx documents.  If None, it defaults to
-# "<project> v<release> documentation".
-#html_title = None
-
-# A shorter title for the navigation bar.  Default is the same as html_title.
-#html_short_title = None
-
-# The name of an image file (relative to this directory) to place at the top
-# of the sidebar.
-#html_logo = pathjoin(BASE_FOLDER, "_tex", "logo.png")
-
-# The name of an image file (within the static path) to use as favicon of the
-# docs.  This file should be a Windows icon file (.ico) being 16x16 or 32x32
-# pixels large.
-#html_favicon = None
-
-# Add any paths that contain custom static files (such as style sheets) here,
-# relative to this directory. They are copied after the builtin static files,
-# so a file named "default.css" will overwrite the builtin "default.css".
-html_static_path.extend([])
-
-# Output file base name for HTML help builder.
-htmlhelp_basename = main_name
-
-# ------------------------------------------------------------------------------
-# Options for rst2pdf output
-# ------------------------------------------------------------------------------
-
-# Grouping the document tree into PDF files. List of tuples
-# (source start file, target name, title, author, options).
-#
-# The options element is a dictionary that lets you override
-# this config per-document.
-# For example,
-# ('index', u'MyProject', u'My Project', u'Author Name',
-#  dict(pdf_compressed = True))
-# would mean that specific document would be compressed
-# regardless of the global pdf_compressed setting.
-#
-# further:  http://rst2pdf.ralsina.me/handbook.html#sphinx
-
-# FIXME: at this time, the rst2pdf fails with a bug
-#pdf_documents = [
-#    (master_doc, main_name, project, author)
-#    , ]
-
-# If false, no index is generated.
-pdf_use_index = False
-
-# How many levels deep should the table of contents be?
-pdf_toc_depth = 3
-
-# Add section number to section references
-pdf_use_numbered_links = False
-
-# Background images fitting mode
-pdf_fit_background_mode = 'scale'
-
-
-# ------------------------------------------------------------------------------
-# Options for manual page output
-# ------------------------------------------------------------------------------
-
-# One entry per manual page. List of tuples
-# (source start file, name, description, authors, manual section).
-# man_pages = [
-#     (master_doc, 'kernel-doc', u'Kernel-Doc',
-#      [author], 1)
-# ]
-
-# If true, show URL addresses after external links.
-#man_show_urls = False
-
-# ------------------------------------------------------------------------------
-# Options for Texinfo output
-# ------------------------------------------------------------------------------
-
-# Grouping the document tree into Texinfo files. List of tuples
-# (source start file, target name, title, author,
-#  dir menu entry, description, category)
-# texinfo_documents = [
-#     (master_doc, 'Kernel-Doc', u'Kernel-Doc Documentation',
-#      author, 'Kernel-Doc', 'One line description of project.',
-#      'Miscellaneous'),
-# ]
-
-# Documents to append as an appendix to all manuals.
-#texinfo_appendices = []
-
-# If false, no module index is generated.
-#texinfo_domain_indices = True
-
-# How to display URL addresses: 'footnote', 'no', or 'inline'.
-#texinfo_show_urls = 'footnote'
-
-# If true, do not generate a @detailmenu in the "Top" node's menu.
-#texinfo_no_detailmenu = False
-
-# ------------------------------------------------------------------------------
-# Options for Epub output
-# ------------------------------------------------------------------------------
-
-# Bibliographic Dublin Core info.
-# epub_title = project
-# epub_author = author
-# epub_publisher = author
-# epub_copyright = copyright
-
-# The basename for the epub file. It defaults to the project name.
-#epub_basename = project
-
-# The HTML theme for the epub output. Since the default themes are not
-# optimized for small screen space, using the same theme for HTML and epub
-# output is usually not wise. This defaults to 'epub', a theme designed to save
-# visual space.
-#epub_theme = 'epub'
-
-# The language of the text. It defaults to the language option
-# or 'en' if the language is not set.
-#epub_language = ''
-
-# The scheme of the identifier. Typical schemes are ISBN or URL.
-#epub_scheme = ''
-
-# The unique identifier of the text. This can be a ISBN number
-# or the project homepage.
-#epub_identifier = ''
-
-# A unique identification for the text.
-#epub_uid = ''
-
-# A tuple containing the cover image and cover page html template filenames.
-#epub_cover = ()
-
-# A sequence of (type, uri, title) tuples for the guide element of content.opf.
-#epub_guide = ()
-
-# HTML files that should be inserted before the pages created by sphinx.
-# The format is a list of tuples containing the path and title.
-#epub_pre_files.extend([])
-
-# HTML files that should be inserted after the pages created by sphinx.
-# The format is a list of tuples containing the path and title.
-#epub_post_files.extend([])
-
-# A list of files that should not be packed into the epub file.
-epub_exclude_files.extend([])
-
-# The depth of the table of contents in toc.ncx.
-#epub_tocdepth = 3
-
-# Allow duplicate toc entries.
-#epub_tocdup = True
-
-# Choose between 'default' and 'includehidden'.
-#epub_tocscope = 'default'
-
-# Fix unsupported image types using the Pillow.
-#epub_fix_images = False
-
-# Scale large images.
-#epub_max_image_width = 0
-
-# How to display URL addresses: 'footnote', 'no', or 'inline'.
-#epub_show_urls = 'inline'
-
-# If false, no index is generated.
-#epub_use_index = True
-
-- 
2.7.4

