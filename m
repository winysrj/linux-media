Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47018
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbcGSPkb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:40:31 -0400
Date: Tue, 19 Jul 2016 12:40:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST
 format
Message-ID: <20160719124024.3d953710@recife.lan>
In-Reply-To: <20160719115319.316349a7@recife.lan>
References: <cover.1468865380.git.mchehab@s-opensource.com>
	<578DF08F.8080701@xs4all.nl>
	<20160719081259.482a8c04@recife.lan>
	<6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
	<20160719115319.316349a7@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Jul 2016 11:53:19 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Yet, this doesn't solve the specific issue for the TOC index
> name. How this could be done in a way that would be backward
> compatible to 1.2.x?

Answering myself, the following patch should trick Sphinx to
allow the media books to be built against older versions of
the toolchain.

Regards,
Mauro


[PATCH] [media] doc-rst: backward compatibility with older Sphinx
 versions

Sphinx is really evil when an older version finds an extra
attribute for the :toctree: tag: it simply ignores everything
and produce documents without any chapter inside!

As we're now using tags available only on Sphinx 1.4.x, we
need to use some creative ways to add a title before the
table of contents. Do that by using a css class.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index e1d4d87f2a47..e4c2e74db9dc 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -14,12 +14,13 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
+.. class:: toc-title
+
+	Table of Contents
 
 .. toctree::
 	:maxdepth: 5
 	:numbered:
-	:caption: Table of Contents
-	:name: dvb_mastertoc
 
 	intro
 	avermedia
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index 0af80e90b7b5..5414d2a7dfb8 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -14,11 +14,13 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
+.. class:: toc-title
+
+        Table of Contents
+
 .. toctree::
     :maxdepth: 5
     :numbered:
-    :caption: Table of Contents
-    :name: kapi_mastertoc
 
     kapi/v4l2-framework
     kapi/v4l2-controls
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index debe4531040b..aaa9a0e387c4 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -14,11 +14,12 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
+.. class:: toc-title
+
+        Table of Contents
 
 .. toctree::
     :maxdepth: 5
-    :caption: Table of Contents
-    :name: uapi_mastertoc
 
     intro
     uapi/v4l/v4l2
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 8d1710234e5a..2aab653905ce 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -14,12 +14,13 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
+.. class:: toc-title
+
+        Table of Contents
 
 .. toctree::
 	:maxdepth: 5
 	:numbered:
-	:caption: Table of Contents
-	:name: v4l_mastertoc
 
 	fourcc
 	v4l-with-ir
diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index c97d8428302d..3a2ac4bcfd78 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -31,6 +31,11 @@
      *   - hide the permalink symbol as long as link is not hovered
      */
 
+    .toc-title {
+        font-size: 150%;
+	font-weight: bold;
+    }
+
     caption, .wy-table caption, .rst-content table.field-list caption {
         font-size: 100%;
     }
