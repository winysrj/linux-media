Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41339 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755910AbcJFLqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2016 07:46:50 -0400
Date: Thu, 6 Oct 2016 08:46:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/4] doc-rst: migrated media build kernel-cmd directive
Message-ID: <20161006084641.7cbaf3cf@vento.lan>
In-Reply-To: <1475738420-8747-4-git-send-email-markus.heiser@darmarit.de>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <1475738420-8747-4-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  6 Oct 2016 09:20:19 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> From: Markus Heiser <markus.heiser@darmarIT.de>
> 
> From: Markus Heiser <markus.heiser@darmarIT.de>
> 
> Remove the media-Makefile and migrate the ``.. kernel-include::``
> directive to the new ``.. kernel-cmd::`` directive.
> 
> To avoid breaking bisect, this patch includes the required changes to
> the implementation (script ``parse-headers.pl``) and the content (*.rst
> files).

It is a way easier to review this patch if you do a diff with the
-M option, as below.

---

doc-rst: migrated media build kernel-cmd directive

From: Markus Heiser <markus.heiser@darmarIT.de>

Remove the media-Makefile and migrate the ``.. kernel-include::``
directive to the new ``.. kernel-cmd::`` directive.

To avoid breaking bisect, this patch includes the required changes to
the implementation (script ``parse-headers.pl``) and the content (*.rst
files).

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>

 Documentation/Makefile.sphinx                      |  2 +-
 Documentation/media/Makefile                       | 61 ----------------------
 Documentation/media/uapi/cec/cec-header.rst        |  3 +-
 .../cec/cec.h.exceptions}                          |  0
 .../dvb/audio.h.exceptions}                        |  0
 Documentation/media/uapi/dvb/audio_h.rst           |  2 +-
 .../dvb/ca.h.exceptions}                           |  0
 Documentation/media/uapi/dvb/ca_h.rst              |  2 +-
 .../dvb/dmx.h.exceptions}                          |  0
 Documentation/media/uapi/dvb/dmx_h.rst             |  2 +-
 .../dvb/frontend.h.exceptions}                     |  0
 Documentation/media/uapi/dvb/frontend_h.rst        |  2 +-
 .../dvb/net.h.exceptions}                          |  0
 Documentation/media/uapi/dvb/net_h.rst             |  2 +-
 .../dvb/video.h.exceptions}                        |  0
 Documentation/media/uapi/dvb/video_h.rst           |  2 +-
 Documentation/media/uapi/mediactl/media-header.rst |  3 +-
 .../mediactl/media.h.exceptions}                   |  0
 Documentation/media/uapi/rc/lirc-header.rst        |  2 +-
 .../rc/lirc.h.exceptions}                          |  0
 Documentation/media/uapi/v4l/videodev.rst          |  2 +-
 .../v4l/videodev2.h.exceptions}                    |  0
 Documentation/sphinx/parse-headers.pl              | 17 +++---
 23 files changed, 18 insertions(+), 84 deletions(-)


diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 92deea30b183..2e033e4e0e60 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -52,7 +52,7 @@ loop_cmd = $(echo-cmd) $(cmd_$(1))
 #    e.g. "media" for the linux-tv book-set at ./Documentation/media
 
 quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4);
-      cmd_sphinx = $(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/media all;\
+      cmd_sphinx = \
 	BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
 	$(SPHINXBUILD) \
 	-b $2 \
diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
deleted file mode 100644
index a7fb35291f6c..000000000000
--- a/Documentation/media/Makefile
+++ /dev/null
@@ -1,61 +0,0 @@
-# Generate the *.h.rst files from uAPI headers
-
-PARSER = $(srctree)/Documentation/sphinx/parse-headers.pl
-UAPI = $(srctree)/include/uapi/linux
-KAPI = $(srctree)/include/linux
-SRC_DIR=$(srctree)/Documentation/media
-
-FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
-	  videodev2.h.rst media.h.rst cec.h.rst lirc.h.rst
-
-TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
-
-.PHONY: all
-all: $(BUILDDIR) ${TARGETS}
-
-$(BUILDDIR):
-	$(Q)mkdir -p $@
-
-# Rule to convert a .h file to inline RST documentation
-
-gen_rst = \
-	echo ${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions; \
-	${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions
-
-quiet_gen_rst = echo '  PARSE   $(patsubst $(srctree)/%,%,$<)'; \
-	${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions
-
-silent_gen_rst = ${gen_rst}
-
-$(BUILDDIR)/audio.h.rst: ${UAPI}/dvb/audio.h ${PARSER} $(SRC_DIR)/audio.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/ca.h.rst: ${UAPI}/dvb/ca.h ${PARSER} $(SRC_DIR)/ca.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/dmx.h.rst: ${UAPI}/dvb/dmx.h ${PARSER} $(SRC_DIR)/dmx.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/frontend.h.rst: ${UAPI}/dvb/frontend.h ${PARSER} $(SRC_DIR)/frontend.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/net.h.rst: ${UAPI}/dvb/net.h ${PARSER} $(SRC_DIR)/net.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/video.h.rst: ${UAPI}/dvb/video.h ${PARSER} $(SRC_DIR)/video.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} $(SRC_DIR)/videodev2.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/media.h.rst: ${UAPI}/media.h ${PARSER} $(SRC_DIR)/media.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/cec.h.rst: ${KAPI}/cec.h ${PARSER} $(SRC_DIR)/cec.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/lirc.h.rst: ${UAPI}/lirc.h ${PARSER} $(SRC_DIR)/lirc.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-cleandocs:
-	-rm ${TARGETS}
diff --git a/Documentation/media/uapi/cec/cec-header.rst b/Documentation/media/uapi/cec/cec-header.rst
index d5a9a2828274..c50cf7ff7892 100644
--- a/Documentation/media/uapi/cec/cec-header.rst
+++ b/Documentation/media/uapi/cec/cec-header.rst
@@ -6,5 +6,4 @@
 CEC Header File
 ***************
 
-.. kernel-include:: $BUILDDIR/cec.h.rst
-
+.. kernel-cmd:: parse-headers.pl $srctree/include/linux/cec.h  cec.h.exceptions
diff --git a/Documentation/media/cec.h.rst.exceptions b/Documentation/media/uapi/cec/cec.h.exceptions
similarity index 100%
rename from Documentation/media/cec.h.rst.exceptions
rename to Documentation/media/uapi/cec/cec.h.exceptions
diff --git a/Documentation/media/audio.h.rst.exceptions b/Documentation/media/uapi/dvb/audio.h.exceptions
similarity index 100%
rename from Documentation/media/audio.h.rst.exceptions
rename to Documentation/media/uapi/dvb/audio.h.exceptions
diff --git a/Documentation/media/uapi/dvb/audio_h.rst b/Documentation/media/uapi/dvb/audio_h.rst
index e00c3010fdf9..8d9eff2ac236 100644
--- a/Documentation/media/uapi/dvb/audio_h.rst
+++ b/Documentation/media/uapi/dvb/audio_h.rst
@@ -6,4 +6,4 @@
 DVB Audio Header File
 *********************
 
-.. kernel-include:: $BUILDDIR/audio.h.rst
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/dvb/audio.h audio.h.exceptions
diff --git a/Documentation/media/ca.h.rst.exceptions b/Documentation/media/uapi/dvb/ca.h.exceptions
similarity index 100%
rename from Documentation/media/ca.h.rst.exceptions
rename to Documentation/media/uapi/dvb/ca.h.exceptions
diff --git a/Documentation/media/uapi/dvb/ca_h.rst b/Documentation/media/uapi/dvb/ca_h.rst
index f513592ef529..57d47de8518a 100644
--- a/Documentation/media/uapi/dvb/ca_h.rst
+++ b/Documentation/media/uapi/dvb/ca_h.rst
@@ -6,4 +6,4 @@
 DVB Conditional Access Header File
 **********************************
 
-.. kernel-include:: $BUILDDIR/ca.h.rst
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/dvb/ca.h ca.h.exceptions
diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/uapi/dvb/dmx.h.exceptions
similarity index 100%
rename from Documentation/media/dmx.h.rst.exceptions
rename to Documentation/media/uapi/dvb/dmx.h.exceptions
diff --git a/Documentation/media/uapi/dvb/dmx_h.rst b/Documentation/media/uapi/dvb/dmx_h.rst
index 4fd1704a0833..90f965be979c 100644
--- a/Documentation/media/uapi/dvb/dmx_h.rst
+++ b/Documentation/media/uapi/dvb/dmx_h.rst
@@ -6,4 +6,4 @@
 DVB Demux Header File
 *********************
 
-.. kernel-include:: $BUILDDIR/dmx.h.rst
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/dvb/dmx.h dmx.h.exceptions
diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentation/media/uapi/dvb/frontend.h.exceptions
similarity index 100%
rename from Documentation/media/frontend.h.rst.exceptions
rename to Documentation/media/uapi/dvb/frontend.h.exceptions
diff --git a/Documentation/media/uapi/dvb/frontend_h.rst b/Documentation/media/uapi/dvb/frontend_h.rst
index 15fca04d1c32..84a064f12fc8 100644
--- a/Documentation/media/uapi/dvb/frontend_h.rst
+++ b/Documentation/media/uapi/dvb/frontend_h.rst
@@ -6,4 +6,4 @@
 DVB Frontend Header File
 ************************
 
-.. kernel-include:: $BUILDDIR/frontend.h.rst
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/dvb/frontend.h frontend.h.exceptions
diff --git a/Documentation/media/net.h.rst.exceptions b/Documentation/media/uapi/dvb/net.h.exceptions
similarity index 100%
rename from Documentation/media/net.h.rst.exceptions
rename to Documentation/media/uapi/dvb/net.h.exceptions
diff --git a/Documentation/media/uapi/dvb/net_h.rst b/Documentation/media/uapi/dvb/net_h.rst
index 7bcf5ba9d1eb..34ed22b09677 100644
--- a/Documentation/media/uapi/dvb/net_h.rst
+++ b/Documentation/media/uapi/dvb/net_h.rst
@@ -6,4 +6,4 @@
 DVB Network Header File
 ***********************
 
-.. kernel-include:: $BUILDDIR/net.h.rst
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/dvb/net.h net.h.exceptions
diff --git a/Documentation/media/video.h.rst.exceptions b/Documentation/media/uapi/dvb/video.h.exceptions
similarity index 100%
rename from Documentation/media/video.h.rst.exceptions
rename to Documentation/media/uapi/dvb/video.h.exceptions
diff --git a/Documentation/media/uapi/dvb/video_h.rst b/Documentation/media/uapi/dvb/video_h.rst
index 3f39b0c4879c..c17b23e348a1 100644
--- a/Documentation/media/uapi/dvb/video_h.rst
+++ b/Documentation/media/uapi/dvb/video_h.rst
@@ -6,4 +6,4 @@
 DVB Video Header File
 *********************
 
-.. kernel-include:: $BUILDDIR/video.h.rst
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/dvb/video.h video.h.exceptions
diff --git a/Documentation/media/uapi/mediactl/media-header.rst b/Documentation/media/uapi/mediactl/media-header.rst
index 96f7b0155e5a..27fe91dd7606 100644
--- a/Documentation/media/uapi/mediactl/media-header.rst
+++ b/Documentation/media/uapi/mediactl/media-header.rst
@@ -6,5 +6,4 @@
 Media Controller Header File
 ****************************
 
-.. kernel-include:: $BUILDDIR/media.h.rst
-
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/media.h media.h.exceptions
diff --git a/Documentation/media/media.h.rst.exceptions b/Documentation/media/uapi/mediactl/media.h.exceptions
similarity index 100%
rename from Documentation/media/media.h.rst.exceptions
rename to Documentation/media/uapi/mediactl/media.h.exceptions
diff --git a/Documentation/media/uapi/rc/lirc-header.rst b/Documentation/media/uapi/rc/lirc-header.rst
index 487fe00e5517..923f10f7f156 100644
--- a/Documentation/media/uapi/rc/lirc-header.rst
+++ b/Documentation/media/uapi/rc/lirc-header.rst
@@ -6,5 +6,5 @@
 LIRC Header File
 ****************
 
-.. kernel-include:: $BUILDDIR/lirc.h.rst
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/lirc.h lirc.h.exceptions
 
diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/uapi/rc/lirc.h.exceptions
similarity index 100%
rename from Documentation/media/lirc.h.rst.exceptions
rename to Documentation/media/uapi/rc/lirc.h.exceptions
diff --git a/Documentation/media/uapi/v4l/videodev.rst b/Documentation/media/uapi/v4l/videodev.rst
index b9ee4672d639..6b36447e5f05 100644
--- a/Documentation/media/uapi/v4l/videodev.rst
+++ b/Documentation/media/uapi/v4l/videodev.rst
@@ -6,4 +6,4 @@
 Video For Linux Two Header File
 *******************************
 
-.. kernel-include:: $BUILDDIR/videodev2.h.rst
+.. kernel-cmd:: parse-headers.pl $srctree/include/uapi/linux/videodev2.h videodev2.h.exceptions
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/uapi/v4l/videodev2.h.exceptions
similarity index 100%
rename from Documentation/media/videodev2.h.rst.exceptions
rename to Documentation/media/uapi/v4l/videodev2.h.exceptions
diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 74089b0da798..92324a588879 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -9,10 +9,10 @@ use Text::Tabs;
 my $debug = 0;
 
 if (scalar @ARGV < 2 || scalar @ARGV > 3) {
-	die "Usage:\n\t$0 <file in> <file out> [<exceptions file>]\n";
+	die "Usage:\n\t$0 <file in> [<exceptions file>]\n";
 }
 
-my ($file_in, $file_out, $file_exceptions) = @ARGV;
+my ($file_in, $file_exceptions) = @ARGV;
 
 my $data;
 my %ioctls;
@@ -306,16 +306,13 @@ foreach my $r (keys %typedefs) {
 $data =~ s/\\ \n/\n/g;
 
 #
-# Generate output file
+# print generated content to stdout
 #
 
 my $title = $file_in;
 $title =~ s,.*/,,;
 
-open OUT, "> $file_out" or die "Can't open $file_out";
-print OUT ".. -*- coding: utf-8; mode: rst -*-\n\n";
-print OUT "$title\n";
-print OUT "=" x length($title);
-print OUT "\n\n.. parsed-literal::\n\n";
-print OUT $data;
-close OUT;
+print "$title\n";
+print "=" x length($title);
+print "\n\n.. parsed-literal::\n\n";
+print $data;
