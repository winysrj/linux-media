Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbcGHNEA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 52/54] doc-rst: auto-generate: fixed include "output/*.h.rst" content
Date: Fri,  8 Jul 2016 10:03:44 -0300
Message-Id: <580e96c78bd62b94c9178ef60f85380685264269.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Include auto-generate reST header files. BTW fixed linux_tv/Makefile.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/Makefile                 | 7 +++++--
 Documentation/linux_tv/media/dvb/audio_h.rst    | 6 +-----
 Documentation/linux_tv/media/dvb/ca_h.rst       | 6 +-----
 Documentation/linux_tv/media/dvb/dmx_h.rst      | 6 +-----
 Documentation/linux_tv/media/dvb/frontend_h.rst | 6 +-----
 Documentation/linux_tv/media/dvb/net_h.rst      | 6 +-----
 Documentation/linux_tv/media/dvb/video_h.rst    | 6 +-----
 Documentation/linux_tv/media/v4l/videodev.rst   | 6 +-----
 8 files changed, 12 insertions(+), 37 deletions(-)

diff --git a/Documentation/linux_tv/Makefile b/Documentation/linux_tv/Makefile
index 639b994a50f6..688e37d7b232 100644
--- a/Documentation/linux_tv/Makefile
+++ b/Documentation/linux_tv/Makefile
@@ -9,7 +9,10 @@ FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
 
 TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
 
-htmldocs: ${TARGETS}
+htmldocs: $(BUILDDIR) ${TARGETS}
+
+$(BUILDDIR):
+	$(Q)mkdir -p $@
 
 # Rule to convert a .h file to inline RST documentation
 
@@ -40,7 +43,7 @@ $(BUILDDIR)/net.h.rst: ${UAPI}/dvb/net.h ${PARSER} $(SRC_DIR)/net.h.rst.exceptio
 $(BUILDDIR)/video.h.rst: ${UAPI}/dvb/video.h ${PARSER} $(SRC_DIR)/video.h.rst.exceptions
 	@$($(quiet)gen_rst)
 
-videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} $(SRC_DIR)/videodev2.h.rst.exceptions
+$(BUILDDIR)/videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} $(SRC_DIR)/videodev2.h.rst.exceptions
 	@$($(quiet)gen_rst)
 
 cleandocs:
diff --git a/Documentation/linux_tv/media/dvb/audio_h.rst b/Documentation/linux_tv/media/dvb/audio_h.rst
index bdd9a709a125..d87be5e2b022 100644
--- a/Documentation/linux_tv/media/dvb/audio_h.rst
+++ b/Documentation/linux_tv/media/dvb/audio_h.rst
@@ -6,8 +6,4 @@
 DVB Audio Header File
 *********************
 
-
-.. toctree::
-    :maxdepth: 1
-
-    ../../audio.h
+.. include:: ../../../output/audio.h.rst
diff --git a/Documentation/linux_tv/media/dvb/ca_h.rst b/Documentation/linux_tv/media/dvb/ca_h.rst
index a7d22154022b..407f840ae2ee 100644
--- a/Documentation/linux_tv/media/dvb/ca_h.rst
+++ b/Documentation/linux_tv/media/dvb/ca_h.rst
@@ -6,8 +6,4 @@
 DVB Conditional Access Header File
 **********************************
 
-
-.. toctree::
-    :maxdepth: 1
-
-    ../../ca.h
+.. include:: ../../../output/ca.h.rst
diff --git a/Documentation/linux_tv/media/dvb/dmx_h.rst b/Documentation/linux_tv/media/dvb/dmx_h.rst
index baf129dd078b..65ee8f095972 100644
--- a/Documentation/linux_tv/media/dvb/dmx_h.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_h.rst
@@ -6,8 +6,4 @@
 DVB Demux Header File
 *********************
 
-
-.. toctree::
-    :maxdepth: 1
-
-    ../../dmx.h
+.. include:: ../../../output/dmx.h.rst
diff --git a/Documentation/linux_tv/media/dvb/frontend_h.rst b/Documentation/linux_tv/media/dvb/frontend_h.rst
index 7101d6ddd916..97735b241f3c 100644
--- a/Documentation/linux_tv/media/dvb/frontend_h.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_h.rst
@@ -6,8 +6,4 @@
 DVB Frontend Header File
 ************************
 
-
-.. toctree::
-    :maxdepth: 1
-
-    ../../frontend.h
+.. include:: ../../../output/frontend.h.rst
diff --git a/Documentation/linux_tv/media/dvb/net_h.rst b/Documentation/linux_tv/media/dvb/net_h.rst
index 09560db4e1c0..5a5a797882f2 100644
--- a/Documentation/linux_tv/media/dvb/net_h.rst
+++ b/Documentation/linux_tv/media/dvb/net_h.rst
@@ -6,8 +6,4 @@
 DVB Network Header File
 ***********************
 
-
-.. toctree::
-    :maxdepth: 1
-
-    ../../net.h
+.. include:: ../../../output/net.h.rst
diff --git a/Documentation/linux_tv/media/dvb/video_h.rst b/Documentation/linux_tv/media/dvb/video_h.rst
index 45c12d295523..9d649a7e0f8b 100644
--- a/Documentation/linux_tv/media/dvb/video_h.rst
+++ b/Documentation/linux_tv/media/dvb/video_h.rst
@@ -6,8 +6,4 @@
 DVB Video Header File
 *********************
 
-
-.. toctree::
-    :maxdepth: 1
-
-    ../../video.h
+.. include:: ../../../output/video.h.rst
diff --git a/Documentation/linux_tv/media/v4l/videodev.rst b/Documentation/linux_tv/media/v4l/videodev.rst
index 4826416b2ab4..82bac4a0b760 100644
--- a/Documentation/linux_tv/media/v4l/videodev.rst
+++ b/Documentation/linux_tv/media/v4l/videodev.rst
@@ -6,8 +6,4 @@
 Video For Linux Two Header File
 *******************************
 
-
-.. toctree::
-    :maxdepth: 1
-
-    ../../videodev2.h
+.. include:: ../../../output/videodev2.h.rst
-- 
2.7.4

