Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbcGHNEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 51/54] doc-rst: linux_tv/Makefile: Honor quiet mode
Date: Fri,  8 Jul 2016 10:03:43 -0300
Message-Id: <573720f07b3bb5e89168406f890a5e54a448d307.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup the Makefile and handle the V=1 flag and make it
to work when specifying an output directory with O=dir

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/Makefile.sphinx   |  2 +-
 Documentation/linux_tv/Makefile | 49 +++++++++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 37cec114254e..6a093e4397b4 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -35,7 +35,7 @@ quiet_cmd_sphinx = SPHINX  $@
       cmd_sphinx = $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(BUILDDIR)/$2
 
 htmldocs:
-	$(MAKE) -C $(srctree)/Documentation/linux_tv $@
+	$(MAKE) BUILDDIR=$(objtree)/$(BUILDDIR) -f $(srctree)/Documentation/linux_tv/Makefile $@
 	$(call cmd,sphinx,html)
 
 pdfdocs:
diff --git a/Documentation/linux_tv/Makefile b/Documentation/linux_tv/Makefile
index 068e26e0cc6f..639b994a50f6 100644
--- a/Documentation/linux_tv/Makefile
+++ b/Documentation/linux_tv/Makefile
@@ -1,32 +1,47 @@
 # Generate the *.h.rst files from uAPI headers
 
-PARSER = ../sphinx/parse-headers.pl
-UAPI = ../../include/uapi/linux
-TARGETS = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
+PARSER = $(srctree)/Documentation/sphinx/parse-headers.pl
+UAPI = $(srctree)/include/uapi/linux
+SRC_DIR=$(srctree)/Documentation/linux_tv
+
+FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
 	  videodev2.h.rst
 
+TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
+
 htmldocs: ${TARGETS}
 
-audio.h.rst: ${PARSER} ${UAPI}/dvb/audio.h  audio.h.rst.exceptions
-	${PARSER} ${UAPI}/dvb/audio.h $@ audio.h.rst.exceptions
+# Rule to convert a .h file to inline RST documentation
 
-ca.h.rst: ${PARSER} ${UAPI}/dvb/ca.h  ca.h.rst.exceptions
-	${PARSER} ${UAPI}/dvb/ca.h $@ ca.h.rst.exceptions
+gen_rst = \
+	echo ${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions; \
+	${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions
 
-dmx.h.rst: ${PARSER} ${UAPI}/dvb/dmx.h  dmx.h.rst.exceptions
-	${PARSER} ${UAPI}/dvb/dmx.h $@ dmx.h.rst.exceptions
+quiet_gen_rst = echo '  PARSE   $(patsubst $(srctree)/%,%,$<)'; \
+	${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions
 
-frontend.h.rst: ${PARSER} ${UAPI}/dvb/frontend.h  frontend.h.rst.exceptions
-	${PARSER} ${UAPI}/dvb/frontend.h $@ frontend.h.rst.exceptions
+silent_gen_rst = ${gen_rst}
 
-net.h.rst: ${PARSER} ${UAPI}/dvb/net.h  net.h.rst.exceptions
-	${PARSER} ${UAPI}/dvb/net.h $@ net.h.rst.exceptions
+$(BUILDDIR)/audio.h.rst: ${UAPI}/dvb/audio.h ${PARSER} $(SRC_DIR)/audio.h.rst.exceptions
+	@$($(quiet)gen_rst)
 
-video.h.rst: ${PARSER} ${UAPI}/dvb/video.h  video.h.rst.exceptions
-	${PARSER} ${UAPI}/dvb/video.h $@ video.h.rst.exceptions
+$(BUILDDIR)/ca.h.rst: ${UAPI}/dvb/ca.h ${PARSER} $(SRC_DIR)/ca.h.rst.exceptions
+	@$($(quiet)gen_rst)
 
-videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} videodev2.h.rst.exceptions
-	${PARSER} ${UAPI}/videodev2.h $@ videodev2.h.rst.exceptions
+$(BUILDDIR)/dmx.h.rst: ${UAPI}/dvb/dmx.h ${PARSER} $(SRC_DIR)/dmx.h.rst.exceptions
+	@$($(quiet)gen_rst)
+
+$(BUILDDIR)/frontend.h.rst: ${UAPI}/dvb/frontend.h ${PARSER} $(SRC_DIR)/frontend.h.rst.exceptions
+	@$($(quiet)gen_rst)
+
+$(BUILDDIR)/net.h.rst: ${UAPI}/dvb/net.h ${PARSER} $(SRC_DIR)/net.h.rst.exceptions
+	@$($(quiet)gen_rst)
+
+$(BUILDDIR)/video.h.rst: ${UAPI}/dvb/video.h ${PARSER} $(SRC_DIR)/video.h.rst.exceptions
+	@$($(quiet)gen_rst)
+
+videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} $(SRC_DIR)/videodev2.h.rst.exceptions
+	@$($(quiet)gen_rst)
 
 cleandocs:
 	-rm ${TARGETS}
-- 
2.7.4

