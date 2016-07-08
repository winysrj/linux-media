Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41292 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbcGHNEA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 54/54] doc-rst: linux_tv/Makefile: Honor quiet make O=dir
Date: Fri,  8 Jul 2016 10:03:46 -0300
Message-Id: <627e32df1a3e88d48c10be85e6561537ad0f4952.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

To honor the:

  make O=dir [targets] Locate all output files in "dir"

* activate kernel-include directive
* export BUILDDIR=$(BUILDDIR)
* linux_tv: replace '.. include::' with '.. kernel-include:: $BUILDDIR/<foo.h.rst>'

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/Makefile.sphinx                   | 4 ++--
 Documentation/conf.py                           | 2 +-
 Documentation/linux_tv/media/dvb/audio_h.rst    | 4 +++-
 Documentation/linux_tv/media/dvb/ca_h.rst       | 2 +-
 Documentation/linux_tv/media/dvb/dmx_h.rst      | 2 +-
 Documentation/linux_tv/media/dvb/frontend_h.rst | 2 +-
 Documentation/linux_tv/media/dvb/net_h.rst      | 2 +-
 Documentation/linux_tv/media/dvb/video_h.rst    | 2 +-
 Documentation/linux_tv/media/v4l/videodev.rst   | 2 +-
 9 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 6a093e4397b4..5aa2161fc3df 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -32,10 +32,10 @@ ALLSPHINXOPTS   = -D version=$(KERNELVERSION) -D release=$(KERNELRELEASE) -d $(B
 I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
 
 quiet_cmd_sphinx = SPHINX  $@
-      cmd_sphinx = $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(BUILDDIR)/$2
+      cmd_sphinx = BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(BUILDDIR)/$2
 
 htmldocs:
-	$(MAKE) BUILDDIR=$(objtree)/$(BUILDDIR) -f $(srctree)/Documentation/linux_tv/Makefile $@
+	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/linux_tv/Makefile $@
 	$(call cmd,sphinx,html)
 
 pdfdocs:
diff --git a/Documentation/conf.py b/Documentation/conf.py
index f35748b4bc26..224240b5bc50 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -28,7 +28,7 @@ sys.path.insert(0, os.path.abspath('sphinx'))
 # Add any Sphinx extension module names here, as strings. They can be
 # extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
 # ones.
-extensions = ['kernel-doc', 'rstFlatTable']
+extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include']
 
 # Gracefully handle missing rst2pdf.
 try:
diff --git a/Documentation/linux_tv/media/dvb/audio_h.rst b/Documentation/linux_tv/media/dvb/audio_h.rst
index d87be5e2b022..0ea0b41b20ae 100644
--- a/Documentation/linux_tv/media/dvb/audio_h.rst
+++ b/Documentation/linux_tv/media/dvb/audio_h.rst
@@ -6,4 +6,6 @@
 DVB Audio Header File
 *********************
 
-.. include:: ../../../output/audio.h.rst
+.. kernel-include:: $BUILDDIR/audio.h.rst
+
+.. kernel-include:: $BUILDDIR/../../../../etc/adduser.conf
diff --git a/Documentation/linux_tv/media/dvb/ca_h.rst b/Documentation/linux_tv/media/dvb/ca_h.rst
index 407f840ae2ee..f513592ef529 100644
--- a/Documentation/linux_tv/media/dvb/ca_h.rst
+++ b/Documentation/linux_tv/media/dvb/ca_h.rst
@@ -6,4 +6,4 @@
 DVB Conditional Access Header File
 **********************************
 
-.. include:: ../../../output/ca.h.rst
+.. kernel-include:: $BUILDDIR/ca.h.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx_h.rst b/Documentation/linux_tv/media/dvb/dmx_h.rst
index 65ee8f095972..4fd1704a0833 100644
--- a/Documentation/linux_tv/media/dvb/dmx_h.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_h.rst
@@ -6,4 +6,4 @@
 DVB Demux Header File
 *********************
 
-.. include:: ../../../output/dmx.h.rst
+.. kernel-include:: $BUILDDIR/dmx.h.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_h.rst b/Documentation/linux_tv/media/dvb/frontend_h.rst
index 97735b241f3c..15fca04d1c32 100644
--- a/Documentation/linux_tv/media/dvb/frontend_h.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_h.rst
@@ -6,4 +6,4 @@
 DVB Frontend Header File
 ************************
 
-.. include:: ../../../output/frontend.h.rst
+.. kernel-include:: $BUILDDIR/frontend.h.rst
diff --git a/Documentation/linux_tv/media/dvb/net_h.rst b/Documentation/linux_tv/media/dvb/net_h.rst
index 5a5a797882f2..7bcf5ba9d1eb 100644
--- a/Documentation/linux_tv/media/dvb/net_h.rst
+++ b/Documentation/linux_tv/media/dvb/net_h.rst
@@ -6,4 +6,4 @@
 DVB Network Header File
 ***********************
 
-.. include:: ../../../output/net.h.rst
+.. kernel-include:: $BUILDDIR/net.h.rst
diff --git a/Documentation/linux_tv/media/dvb/video_h.rst b/Documentation/linux_tv/media/dvb/video_h.rst
index 9d649a7e0f8b..3f39b0c4879c 100644
--- a/Documentation/linux_tv/media/dvb/video_h.rst
+++ b/Documentation/linux_tv/media/dvb/video_h.rst
@@ -6,4 +6,4 @@
 DVB Video Header File
 *********************
 
-.. include:: ../../../output/video.h.rst
+.. kernel-include:: $BUILDDIR/video.h.rst
diff --git a/Documentation/linux_tv/media/v4l/videodev.rst b/Documentation/linux_tv/media/v4l/videodev.rst
index 82bac4a0b760..b9ee4672d639 100644
--- a/Documentation/linux_tv/media/v4l/videodev.rst
+++ b/Documentation/linux_tv/media/v4l/videodev.rst
@@ -6,4 +6,4 @@
 Video For Linux Two Header File
 *******************************
 
-.. include:: ../../../output/videodev2.h.rst
+.. kernel-include:: $BUILDDIR/videodev2.h.rst
-- 
2.7.4

