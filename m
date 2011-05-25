Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985Ab1EYP04 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 11:26:56 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4PFQtWa009852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 11:26:56 -0400
Received: from pedra (vpn-235-184.phx2.redhat.com [10.3.235.184])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p4PFQnla007978
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 11:26:53 -0400
Date: Wed, 25 May 2011 12:26:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] [media] DocBook: Add rules to auto-generate some media
 docbook
Message-ID: <20110525122642.7b4f381f@pedra>
In-Reply-To: <96c3a1277523b929bd27f5d68d5f40e2a0e5bdf3.1306337174.git.mchehab@redhat.com>
References: <96c3a1277523b929bd27f5d68d5f40e2a0e5bdf3.1306337174.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Auto-generate the videodev2.h.xml,frontend.h.xml and the indexes.

Some logic at the Makefile helps us to identify when a symbol is missing,
like for example:

Error: no ID for constraint linkend: V4L2-PIX-FMT-JPGL.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 Documentation/DocBook/dvb/frontend.h.xml
 delete mode 100644 Documentation/DocBook/media-indices.tmpl
 delete mode 100644 Documentation/DocBook/v4l/videodev2.h.xml

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 8436b01..619b943 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -6,6 +6,8 @@
 # To add a new book the only step required is to add the book to the
 # list of DOCBOOKS.
 
+TMPMEDIA=.tmpmedia
+
 DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
 	    writing_usb_driver.xml networking.xml \
@@ -14,7 +16,7 @@ DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
 	    80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
-	    tracepoint.xml media.xml drm.xml
+	    tracepoint.xml $(TMPMEDIA)/media.xml drm.xml
 
 ###
 # The build process is as follows (targets):
@@ -32,7 +34,7 @@ PS_METHOD	= $(prefer-db2x)
 
 ###
 # The targets that may be used.
-PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs xmldoclinks
+PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs mediaprep
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
 xmldocs: $(BOOKS)
@@ -45,27 +47,13 @@ PDF := $(patsubst %.xml, %.pdf, $(BOOKS))
 pdfdocs: $(PDF)
 
 HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
-htmldocs: $(HTML) xmldoclinks
+htmldocs: $(HTML)
 	$(call build_main_index)
 	$(call build_images)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
 
-build_images = mkdir -p $(objtree)/Documentation/DocBook/media/ && \
-	       cp $(srctree)/Documentation/DocBook/dvb/*.png \
-	          $(srctree)/Documentation/DocBook/v4l/*.gif \
-		  $(objtree)/Documentation/DocBook/media/
-
-xmldoclinks:
-ifneq ($(objtree),$(srctree))
-	for dep in dvb media-entities.tmpl media-indices.tmpl v4l; do \
-		rm -f $(objtree)/Documentation/DocBook/$$dep \
-		&& ln -s $(srctree)/Documentation/DocBook/$$dep $(objtree)/Documentation/DocBook/ \
-		|| exit; \
-	done
-endif
-
 installmandocs: mandocs
 	mkdir -p /usr/local/man/man9/
 	install Documentation/DocBook/man/*.9.gz /usr/local/man/man9/
@@ -97,11 +85,11 @@ define rule_docproc
         ) > $(dir $@).$(notdir $@).cmd
 endef
 
-%.xml: %.tmpl xmldoclinks FORCE
+%.xml: %.tmpl FORCE
 	$(call if_changed_rule,docproc)
 
 ###
-#Read in all saved dependency files 
+#Read in all saved dependency files
 cmd_files := $(wildcard $(foreach f,$(BOOKS),$(dir $(f)).$(notdir $(f)).cmd))
 
 ifneq ($(cmd_files),)
@@ -150,7 +138,7 @@ quiet_cmd_db2pdf = PDF     $@
 
 index = index.html
 main_idx = Documentation/DocBook/$(index)
-build_main_index = rm -rf $(main_idx) && \
+build_main_index = rm -rf $(main_idx); \
 		   echo '<h1>Linux Kernel HTML Documentation</h1>' >> $(main_idx) && \
 		   echo '<h2>Kernel Version: $(KERNELVERSION)</h2>' >> $(main_idx) && \
 		   cat $(HTML) >> $(main_idx)
@@ -240,7 +228,7 @@ clean-files := $(DOCBOOKS) \
 	$(patsubst %.xml, %.9,    $(DOCBOOKS)) \
 	$(index)
 
-clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man
+clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man $(MEDIA_DIR)
 
 cleandocs:
 	$(Q)rm -f $(call objectify, $(clean-files))
@@ -250,3 +238,252 @@ cleandocs:
 # information in a variable se we can use it in if_changed and friends.
 
 .PHONY: $(PHONY)
+
+
+#
+# Media build rules - Auto-generates media contents/indexes and *.h xml's
+#
+
+SHELL=/bin/bash
+
+MEDIA_DIR=$(objtree)/Documentation/DocBook/$(TMPMEDIA)
+
+V4L_SGMLS = \
+	$(shell ls $(srctree)/Documentation/DocBook/v4l/*.xml|perl -ne 'print "$$1 " if (m,.*/(.*)\n,)') \
+	capture.c.xml \
+	keytable.c.xml \
+	v4l2grab.c.xml
+
+DVB_SGMLS = \
+	$(shell ls $(srctree)/Documentation/DocBook/dvb/*.xml|perl -ne 'print "$$1 " if (m,.*/(.*)\n,)')
+
+MEDIA_TEMP =  media-entities.tmpl \
+	      media-indices.tmpl \
+	      videodev2.h.xml \
+	      frontend.h.xml
+
+MEDIA_SGMLS =  $(addprefix ./,$(V4L_SGMLS)) $(addprefix ./,$(DVB_SGMLS)) $(addprefix ./,$(MEDIA_TEMP))
+
+MEDIA_TEMP_OBJ := $(addprefix $(MEDIA_DIR)/,$(MEDIA_TEMP))
+
+FUNCS = \
+	close \
+	ioctl \
+	mmap \
+	munmap \
+	open \
+	poll \
+	read \
+	select \
+	write \
+
+IOCTLS = \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/v4l2-subdev.h) \
+	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
+	VIDIOC_SUBDEV_S_FRAME_INTERVAL \
+	VIDIOC_SUBDEV_ENUM_MBUS_CODE \
+	VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
+	VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
+
+TYPES = \
+	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/linux/videodev2.h)
+
+ENUMS = \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h) \
+	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h)
+
+STRUCTS = \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h) \
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h)
+
+ERRORS = \
+	EACCES \
+	EAGAIN \
+	EBADF \
+	EBUSY \
+	EFAULT \
+	EIO \
+	EINTR \
+	EINVAL \
+	ENFILE \
+	ENOMEM \
+	ENOSPC \
+	ENOTTY \
+	ENXIO \
+	EMFILE \
+	EPERM \
+	ERANGE \
+	EPIPE \
+
+ESCAPE = \
+	-e "s/&/\\&amp;/g" \
+	-e "s/</\\&lt;/g" \
+	-e "s/>/\\&gt;/g"
+
+FILENAME = \
+	-e s,"^[^\/]*/",, \
+	-e s/"\\.xml"// \
+	-e s/"\\.tmpl"// \
+	-e s/\\\./-/g \
+	-e s/"^func-"// \
+	-e s/"^pixfmt-"// \
+	-e s/"^vidioc-"//
+
+# Generate references to these structs in videodev2.h.xml.
+DOCUMENTED = \
+	-e "s/\(enum *\)v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type\)/\1<link linkend=\"\2\">v4l2_mpeg_cx2341x_video_\2<\/link>/g" \
+	-e "s/\(\(enum\|struct\) *\)\(v4l2_[a-zA-Z0-9_]*\)/\1<link linkend=\"\3\">\3<\/link>/g" \
+	-e "s/\(V4L2_PIX_FMT_[A-Z0-9_]\+\) /<link linkend=\"\1\">\1<\/link> /g" \
+	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
+	-e "s/v4l2\-mpeg\-vbi\-ITV0/v4l2-mpeg-vbi-itv0-1/g"
+
+DVB_DOCUMENTED = \
+	-e "s,\(define \)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
+	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g"
+
+
+#
+# Media targets and dependencies
+#
+
+$(obj)/$(TMPMEDIA)/media.xml: $(obj)/media.tmpl $(MEDIA_TEMP_OBJ) FORCE
+	$(call if_changed_rule,docproc)
+
+$(MEDIA_DIR)/v4l2.xml:
+	@$($(quiet)gen_xml)
+	@(mkdir -p $(MEDIA_DIR))
+	@(cp $(srctree)/Documentation/DocBook/dvb/*.png $(srctree)/Documentation/DocBook/v4l/*.gif $(MEDIA_DIR)/)
+	@(ln -sf $(srctree)/Documentation/DocBook/v4l/*xml $(MEDIA_DIR)/)
+	@(ln -sf $(srctree)/Documentation/DocBook/dvb/*xml $(MEDIA_DIR)/)
+
+$(MEDIA_DIR)/videodev2.h.xml: $(srctree)/include/linux/videodev2.h $(MEDIA_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(					\
+	echo "<programlisting>") > $@
+	@(					\
+	expand --tabs=8 < $< |			\
+	  sed $(ESCAPE) $(DOCUMENTED) |		\
+	  sed 's/i\.e\./&ie;/') >> $@
+	@(					\
+	echo "</programlisting>") >> $@
+
+$(MEDIA_DIR)/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h $(MEDIA_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(					\
+	echo "<programlisting>") > $@
+	@(					\
+	expand --tabs=8 < $< |			\
+	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
+	  sed 's/i\.e\./&ie;/') >> $@
+	@(					\
+	echo "</programlisting>") >> $@
+
+$(MEDIA_DIR)/media-entities.tmpl: $(MEDIA_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(								\
+	echo "<!-- Generated file! Do not edit. -->") >$@
+	@(								\
+	echo -e "\n<!-- Functions -->") >>$@
+	@(								\
+	for ident in $(FUNCS) ; do					\
+	  entity=`echo $$ident | tr _ -` ;				\
+	  echo "<!ENTITY func-$$entity \"<link"				\
+	    "linkend='func-$$entity'><function>$$ident()</function></link>\">" \
+	  >>$@ ;							\
+	done)
+	@(								\
+	echo -e "\n<!-- Ioctls -->") >>$@
+	@(								\
+	for ident in $(IOCTLS) ; do					\
+	  entity=`echo $$ident | tr _ -` ;				\
+	  id=`grep "<refname>$$ident" $(MEDIA_DIR)/vidioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
+	  echo "<!ENTITY $$entity \"<link"				\
+	    "linkend='$$id'><constant>$$ident</constant></link>\">"	\
+	  >>$@ ;							\
+	done)
+	@(								\
+	echo -e "\n<!-- Types -->") >>$@
+	@(								\
+	for ident in $(TYPES) ; do					\
+	  entity=`echo $$ident | tr _ -` ;				\
+	  echo "<!ENTITY $$entity \"<link"				\
+	    "linkend='$$entity'>$$ident</link>\">" >>$@ ;		\
+	done)
+	@(								\
+	echo -e "\n<!-- Enums -->") >>$@
+	@(								\
+	for ident in $(ENUMS) ; do					\
+	  entity=`echo $$ident | sed -e "s/v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type\)/\1/" | tr _ -` ; \
+	  echo "<!ENTITY $$entity \"enum&nbsp;<link"			\
+	    "linkend='$$entity'>$$ident</link>\">" >>$@ ;		\
+	done)
+	@(								\
+	echo -e "\n<!-- Structures -->") >>$@
+	@(								\
+	for ident in $(STRUCTS) ; do					\
+	  entity=`echo $$ident | tr _ - | sed s/v4l2-mpeg-vbi-ITV0/v4l2-mpeg-vbi-itv0-1/g` ; \
+	  echo "<!ENTITY $$entity \"struct&nbsp;<link"			\
+	    "linkend='$$entity'>$$ident</link>\">" >>$@ ;		\
+	done)
+	@(								\
+	echo -e "\n<!-- Error Codes -->") >>$@
+	@(								\
+	for ident in $(ERRORS) ; do					\
+	  echo "<!ENTITY $$ident \"<errorcode>$$ident</errorcode>"	\
+	    "error code\">" >>$@ ;					\
+	done)
+	@(								\
+	echo -e "\n<!-- Subsections -->") >>$@
+	@(								\
+	for file in $(MEDIA_SGMLS) ; do					\
+	  entity=`echo "$$file" | sed $(FILENAME) -e s/"^([^-]*)"/sub\1/` ; \
+	  if ! echo "$$file" |						\
+	    grep -q -E -e '^(func|vidioc|pixfmt)-' ; then		\
+	    echo "<!ENTITY sub-$$entity SYSTEM \"$$file\">" >>$@ ;	\
+	  fi ;								\
+	done)
+	@(								\
+	echo -e "\n<!-- Function Reference -->") >>$@
+	@(								\
+	for file in $(MEDIA_SGMLS) ; do					\
+	  if echo "$$file" |						\
+	    grep -q -E -e '(func|vidioc|pixfmt)-' ; then		\
+	    entity=`echo "$$file" |sed $(FILENAME)` ;			\
+	    echo "<!ENTITY $$entity SYSTEM \"$$file\">" >>$@ ;	\
+	  fi ;								\
+	done)
+
+# Jade can auto-generate a list-of-tables, which includes all structs,
+# but we only want data types, all types, and sorted please.
+$(MEDIA_DIR)/media-indices.tmpl: $(MEDIA_DIR)/v4l2.xml
+	@$($(quiet)gen_xml)
+	@(								\
+	echo "<!-- Generated file! Do not edit. -->") >$@
+	@(								\
+	echo -e "\n<index><title>List of Types</title>") >>$@
+	@(								\
+	for ident in $(TYPES) ; do					\
+	  id=`echo $$ident | tr _ -` ;					\
+	  echo "<indexentry><primaryie><link"				\
+	    "linkend='$$id'>$$ident</link></primaryie></indexentry>" >>$@ ; \
+	done)
+	@(								\
+	for ident in $(ENUMS) ; do					\
+	  id=`echo $$ident | sed -e "s/v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type\)/\1/" | tr _ -`; \
+	  echo "<indexentry><primaryie>enum&nbsp;<link"			\
+	    "linkend='$$id'>$$ident</link></primaryie></indexentry>" >>$@ ; \
+	done)
+	@(								\
+	for ident in $(STRUCTS) ; do					\
+	  id=`echo $$ident | tr _ - | sed s/v4l2-mpeg-vbi-ITV0/v4l2-mpeg-vbi-itv0-1/g` ; \
+	  echo "<indexentry><primaryie>struct&nbsp;<link"		\
+	    "linkend='$$id'>$$ident</link></primaryie></indexentry>" >>$@ ; \
+	done)
+	@(								\
+	echo "</index>") >>$@
diff --git a/Documentation/DocBook/dvb/frontend.h.xml b/Documentation/DocBook/dvb/frontend.h.xml
deleted file mode 100644
index d792f78..0000000
--- a/Documentation/DocBook/dvb/frontend.h.xml
+++ /dev/null
@@ -1,428 +0,0 @@
-<programlisting>
-/*
- * frontend.h
- *
- * Copyright (C) 2000 Marcus Metzler &lt;marcus@convergence.de&gt;
- *                  Ralph  Metzler &lt;ralph@convergence.de&gt;
- *                  Holger Waechtler &lt;holger@convergence.de&gt;
- *                  Andre Draszik &lt;ad@convergence.de&gt;
- *                  for convergence integrated media GmbH
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation; either version 2.1
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- */
-
-#ifndef _DVBFRONTEND_H_
-#define _DVBFRONTEND_H_
-
-#include &lt;linux/types.h&gt;
-
-typedef enum fe_type {
-        FE_QPSK,
-        FE_QAM,
-        FE_OFDM,
-        FE_ATSC
-} fe_type_t;
-
-
-typedef enum fe_caps {
-        FE_IS_STUPID                    = 0,
-        FE_CAN_INVERSION_AUTO           = 0x1,
-        FE_CAN_FEC_1_2                  = 0x2,
-        FE_CAN_FEC_2_3                  = 0x4,
-        FE_CAN_FEC_3_4                  = 0x8,
-        FE_CAN_FEC_4_5                  = 0x10,
-        FE_CAN_FEC_5_6                  = 0x20,
-        FE_CAN_FEC_6_7                  = 0x40,
-        FE_CAN_FEC_7_8                  = 0x80,
-        FE_CAN_FEC_8_9                  = 0x100,
-        FE_CAN_FEC_AUTO                 = 0x200,
-        FE_CAN_QPSK                     = 0x400,
-        FE_CAN_QAM_16                   = 0x800,
-        FE_CAN_QAM_32                   = 0x1000,
-        FE_CAN_QAM_64                   = 0x2000,
-        FE_CAN_QAM_128                  = 0x4000,
-        FE_CAN_QAM_256                  = 0x8000,
-        FE_CAN_QAM_AUTO                 = 0x10000,
-        FE_CAN_TRANSMISSION_MODE_AUTO   = 0x20000,
-        FE_CAN_BANDWIDTH_AUTO           = 0x40000,
-        FE_CAN_GUARD_INTERVAL_AUTO      = 0x80000,
-        FE_CAN_HIERARCHY_AUTO           = 0x100000,
-        FE_CAN_8VSB                     = 0x200000,
-        FE_CAN_16VSB                    = 0x400000,
-        FE_HAS_EXTENDED_CAPS            = 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
-        FE_CAN_TURBO_FEC                = 0x8000000,  /* frontend supports "turbo fec modulation" */
-        FE_CAN_2G_MODULATION            = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
-        FE_NEEDS_BENDING                = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
-        FE_CAN_RECOVER                  = 0x40000000, /* frontend can recover from a cable unplug automatically */
-        FE_CAN_MUTE_TS                  = 0x80000000  /* frontend can stop spurious TS data output */
-} fe_caps_t;
-
-
-struct dvb_frontend_info {
-        char       name[128];
-        fe_type_t  type;
-        __u32      frequency_min;
-        __u32      frequency_max;
-        __u32      frequency_stepsize;
-        __u32      frequency_tolerance;
-        __u32      symbol_rate_min;
-        __u32      symbol_rate_max;
-        __u32      symbol_rate_tolerance;       /* ppm */
-        __u32      notifier_delay;              /* DEPRECATED */
-        fe_caps_t  caps;
-};
-
-
-/**
- *  Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
- *  the meaning of this struct...
- */
-struct dvb_diseqc_master_cmd {
-        __u8 msg [6];   /*  { framing, address, command, data [3] } */
-        __u8 msg_len;   /*  valid values are 3...6  */
-};
-
-
-struct dvb_diseqc_slave_reply {
-        __u8 msg [4];   /*  { framing, data [3] } */
-        __u8 msg_len;   /*  valid values are 0...4, 0 means no msg  */
-        int  timeout;   /*  return from ioctl after timeout ms with */
-};                      /*  errorcode when no message was received  */
-
-
-typedef enum fe_sec_voltage {
-        SEC_VOLTAGE_13,
-        SEC_VOLTAGE_18,
-        SEC_VOLTAGE_OFF
-} fe_sec_voltage_t;
-
-
-typedef enum fe_sec_tone_mode {
-        SEC_TONE_ON,
-        SEC_TONE_OFF
-} fe_sec_tone_mode_t;
-
-
-typedef enum fe_sec_mini_cmd {
-        SEC_MINI_A,
-        SEC_MINI_B
-} fe_sec_mini_cmd_t;
-
-
-typedef enum fe_status {
-        FE_HAS_SIGNAL   = 0x01,   /* found something above the noise level */
-        FE_HAS_CARRIER  = 0x02,   /* found a DVB signal  */
-        FE_HAS_VITERBI  = 0x04,   /* FEC is stable  */
-        FE_HAS_SYNC     = 0x08,   /* found sync bytes  */
-        FE_HAS_LOCK     = 0x10,   /* everything's working... */
-        FE_TIMEDOUT     = 0x20,   /* no lock within the last ~2 seconds */
-        FE_REINIT       = 0x40    /* frontend was reinitialized,  */
-} fe_status_t;                    /* application is recommended to reset */
-                                  /* DiSEqC, tone and parameters */
-
-typedef enum fe_spectral_inversion {
-        INVERSION_OFF,
-        INVERSION_ON,
-        INVERSION_AUTO
-} fe_spectral_inversion_t;
-
-
-typedef enum fe_code_rate {
-        FEC_NONE = 0,
-        FEC_1_2,
-        FEC_2_3,
-        FEC_3_4,
-        FEC_4_5,
-        FEC_5_6,
-        FEC_6_7,
-        FEC_7_8,
-        FEC_8_9,
-        FEC_AUTO,
-        FEC_3_5,
-        FEC_9_10,
-} fe_code_rate_t;
-
-
-typedef enum fe_modulation {
-        QPSK,
-        QAM_16,
-        QAM_32,
-        QAM_64,
-        QAM_128,
-        QAM_256,
-        QAM_AUTO,
-        VSB_8,
-        VSB_16,
-        PSK_8,
-        APSK_16,
-        APSK_32,
-        DQPSK,
-} fe_modulation_t;
-
-typedef enum fe_transmit_mode {
-        TRANSMISSION_MODE_2K,
-        TRANSMISSION_MODE_8K,
-        TRANSMISSION_MODE_AUTO,
-        TRANSMISSION_MODE_4K,
-        TRANSMISSION_MODE_1K,
-        TRANSMISSION_MODE_16K,
-        TRANSMISSION_MODE_32K,
-} fe_transmit_mode_t;
-
-typedef enum fe_bandwidth {
-        BANDWIDTH_8_MHZ,
-        BANDWIDTH_7_MHZ,
-        BANDWIDTH_6_MHZ,
-        BANDWIDTH_AUTO,
-        BANDWIDTH_5_MHZ,
-        BANDWIDTH_10_MHZ,
-        BANDWIDTH_1_712_MHZ,
-} fe_bandwidth_t;
-
-
-typedef enum fe_guard_interval {
-        GUARD_INTERVAL_1_32,
-        GUARD_INTERVAL_1_16,
-        GUARD_INTERVAL_1_8,
-        GUARD_INTERVAL_1_4,
-        GUARD_INTERVAL_AUTO,
-        GUARD_INTERVAL_1_128,
-        GUARD_INTERVAL_19_128,
-        GUARD_INTERVAL_19_256,
-} fe_guard_interval_t;
-
-
-typedef enum fe_hierarchy {
-        HIERARCHY_NONE,
-        HIERARCHY_1,
-        HIERARCHY_2,
-        HIERARCHY_4,
-        HIERARCHY_AUTO
-} fe_hierarchy_t;
-
-
-struct dvb_qpsk_parameters {
-        __u32           symbol_rate;  /* symbol rate in Symbols per second */
-        fe_code_rate_t  fec_inner;    /* forward error correction (see above) */
-};
-
-struct dvb_qam_parameters {
-        __u32           symbol_rate; /* symbol rate in Symbols per second */
-        fe_code_rate_t  fec_inner;   /* forward error correction (see above) */
-        fe_modulation_t modulation;  /* modulation type (see above) */
-};
-
-struct dvb_vsb_parameters {
-        fe_modulation_t modulation;  /* modulation type (see above) */
-};
-
-struct dvb_ofdm_parameters {
-        fe_bandwidth_t      bandwidth;
-        fe_code_rate_t      code_rate_HP;  /* high priority stream code rate */
-        fe_code_rate_t      code_rate_LP;  /* low priority stream code rate */
-        fe_modulation_t     constellation; /* modulation type (see above) */
-        fe_transmit_mode_t  transmission_mode;
-        fe_guard_interval_t guard_interval;
-        fe_hierarchy_t      hierarchy_information;
-};
-
-
-struct dvb_frontend_parameters {
-        __u32 frequency;     /* (absolute) frequency in Hz for QAM/OFDM/ATSC */
-                             /* intermediate frequency in kHz for QPSK */
-        fe_spectral_inversion_t inversion;
-        union {
-                struct dvb_qpsk_parameters qpsk;
-                struct dvb_qam_parameters  qam;
-                struct dvb_ofdm_parameters ofdm;
-                struct dvb_vsb_parameters vsb;
-        } u;
-};
-
-
-struct dvb_frontend_event {
-        fe_status_t status;
-        struct dvb_frontend_parameters parameters;
-};
-
-/* S2API Commands */
-#define DTV_UNDEFINED           0
-#define DTV_TUNE                1
-#define DTV_CLEAR               2
-#define DTV_FREQUENCY           3
-#define DTV_MODULATION          4
-#define DTV_BANDWIDTH_HZ        5
-#define DTV_INVERSION           6
-#define DTV_DISEQC_MASTER       7
-#define DTV_SYMBOL_RATE         8
-#define DTV_INNER_FEC           9
-#define DTV_VOLTAGE             10
-#define DTV_TONE                11
-#define DTV_PILOT               12
-#define DTV_ROLLOFF             13
-#define DTV_DISEQC_SLAVE_REPLY  14
-
-/* Basic enumeration set for querying unlimited capabilities */
-#define DTV_FE_CAPABILITY_COUNT 15
-#define DTV_FE_CAPABILITY       16
-#define DTV_DELIVERY_SYSTEM     17
-
-/* ISDB-T and ISDB-Tsb */
-#define DTV_ISDBT_PARTIAL_RECEPTION     18
-#define DTV_ISDBT_SOUND_BROADCASTING    19
-
-#define DTV_ISDBT_SB_SUBCHANNEL_ID      20
-#define DTV_ISDBT_SB_SEGMENT_IDX        21
-#define DTV_ISDBT_SB_SEGMENT_COUNT      22
-
-#define DTV_ISDBT_LAYERA_FEC                    23
-#define DTV_ISDBT_LAYERA_MODULATION             24
-#define DTV_ISDBT_LAYERA_SEGMENT_COUNT          25
-#define DTV_ISDBT_LAYERA_TIME_INTERLEAVING      26
-
-#define DTV_ISDBT_LAYERB_FEC                    27
-#define DTV_ISDBT_LAYERB_MODULATION             28
-#define DTV_ISDBT_LAYERB_SEGMENT_COUNT          29
-#define DTV_ISDBT_LAYERB_TIME_INTERLEAVING      30
-
-#define DTV_ISDBT_LAYERC_FEC                    31
-#define DTV_ISDBT_LAYERC_MODULATION             32
-#define DTV_ISDBT_LAYERC_SEGMENT_COUNT          33
-#define DTV_ISDBT_LAYERC_TIME_INTERLEAVING      34
-
-#define DTV_API_VERSION         35
-
-#define DTV_CODE_RATE_HP        36
-#define DTV_CODE_RATE_LP        37
-#define DTV_GUARD_INTERVAL      38
-#define DTV_TRANSMISSION_MODE   39
-#define DTV_HIERARCHY           40
-
-#define DTV_ISDBT_LAYER_ENABLED 41
-
-#define DTV_ISDBS_TS_ID         42
-
-#define DTV_DVBT2_PLP_ID	43
-
-#define DTV_MAX_COMMAND                         DTV_DVBT2_PLP_ID
-
-typedef enum fe_pilot {
-        PILOT_ON,
-        PILOT_OFF,
-        PILOT_AUTO,
-} fe_pilot_t;
-
-typedef enum fe_rolloff {
-        ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
-        ROLLOFF_20,
-        ROLLOFF_25,
-        ROLLOFF_AUTO,
-} fe_rolloff_t;
-
-typedef enum fe_delivery_system {
-        SYS_UNDEFINED,
-        SYS_DVBC_ANNEX_AC,
-        SYS_DVBC_ANNEX_B,
-        SYS_DVBT,
-        SYS_DSS,
-        SYS_DVBS,
-        SYS_DVBS2,
-        SYS_DVBH,
-        SYS_ISDBT,
-        SYS_ISDBS,
-        SYS_ISDBC,
-        SYS_ATSC,
-        SYS_ATSCMH,
-        SYS_DMBTH,
-        SYS_CMMB,
-        SYS_DAB,
-        SYS_DVBT2,
-} fe_delivery_system_t;
-
-struct dtv_cmds_h {
-        char    *name;          /* A display name for debugging purposes */
-
-        __u32   cmd;            /* A unique ID */
-
-        /* Flags */
-        __u32   set:1;          /* Either a set or get property */
-        __u32   buffer:1;       /* Does this property use the buffer? */
-        __u32   reserved:30;    /* Align */
-};
-
-struct dtv_property {
-        __u32 cmd;
-        __u32 reserved[3];
-        union {
-                __u32 data;
-                struct {
-                        __u8 data[32];
-                        __u32 len;
-                        __u32 reserved1[3];
-                        void *reserved2;
-                } buffer;
-        } u;
-        int result;
-} __attribute__ ((packed));
-
-/* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
-#define DTV_IOCTL_MAX_MSGS 64
-
-struct dtv_properties {
-        __u32 num;
-        struct dtv_property *props;
-};
-
-#define <link linkend="FE_GET_PROPERTY">FE_SET_PROPERTY</link>            _IOW('o', 82, struct dtv_properties)
-#define <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY</link>            _IOR('o', 83, struct dtv_properties)
-
-
-/**
- * When set, this flag will disable any zigzagging or other "normal" tuning
- * behaviour. Additionally, there will be no automatic monitoring of the lock
- * status, and hence no frontend events will be generated. If a frontend device
- * is closed, this flag will be automatically turned off when the device is
- * reopened read-write.
- */
-#define FE_TUNE_MODE_ONESHOT 0x01
-
-
-#define <link linkend="FE_GET_INFO">FE_GET_INFO</link>                _IOR('o', 61, struct dvb_frontend_info)
-
-#define <link linkend="FE_DISEQC_RESET_OVERLOAD">FE_DISEQC_RESET_OVERLOAD</link>   _IO('o', 62)
-#define <link linkend="FE_DISEQC_SEND_MASTER_CMD">FE_DISEQC_SEND_MASTER_CMD</link>  _IOW('o', 63, struct dvb_diseqc_master_cmd)
-#define <link linkend="FE_DISEQC_RECV_SLAVE_REPLY">FE_DISEQC_RECV_SLAVE_REPLY</link> _IOR('o', 64, struct dvb_diseqc_slave_reply)
-#define <link linkend="FE_DISEQC_SEND_BURST">FE_DISEQC_SEND_BURST</link>       _IO('o', 65)  /* fe_sec_mini_cmd_t */
-
-#define <link linkend="FE_SET_TONE">FE_SET_TONE</link>                _IO('o', 66)  /* fe_sec_tone_mode_t */
-#define <link linkend="FE_SET_VOLTAGE">FE_SET_VOLTAGE</link>             _IO('o', 67)  /* fe_sec_voltage_t */
-#define <link linkend="FE_ENABLE_HIGH_LNB_VOLTAGE">FE_ENABLE_HIGH_LNB_VOLTAGE</link> _IO('o', 68)  /* int */
-
-#define <link linkend="FE_READ_STATUS">FE_READ_STATUS</link>             _IOR('o', 69, fe_status_t)
-#define <link linkend="FE_READ_BER">FE_READ_BER</link>                _IOR('o', 70, __u32)
-#define <link linkend="FE_READ_SIGNAL_STRENGTH">FE_READ_SIGNAL_STRENGTH</link>    _IOR('o', 71, __u16)
-#define <link linkend="FE_READ_SNR">FE_READ_SNR</link>                _IOR('o', 72, __u16)
-#define <link linkend="FE_READ_UNCORRECTED_BLOCKS">FE_READ_UNCORRECTED_BLOCKS</link> _IOR('o', 73, __u32)
-
-#define <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link>            _IOW('o', 76, struct dvb_frontend_parameters)
-#define <link linkend="FE_GET_FRONTEND">FE_GET_FRONTEND</link>            _IOR('o', 77, struct dvb_frontend_parameters)
-#define <link linkend="FE_SET_FRONTEND_TUNE_MODE">FE_SET_FRONTEND_TUNE_MODE</link>  _IO('o', 81) /* unsigned int */
-#define <link linkend="FE_GET_EVENT">FE_GET_EVENT</link>               _IOR('o', 78, struct dvb_frontend_event)
-
-#define <link linkend="FE_DISHNETWORK_SEND_LEGACY_CMD">FE_DISHNETWORK_SEND_LEGACY_CMD</link> _IO('o', 80) /* unsigned int */
-
-#endif /*_DVBFRONTEND_H_*/
-</programlisting>
diff --git a/Documentation/DocBook/media-indices.tmpl b/Documentation/DocBook/media-indices.tmpl
deleted file mode 100644
index 78d6031..0000000
--- a/Documentation/DocBook/media-indices.tmpl
+++ /dev/null
@@ -1,89 +0,0 @@
-<!-- Generated file! Do not edit. -->
-
-<index><title>List of Types</title>
-<indexentry><primaryie><link linkend='v4l2-std-id'>v4l2_std_id</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-buf-type'>v4l2_buf_type</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-colorspace'>v4l2_colorspace</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-ctrl-type'>v4l2_ctrl_type</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-exposure-auto-type'>v4l2_exposure_auto_type</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-field'>v4l2_field</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-frmivaltypes'>v4l2_frmivaltypes</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-frmsizetypes'>v4l2_frmsizetypes</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-memory'>v4l2_memory</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-ac3-bitrate'>v4l2_mpeg_audio_ac3_bitrate</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-crc'>v4l2_mpeg_audio_crc</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-emphasis'>v4l2_mpeg_audio_emphasis</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-encoding'>v4l2_mpeg_audio_encoding</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-l1-bitrate'>v4l2_mpeg_audio_l1_bitrate</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-l2-bitrate'>v4l2_mpeg_audio_l2_bitrate</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-l3-bitrate'>v4l2_mpeg_audio_l3_bitrate</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-mode'>v4l2_mpeg_audio_mode</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-mode-extension'>v4l2_mpeg_audio_mode_extension</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-audio-sampling-freq'>v4l2_mpeg_audio_sampling_freq</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='chroma-spatial-filter-type'>v4l2_mpeg_cx2341x_video_chroma_spatial_filter_type</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='luma-spatial-filter-type'>v4l2_mpeg_cx2341x_video_luma_spatial_filter_type</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-cx2341x-video-median-filter-type'>v4l2_mpeg_cx2341x_video_median_filter_type</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-cx2341x-video-spatial-filter-mode'>v4l2_mpeg_cx2341x_video_spatial_filter_mode</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-cx2341x-video-temporal-filter-mode'>v4l2_mpeg_cx2341x_video_temporal_filter_mode</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-stream-type'>v4l2_mpeg_stream_type</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-stream-vbi-fmt'>v4l2_mpeg_stream_vbi_fmt</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-video-aspect'>v4l2_mpeg_video_aspect</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-video-bitrate-mode'>v4l2_mpeg_video_bitrate_mode</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-mpeg-video-encoding'>v4l2_mpeg_video_encoding</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-power-line-frequency'>v4l2_power_line_frequency</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-priority'>v4l2_priority</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-tuner-type'>v4l2_tuner_type</link></primaryie></indexentry>
-<indexentry><primaryie>enum&nbsp;<link linkend='v4l2-preemphasis'>v4l2_preemphasis</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-audio'>v4l2_audio</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-audioout'>v4l2_audioout</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-bt-timings'>v4l2_bt_timings</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-buffer'>v4l2_buffer</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-capability'>v4l2_capability</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-captureparm'>v4l2_captureparm</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-clip'>v4l2_clip</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-control'>v4l2_control</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-crop'>v4l2_crop</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-cropcap'>v4l2_cropcap</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-dbg-chip-ident'>v4l2_dbg_chip_ident</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-dbg-match'>v4l2_dbg_match</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-dbg-register'>v4l2_dbg_register</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-dv-enum-preset'>v4l2_dv_enum_preset</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-dv-preset'>v4l2_dv_preset</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-dv-timings'>v4l2_dv_timings</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-enc-idx'>v4l2_enc_idx</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-enc-idx-entry'>v4l2_enc_idx_entry</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-encoder-cmd'>v4l2_encoder_cmd</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-ext-control'>v4l2_ext_control</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-ext-controls'>v4l2_ext_controls</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-fmtdesc'>v4l2_fmtdesc</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-format'>v4l2_format</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-fract'>v4l2_fract</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-framebuffer'>v4l2_framebuffer</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-frequency'>v4l2_frequency</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-frmival-stepwise'>v4l2_frmival_stepwise</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-frmivalenum'>v4l2_frmivalenum</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-frmsize-discrete'>v4l2_frmsize_discrete</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-frmsize-stepwise'>v4l2_frmsize_stepwise</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-frmsizeenum'>v4l2_frmsizeenum</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-hw-freq-seek'>v4l2_hw_freq_seek</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-input'>v4l2_input</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-jpegcompression'>v4l2_jpegcompression</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-modulator'>v4l2_modulator</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-mpeg-vbi-fmt-ivtv'>v4l2_mpeg_vbi_fmt_ivtv</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-output'>v4l2_output</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-outputparm'>v4l2_outputparm</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-pix-format'>v4l2_pix_format</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-queryctrl'>v4l2_queryctrl</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-querymenu'>v4l2_querymenu</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-rect'>v4l2_rect</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-requestbuffers'>v4l2_requestbuffers</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-sliced-vbi-cap'>v4l2_sliced_vbi_cap</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-sliced-vbi-data'>v4l2_sliced_vbi_data</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-sliced-vbi-format'>v4l2_sliced_vbi_format</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-standard'>v4l2_standard</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-streamparm'>v4l2_streamparm</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-timecode'>v4l2_timecode</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-tuner'>v4l2_tuner</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-vbi-format'>v4l2_vbi_format</link></primaryie></indexentry>
-<indexentry><primaryie>struct&nbsp;<link linkend='v4l2-window'>v4l2_window</link></primaryie></indexentry>
-</index>
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
deleted file mode 100644
index c50536a..0000000
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ /dev/null
@@ -1,1946 +0,0 @@
-<programlisting>
-/*
- *  Video for Linux Two header file
- *
- *  Copyright (C) 1999-2007 the contributors
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  Alternatively you can redistribute this file under the terms of the
- *  BSD license as stated below:
- *
- *  Redistribution and use in source and binary forms, with or without
- *  modification, are permitted provided that the following conditions
- *  are met:
- *  1. Redistributions of source code must retain the above copyright
- *     notice, this list of conditions and the following disclaimer.
- *  2. Redistributions in binary form must reproduce the above copyright
- *     notice, this list of conditions and the following disclaimer in
- *     the documentation and/or other materials provided with the
- *     distribution.
- *  3. The names of its contributors may not be used to endorse or promote
- *     products derived from this software without specific prior written
- *     permission.
- *
- *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
- *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
- *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
- *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
- *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
- *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *      Header file for v4l or V4L2 drivers and applications
- * with public API.
- * All kernel-specific stuff were moved to media/v4l2-dev.h, so
- * no #if __KERNEL tests are allowed here
- *
- *      See http://linuxtv.org for more info
- *
- *      Author: Bill Dirks &lt;bill@thedirks.org&gt;
- *              Justin Schoeman
- *              Hans Verkuil &lt;hverkuil@xs4all.nl&gt;
- *              et al.
- */
-#ifndef __LINUX_VIDEODEV2_H
-#define __LINUX_VIDEODEV2_H
-
-#ifdef __KERNEL__
-#include &lt;linux/time.h&gt;     /* need struct timeval */
-#else
-#include &lt;sys/time.h&gt;
-#endif
-#include &lt;linux/compiler.h&gt;
-#include &lt;linux/ioctl.h&gt;
-#include &lt;linux/types.h&gt;
-
-/*
- * Common stuff for both V4L1 and V4L2
- * Moved from videodev.h
- */
-#define VIDEO_MAX_FRAME               32
-#define VIDEO_MAX_PLANES               8
-
-#ifndef __KERNEL__
-
-/* These defines are V4L1 specific and should not be used with the V4L2 API!
-   They will be removed from this header in the future. */
-
-#define VID_TYPE_CAPTURE        1       /* Can capture */
-#define VID_TYPE_TUNER          2       /* Can tune */
-#define VID_TYPE_TELETEXT       4       /* Does teletext */
-#define VID_TYPE_OVERLAY        8       /* Overlay onto frame buffer */
-#define VID_TYPE_CHROMAKEY      16      /* Overlay by chromakey */
-#define VID_TYPE_CLIPPING       32      /* Can clip */
-#define VID_TYPE_FRAMERAM       64      /* Uses the frame buffer memory */
-#define VID_TYPE_SCALES         128     /* Scalable */
-#define VID_TYPE_MONOCHROME     256     /* Monochrome only */
-#define VID_TYPE_SUBCAPTURE     512     /* Can capture subareas of the image */
-#define VID_TYPE_MPEG_DECODER   1024    /* Can decode MPEG streams */
-#define VID_TYPE_MPEG_ENCODER   2048    /* Can encode MPEG streams */
-#define VID_TYPE_MJPEG_DECODER  4096    /* Can decode MJPEG streams */
-#define VID_TYPE_MJPEG_ENCODER  8192    /* Can encode MJPEG streams */
-#endif
-
-/*
- *      M I S C E L L A N E O U S
- */
-
-/*  Four-character-code (FOURCC) */
-#define v4l2_fourcc(a, b, c, d)\
-        ((__u32)(a) | ((__u32)(b) &lt;&lt; 8) | ((__u32)(c) &lt;&lt; 16) | ((__u32)(d) &lt;&lt; 24))
-
-/*
- *      E N U M S
- */
-enum <link linkend="v4l2-field">v4l2_field</link> {
-        V4L2_FIELD_ANY           = 0, /* driver can choose from none,
-                                         top, bottom, interlaced
-                                         depending on whatever it thinks
-                                         is approximate ... */
-        V4L2_FIELD_NONE          = 1, /* this device has no fields ... */
-        V4L2_FIELD_TOP           = 2, /* top field only */
-        V4L2_FIELD_BOTTOM        = 3, /* bottom field only */
-        V4L2_FIELD_INTERLACED    = 4, /* both fields interlaced */
-        V4L2_FIELD_SEQ_TB        = 5, /* both fields sequential into one
-                                         buffer, top-bottom order */
-        V4L2_FIELD_SEQ_BT        = 6, /* same as above + bottom-top order */
-        V4L2_FIELD_ALTERNATE     = 7, /* both fields alternating into
-                                         separate buffers */
-        V4L2_FIELD_INTERLACED_TB = 8, /* both fields interlaced, top field
-                                         first and the top field is
-                                         transmitted first */
-        V4L2_FIELD_INTERLACED_BT = 9, /* both fields interlaced, top field
-                                         first and the bottom field is
-                                         transmitted first */
-};
-#define V4L2_FIELD_HAS_TOP(field)       \
-        ((field) == V4L2_FIELD_TOP      ||\
-         (field) == V4L2_FIELD_INTERLACED ||\
-         (field) == V4L2_FIELD_INTERLACED_TB ||\
-         (field) == V4L2_FIELD_INTERLACED_BT ||\
-         (field) == V4L2_FIELD_SEQ_TB   ||\
-         (field) == V4L2_FIELD_SEQ_BT)
-#define V4L2_FIELD_HAS_BOTTOM(field)    \
-        ((field) == V4L2_FIELD_BOTTOM   ||\
-         (field) == V4L2_FIELD_INTERLACED ||\
-         (field) == V4L2_FIELD_INTERLACED_TB ||\
-         (field) == V4L2_FIELD_INTERLACED_BT ||\
-         (field) == V4L2_FIELD_SEQ_TB   ||\
-         (field) == V4L2_FIELD_SEQ_BT)
-#define V4L2_FIELD_HAS_BOTH(field)      \
-        ((field) == V4L2_FIELD_INTERLACED ||\
-         (field) == V4L2_FIELD_INTERLACED_TB ||\
-         (field) == V4L2_FIELD_INTERLACED_BT ||\
-         (field) == V4L2_FIELD_SEQ_TB ||\
-         (field) == V4L2_FIELD_SEQ_BT)
-
-enum <link linkend="v4l2-buf-type">v4l2_buf_type</link> {
-        V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
-        V4L2_BUF_TYPE_VIDEO_OUTPUT         = 2,
-        V4L2_BUF_TYPE_VIDEO_OVERLAY        = 3,
-        V4L2_BUF_TYPE_VBI_CAPTURE          = 4,
-        V4L2_BUF_TYPE_VBI_OUTPUT           = 5,
-        V4L2_BUF_TYPE_SLICED_VBI_CAPTURE   = 6,
-        V4L2_BUF_TYPE_SLICED_VBI_OUTPUT    = 7,
-#if 1
-        /* Experimental */
-        V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
-#endif
-        V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
-        V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
-        V4L2_BUF_TYPE_PRIVATE              = 0x80,
-};
-
-#define V4L2_TYPE_IS_MULTIPLANAR(type)                  \
-        ((type) == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE   \
-         || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-
-#define V4L2_TYPE_IS_OUTPUT(type)                               \
-        ((type) == V4L2_BUF_TYPE_VIDEO_OUTPUT                   \
-         || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE         \
-         || (type) == V4L2_BUF_TYPE_VIDEO_OVERLAY               \
-         || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY        \
-         || (type) == V4L2_BUF_TYPE_VBI_OUTPUT                  \
-         || (type) == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT)
-
-enum <link linkend="v4l2-tuner-type">v4l2_tuner_type</link> {
-        V4L2_TUNER_RADIO             = 1,
-        V4L2_TUNER_ANALOG_TV         = 2,
-        V4L2_TUNER_DIGITAL_TV        = 3,
-};
-
-enum <link linkend="v4l2-memory">v4l2_memory</link> {
-        V4L2_MEMORY_MMAP             = 1,
-        V4L2_MEMORY_USERPTR          = 2,
-        V4L2_MEMORY_OVERLAY          = 3,
-};
-
-/* see also http://vektor.theorem.ca/graphics/ycbcr/ */
-enum <link linkend="v4l2-colorspace">v4l2_colorspace</link> {
-        /* ITU-R 601 -- broadcast NTSC/PAL */
-        V4L2_COLORSPACE_SMPTE170M     = 1,
-
-        /* 1125-Line (US) HDTV */
-        V4L2_COLORSPACE_SMPTE240M     = 2,
-
-        /* HD and modern captures. */
-        V4L2_COLORSPACE_REC709        = 3,
-
-        /* broken BT878 extents (601, luma range 16-253 instead of 16-235) */
-        V4L2_COLORSPACE_BT878         = 4,
-
-        /* These should be useful.  Assume 601 extents. */
-        V4L2_COLORSPACE_470_SYSTEM_M  = 5,
-        V4L2_COLORSPACE_470_SYSTEM_BG = 6,
-
-        /* I know there will be cameras that send this.  So, this is
-         * unspecified chromaticities and full 0-255 on each of the
-         * Y'CbCr components
-         */
-        V4L2_COLORSPACE_JPEG          = 7,
-
-        /* For RGB colourspaces, this is probably a good start. */
-        V4L2_COLORSPACE_SRGB          = 8,
-};
-
-enum <link linkend="v4l2-priority">v4l2_priority</link> {
-        V4L2_PRIORITY_UNSET       = 0,  /* not initialized */
-        V4L2_PRIORITY_BACKGROUND  = 1,
-        V4L2_PRIORITY_INTERACTIVE = 2,
-        V4L2_PRIORITY_RECORD      = 3,
-        V4L2_PRIORITY_DEFAULT     = V4L2_PRIORITY_INTERACTIVE,
-};
-
-struct <link linkend="v4l2-rect">v4l2_rect</link> {
-        __s32   left;
-        __s32   top;
-        __s32   width;
-        __s32   height;
-};
-
-struct <link linkend="v4l2-fract">v4l2_fract</link> {
-        __u32   numerator;
-        __u32   denominator;
-};
-
-/*
- *      D R I V E R   C A P A B I L I T I E S
- */
-struct <link linkend="v4l2-capability">v4l2_capability</link> {
-        __u8    driver[16];     /* i.e.ie; "bttv" */
-        __u8    card[32];       /* i.e.ie; "Hauppauge WinTV" */
-        __u8    bus_info[32];   /* "PCI:" + pci_name(pci_dev) */
-        __u32   version;        /* should use KERNEL_VERSION() */
-        __u32   capabilities;   /* Device capabilities */
-        __u32   reserved[4];
-};
-
-/* Values for 'capabilities' field */
-#define V4L2_CAP_VIDEO_CAPTURE          0x00000001  /* Is a video capture device */
-#define V4L2_CAP_VIDEO_OUTPUT           0x00000002  /* Is a video output device */
-#define V4L2_CAP_VIDEO_OVERLAY          0x00000004  /* Can do video overlay */
-#define V4L2_CAP_VBI_CAPTURE            0x00000010  /* Is a raw VBI capture device */
-#define V4L2_CAP_VBI_OUTPUT             0x00000020  /* Is a raw VBI output device */
-#define V4L2_CAP_SLICED_VBI_CAPTURE     0x00000040  /* Is a sliced VBI capture device */
-#define V4L2_CAP_SLICED_VBI_OUTPUT      0x00000080  /* Is a sliced VBI output device */
-#define V4L2_CAP_RDS_CAPTURE            0x00000100  /* RDS data capture */
-#define V4L2_CAP_VIDEO_OUTPUT_OVERLAY   0x00000200  /* Can do video output overlay */
-#define V4L2_CAP_HW_FREQ_SEEK           0x00000400  /* Can do hardware frequency seek  */
-#define V4L2_CAP_RDS_OUTPUT             0x00000800  /* Is an RDS encoder */
-
-/* Is a video capture device that supports multiplanar formats */
-#define V4L2_CAP_VIDEO_CAPTURE_MPLANE   0x00001000
-/* Is a video output device that supports multiplanar formats */
-#define V4L2_CAP_VIDEO_OUTPUT_MPLANE    0x00002000
-
-#define V4L2_CAP_TUNER                  0x00010000  /* has a tuner */
-#define V4L2_CAP_AUDIO                  0x00020000  /* has audio support */
-#define V4L2_CAP_RADIO                  0x00040000  /* is a radio device */
-#define V4L2_CAP_MODULATOR              0x00080000  /* has a modulator */
-
-#define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
-#define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
-#define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
-
-/*
- *      V I D E O   I M A G E   F O R M A T
- */
-struct <link linkend="v4l2-pix-format">v4l2_pix_format</link> {
-        __u32                   width;
-        __u32                   height;
-        __u32                   pixelformat;
-        enum <link linkend="v4l2-field">v4l2_field</link>         field;
-        __u32                   bytesperline;   /* for padding, zero if unused */
-        __u32                   sizeimage;
-        enum <link linkend="v4l2-colorspace">v4l2_colorspace</link>    colorspace;
-        __u32                   priv;           /* private data, depends on pixelformat */
-};
-
-/*      Pixel format         FOURCC                          depth  Description  */
-
-/* RGB formats */
-#define <link linkend="V4L2-PIX-FMT-RGB332">V4L2_PIX_FMT_RGB332</link>  v4l2_fourcc('R', 'G', 'B', '1') /*  8  RGB-3-3-2     */
-#define <link linkend="V4L2-PIX-FMT-RGB444">V4L2_PIX_FMT_RGB444</link>  v4l2_fourcc('R', '4', '4', '4') /* 16  xxxxrrrr ggggbbbb */
-#define <link linkend="V4L2-PIX-FMT-RGB555">V4L2_PIX_FMT_RGB555</link>  v4l2_fourcc('R', 'G', 'B', 'O') /* 16  RGB-5-5-5     */
-#define <link linkend="V4L2-PIX-FMT-RGB565">V4L2_PIX_FMT_RGB565</link>  v4l2_fourcc('R', 'G', 'B', 'P') /* 16  RGB-5-6-5     */
-#define <link linkend="V4L2-PIX-FMT-RGB555X">V4L2_PIX_FMT_RGB555X</link> v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
-#define <link linkend="V4L2-PIX-FMT-RGB565X">V4L2_PIX_FMT_RGB565X</link> v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
-#define <link linkend="V4L2-PIX-FMT-BGR666">V4L2_PIX_FMT_BGR666</link>  v4l2_fourcc('B', 'G', 'R', 'H') /* 18  BGR-6-6-6     */
-#define <link linkend="V4L2-PIX-FMT-BGR24">V4L2_PIX_FMT_BGR24</link>   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
-#define <link linkend="V4L2-PIX-FMT-RGB24">V4L2_PIX_FMT_RGB24</link>   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */
-#define <link linkend="V4L2-PIX-FMT-BGR32">V4L2_PIX_FMT_BGR32</link>   v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
-#define <link linkend="V4L2-PIX-FMT-RGB32">V4L2_PIX_FMT_RGB32</link>   v4l2_fourcc('R', 'G', 'B', '4') /* 32  RGB-8-8-8-8   */
-
-/* Grey formats */
-#define <link linkend="V4L2-PIX-FMT-GREY">V4L2_PIX_FMT_GREY</link>    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greyscale     */
-#define <link linkend="V4L2-PIX-FMT-Y4">V4L2_PIX_FMT_Y4</link>      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
-#define <link linkend="V4L2-PIX-FMT-Y6">V4L2_PIX_FMT_Y6</link>      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
-#define <link linkend="V4L2-PIX-FMT-Y10">V4L2_PIX_FMT_Y10</link>     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
-#define <link linkend="V4L2-PIX-FMT-Y16">V4L2_PIX_FMT_Y16</link>     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
-
-/* Grey bit-packed formats */
-#define <link linkend="V4L2-PIX-FMT-Y10BPACK">V4L2_PIX_FMT_Y10BPACK</link>    v4l2_fourcc('Y', '1', '0', 'B') /* 10  Greyscale bit-packed */
-
-/* Palette formats */
-#define <link linkend="V4L2-PIX-FMT-PAL8">V4L2_PIX_FMT_PAL8</link>    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit palette */
-
-/* Luminance+Chrominance formats */
-#define <link linkend="V4L2-PIX-FMT-YVU410">V4L2_PIX_FMT_YVU410</link>  v4l2_fourcc('Y', 'V', 'U', '9') /*  9  YVU 4:1:0     */
-#define <link linkend="V4L2-PIX-FMT-YVU420">V4L2_PIX_FMT_YVU420</link>  v4l2_fourcc('Y', 'V', '1', '2') /* 12  YVU 4:2:0     */
-#define <link linkend="V4L2-PIX-FMT-YUYV">V4L2_PIX_FMT_YUYV</link>    v4l2_fourcc('Y', 'U', 'Y', 'V') /* 16  YUV 4:2:2     */
-#define <link linkend="V4L2-PIX-FMT-YYUV">V4L2_PIX_FMT_YYUV</link>    v4l2_fourcc('Y', 'Y', 'U', 'V') /* 16  YUV 4:2:2     */
-#define <link linkend="V4L2-PIX-FMT-YVYU">V4L2_PIX_FMT_YVYU</link>    v4l2_fourcc('Y', 'V', 'Y', 'U') /* 16 YVU 4:2:2 */
-#define <link linkend="V4L2-PIX-FMT-UYVY">V4L2_PIX_FMT_UYVY</link>    v4l2_fourcc('U', 'Y', 'V', 'Y') /* 16  YUV 4:2:2     */
-#define <link linkend="V4L2-PIX-FMT-VYUY">V4L2_PIX_FMT_VYUY</link>    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:2:2     */
-#define <link linkend="V4L2-PIX-FMT-YUV422P">V4L2_PIX_FMT_YUV422P</link> v4l2_fourcc('4', '2', '2', 'P') /* 16  YVU422 planar */
-#define <link linkend="V4L2-PIX-FMT-YUV411P">V4L2_PIX_FMT_YUV411P</link> v4l2_fourcc('4', '1', '1', 'P') /* 16  YVU411 planar */
-#define <link linkend="V4L2-PIX-FMT-Y41P">V4L2_PIX_FMT_Y41P</link>    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:1:1     */
-#define <link linkend="V4L2-PIX-FMT-YUV444">V4L2_PIX_FMT_YUV444</link>  v4l2_fourcc('Y', '4', '4', '4') /* 16  xxxxyyyy uuuuvvvv */
-#define <link linkend="V4L2-PIX-FMT-YUV555">V4L2_PIX_FMT_YUV555</link>  v4l2_fourcc('Y', 'U', 'V', 'O') /* 16  YUV-5-5-5     */
-#define <link linkend="V4L2-PIX-FMT-YUV565">V4L2_PIX_FMT_YUV565</link>  v4l2_fourcc('Y', 'U', 'V', 'P') /* 16  YUV-5-6-5     */
-#define <link linkend="V4L2-PIX-FMT-YUV32">V4L2_PIX_FMT_YUV32</link>   v4l2_fourcc('Y', 'U', 'V', '4') /* 32  YUV-8-8-8-8   */
-#define <link linkend="V4L2-PIX-FMT-YUV410">V4L2_PIX_FMT_YUV410</link>  v4l2_fourcc('Y', 'U', 'V', '9') /*  9  YUV 4:1:0     */
-#define <link linkend="V4L2-PIX-FMT-YUV420">V4L2_PIX_FMT_YUV420</link>  v4l2_fourcc('Y', 'U', '1', '2') /* 12  YUV 4:2:0     */
-#define <link linkend="V4L2-PIX-FMT-HI240">V4L2_PIX_FMT_HI240</link>   v4l2_fourcc('H', 'I', '2', '4') /*  8  8-bit color   */
-#define <link linkend="V4L2-PIX-FMT-HM12">V4L2_PIX_FMT_HM12</link>    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV 4:2:0 16x16 macroblocks */
-#define <link linkend="V4L2-PIX-FMT-M420">V4L2_PIX_FMT_M420</link>    v4l2_fourcc('M', '4', '2', '0') /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */
-
-/* two planes -- one Y, one Cr + Cb interleaved  */
-#define <link linkend="V4L2-PIX-FMT-NV12">V4L2_PIX_FMT_NV12</link>    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr 4:2:0  */
-#define <link linkend="V4L2-PIX-FMT-NV21">V4L2_PIX_FMT_NV21</link>    v4l2_fourcc('N', 'V', '2', '1') /* 12  Y/CrCb 4:2:0  */
-#define <link linkend="V4L2-PIX-FMT-NV16">V4L2_PIX_FMT_NV16</link>    v4l2_fourcc('N', 'V', '1', '6') /* 16  Y/CbCr 4:2:2  */
-#define <link linkend="V4L2-PIX-FMT-NV61">V4L2_PIX_FMT_NV61</link>    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
-
-/* two non contiguous planes - one Y, one Cr + Cb interleaved  */
-#define <link linkend="V4L2-PIX-FMT-NV12M">V4L2_PIX_FMT_NV12M</link>   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
-#define <link linkend="V4L2-PIX-FMT-NV12MT">V4L2_PIX_FMT_NV12MT</link>  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
-
-/* three non contiguous planes - Y, Cb, Cr */
-#define <link linkend="V4L2-PIX-FMT-YUV420M">V4L2_PIX_FMT_YUV420M</link> v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
-
-/* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
-#define <link linkend="V4L2-PIX-FMT-SBGGR8">V4L2_PIX_FMT_SBGGR8</link>  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
-#define <link linkend="V4L2-PIX-FMT-SGBRG8">V4L2_PIX_FMT_SGBRG8</link>  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
-#define <link linkend="V4L2-PIX-FMT-SGRBG8">V4L2_PIX_FMT_SGRBG8</link>  v4l2_fourcc('G', 'R', 'B', 'G') /*  8  GRGR.. BGBG.. */
-#define <link linkend="V4L2-PIX-FMT-SRGGB8">V4L2_PIX_FMT_SRGGB8</link>  v4l2_fourcc('R', 'G', 'G', 'B') /*  8  RGRG.. GBGB.. */
-#define <link linkend="V4L2-PIX-FMT-SBGGR10">V4L2_PIX_FMT_SBGGR10</link> v4l2_fourcc('B', 'G', '1', '0') /* 10  BGBG.. GRGR.. */
-#define <link linkend="V4L2-PIX-FMT-SGBRG10">V4L2_PIX_FMT_SGBRG10</link> v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
-#define <link linkend="V4L2-PIX-FMT-SGRBG10">V4L2_PIX_FMT_SGRBG10</link> v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
-#define <link linkend="V4L2-PIX-FMT-SRGGB10">V4L2_PIX_FMT_SRGGB10</link> v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
-        /* 10bit raw bayer DPCM compressed to 8 bits */
-#define <link linkend="V4L2-PIX-FMT-SGRBG10DPCM8">V4L2_PIX_FMT_SGRBG10DPCM8</link> v4l2_fourcc('B', 'D', '1', '0')
-        /*
-         * 10bit raw bayer, expanded to 16 bits
-         * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
-         */
-#define <link linkend="V4L2-PIX-FMT-SBGGR16">V4L2_PIX_FMT_SBGGR16</link> v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
-
-/* compressed formats */
-#define <link linkend="V4L2-PIX-FMT-MJPEG">V4L2_PIX_FMT_MJPEG</link>    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-JPEG   */
-#define <link linkend="V4L2-PIX-FMT-JPEG">V4L2_PIX_FMT_JPEG</link>     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
-#define <link linkend="V4L2-PIX-FMT-DV">V4L2_PIX_FMT_DV</link>       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
-#define <link linkend="V4L2-PIX-FMT-MPEG">V4L2_PIX_FMT_MPEG</link>     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4    */
-
-/*  Vendor-specific formats   */
-#define <link linkend="V4L2-PIX-FMT-CPIA1">V4L2_PIX_FMT_CPIA1</link>    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-#define <link linkend="V4L2-PIX-FMT-WNVA">V4L2_PIX_FMT_WNVA</link>     v4l2_fourcc('W', 'N', 'V', 'A') /* Winnov hw compress */
-#define <link linkend="V4L2-PIX-FMT-SN9C10X">V4L2_PIX_FMT_SN9C10X</link>  v4l2_fourcc('S', '9', '1', '0') /* SN9C10x compression */
-#define <link linkend="V4L2-PIX-FMT-SN9C20X-I420">V4L2_PIX_FMT_SN9C20X_I420</link> v4l2_fourcc('S', '9', '2', '0') /* SN9C20x YUV 4:2:0 */
-#define <link linkend="V4L2-PIX-FMT-PWC1">V4L2_PIX_FMT_PWC1</link>     v4l2_fourcc('P', 'W', 'C', '1') /* pwc older webcam */
-#define <link linkend="V4L2-PIX-FMT-PWC2">V4L2_PIX_FMT_PWC2</link>     v4l2_fourcc('P', 'W', 'C', '2') /* pwc newer webcam */
-#define <link linkend="V4L2-PIX-FMT-ET61X251">V4L2_PIX_FMT_ET61X251</link> v4l2_fourcc('E', '6', '2', '5') /* ET61X251 compression */
-#define <link linkend="V4L2-PIX-FMT-SPCA501">V4L2_PIX_FMT_SPCA501</link>  v4l2_fourcc('S', '5', '0', '1') /* YUYV per line */
-#define <link linkend="V4L2-PIX-FMT-SPCA505">V4L2_PIX_FMT_SPCA505</link>  v4l2_fourcc('S', '5', '0', '5') /* YYUV per line */
-#define <link linkend="V4L2-PIX-FMT-SPCA508">V4L2_PIX_FMT_SPCA508</link>  v4l2_fourcc('S', '5', '0', '8') /* YUVY per line */
-#define <link linkend="V4L2-PIX-FMT-SPCA561">V4L2_PIX_FMT_SPCA561</link>  v4l2_fourcc('S', '5', '6', '1') /* compressed GBRG bayer */
-#define <link linkend="V4L2-PIX-FMT-PAC207">V4L2_PIX_FMT_PAC207</link>   v4l2_fourcc('P', '2', '0', '7') /* compressed BGGR bayer */
-#define <link linkend="V4L2-PIX-FMT-MR97310A">V4L2_PIX_FMT_MR97310A</link> v4l2_fourcc('M', '3', '1', '0') /* compressed BGGR bayer */
-#define <link linkend="V4L2-PIX-FMT-SN9C2028">V4L2_PIX_FMT_SN9C2028</link> v4l2_fourcc('S', 'O', 'N', 'X') /* compressed GBRG bayer */
-#define <link linkend="V4L2-PIX-FMT-SQ905C">V4L2_PIX_FMT_SQ905C</link>   v4l2_fourcc('9', '0', '5', 'C') /* compressed RGGB bayer */
-#define <link linkend="V4L2-PIX-FMT-PJPG">V4L2_PIX_FMT_PJPG</link>     v4l2_fourcc('P', 'J', 'P', 'G') /* Pixart 73xx JPEG */
-#define <link linkend="V4L2-PIX-FMT-OV511">V4L2_PIX_FMT_OV511</link>    v4l2_fourcc('O', '5', '1', '1') /* ov511 JPEG */
-#define <link linkend="V4L2-PIX-FMT-OV518">V4L2_PIX_FMT_OV518</link>    v4l2_fourcc('O', '5', '1', '8') /* ov518 JPEG */
-#define <link linkend="V4L2-PIX-FMT-STV0680">V4L2_PIX_FMT_STV0680</link>  v4l2_fourcc('S', '6', '8', '0') /* stv0680 bayer */
-#define <link linkend="V4L2-PIX-FMT-TM6000">V4L2_PIX_FMT_TM6000</link>   v4l2_fourcc('T', 'M', '6', '0') /* tm5600/tm60x0 */
-#define <link linkend="V4L2-PIX-FMT-CIT-YYVYUY">V4L2_PIX_FMT_CIT_YYVYUY</link> v4l2_fourcc('C', 'I', 'T', 'V') /* one line of Y then 1 line of VYUY */
-#define <link linkend="V4L2-PIX-FMT-KONICA420">V4L2_PIX_FMT_KONICA420</link>  v4l2_fourcc('K', 'O', 'N', 'I') /* YUV420 planar in blocks of 256 pixels */
-
-/*
- *      F O R M A T   E N U M E R A T I O N
- */
-struct <link linkend="v4l2-fmtdesc">v4l2_fmtdesc</link> {
-        __u32               index;             /* Format number      */
-        enum <link linkend="v4l2-buf-type">v4l2_buf_type</link>  type;              /* buffer type        */
-        __u32               flags;
-        __u8                description[32];   /* Description string */
-        __u32               pixelformat;       /* Format fourcc      */
-        __u32               reserved[4];
-};
-
-#define V4L2_FMT_FLAG_COMPRESSED 0x0001
-#define V4L2_FMT_FLAG_EMULATED   0x0002
-
-#if 1
-        /* Experimental Frame Size and frame rate enumeration */
-/*
- *      F R A M E   S I Z E   E N U M E R A T I O N
- */
-enum <link linkend="v4l2-frmsizetypes">v4l2_frmsizetypes</link> {
-        V4L2_FRMSIZE_TYPE_DISCRETE      = 1,
-        V4L2_FRMSIZE_TYPE_CONTINUOUS    = 2,
-        V4L2_FRMSIZE_TYPE_STEPWISE      = 3,
-};
-
-struct <link linkend="v4l2-frmsize-discrete">v4l2_frmsize_discrete</link> {
-        __u32                   width;          /* Frame width [pixel] */
-        __u32                   height;         /* Frame height [pixel] */
-};
-
-struct <link linkend="v4l2-frmsize-stepwise">v4l2_frmsize_stepwise</link> {
-        __u32                   min_width;      /* Minimum frame width [pixel] */
-        __u32                   max_width;      /* Maximum frame width [pixel] */
-        __u32                   step_width;     /* Frame width step size [pixel] */
-        __u32                   min_height;     /* Minimum frame height [pixel] */
-        __u32                   max_height;     /* Maximum frame height [pixel] */
-        __u32                   step_height;    /* Frame height step size [pixel] */
-};
-
-struct <link linkend="v4l2-frmsizeenum">v4l2_frmsizeenum</link> {
-        __u32                   index;          /* Frame size number */
-        __u32                   pixel_format;   /* Pixel format */
-        __u32                   type;           /* Frame size type the device supports. */
-
-        union {                                 /* Frame size */
-                struct <link linkend="v4l2-frmsize-discrete">v4l2_frmsize_discrete</link>    discrete;
-                struct <link linkend="v4l2-frmsize-stepwise">v4l2_frmsize_stepwise</link>    stepwise;
-        };
-
-        __u32   reserved[2];                    /* Reserved space for future use */
-};
-
-/*
- *      F R A M E   R A T E   E N U M E R A T I O N
- */
-enum <link linkend="v4l2-frmivaltypes">v4l2_frmivaltypes</link> {
-        V4L2_FRMIVAL_TYPE_DISCRETE      = 1,
-        V4L2_FRMIVAL_TYPE_CONTINUOUS    = 2,
-        V4L2_FRMIVAL_TYPE_STEPWISE      = 3,
-};
-
-struct <link linkend="v4l2-frmival-stepwise">v4l2_frmival_stepwise</link> {
-        struct <link linkend="v4l2-fract">v4l2_fract</link>       min;            /* Minimum frame interval [s] */
-        struct <link linkend="v4l2-fract">v4l2_fract</link>       max;            /* Maximum frame interval [s] */
-        struct <link linkend="v4l2-fract">v4l2_fract</link>       step;           /* Frame interval step size [s] */
-};
-
-struct <link linkend="v4l2-frmivalenum">v4l2_frmivalenum</link> {
-        __u32                   index;          /* Frame format index */
-        __u32                   pixel_format;   /* Pixel format */
-        __u32                   width;          /* Frame width */
-        __u32                   height;         /* Frame height */
-        __u32                   type;           /* Frame interval type the device supports. */
-
-        union {                                 /* Frame interval */
-                struct <link linkend="v4l2-fract">v4l2_fract</link>               discrete;
-                struct <link linkend="v4l2-frmival-stepwise">v4l2_frmival_stepwise</link>    stepwise;
-        };
-
-        __u32   reserved[2];                    /* Reserved space for future use */
-};
-#endif
-
-/*
- *      T I M E C O D E
- */
-struct <link linkend="v4l2-timecode">v4l2_timecode</link> {
-        __u32   type;
-        __u32   flags;
-        __u8    frames;
-        __u8    seconds;
-        __u8    minutes;
-        __u8    hours;
-        __u8    userbits[4];
-};
-
-/*  Type  */
-#define V4L2_TC_TYPE_24FPS              1
-#define V4L2_TC_TYPE_25FPS              2
-#define V4L2_TC_TYPE_30FPS              3
-#define V4L2_TC_TYPE_50FPS              4
-#define V4L2_TC_TYPE_60FPS              5
-
-/*  Flags  */
-#define V4L2_TC_FLAG_DROPFRAME          0x0001 /* "drop-frame" mode */
-#define V4L2_TC_FLAG_COLORFRAME         0x0002
-#define V4L2_TC_USERBITS_field          0x000C
-#define V4L2_TC_USERBITS_USERDEFINED    0x0000
-#define V4L2_TC_USERBITS_8BITCHARS      0x0008
-/* The above is based on SMPTE timecodes */
-
-struct <link linkend="v4l2-jpegcompression">v4l2_jpegcompression</link> {
-        int quality;
-
-        int  APPn;              /* Number of APP segment to be written,
-                                 * must be 0..15 */
-        int  APP_len;           /* Length of data in JPEG APPn segment */
-        char APP_data[60];      /* Data in the JPEG APPn segment. */
-
-        int  COM_len;           /* Length of data in JPEG COM segment */
-        char COM_data[60];      /* Data in JPEG COM segment */
-
-        __u32 jpeg_markers;     /* Which markers should go into the JPEG
-                                 * output. Unless you exactly know what
-                                 * you do, leave them untouched.
-                                 * Inluding less markers will make the
-                                 * resulting code smaller, but there will
-                                 * be fewer applications which can read it.
-                                 * The presence of the APP and COM marker
-                                 * is influenced by APP_len and COM_len
-                                 * ONLY, not by this property! */
-
-#define V4L2_JPEG_MARKER_DHT (1&lt;&lt;3)    /* Define Huffman Tables */
-#define V4L2_JPEG_MARKER_DQT (1&lt;&lt;4)    /* Define Quantization Tables */
-#define V4L2_JPEG_MARKER_DRI (1&lt;&lt;5)    /* Define Restart Interval */
-#define V4L2_JPEG_MARKER_COM (1&lt;&lt;6)    /* Comment segment */
-#define V4L2_JPEG_MARKER_APP (1&lt;&lt;7)    /* App segment, driver will
-                                        * allways use APP0 */
-};
-
-/*
- *      M E M O R Y - M A P P I N G   B U F F E R S
- */
-struct <link linkend="v4l2-requestbuffers">v4l2_requestbuffers</link> {
-        __u32                   count;
-        enum <link linkend="v4l2-buf-type">v4l2_buf_type</link>      type;
-        enum <link linkend="v4l2-memory">v4l2_memory</link>        memory;
-        __u32                   reserved[2];
-};
-
-/**
- * struct <link linkend="v4l2-plane">v4l2_plane</link> - plane info for multi-planar buffers
- * @bytesused:          number of bytes occupied by data in the plane (payload)
- * @length:             size of this plane (NOT the payload) in bytes
- * @mem_offset:         when memory in the associated struct <link linkend="v4l2-buffer">v4l2_buffer</link> is
- *                      V4L2_MEMORY_MMAP, equals the offset from the start of
- *                      the device memory for this plane (or is a "cookie" that
- *                      should be passed to mmap() called on the video node)
- * @userptr:            when memory is V4L2_MEMORY_USERPTR, a userspace pointer
- *                      pointing to this plane
- * @data_offset:        offset in the plane to the start of data; usually 0,
- *                      unless there is a header in front of the data
- *
- * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
- * with two planes can have one plane for Y, and another for interleaved CbCr
- * components. Each plane can reside in a separate memory buffer, or even in
- * a completely separate memory node (e.g. in embedded devices).
- */
-struct <link linkend="v4l2-plane">v4l2_plane</link> {
-        __u32                   bytesused;
-        __u32                   length;
-        union {
-                __u32           mem_offset;
-                unsigned long   userptr;
-        } m;
-        __u32                   data_offset;
-        __u32                   reserved[11];
-};
-
-/**
- * struct <link linkend="v4l2-buffer">v4l2_buffer</link> - video buffer info
- * @index:      id number of the buffer
- * @type:       buffer type (type == *_MPLANE for multiplanar buffers)
- * @bytesused:  number of bytes occupied by data in the buffer (payload);
- *              unused (set to 0) for multiplanar buffers
- * @flags:      buffer informational flags
- * @field:      field order of the image in the buffer
- * @timestamp:  frame timestamp
- * @timecode:   frame timecode
- * @sequence:   sequence count of this frame
- * @memory:     the method, in which the actual video data is passed
- * @offset:     for non-multiplanar buffers with memory == V4L2_MEMORY_MMAP;
- *              offset from the start of the device memory for this plane,
- *              (or a "cookie" that should be passed to mmap() as offset)
- * @userptr:    for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
- *              a userspace pointer pointing to this buffer
- * @planes:     for multiplanar buffers; userspace pointer to the array of plane
- *              info structs for this buffer
- * @length:     size in bytes of the buffer (NOT its payload) for single-plane
- *              buffers (when type != *_MPLANE); number of elements in the
- *              planes array for multi-plane buffers
- * @input:      input number from which the video data has has been captured
- *
- * Contains data exchanged by application and driver using one of the Streaming
- * I/O methods.
- */
-struct <link linkend="v4l2-buffer">v4l2_buffer</link> {
-        __u32                   index;
-        enum <link linkend="v4l2-buf-type">v4l2_buf_type</link>      type;
-        __u32                   bytesused;
-        __u32                   flags;
-        enum <link linkend="v4l2-field">v4l2_field</link>         field;
-        struct timeval          timestamp;
-        struct <link linkend="v4l2-timecode">v4l2_timecode</link>    timecode;
-        __u32                   sequence;
-
-        /* memory location */
-        enum <link linkend="v4l2-memory">v4l2_memory</link>        memory;
-        union {
-                __u32           offset;
-                unsigned long   userptr;
-                struct <link linkend="v4l2-plane">v4l2_plane</link> *planes;
-        } m;
-        __u32                   length;
-        __u32                   input;
-        __u32                   reserved;
-};
-
-/*  Flags for 'flags' field */
-#define V4L2_BUF_FLAG_MAPPED    0x0001  /* Buffer is mapped (flag) */
-#define V4L2_BUF_FLAG_QUEUED    0x0002  /* Buffer is queued for processing */
-#define V4L2_BUF_FLAG_DONE      0x0004  /* Buffer is ready */
-#define V4L2_BUF_FLAG_KEYFRAME  0x0008  /* Image is a keyframe (I-frame) */
-#define V4L2_BUF_FLAG_PFRAME    0x0010  /* Image is a P-frame */
-#define V4L2_BUF_FLAG_BFRAME    0x0020  /* Image is a B-frame */
-/* Buffer is ready, but the data contained within is corrupted. */
-#define V4L2_BUF_FLAG_ERROR     0x0040
-#define V4L2_BUF_FLAG_TIMECODE  0x0100  /* timecode field is valid */
-#define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
-
-/*
- *      O V E R L A Y   P R E V I E W
- */
-struct <link linkend="v4l2-framebuffer">v4l2_framebuffer</link> {
-        __u32                   capability;
-        __u32                   flags;
-/* FIXME: in theory we should pass something like PCI device + memory
- * region + offset instead of some physical address */
-        void                    *base;
-        struct <link linkend="v4l2-pix-format">v4l2_pix_format</link>  fmt;
-};
-/*  Flags for the 'capability' field. Read only */
-#define V4L2_FBUF_CAP_EXTERNOVERLAY     0x0001
-#define V4L2_FBUF_CAP_CHROMAKEY         0x0002
-#define V4L2_FBUF_CAP_LIST_CLIPPING     0x0004
-#define V4L2_FBUF_CAP_BITMAP_CLIPPING   0x0008
-#define V4L2_FBUF_CAP_LOCAL_ALPHA       0x0010
-#define V4L2_FBUF_CAP_GLOBAL_ALPHA      0x0020
-#define V4L2_FBUF_CAP_LOCAL_INV_ALPHA   0x0040
-#define V4L2_FBUF_CAP_SRC_CHROMAKEY     0x0080
-/*  Flags for the 'flags' field. */
-#define V4L2_FBUF_FLAG_PRIMARY          0x0001
-#define V4L2_FBUF_FLAG_OVERLAY          0x0002
-#define V4L2_FBUF_FLAG_CHROMAKEY        0x0004
-#define V4L2_FBUF_FLAG_LOCAL_ALPHA      0x0008
-#define V4L2_FBUF_FLAG_GLOBAL_ALPHA     0x0010
-#define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA  0x0020
-#define V4L2_FBUF_FLAG_SRC_CHROMAKEY    0x0040
-
-struct <link linkend="v4l2-clip">v4l2_clip</link> {
-        struct <link linkend="v4l2-rect">v4l2_rect</link>        c;
-        struct <link linkend="v4l2-clip">v4l2_clip</link>        __user *next;
-};
-
-struct <link linkend="v4l2-window">v4l2_window</link> {
-        struct <link linkend="v4l2-rect">v4l2_rect</link>        w;
-        enum <link linkend="v4l2-field">v4l2_field</link>         field;
-        __u32                   chromakey;
-        struct <link linkend="v4l2-clip">v4l2_clip</link>        __user *clips;
-        __u32                   clipcount;
-        void                    __user *bitmap;
-        __u8                    global_alpha;
-};
-
-/*
- *      C A P T U R E   P A R A M E T E R S
- */
-struct <link linkend="v4l2-captureparm">v4l2_captureparm</link> {
-        __u32              capability;    /*  Supported modes */
-        __u32              capturemode;   /*  Current mode */
-        struct <link linkend="v4l2-fract">v4l2_fract</link>  timeperframe;  /*  Time per frame in .1us units */
-        __u32              extendedmode;  /*  Driver-specific extensions */
-        __u32              readbuffers;   /*  # of buffers for read */
-        __u32              reserved[4];
-};
-
-/*  Flags for 'capability' and 'capturemode' fields */
-#define V4L2_MODE_HIGHQUALITY   0x0001  /*  High quality imaging mode */
-#define V4L2_CAP_TIMEPERFRAME   0x1000  /*  timeperframe field is supported */
-
-struct <link linkend="v4l2-outputparm">v4l2_outputparm</link> {
-        __u32              capability;   /*  Supported modes */
-        __u32              outputmode;   /*  Current mode */
-        struct <link linkend="v4l2-fract">v4l2_fract</link>  timeperframe; /*  Time per frame in seconds */
-        __u32              extendedmode; /*  Driver-specific extensions */
-        __u32              writebuffers; /*  # of buffers for write */
-        __u32              reserved[4];
-};
-
-/*
- *      I N P U T   I M A G E   C R O P P I N G
- */
-struct <link linkend="v4l2-cropcap">v4l2_cropcap</link> {
-        enum <link linkend="v4l2-buf-type">v4l2_buf_type</link>      type;
-        struct <link linkend="v4l2-rect">v4l2_rect</link>        bounds;
-        struct <link linkend="v4l2-rect">v4l2_rect</link>        defrect;
-        struct <link linkend="v4l2-fract">v4l2_fract</link>       pixelaspect;
-};
-
-struct <link linkend="v4l2-crop">v4l2_crop</link> {
-        enum <link linkend="v4l2-buf-type">v4l2_buf_type</link>      type;
-        struct <link linkend="v4l2-rect">v4l2_rect</link>        c;
-};
-
-/*
- *      A N A L O G   V I D E O   S T A N D A R D
- */
-
-typedef __u64 v4l2_std_id;
-
-/* one bit for each */
-#define V4L2_STD_PAL_B          ((v4l2_std_id)0x00000001)
-#define V4L2_STD_PAL_B1         ((v4l2_std_id)0x00000002)
-#define V4L2_STD_PAL_G          ((v4l2_std_id)0x00000004)
-#define V4L2_STD_PAL_H          ((v4l2_std_id)0x00000008)
-#define V4L2_STD_PAL_I          ((v4l2_std_id)0x00000010)
-#define V4L2_STD_PAL_D          ((v4l2_std_id)0x00000020)
-#define V4L2_STD_PAL_D1         ((v4l2_std_id)0x00000040)
-#define V4L2_STD_PAL_K          ((v4l2_std_id)0x00000080)
-
-#define V4L2_STD_PAL_M          ((v4l2_std_id)0x00000100)
-#define V4L2_STD_PAL_N          ((v4l2_std_id)0x00000200)
-#define V4L2_STD_PAL_Nc         ((v4l2_std_id)0x00000400)
-#define V4L2_STD_PAL_60         ((v4l2_std_id)0x00000800)
-
-#define V4L2_STD_NTSC_M         ((v4l2_std_id)0x00001000)
-#define V4L2_STD_NTSC_M_JP      ((v4l2_std_id)0x00002000)
-#define V4L2_STD_NTSC_443       ((v4l2_std_id)0x00004000)
-#define V4L2_STD_NTSC_M_KR      ((v4l2_std_id)0x00008000)
-
-#define V4L2_STD_SECAM_B        ((v4l2_std_id)0x00010000)
-#define V4L2_STD_SECAM_D        ((v4l2_std_id)0x00020000)
-#define V4L2_STD_SECAM_G        ((v4l2_std_id)0x00040000)
-#define V4L2_STD_SECAM_H        ((v4l2_std_id)0x00080000)
-#define V4L2_STD_SECAM_K        ((v4l2_std_id)0x00100000)
-#define V4L2_STD_SECAM_K1       ((v4l2_std_id)0x00200000)
-#define V4L2_STD_SECAM_L        ((v4l2_std_id)0x00400000)
-#define V4L2_STD_SECAM_LC       ((v4l2_std_id)0x00800000)
-
-/* ATSC/HDTV */
-#define V4L2_STD_ATSC_8_VSB     ((v4l2_std_id)0x01000000)
-#define V4L2_STD_ATSC_16_VSB    ((v4l2_std_id)0x02000000)
-
-/* FIXME:
-   Although std_id is 64 bits, there is an issue on PPC32 architecture that
-   makes switch(__u64) to break. So, there's a hack on v4l2-common.c rounding
-   this value to 32 bits.
-   As, currently, the max value is for V4L2_STD_ATSC_16_VSB (30 bits wide),
-   it should work fine. However, if needed to add more than two standards,
-   v4l2-common.c should be fixed.
- */
-
-/* some merged standards */
-#define V4L2_STD_MN     (V4L2_STD_PAL_M|V4L2_STD_PAL_N|V4L2_STD_PAL_Nc|V4L2_STD_NTSC)
-#define V4L2_STD_B      (V4L2_STD_PAL_B|V4L2_STD_PAL_B1|V4L2_STD_SECAM_B)
-#define V4L2_STD_GH     (V4L2_STD_PAL_G|V4L2_STD_PAL_H|V4L2_STD_SECAM_G|V4L2_STD_SECAM_H)
-#define V4L2_STD_DK     (V4L2_STD_PAL_DK|V4L2_STD_SECAM_DK)
-
-/* some common needed stuff */
-#define V4L2_STD_PAL_BG         (V4L2_STD_PAL_B         |\
-                                 V4L2_STD_PAL_B1        |\
-                                 V4L2_STD_PAL_G)
-#define V4L2_STD_PAL_DK         (V4L2_STD_PAL_D         |\
-                                 V4L2_STD_PAL_D1        |\
-                                 V4L2_STD_PAL_K)
-#define V4L2_STD_PAL            (V4L2_STD_PAL_BG        |\
-                                 V4L2_STD_PAL_DK        |\
-                                 V4L2_STD_PAL_H         |\
-                                 V4L2_STD_PAL_I)
-#define V4L2_STD_NTSC           (V4L2_STD_NTSC_M        |\
-                                 V4L2_STD_NTSC_M_JP     |\
-                                 V4L2_STD_NTSC_M_KR)
-#define V4L2_STD_SECAM_DK       (V4L2_STD_SECAM_D       |\
-                                 V4L2_STD_SECAM_K       |\
-                                 V4L2_STD_SECAM_K1)
-#define V4L2_STD_SECAM          (V4L2_STD_SECAM_B       |\
-                                 V4L2_STD_SECAM_G       |\
-                                 V4L2_STD_SECAM_H       |\
-                                 V4L2_STD_SECAM_DK      |\
-                                 V4L2_STD_SECAM_L       |\
-                                 V4L2_STD_SECAM_LC)
-
-#define V4L2_STD_525_60         (V4L2_STD_PAL_M         |\
-                                 V4L2_STD_PAL_60        |\
-                                 V4L2_STD_NTSC          |\
-                                 V4L2_STD_NTSC_443)
-#define V4L2_STD_625_50         (V4L2_STD_PAL           |\
-                                 V4L2_STD_PAL_N         |\
-                                 V4L2_STD_PAL_Nc        |\
-                                 V4L2_STD_SECAM)
-#define V4L2_STD_ATSC           (V4L2_STD_ATSC_8_VSB    |\
-                                 V4L2_STD_ATSC_16_VSB)
-
-#define V4L2_STD_UNKNOWN        0
-#define V4L2_STD_ALL            (V4L2_STD_525_60        |\
-                                 V4L2_STD_625_50)
-
-struct <link linkend="v4l2-standard">v4l2_standard</link> {
-        __u32                index;
-        v4l2_std_id          id;
-        __u8                 name[24];
-        struct <link linkend="v4l2-fract">v4l2_fract</link>    frameperiod; /* Frames, not fields */
-        __u32                framelines;
-        __u32                reserved[4];
-};
-
-/*
- *      V I D E O       T I M I N G S   D V     P R E S E T
- */
-struct <link linkend="v4l2-dv-preset">v4l2_dv_preset</link> {
-        __u32   preset;
-        __u32   reserved[4];
-};
-
-/*
- *      D V     P R E S E T S   E N U M E R A T I O N
- */
-struct <link linkend="v4l2-dv-enum-preset">v4l2_dv_enum_preset</link> {
-        __u32   index;
-        __u32   preset;
-        __u8    name[32]; /* Name of the preset timing */
-        __u32   width;
-        __u32   height;
-        __u32   reserved[4];
-};
-
-/*
- *      D V     P R E S E T     V A L U E S
- */
-#define         V4L2_DV_INVALID         0
-#define         V4L2_DV_480P59_94       1 /* BT.1362 */
-#define         V4L2_DV_576P50          2 /* BT.1362 */
-#define         V4L2_DV_720P24          3 /* SMPTE 296M */
-#define         V4L2_DV_720P25          4 /* SMPTE 296M */
-#define         V4L2_DV_720P30          5 /* SMPTE 296M */
-#define         V4L2_DV_720P50          6 /* SMPTE 296M */
-#define         V4L2_DV_720P59_94       7 /* SMPTE 274M */
-#define         V4L2_DV_720P60          8 /* SMPTE 274M/296M */
-#define         V4L2_DV_1080I29_97      9 /* BT.1120/ SMPTE 274M */
-#define         V4L2_DV_1080I30         10 /* BT.1120/ SMPTE 274M */
-#define         V4L2_DV_1080I25         11 /* BT.1120 */
-#define         V4L2_DV_1080I50         12 /* SMPTE 296M */
-#define         V4L2_DV_1080I60         13 /* SMPTE 296M */
-#define         V4L2_DV_1080P24         14 /* SMPTE 296M */
-#define         V4L2_DV_1080P25         15 /* SMPTE 296M */
-#define         V4L2_DV_1080P30         16 /* SMPTE 296M */
-#define         V4L2_DV_1080P50         17 /* BT.1120 */
-#define         V4L2_DV_1080P60         18 /* BT.1120 */
-
-/*
- *      D V     B T     T I M I N G S
- */
-
-/* BT.656/BT.1120 timing data */
-struct <link linkend="v4l2-bt-timings">v4l2_bt_timings</link> {
-        __u32   width;          /* width in pixels */
-        __u32   height;         /* height in lines */
-        __u32   interlaced;     /* Interlaced or progressive */
-        __u32   polarities;     /* Positive or negative polarity */
-        __u64   pixelclock;     /* Pixel clock in HZ. Ex. 74.25MHz-&gt;74250000 */
-        __u32   hfrontporch;    /* Horizpontal front porch in pixels */
-        __u32   hsync;          /* Horizontal Sync length in pixels */
-        __u32   hbackporch;     /* Horizontal back porch in pixels */
-        __u32   vfrontporch;    /* Vertical front porch in pixels */
-        __u32   vsync;          /* Vertical Sync length in lines */
-        __u32   vbackporch;     /* Vertical back porch in lines */
-        __u32   il_vfrontporch; /* Vertical front porch for bottom field of
-                                 * interlaced field formats
-                                 */
-        __u32   il_vsync;       /* Vertical sync length for bottom field of
-                                 * interlaced field formats
-                                 */
-        __u32   il_vbackporch;  /* Vertical back porch for bottom field of
-                                 * interlaced field formats
-                                 */
-        __u32   reserved[16];
-} __attribute__ ((packed));
-
-/* Interlaced or progressive format */
-#define V4L2_DV_PROGRESSIVE     0
-#define V4L2_DV_INTERLACED      1
-
-/* Polarities. If bit is not set, it is assumed to be negative polarity */
-#define V4L2_DV_VSYNC_POS_POL   0x00000001
-#define V4L2_DV_HSYNC_POS_POL   0x00000002
-
-
-/* DV timings */
-struct <link linkend="v4l2-dv-timings">v4l2_dv_timings</link> {
-        __u32 type;
-        union {
-                struct <link linkend="v4l2-bt-timings">v4l2_bt_timings</link>  bt;
-                __u32   reserved[32];
-        };
-} __attribute__ ((packed));
-
-/* Values for the type field */
-#define V4L2_DV_BT_656_1120     0       /* BT.656/1120 timing type */
-
-/*
- *      V I D E O   I N P U T S
- */
-struct <link linkend="v4l2-input">v4l2_input</link> {
-        __u32        index;             /*  Which input */
-        __u8         name[32];          /*  Label */
-        __u32        type;              /*  Type of input */
-        __u32        audioset;          /*  Associated audios (bitfield) */
-        __u32        tuner;             /*  Associated tuner */
-        v4l2_std_id  std;
-        __u32        status;
-        __u32        capabilities;
-        __u32        reserved[3];
-};
-
-/*  Values for the 'type' field */
-#define V4L2_INPUT_TYPE_TUNER           1
-#define V4L2_INPUT_TYPE_CAMERA          2
-
-/* field 'status' - general */
-#define V4L2_IN_ST_NO_POWER    0x00000001  /* Attached device is off */
-#define V4L2_IN_ST_NO_SIGNAL   0x00000002
-#define V4L2_IN_ST_NO_COLOR    0x00000004
-
-/* field 'status' - sensor orientation */
-/* If sensor is mounted upside down set both bits */
-#define V4L2_IN_ST_HFLIP       0x00000010 /* Frames are flipped horizontally */
-#define V4L2_IN_ST_VFLIP       0x00000020 /* Frames are flipped vertically */
-
-/* field 'status' - analog */
-#define V4L2_IN_ST_NO_H_LOCK   0x00000100  /* No horizontal sync lock */
-#define V4L2_IN_ST_COLOR_KILL  0x00000200  /* Color killer is active */
-
-/* field 'status' - digital */
-#define V4L2_IN_ST_NO_SYNC     0x00010000  /* No synchronization lock */
-#define V4L2_IN_ST_NO_EQU      0x00020000  /* No equalizer lock */
-#define V4L2_IN_ST_NO_CARRIER  0x00040000  /* Carrier recovery failed */
-
-/* field 'status' - VCR and set-top box */
-#define V4L2_IN_ST_MACROVISION 0x01000000  /* Macrovision detected */
-#define V4L2_IN_ST_NO_ACCESS   0x02000000  /* Conditional access denied */
-#define V4L2_IN_ST_VTR         0x04000000  /* VTR time constant */
-
-/* capabilities flags */
-#define V4L2_IN_CAP_PRESETS             0x00000001 /* Supports S_DV_PRESET */
-#define V4L2_IN_CAP_CUSTOM_TIMINGS      0x00000002 /* Supports S_DV_TIMINGS */
-#define V4L2_IN_CAP_STD                 0x00000004 /* Supports S_STD */
-
-/*
- *      V I D E O   O U T P U T S
- */
-struct <link linkend="v4l2-output">v4l2_output</link> {
-        __u32        index;             /*  Which output */
-        __u8         name[32];          /*  Label */
-        __u32        type;              /*  Type of output */
-        __u32        audioset;          /*  Associated audios (bitfield) */
-        __u32        modulator;         /*  Associated modulator */
-        v4l2_std_id  std;
-        __u32        capabilities;
-        __u32        reserved[3];
-};
-/*  Values for the 'type' field */
-#define V4L2_OUTPUT_TYPE_MODULATOR              1
-#define V4L2_OUTPUT_TYPE_ANALOG                 2
-#define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY       3
-
-/* capabilities flags */
-#define V4L2_OUT_CAP_PRESETS            0x00000001 /* Supports S_DV_PRESET */
-#define V4L2_OUT_CAP_CUSTOM_TIMINGS     0x00000002 /* Supports S_DV_TIMINGS */
-#define V4L2_OUT_CAP_STD                0x00000004 /* Supports S_STD */
-
-/*
- *      C O N T R O L S
- */
-struct <link linkend="v4l2-control">v4l2_control</link> {
-        __u32                id;
-        __s32                value;
-};
-
-struct <link linkend="v4l2-ext-control">v4l2_ext_control</link> {
-        __u32 id;
-        __u32 size;
-        __u32 reserved2[1];
-        union {
-                __s32 value;
-                __s64 value64;
-                char *string;
-        };
-} __attribute__ ((packed));
-
-struct <link linkend="v4l2-ext-controls">v4l2_ext_controls</link> {
-        __u32 ctrl_class;
-        __u32 count;
-        __u32 error_idx;
-        __u32 reserved[2];
-        struct <link linkend="v4l2-ext-control">v4l2_ext_control</link> *controls;
-};
-
-/*  Values for ctrl_class field */
-#define V4L2_CTRL_CLASS_USER 0x00980000 /* Old-style 'user' controls */
-#define V4L2_CTRL_CLASS_MPEG 0x00990000 /* MPEG-compression controls */
-#define V4L2_CTRL_CLASS_CAMERA 0x009a0000       /* Camera class controls */
-#define V4L2_CTRL_CLASS_FM_TX 0x009b0000        /* FM Modulator control class */
-
-#define V4L2_CTRL_ID_MASK         (0x0fffffff)
-#define V4L2_CTRL_ID2CLASS(id)    ((id) &amp; 0x0fff0000UL)
-#define V4L2_CTRL_DRIVER_PRIV(id) (((id) &amp; 0xffff) &gt;= 0x1000)
-
-enum <link linkend="v4l2-ctrl-type">v4l2_ctrl_type</link> {
-        V4L2_CTRL_TYPE_INTEGER       = 1,
-        V4L2_CTRL_TYPE_BOOLEAN       = 2,
-        V4L2_CTRL_TYPE_MENU          = 3,
-        V4L2_CTRL_TYPE_BUTTON        = 4,
-        V4L2_CTRL_TYPE_INTEGER64     = 5,
-        V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
-        V4L2_CTRL_TYPE_STRING        = 7,
-};
-
-/*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-struct <link linkend="v4l2-queryctrl">v4l2_queryctrl</link> {
-        __u32                id;
-        enum <link linkend="v4l2-ctrl-type">v4l2_ctrl_type</link>  type;
-        __u8                 name[32];  /* Whatever */
-        __s32                minimum;   /* Note signedness */
-        __s32                maximum;
-        __s32                step;
-        __s32                default_value;
-        __u32                flags;
-        __u32                reserved[2];
-};
-
-/*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
-struct <link linkend="v4l2-querymenu">v4l2_querymenu</link> {
-        __u32           id;
-        __u32           index;
-        __u8            name[32];       /* Whatever */
-        __u32           reserved;
-};
-
-/*  Control flags  */
-#define V4L2_CTRL_FLAG_DISABLED         0x0001
-#define V4L2_CTRL_FLAG_GRABBED          0x0002
-#define V4L2_CTRL_FLAG_READ_ONLY        0x0004
-#define V4L2_CTRL_FLAG_UPDATE           0x0008
-#define V4L2_CTRL_FLAG_INACTIVE         0x0010
-#define V4L2_CTRL_FLAG_SLIDER           0x0020
-#define V4L2_CTRL_FLAG_WRITE_ONLY       0x0040
-
-/*  Query flag, to be ORed with the control ID */
-#define V4L2_CTRL_FLAG_NEXT_CTRL        0x80000000
-
-/*  User-class control IDs defined by V4L2 */
-#define V4L2_CID_BASE                   (V4L2_CTRL_CLASS_USER | 0x900)
-#define V4L2_CID_USER_BASE              V4L2_CID_BASE
-/*  IDs reserved for driver specific controls */
-#define V4L2_CID_PRIVATE_BASE           0x08000000
-
-#define V4L2_CID_USER_CLASS             (V4L2_CTRL_CLASS_USER | 1)
-#define V4L2_CID_BRIGHTNESS             (V4L2_CID_BASE+0)
-#define V4L2_CID_CONTRAST               (V4L2_CID_BASE+1)
-#define V4L2_CID_SATURATION             (V4L2_CID_BASE+2)
-#define V4L2_CID_HUE                    (V4L2_CID_BASE+3)
-#define V4L2_CID_AUDIO_VOLUME           (V4L2_CID_BASE+5)
-#define V4L2_CID_AUDIO_BALANCE          (V4L2_CID_BASE+6)
-#define V4L2_CID_AUDIO_BASS             (V4L2_CID_BASE+7)
-#define V4L2_CID_AUDIO_TREBLE           (V4L2_CID_BASE+8)
-#define V4L2_CID_AUDIO_MUTE             (V4L2_CID_BASE+9)
-#define V4L2_CID_AUDIO_LOUDNESS         (V4L2_CID_BASE+10)
-#define V4L2_CID_BLACK_LEVEL            (V4L2_CID_BASE+11) /* Deprecated */
-#define V4L2_CID_AUTO_WHITE_BALANCE     (V4L2_CID_BASE+12)
-#define V4L2_CID_DO_WHITE_BALANCE       (V4L2_CID_BASE+13)
-#define V4L2_CID_RED_BALANCE            (V4L2_CID_BASE+14)
-#define V4L2_CID_BLUE_BALANCE           (V4L2_CID_BASE+15)
-#define V4L2_CID_GAMMA                  (V4L2_CID_BASE+16)
-#define V4L2_CID_WHITENESS              (V4L2_CID_GAMMA) /* Deprecated */
-#define V4L2_CID_EXPOSURE               (V4L2_CID_BASE+17)
-#define V4L2_CID_AUTOGAIN               (V4L2_CID_BASE+18)
-#define V4L2_CID_GAIN                   (V4L2_CID_BASE+19)
-#define V4L2_CID_HFLIP                  (V4L2_CID_BASE+20)
-#define V4L2_CID_VFLIP                  (V4L2_CID_BASE+21)
-
-/* Deprecated; use V4L2_CID_PAN_RESET and V4L2_CID_TILT_RESET */
-#define V4L2_CID_HCENTER                (V4L2_CID_BASE+22)
-#define V4L2_CID_VCENTER                (V4L2_CID_BASE+23)
-
-#define V4L2_CID_POWER_LINE_FREQUENCY   (V4L2_CID_BASE+24)
-enum <link linkend="v4l2-power-line-frequency">v4l2_power_line_frequency</link> {
-        V4L2_CID_POWER_LINE_FREQUENCY_DISABLED  = 0,
-        V4L2_CID_POWER_LINE_FREQUENCY_50HZ      = 1,
-        V4L2_CID_POWER_LINE_FREQUENCY_60HZ      = 2,
-};
-#define V4L2_CID_HUE_AUTO                       (V4L2_CID_BASE+25)
-#define V4L2_CID_WHITE_BALANCE_TEMPERATURE      (V4L2_CID_BASE+26)
-#define V4L2_CID_SHARPNESS                      (V4L2_CID_BASE+27)
-#define V4L2_CID_BACKLIGHT_COMPENSATION         (V4L2_CID_BASE+28)
-#define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
-#define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
-#define V4L2_CID_COLORFX                        (V4L2_CID_BASE+31)
-enum <link linkend="v4l2-colorfx">v4l2_colorfx</link> {
-        V4L2_COLORFX_NONE       = 0,
-        V4L2_COLORFX_BW         = 1,
-        V4L2_COLORFX_SEPIA      = 2,
-        V4L2_COLORFX_NEGATIVE = 3,
-        V4L2_COLORFX_EMBOSS = 4,
-        V4L2_COLORFX_SKETCH = 5,
-        V4L2_COLORFX_SKY_BLUE = 6,
-        V4L2_COLORFX_GRASS_GREEN = 7,
-        V4L2_COLORFX_SKIN_WHITEN = 8,
-        V4L2_COLORFX_VIVID = 9,
-};
-#define V4L2_CID_AUTOBRIGHTNESS                 (V4L2_CID_BASE+32)
-#define V4L2_CID_BAND_STOP_FILTER               (V4L2_CID_BASE+33)
-
-#define V4L2_CID_ROTATE                         (V4L2_CID_BASE+34)
-#define V4L2_CID_BG_COLOR                       (V4L2_CID_BASE+35)
-
-#define V4L2_CID_CHROMA_GAIN                    (V4L2_CID_BASE+36)
-
-#define V4L2_CID_ILLUMINATORS_1                 (V4L2_CID_BASE+37)
-#define V4L2_CID_ILLUMINATORS_2                 (V4L2_CID_BASE+38)
-
-/* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+39)
-
-/*  MPEG-class control IDs defined by V4L2 */
-#define V4L2_CID_MPEG_BASE                      (V4L2_CTRL_CLASS_MPEG | 0x900)
-#define V4L2_CID_MPEG_CLASS                     (V4L2_CTRL_CLASS_MPEG | 1)
-
-/*  MPEG streams */
-#define V4L2_CID_MPEG_STREAM_TYPE               (V4L2_CID_MPEG_BASE+0)
-enum <link linkend="v4l2-mpeg-stream-type">v4l2_mpeg_stream_type</link> {
-        V4L2_MPEG_STREAM_TYPE_MPEG2_PS   = 0, /* MPEG-2 program stream */
-        V4L2_MPEG_STREAM_TYPE_MPEG2_TS   = 1, /* MPEG-2 transport stream */
-        V4L2_MPEG_STREAM_TYPE_MPEG1_SS   = 2, /* MPEG-1 system stream */
-        V4L2_MPEG_STREAM_TYPE_MPEG2_DVD  = 3, /* MPEG-2 DVD-compatible stream */
-        V4L2_MPEG_STREAM_TYPE_MPEG1_VCD  = 4, /* MPEG-1 VCD-compatible stream */
-        V4L2_MPEG_STREAM_TYPE_MPEG2_SVCD = 5, /* MPEG-2 SVCD-compatible stream */
-};
-#define V4L2_CID_MPEG_STREAM_PID_PMT            (V4L2_CID_MPEG_BASE+1)
-#define V4L2_CID_MPEG_STREAM_PID_AUDIO          (V4L2_CID_MPEG_BASE+2)
-#define V4L2_CID_MPEG_STREAM_PID_VIDEO          (V4L2_CID_MPEG_BASE+3)
-#define V4L2_CID_MPEG_STREAM_PID_PCR            (V4L2_CID_MPEG_BASE+4)
-#define V4L2_CID_MPEG_STREAM_PES_ID_AUDIO       (V4L2_CID_MPEG_BASE+5)
-#define V4L2_CID_MPEG_STREAM_PES_ID_VIDEO       (V4L2_CID_MPEG_BASE+6)
-#define V4L2_CID_MPEG_STREAM_VBI_FMT            (V4L2_CID_MPEG_BASE+7)
-enum <link linkend="v4l2-mpeg-stream-vbi-fmt">v4l2_mpeg_stream_vbi_fmt</link> {
-        V4L2_MPEG_STREAM_VBI_FMT_NONE = 0,  /* No VBI in the MPEG stream */
-        V4L2_MPEG_STREAM_VBI_FMT_IVTV = 1,  /* VBI in private packets, IVTV format */
-};
-
-/*  MPEG audio */
-#define V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ       (V4L2_CID_MPEG_BASE+100)
-enum <link linkend="v4l2-mpeg-audio-sampling-freq">v4l2_mpeg_audio_sampling_freq</link> {
-        V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100 = 0,
-        V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000 = 1,
-        V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000 = 2,
-};
-#define V4L2_CID_MPEG_AUDIO_ENCODING            (V4L2_CID_MPEG_BASE+101)
-enum <link linkend="v4l2-mpeg-audio-encoding">v4l2_mpeg_audio_encoding</link> {
-        V4L2_MPEG_AUDIO_ENCODING_LAYER_1 = 0,
-        V4L2_MPEG_AUDIO_ENCODING_LAYER_2 = 1,
-        V4L2_MPEG_AUDIO_ENCODING_LAYER_3 = 2,
-        V4L2_MPEG_AUDIO_ENCODING_AAC     = 3,
-        V4L2_MPEG_AUDIO_ENCODING_AC3     = 4,
-};
-#define V4L2_CID_MPEG_AUDIO_L1_BITRATE          (V4L2_CID_MPEG_BASE+102)
-enum <link linkend="v4l2-mpeg-audio-l1-bitrate">v4l2_mpeg_audio_l1_bitrate</link> {
-        V4L2_MPEG_AUDIO_L1_BITRATE_32K  = 0,
-        V4L2_MPEG_AUDIO_L1_BITRATE_64K  = 1,
-        V4L2_MPEG_AUDIO_L1_BITRATE_96K  = 2,
-        V4L2_MPEG_AUDIO_L1_BITRATE_128K = 3,
-        V4L2_MPEG_AUDIO_L1_BITRATE_160K = 4,
-        V4L2_MPEG_AUDIO_L1_BITRATE_192K = 5,
-        V4L2_MPEG_AUDIO_L1_BITRATE_224K = 6,
-        V4L2_MPEG_AUDIO_L1_BITRATE_256K = 7,
-        V4L2_MPEG_AUDIO_L1_BITRATE_288K = 8,
-        V4L2_MPEG_AUDIO_L1_BITRATE_320K = 9,
-        V4L2_MPEG_AUDIO_L1_BITRATE_352K = 10,
-        V4L2_MPEG_AUDIO_L1_BITRATE_384K = 11,
-        V4L2_MPEG_AUDIO_L1_BITRATE_416K = 12,
-        V4L2_MPEG_AUDIO_L1_BITRATE_448K = 13,
-};
-#define V4L2_CID_MPEG_AUDIO_L2_BITRATE          (V4L2_CID_MPEG_BASE+103)
-enum <link linkend="v4l2-mpeg-audio-l2-bitrate">v4l2_mpeg_audio_l2_bitrate</link> {
-        V4L2_MPEG_AUDIO_L2_BITRATE_32K  = 0,
-        V4L2_MPEG_AUDIO_L2_BITRATE_48K  = 1,
-        V4L2_MPEG_AUDIO_L2_BITRATE_56K  = 2,
-        V4L2_MPEG_AUDIO_L2_BITRATE_64K  = 3,
-        V4L2_MPEG_AUDIO_L2_BITRATE_80K  = 4,
-        V4L2_MPEG_AUDIO_L2_BITRATE_96K  = 5,
-        V4L2_MPEG_AUDIO_L2_BITRATE_112K = 6,
-        V4L2_MPEG_AUDIO_L2_BITRATE_128K = 7,
-        V4L2_MPEG_AUDIO_L2_BITRATE_160K = 8,
-        V4L2_MPEG_AUDIO_L2_BITRATE_192K = 9,
-        V4L2_MPEG_AUDIO_L2_BITRATE_224K = 10,
-        V4L2_MPEG_AUDIO_L2_BITRATE_256K = 11,
-        V4L2_MPEG_AUDIO_L2_BITRATE_320K = 12,
-        V4L2_MPEG_AUDIO_L2_BITRATE_384K = 13,
-};
-#define V4L2_CID_MPEG_AUDIO_L3_BITRATE          (V4L2_CID_MPEG_BASE+104)
-enum <link linkend="v4l2-mpeg-audio-l3-bitrate">v4l2_mpeg_audio_l3_bitrate</link> {
-        V4L2_MPEG_AUDIO_L3_BITRATE_32K  = 0,
-        V4L2_MPEG_AUDIO_L3_BITRATE_40K  = 1,
-        V4L2_MPEG_AUDIO_L3_BITRATE_48K  = 2,
-        V4L2_MPEG_AUDIO_L3_BITRATE_56K  = 3,
-        V4L2_MPEG_AUDIO_L3_BITRATE_64K  = 4,
-        V4L2_MPEG_AUDIO_L3_BITRATE_80K  = 5,
-        V4L2_MPEG_AUDIO_L3_BITRATE_96K  = 6,
-        V4L2_MPEG_AUDIO_L3_BITRATE_112K = 7,
-        V4L2_MPEG_AUDIO_L3_BITRATE_128K = 8,
-        V4L2_MPEG_AUDIO_L3_BITRATE_160K = 9,
-        V4L2_MPEG_AUDIO_L3_BITRATE_192K = 10,
-        V4L2_MPEG_AUDIO_L3_BITRATE_224K = 11,
-        V4L2_MPEG_AUDIO_L3_BITRATE_256K = 12,
-        V4L2_MPEG_AUDIO_L3_BITRATE_320K = 13,
-};
-#define V4L2_CID_MPEG_AUDIO_MODE                (V4L2_CID_MPEG_BASE+105)
-enum <link linkend="v4l2-mpeg-audio-mode">v4l2_mpeg_audio_mode</link> {
-        V4L2_MPEG_AUDIO_MODE_STEREO       = 0,
-        V4L2_MPEG_AUDIO_MODE_JOINT_STEREO = 1,
-        V4L2_MPEG_AUDIO_MODE_DUAL         = 2,
-        V4L2_MPEG_AUDIO_MODE_MONO         = 3,
-};
-#define V4L2_CID_MPEG_AUDIO_MODE_EXTENSION      (V4L2_CID_MPEG_BASE+106)
-enum <link linkend="v4l2-mpeg-audio-mode-extension">v4l2_mpeg_audio_mode_extension</link> {
-        V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_4  = 0,
-        V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_8  = 1,
-        V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_12 = 2,
-        V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_16 = 3,
-};
-#define V4L2_CID_MPEG_AUDIO_EMPHASIS            (V4L2_CID_MPEG_BASE+107)
-enum <link linkend="v4l2-mpeg-audio-emphasis">v4l2_mpeg_audio_emphasis</link> {
-        V4L2_MPEG_AUDIO_EMPHASIS_NONE         = 0,
-        V4L2_MPEG_AUDIO_EMPHASIS_50_DIV_15_uS = 1,
-        V4L2_MPEG_AUDIO_EMPHASIS_CCITT_J17    = 2,
-};
-#define V4L2_CID_MPEG_AUDIO_CRC                 (V4L2_CID_MPEG_BASE+108)
-enum <link linkend="v4l2-mpeg-audio-crc">v4l2_mpeg_audio_crc</link> {
-        V4L2_MPEG_AUDIO_CRC_NONE  = 0,
-        V4L2_MPEG_AUDIO_CRC_CRC16 = 1,
-};
-#define V4L2_CID_MPEG_AUDIO_MUTE                (V4L2_CID_MPEG_BASE+109)
-#define V4L2_CID_MPEG_AUDIO_AAC_BITRATE         (V4L2_CID_MPEG_BASE+110)
-#define V4L2_CID_MPEG_AUDIO_AC3_BITRATE         (V4L2_CID_MPEG_BASE+111)
-enum <link linkend="v4l2-mpeg-audio-ac3-bitrate">v4l2_mpeg_audio_ac3_bitrate</link> {
-        V4L2_MPEG_AUDIO_AC3_BITRATE_32K  = 0,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_40K  = 1,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_48K  = 2,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_56K  = 3,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_64K  = 4,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_80K  = 5,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_96K  = 6,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_112K = 7,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_128K = 8,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_160K = 9,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_192K = 10,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_224K = 11,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_256K = 12,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_320K = 13,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_384K = 14,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_448K = 15,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_512K = 16,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_576K = 17,
-        V4L2_MPEG_AUDIO_AC3_BITRATE_640K = 18,
-};
-
-/*  MPEG video */
-#define V4L2_CID_MPEG_VIDEO_ENCODING            (V4L2_CID_MPEG_BASE+200)
-enum <link linkend="v4l2-mpeg-video-encoding">v4l2_mpeg_video_encoding</link> {
-        V4L2_MPEG_VIDEO_ENCODING_MPEG_1     = 0,
-        V4L2_MPEG_VIDEO_ENCODING_MPEG_2     = 1,
-        V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC = 2,
-};
-#define V4L2_CID_MPEG_VIDEO_ASPECT              (V4L2_CID_MPEG_BASE+201)
-enum <link linkend="v4l2-mpeg-video-aspect">v4l2_mpeg_video_aspect</link> {
-        V4L2_MPEG_VIDEO_ASPECT_1x1     = 0,
-        V4L2_MPEG_VIDEO_ASPECT_4x3     = 1,
-        V4L2_MPEG_VIDEO_ASPECT_16x9    = 2,
-        V4L2_MPEG_VIDEO_ASPECT_221x100 = 3,
-};
-#define V4L2_CID_MPEG_VIDEO_B_FRAMES            (V4L2_CID_MPEG_BASE+202)
-#define V4L2_CID_MPEG_VIDEO_GOP_SIZE            (V4L2_CID_MPEG_BASE+203)
-#define V4L2_CID_MPEG_VIDEO_GOP_CLOSURE         (V4L2_CID_MPEG_BASE+204)
-#define V4L2_CID_MPEG_VIDEO_PULLDOWN            (V4L2_CID_MPEG_BASE+205)
-#define V4L2_CID_MPEG_VIDEO_BITRATE_MODE        (V4L2_CID_MPEG_BASE+206)
-enum <link linkend="v4l2-mpeg-video-bitrate-mode">v4l2_mpeg_video_bitrate_mode</link> {
-        V4L2_MPEG_VIDEO_BITRATE_MODE_VBR = 0,
-        V4L2_MPEG_VIDEO_BITRATE_MODE_CBR = 1,
-};
-#define V4L2_CID_MPEG_VIDEO_BITRATE             (V4L2_CID_MPEG_BASE+207)
-#define V4L2_CID_MPEG_VIDEO_BITRATE_PEAK        (V4L2_CID_MPEG_BASE+208)
-#define V4L2_CID_MPEG_VIDEO_TEMPORAL_DECIMATION (V4L2_CID_MPEG_BASE+209)
-#define V4L2_CID_MPEG_VIDEO_MUTE                (V4L2_CID_MPEG_BASE+210)
-#define V4L2_CID_MPEG_VIDEO_MUTE_YUV            (V4L2_CID_MPEG_BASE+211)
-
-/*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
-#define V4L2_CID_MPEG_CX2341X_BASE                              (V4L2_CTRL_CLASS_MPEG | 0x1000)
-#define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE         (V4L2_CID_MPEG_CX2341X_BASE+0)
-enum <link linkend="v4l2-mpeg-cx2341x-video-spatial-filter-mode">v4l2_mpeg_cx2341x_video_spatial_filter_mode</link> {
-        V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_MANUAL = 0,
-        V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_AUTO   = 1,
-};
-#define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER              (V4L2_CID_MPEG_CX2341X_BASE+1)
-#define V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE    (V4L2_CID_MPEG_CX2341X_BASE+2)
-enum <link linkend="luma-spatial-filter-type">v4l2_mpeg_cx2341x_video_luma_spatial_filter_type</link> {
-        V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_OFF                  = 0,
-        V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_1D_HOR               = 1,
-        V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_1D_VERT              = 2,
-        V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_2D_HV_SEPARABLE      = 3,
-        V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_2D_SYM_NON_SEPARABLE = 4,
-};
-#define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE  (V4L2_CID_MPEG_CX2341X_BASE+3)
-enum <link linkend="chroma-spatial-filter-type">v4l2_mpeg_cx2341x_video_chroma_spatial_filter_type</link> {
-        V4L2_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE_OFF    = 0,
-        V4L2_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE_1D_HOR = 1,
-};
-#define V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE        (V4L2_CID_MPEG_CX2341X_BASE+4)
-enum <link linkend="v4l2-mpeg-cx2341x-video-temporal-filter-mode">v4l2_mpeg_cx2341x_video_temporal_filter_mode</link> {
-        V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_MANUAL = 0,
-        V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_AUTO   = 1,
-};
-#define V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER             (V4L2_CID_MPEG_CX2341X_BASE+5)
-#define V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE          (V4L2_CID_MPEG_CX2341X_BASE+6)
-enum <link linkend="v4l2-mpeg-cx2341x-video-median-filter-type">v4l2_mpeg_cx2341x_video_median_filter_type</link> {
-        V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_OFF      = 0,
-        V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_HOR      = 1,
-        V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_VERT     = 2,
-        V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_HOR_VERT = 3,
-        V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_DIAG     = 4,
-};
-#define V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_BOTTOM   (V4L2_CID_MPEG_CX2341X_BASE+7)
-#define V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_TOP      (V4L2_CID_MPEG_CX2341X_BASE+8)
-#define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_BOTTOM (V4L2_CID_MPEG_CX2341X_BASE+9)
-#define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP    (V4L2_CID_MPEG_CX2341X_BASE+10)
-#define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS         (V4L2_CID_MPEG_CX2341X_BASE+11)
-
-/*  Camera class control IDs */
-#define V4L2_CID_CAMERA_CLASS_BASE      (V4L2_CTRL_CLASS_CAMERA | 0x900)
-#define V4L2_CID_CAMERA_CLASS           (V4L2_CTRL_CLASS_CAMERA | 1)
-
-#define V4L2_CID_EXPOSURE_AUTO                  (V4L2_CID_CAMERA_CLASS_BASE+1)
-enum  <link linkend="v4l2-exposure-auto-type">v4l2_exposure_auto_type</link> {
-        V4L2_EXPOSURE_AUTO = 0,
-        V4L2_EXPOSURE_MANUAL = 1,
-        V4L2_EXPOSURE_SHUTTER_PRIORITY = 2,
-        V4L2_EXPOSURE_APERTURE_PRIORITY = 3
-};
-#define V4L2_CID_EXPOSURE_ABSOLUTE              (V4L2_CID_CAMERA_CLASS_BASE+2)
-#define V4L2_CID_EXPOSURE_AUTO_PRIORITY         (V4L2_CID_CAMERA_CLASS_BASE+3)
-
-#define V4L2_CID_PAN_RELATIVE                   (V4L2_CID_CAMERA_CLASS_BASE+4)
-#define V4L2_CID_TILT_RELATIVE                  (V4L2_CID_CAMERA_CLASS_BASE+5)
-#define V4L2_CID_PAN_RESET                      (V4L2_CID_CAMERA_CLASS_BASE+6)
-#define V4L2_CID_TILT_RESET                     (V4L2_CID_CAMERA_CLASS_BASE+7)
-
-#define V4L2_CID_PAN_ABSOLUTE                   (V4L2_CID_CAMERA_CLASS_BASE+8)
-#define V4L2_CID_TILT_ABSOLUTE                  (V4L2_CID_CAMERA_CLASS_BASE+9)
-
-#define V4L2_CID_FOCUS_ABSOLUTE                 (V4L2_CID_CAMERA_CLASS_BASE+10)
-#define V4L2_CID_FOCUS_RELATIVE                 (V4L2_CID_CAMERA_CLASS_BASE+11)
-#define V4L2_CID_FOCUS_AUTO                     (V4L2_CID_CAMERA_CLASS_BASE+12)
-
-#define V4L2_CID_ZOOM_ABSOLUTE                  (V4L2_CID_CAMERA_CLASS_BASE+13)
-#define V4L2_CID_ZOOM_RELATIVE                  (V4L2_CID_CAMERA_CLASS_BASE+14)
-#define V4L2_CID_ZOOM_CONTINUOUS                (V4L2_CID_CAMERA_CLASS_BASE+15)
-
-#define V4L2_CID_PRIVACY                        (V4L2_CID_CAMERA_CLASS_BASE+16)
-
-#define V4L2_CID_IRIS_ABSOLUTE                  (V4L2_CID_CAMERA_CLASS_BASE+17)
-#define V4L2_CID_IRIS_RELATIVE                  (V4L2_CID_CAMERA_CLASS_BASE+18)
-
-/* FM Modulator class control IDs */
-#define V4L2_CID_FM_TX_CLASS_BASE               (V4L2_CTRL_CLASS_FM_TX | 0x900)
-#define V4L2_CID_FM_TX_CLASS                    (V4L2_CTRL_CLASS_FM_TX | 1)
-
-#define V4L2_CID_RDS_TX_DEVIATION               (V4L2_CID_FM_TX_CLASS_BASE + 1)
-#define V4L2_CID_RDS_TX_PI                      (V4L2_CID_FM_TX_CLASS_BASE + 2)
-#define V4L2_CID_RDS_TX_PTY                     (V4L2_CID_FM_TX_CLASS_BASE + 3)
-#define V4L2_CID_RDS_TX_PS_NAME                 (V4L2_CID_FM_TX_CLASS_BASE + 5)
-#define V4L2_CID_RDS_TX_RADIO_TEXT              (V4L2_CID_FM_TX_CLASS_BASE + 6)
-
-#define V4L2_CID_AUDIO_LIMITER_ENABLED          (V4L2_CID_FM_TX_CLASS_BASE + 64)
-#define V4L2_CID_AUDIO_LIMITER_RELEASE_TIME     (V4L2_CID_FM_TX_CLASS_BASE + 65)
-#define V4L2_CID_AUDIO_LIMITER_DEVIATION        (V4L2_CID_FM_TX_CLASS_BASE + 66)
-
-#define V4L2_CID_AUDIO_COMPRESSION_ENABLED      (V4L2_CID_FM_TX_CLASS_BASE + 80)
-#define V4L2_CID_AUDIO_COMPRESSION_GAIN         (V4L2_CID_FM_TX_CLASS_BASE + 81)
-#define V4L2_CID_AUDIO_COMPRESSION_THRESHOLD    (V4L2_CID_FM_TX_CLASS_BASE + 82)
-#define V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME  (V4L2_CID_FM_TX_CLASS_BASE + 83)
-#define V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME (V4L2_CID_FM_TX_CLASS_BASE + 84)
-
-#define V4L2_CID_PILOT_TONE_ENABLED             (V4L2_CID_FM_TX_CLASS_BASE + 96)
-#define V4L2_CID_PILOT_TONE_DEVIATION           (V4L2_CID_FM_TX_CLASS_BASE + 97)
-#define V4L2_CID_PILOT_TONE_FREQUENCY           (V4L2_CID_FM_TX_CLASS_BASE + 98)
-
-#define V4L2_CID_TUNE_PREEMPHASIS               (V4L2_CID_FM_TX_CLASS_BASE + 112)
-enum <link linkend="v4l2-preemphasis">v4l2_preemphasis</link> {
-        V4L2_PREEMPHASIS_DISABLED       = 0,
-        V4L2_PREEMPHASIS_50_uS          = 1,
-        V4L2_PREEMPHASIS_75_uS          = 2,
-};
-#define V4L2_CID_TUNE_POWER_LEVEL               (V4L2_CID_FM_TX_CLASS_BASE + 113)
-#define V4L2_CID_TUNE_ANTENNA_CAPACITOR         (V4L2_CID_FM_TX_CLASS_BASE + 114)
-
-/*
- *      T U N I N G
- */
-struct <link linkend="v4l2-tuner">v4l2_tuner</link> {
-        __u32                   index;
-        __u8                    name[32];
-        enum <link linkend="v4l2-tuner-type">v4l2_tuner_type</link>    type;
-        __u32                   capability;
-        __u32                   rangelow;
-        __u32                   rangehigh;
-        __u32                   rxsubchans;
-        __u32                   audmode;
-        __s32                   signal;
-        __s32                   afc;
-        __u32                   reserved[4];
-};
-
-struct <link linkend="v4l2-modulator">v4l2_modulator</link> {
-        __u32                   index;
-        __u8                    name[32];
-        __u32                   capability;
-        __u32                   rangelow;
-        __u32                   rangehigh;
-        __u32                   txsubchans;
-        __u32                   reserved[4];
-};
-
-/*  Flags for the 'capability' field */
-#define V4L2_TUNER_CAP_LOW              0x0001
-#define V4L2_TUNER_CAP_NORM             0x0002
-#define V4L2_TUNER_CAP_STEREO           0x0010
-#define V4L2_TUNER_CAP_LANG2            0x0020
-#define V4L2_TUNER_CAP_SAP              0x0020
-#define V4L2_TUNER_CAP_LANG1            0x0040
-#define V4L2_TUNER_CAP_RDS              0x0080
-#define V4L2_TUNER_CAP_RDS_BLOCK_IO     0x0100
-#define V4L2_TUNER_CAP_RDS_CONTROLS     0x0200
-
-/*  Flags for the 'rxsubchans' field */
-#define V4L2_TUNER_SUB_MONO             0x0001
-#define V4L2_TUNER_SUB_STEREO           0x0002
-#define V4L2_TUNER_SUB_LANG2            0x0004
-#define V4L2_TUNER_SUB_SAP              0x0004
-#define V4L2_TUNER_SUB_LANG1            0x0008
-#define V4L2_TUNER_SUB_RDS              0x0010
-
-/*  Values for the 'audmode' field */
-#define V4L2_TUNER_MODE_MONO            0x0000
-#define V4L2_TUNER_MODE_STEREO          0x0001
-#define V4L2_TUNER_MODE_LANG2           0x0002
-#define V4L2_TUNER_MODE_SAP             0x0002
-#define V4L2_TUNER_MODE_LANG1           0x0003
-#define V4L2_TUNER_MODE_LANG1_LANG2     0x0004
-
-struct <link linkend="v4l2-frequency">v4l2_frequency</link> {
-        __u32                 tuner;
-        enum <link linkend="v4l2-tuner-type">v4l2_tuner_type</link>  type;
-        __u32                 frequency;
-        __u32                 reserved[8];
-};
-
-struct <link linkend="v4l2-hw-freq-seek">v4l2_hw_freq_seek</link> {
-        __u32                 tuner;
-        enum <link linkend="v4l2-tuner-type">v4l2_tuner_type</link>  type;
-        __u32                 seek_upward;
-        __u32                 wrap_around;
-        __u32                 spacing;
-        __u32                 reserved[7];
-};
-
-/*
- *      R D S
- */
-
-struct <link linkend="v4l2-rds-data">v4l2_rds_data</link> {
-        __u8    lsb;
-        __u8    msb;
-        __u8    block;
-} __attribute__ ((packed));
-
-#define V4L2_RDS_BLOCK_MSK       0x7
-#define V4L2_RDS_BLOCK_A         0
-#define V4L2_RDS_BLOCK_B         1
-#define V4L2_RDS_BLOCK_C         2
-#define V4L2_RDS_BLOCK_D         3
-#define V4L2_RDS_BLOCK_C_ALT     4
-#define V4L2_RDS_BLOCK_INVALID   7
-
-#define V4L2_RDS_BLOCK_CORRECTED 0x40
-#define V4L2_RDS_BLOCK_ERROR     0x80
-
-/*
- *      A U D I O
- */
-struct <link linkend="v4l2-audio">v4l2_audio</link> {
-        __u32   index;
-        __u8    name[32];
-        __u32   capability;
-        __u32   mode;
-        __u32   reserved[2];
-};
-
-/*  Flags for the 'capability' field */
-#define V4L2_AUDCAP_STEREO              0x00001
-#define V4L2_AUDCAP_AVL                 0x00002
-
-/*  Flags for the 'mode' field */
-#define V4L2_AUDMODE_AVL                0x00001
-
-struct <link linkend="v4l2-audioout">v4l2_audioout</link> {
-        __u32   index;
-        __u8    name[32];
-        __u32   capability;
-        __u32   mode;
-        __u32   reserved[2];
-};
-
-/*
- *      M P E G   S E R V I C E S
- *
- *      NOTE: EXPERIMENTAL API
- */
-#if 1
-#define V4L2_ENC_IDX_FRAME_I    (0)
-#define V4L2_ENC_IDX_FRAME_P    (1)
-#define V4L2_ENC_IDX_FRAME_B    (2)
-#define V4L2_ENC_IDX_FRAME_MASK (0xf)
-
-struct <link linkend="v4l2-enc-idx-entry">v4l2_enc_idx_entry</link> {
-        __u64 offset;
-        __u64 pts;
-        __u32 length;
-        __u32 flags;
-        __u32 reserved[2];
-};
-
-#define V4L2_ENC_IDX_ENTRIES (64)
-struct <link linkend="v4l2-enc-idx">v4l2_enc_idx</link> {
-        __u32 entries;
-        __u32 entries_cap;
-        __u32 reserved[4];
-        struct <link linkend="v4l2-enc-idx-entry">v4l2_enc_idx_entry</link> entry[V4L2_ENC_IDX_ENTRIES];
-};
-
-
-#define V4L2_ENC_CMD_START      (0)
-#define V4L2_ENC_CMD_STOP       (1)
-#define V4L2_ENC_CMD_PAUSE      (2)
-#define V4L2_ENC_CMD_RESUME     (3)
-
-/* Flags for V4L2_ENC_CMD_STOP */
-#define V4L2_ENC_CMD_STOP_AT_GOP_END    (1 &lt;&lt; 0)
-
-struct <link linkend="v4l2-encoder-cmd">v4l2_encoder_cmd</link> {
-        __u32 cmd;
-        __u32 flags;
-        union {
-                struct {
-                        __u32 data[8];
-                } raw;
-        };
-};
-
-#endif
-
-
-/*
- *      D A T A   S E R V I C E S   ( V B I )
- *
- *      Data services API by Michael Schimek
- */
-
-/* Raw VBI */
-struct <link linkend="v4l2-vbi-format">v4l2_vbi_format</link> {
-        __u32   sampling_rate;          /* in 1 Hz */
-        __u32   offset;
-        __u32   samples_per_line;
-        __u32   sample_format;          /* V4L2_PIX_FMT_* */
-        __s32   start[2];
-        __u32   count[2];
-        __u32   flags;                  /* V4L2_VBI_* */
-        __u32   reserved[2];            /* must be zero */
-};
-
-/*  VBI flags  */
-#define V4L2_VBI_UNSYNC         (1 &lt;&lt; 0)
-#define V4L2_VBI_INTERLACED     (1 &lt;&lt; 1)
-
-/* Sliced VBI
- *
- *    This implements is a proposal V4L2 API to allow SLICED VBI
- * required for some hardware encoders. It should change without
- * notice in the definitive implementation.
- */
-
-struct <link linkend="v4l2-sliced-vbi-format">v4l2_sliced_vbi_format</link> {
-        __u16   service_set;
-        /* service_lines[0][...] specifies lines 0-23 (1-23 used) of the first field
-           service_lines[1][...] specifies lines 0-23 (1-23 used) of the second field
-                                 (equals frame lines 313-336 for 625 line video
-                                  standards, 263-286 for 525 line standards) */
-        __u16   service_lines[2][24];
-        __u32   io_size;
-        __u32   reserved[2];            /* must be zero */
-};
-
-/* Teletext World System Teletext
-   (WST), defined on ITU-R BT.653-2 */
-#define V4L2_SLICED_TELETEXT_B          (0x0001)
-/* Video Program System, defined on ETS 300 231*/
-#define V4L2_SLICED_VPS                 (0x0400)
-/* Closed Caption, defined on EIA-608 */
-#define V4L2_SLICED_CAPTION_525         (0x1000)
-/* Wide Screen System, defined on ITU-R BT1119.1 */
-#define V4L2_SLICED_WSS_625             (0x4000)
-
-#define V4L2_SLICED_VBI_525             (V4L2_SLICED_CAPTION_525)
-#define V4L2_SLICED_VBI_625             (V4L2_SLICED_TELETEXT_B | V4L2_SLICED_VPS | V4L2_SLICED_WSS_625)
-
-struct <link linkend="v4l2-sliced-vbi-cap">v4l2_sliced_vbi_cap</link> {
-        __u16   service_set;
-        /* service_lines[0][...] specifies lines 0-23 (1-23 used) of the first field
-           service_lines[1][...] specifies lines 0-23 (1-23 used) of the second field
-                                 (equals frame lines 313-336 for 625 line video
-                                  standards, 263-286 for 525 line standards) */
-        __u16   service_lines[2][24];
-        enum <link linkend="v4l2-buf-type">v4l2_buf_type</link> type;
-        __u32   reserved[3];    /* must be 0 */
-};
-
-struct <link linkend="v4l2-sliced-vbi-data">v4l2_sliced_vbi_data</link> {
-        __u32   id;
-        __u32   field;          /* 0: first field, 1: second field */
-        __u32   line;           /* 1-23 */
-        __u32   reserved;       /* must be 0 */
-        __u8    data[48];
-};
-
-/*
- * Sliced VBI data inserted into MPEG Streams
- */
-
-/*
- * V4L2_MPEG_STREAM_VBI_FMT_IVTV:
- *
- * Structure of payload contained in an MPEG 2 Private Stream 1 PES Packet in an
- * MPEG-2 Program Pack that contains V4L2_MPEG_STREAM_VBI_FMT_IVTV Sliced VBI
- * data
- *
- * Note, the MPEG-2 Program Pack and Private Stream 1 PES packet header
- * definitions are not included here.  See the MPEG-2 specifications for details
- * on these headers.
- */
-
-/* Line type IDs */
-#define V4L2_MPEG_VBI_IVTV_TELETEXT_B     (1)
-#define V4L2_MPEG_VBI_IVTV_CAPTION_525    (4)
-#define V4L2_MPEG_VBI_IVTV_WSS_625        (5)
-#define V4L2_MPEG_VBI_IVTV_VPS            (7)
-
-struct <link linkend="v4l2-mpeg-vbi-itv0-line">v4l2_mpeg_vbi_itv0_line</link> {
-        __u8 id;        /* One of V4L2_MPEG_VBI_IVTV_* above */
-        __u8 data[42];  /* Sliced VBI data for the line */
-} __attribute__ ((packed));
-
-struct <link linkend="v4l2-mpeg-vbi-itv0">v4l2_mpeg_vbi_itv0</link> {
-        __le32 linemask[2]; /* Bitmasks of VBI service lines present */
-        struct <link linkend="v4l2-mpeg-vbi-itv0-line">v4l2_mpeg_vbi_itv0_line</link> line[35];
-} __attribute__ ((packed));
-
-struct <link linkend="v4l2-mpeg-vbi-itv0-1">v4l2_mpeg_vbi_ITV0</link> {
-        struct <link linkend="v4l2-mpeg-vbi-itv0-line">v4l2_mpeg_vbi_itv0_line</link> line[36];
-} __attribute__ ((packed));
-
-#define V4L2_MPEG_VBI_IVTV_MAGIC0       "itv0"
-#define V4L2_MPEG_VBI_IVTV_MAGIC1       "ITV0"
-
-struct <link linkend="v4l2-mpeg-vbi-fmt-ivtv">v4l2_mpeg_vbi_fmt_ivtv</link> {
-        __u8 magic[4];
-        union {
-                struct <link linkend="v4l2-mpeg-vbi-itv0">v4l2_mpeg_vbi_itv0</link> itv0;
-                struct <link linkend="v4l2-mpeg-vbi-itv0-1">v4l2_mpeg_vbi_ITV0</link> ITV0;
-        };
-} __attribute__ ((packed));
-
-/*
- *      A G G R E G A T E   S T R U C T U R E S
- */
-
-/**
- * struct <link linkend="v4l2-plane-pix-format">v4l2_plane_pix_format</link> - additional, per-plane format definition
- * @sizeimage:          maximum size in bytes required for data, for which
- *                      this plane will be used
- * @bytesperline:       distance in bytes between the leftmost pixels in two
- *                      adjacent lines
- */
-struct <link linkend="v4l2-plane-pix-format">v4l2_plane_pix_format</link> {
-        __u32           sizeimage;
-        __u16           bytesperline;
-        __u16           reserved[7];
-} __attribute__ ((packed));
-
-/**
- * struct <link linkend="v4l2-pix-format-mplane">v4l2_pix_format_mplane</link> - multiplanar format definition
- * @width:              image width in pixels
- * @height:             image height in pixels
- * @pixelformat:        little endian four character code (fourcc)
- * @field:              field order (for interlaced video)
- * @colorspace:         supplemental to pixelformat
- * @plane_fmt:          per-plane information
- * @num_planes:         number of planes for this format
- */
-struct <link linkend="v4l2-pix-format-mplane">v4l2_pix_format_mplane</link> {
-        __u32                           width;
-        __u32                           height;
-        __u32                           pixelformat;
-        enum <link linkend="v4l2-field">v4l2_field</link>                 field;
-        enum <link linkend="v4l2-colorspace">v4l2_colorspace</link>            colorspace;
-
-        struct <link linkend="v4l2-plane-pix-format">v4l2_plane_pix_format</link>    plane_fmt[VIDEO_MAX_PLANES];
-        __u8                            num_planes;
-        __u8                            reserved[11];
-} __attribute__ ((packed));
-
-/**
- * struct <link linkend="v4l2-format">v4l2_format</link> - stream data format
- * @type:       type of the data stream
- * @pix:        definition of an image format
- * @pix_mp:     definition of a multiplanar image format
- * @win:        definition of an overlaid image
- * @vbi:        raw VBI capture or output parameters
- * @sliced:     sliced VBI capture or output parameters
- * @raw_data:   placeholder for future extensions and custom formats
- */
-struct <link linkend="v4l2-format">v4l2_format</link> {
-        enum <link linkend="v4l2-buf-type">v4l2_buf_type</link> type;
-        union {
-                struct <link linkend="v4l2-pix-format">v4l2_pix_format</link>          pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
-                struct <link linkend="v4l2-pix-format-mplane">v4l2_pix_format_mplane</link>   pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
-                struct <link linkend="v4l2-window">v4l2_window</link>              win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
-                struct <link linkend="v4l2-vbi-format">v4l2_vbi_format</link>          vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
-                struct <link linkend="v4l2-sliced-vbi-format">v4l2_sliced_vbi_format</link>   sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
-                __u8    raw_data[200];                   /* user-defined */
-        } fmt;
-};
-
-/*      Stream type-dependent parameters
- */
-struct <link linkend="v4l2-streamparm">v4l2_streamparm</link> {
-        enum <link linkend="v4l2-buf-type">v4l2_buf_type</link> type;
-        union {
-                struct <link linkend="v4l2-captureparm">v4l2_captureparm</link> capture;
-                struct <link linkend="v4l2-outputparm">v4l2_outputparm</link>  output;
-                __u8    raw_data[200];  /* user-defined */
-        } parm;
-};
-
-/*
- *      E V E N T S
- */
-
-#define V4L2_EVENT_ALL                          0
-#define V4L2_EVENT_VSYNC                        1
-#define V4L2_EVENT_EOS                          2
-#define V4L2_EVENT_PRIVATE_START                0x08000000
-
-/* Payload for V4L2_EVENT_VSYNC */
-struct <link linkend="v4l2-event-vsync">v4l2_event_vsync</link> {
-        /* Can be V4L2_FIELD_ANY, _NONE, _TOP or _BOTTOM */
-        __u8 field;
-} __attribute__ ((packed));
-
-struct <link linkend="v4l2-event">v4l2_event</link> {
-        __u32                           type;
-        union {
-                struct <link linkend="v4l2-event-vsync">v4l2_event_vsync</link> vsync;
-                __u8                    data[64];
-        } u;
-        __u32                           pending;
-        __u32                           sequence;
-        struct timespec                 timestamp;
-        __u32                           reserved[9];
-};
-
-struct <link linkend="v4l2-event-subscription">v4l2_event_subscription</link> {
-        __u32                           type;
-        __u32                           reserved[7];
-};
-
-/*
- *      A D V A N C E D   D E B U G G I N G
- *
- *      NOTE: EXPERIMENTAL API, NEVER RELY ON THIS IN APPLICATIONS!
- *      FOR DEBUGGING, TESTING AND INTERNAL USE ONLY!
- */
-
-/* VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER */
-
-#define V4L2_CHIP_MATCH_HOST       0  /* Match against chip ID on host (0 for the host) */
-#define V4L2_CHIP_MATCH_I2C_DRIVER 1  /* Match against I2C driver name */
-#define V4L2_CHIP_MATCH_I2C_ADDR   2  /* Match against I2C 7-bit address */
-#define V4L2_CHIP_MATCH_AC97       3  /* Match against anciliary AC97 chip */
-
-struct <link linkend="v4l2-dbg-match">v4l2_dbg_match</link> {
-        __u32 type; /* Match type */
-        union {     /* Match this chip, meaning determined by type */
-                __u32 addr;
-                char name[32];
-        };
-} __attribute__ ((packed));
-
-struct <link linkend="v4l2-dbg-register">v4l2_dbg_register</link> {
-        struct <link linkend="v4l2-dbg-match">v4l2_dbg_match</link> match;
-        __u32 size;     /* register size in bytes */
-        __u64 reg;
-        __u64 val;
-} __attribute__ ((packed));
-
-/* VIDIOC_DBG_G_CHIP_IDENT */
-struct <link linkend="v4l2-dbg-chip-ident">v4l2_dbg_chip_ident</link> {
-        struct <link linkend="v4l2-dbg-match">v4l2_dbg_match</link> match;
-        __u32 ident;       /* chip identifier as specified in &lt;media/v4l2-chip-ident.h&gt; */
-        __u32 revision;    /* chip revision, chip specific */
-} __attribute__ ((packed));
-
-/*
- *      I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
- *
- */
-#define VIDIOC_QUERYCAP          _IOR('V',  0, struct <link linkend="v4l2-capability">v4l2_capability</link>)
-#define VIDIOC_RESERVED           _IO('V',  1)
-#define VIDIOC_ENUM_FMT         _IOWR('V',  2, struct <link linkend="v4l2-fmtdesc">v4l2_fmtdesc</link>)
-#define VIDIOC_G_FMT            _IOWR('V',  4, struct <link linkend="v4l2-format">v4l2_format</link>)
-#define VIDIOC_S_FMT            _IOWR('V',  5, struct <link linkend="v4l2-format">v4l2_format</link>)
-#define VIDIOC_REQBUFS          _IOWR('V',  8, struct <link linkend="v4l2-requestbuffers">v4l2_requestbuffers</link>)
-#define VIDIOC_QUERYBUF         _IOWR('V',  9, struct <link linkend="v4l2-buffer">v4l2_buffer</link>)
-#define VIDIOC_G_FBUF            _IOR('V', 10, struct <link linkend="v4l2-framebuffer">v4l2_framebuffer</link>)
-#define VIDIOC_S_FBUF            _IOW('V', 11, struct <link linkend="v4l2-framebuffer">v4l2_framebuffer</link>)
-#define VIDIOC_OVERLAY           _IOW('V', 14, int)
-#define VIDIOC_QBUF             _IOWR('V', 15, struct <link linkend="v4l2-buffer">v4l2_buffer</link>)
-#define VIDIOC_DQBUF            _IOWR('V', 17, struct <link linkend="v4l2-buffer">v4l2_buffer</link>)
-#define VIDIOC_STREAMON          _IOW('V', 18, int)
-#define VIDIOC_STREAMOFF         _IOW('V', 19, int)
-#define VIDIOC_G_PARM           _IOWR('V', 21, struct <link linkend="v4l2-streamparm">v4l2_streamparm</link>)
-#define VIDIOC_S_PARM           _IOWR('V', 22, struct <link linkend="v4l2-streamparm">v4l2_streamparm</link>)
-#define VIDIOC_G_STD             _IOR('V', 23, v4l2_std_id)
-#define VIDIOC_S_STD             _IOW('V', 24, v4l2_std_id)
-#define VIDIOC_ENUMSTD          _IOWR('V', 25, struct <link linkend="v4l2-standard">v4l2_standard</link>)
-#define VIDIOC_ENUMINPUT        _IOWR('V', 26, struct <link linkend="v4l2-input">v4l2_input</link>)
-#define VIDIOC_G_CTRL           _IOWR('V', 27, struct <link linkend="v4l2-control">v4l2_control</link>)
-#define VIDIOC_S_CTRL           _IOWR('V', 28, struct <link linkend="v4l2-control">v4l2_control</link>)
-#define VIDIOC_G_TUNER          _IOWR('V', 29, struct <link linkend="v4l2-tuner">v4l2_tuner</link>)
-#define VIDIOC_S_TUNER           _IOW('V', 30, struct <link linkend="v4l2-tuner">v4l2_tuner</link>)
-#define VIDIOC_G_AUDIO           _IOR('V', 33, struct <link linkend="v4l2-audio">v4l2_audio</link>)
-#define VIDIOC_S_AUDIO           _IOW('V', 34, struct <link linkend="v4l2-audio">v4l2_audio</link>)
-#define VIDIOC_QUERYCTRL        _IOWR('V', 36, struct <link linkend="v4l2-queryctrl">v4l2_queryctrl</link>)
-#define VIDIOC_QUERYMENU        _IOWR('V', 37, struct <link linkend="v4l2-querymenu">v4l2_querymenu</link>)
-#define VIDIOC_G_INPUT           _IOR('V', 38, int)
-#define VIDIOC_S_INPUT          _IOWR('V', 39, int)
-#define VIDIOC_G_OUTPUT          _IOR('V', 46, int)
-#define VIDIOC_S_OUTPUT         _IOWR('V', 47, int)
-#define VIDIOC_ENUMOUTPUT       _IOWR('V', 48, struct <link linkend="v4l2-output">v4l2_output</link>)
-#define VIDIOC_G_AUDOUT          _IOR('V', 49, struct <link linkend="v4l2-audioout">v4l2_audioout</link>)
-#define VIDIOC_S_AUDOUT          _IOW('V', 50, struct <link linkend="v4l2-audioout">v4l2_audioout</link>)
-#define VIDIOC_G_MODULATOR      _IOWR('V', 54, struct <link linkend="v4l2-modulator">v4l2_modulator</link>)
-#define VIDIOC_S_MODULATOR       _IOW('V', 55, struct <link linkend="v4l2-modulator">v4l2_modulator</link>)
-#define VIDIOC_G_FREQUENCY      _IOWR('V', 56, struct <link linkend="v4l2-frequency">v4l2_frequency</link>)
-#define VIDIOC_S_FREQUENCY       _IOW('V', 57, struct <link linkend="v4l2-frequency">v4l2_frequency</link>)
-#define VIDIOC_CROPCAP          _IOWR('V', 58, struct <link linkend="v4l2-cropcap">v4l2_cropcap</link>)
-#define VIDIOC_G_CROP           _IOWR('V', 59, struct <link linkend="v4l2-crop">v4l2_crop</link>)
-#define VIDIOC_S_CROP            _IOW('V', 60, struct <link linkend="v4l2-crop">v4l2_crop</link>)
-#define VIDIOC_G_JPEGCOMP        _IOR('V', 61, struct <link linkend="v4l2-jpegcompression">v4l2_jpegcompression</link>)
-#define VIDIOC_S_JPEGCOMP        _IOW('V', 62, struct <link linkend="v4l2-jpegcompression">v4l2_jpegcompression</link>)
-#define VIDIOC_QUERYSTD          _IOR('V', 63, v4l2_std_id)
-#define VIDIOC_TRY_FMT          _IOWR('V', 64, struct <link linkend="v4l2-format">v4l2_format</link>)
-#define VIDIOC_ENUMAUDIO        _IOWR('V', 65, struct <link linkend="v4l2-audio">v4l2_audio</link>)
-#define VIDIOC_ENUMAUDOUT       _IOWR('V', 66, struct <link linkend="v4l2-audioout">v4l2_audioout</link>)
-#define VIDIOC_G_PRIORITY        _IOR('V', 67, enum <link linkend="v4l2-priority">v4l2_priority</link>)
-#define VIDIOC_S_PRIORITY        _IOW('V', 68, enum <link linkend="v4l2-priority">v4l2_priority</link>)
-#define VIDIOC_G_SLICED_VBI_CAP _IOWR('V', 69, struct <link linkend="v4l2-sliced-vbi-cap">v4l2_sliced_vbi_cap</link>)
-#define VIDIOC_LOG_STATUS         _IO('V', 70)
-#define VIDIOC_G_EXT_CTRLS      _IOWR('V', 71, struct <link linkend="v4l2-ext-controls">v4l2_ext_controls</link>)
-#define VIDIOC_S_EXT_CTRLS      _IOWR('V', 72, struct <link linkend="v4l2-ext-controls">v4l2_ext_controls</link>)
-#define VIDIOC_TRY_EXT_CTRLS    _IOWR('V', 73, struct <link linkend="v4l2-ext-controls">v4l2_ext_controls</link>)
-#if 1
-#define VIDIOC_ENUM_FRAMESIZES  _IOWR('V', 74, struct <link linkend="v4l2-frmsizeenum">v4l2_frmsizeenum</link>)
-#define VIDIOC_ENUM_FRAMEINTERVALS _IOWR('V', 75, struct <link linkend="v4l2-frmivalenum">v4l2_frmivalenum</link>)
-#define VIDIOC_G_ENC_INDEX       _IOR('V', 76, struct <link linkend="v4l2-enc-idx">v4l2_enc_idx</link>)
-#define VIDIOC_ENCODER_CMD      _IOWR('V', 77, struct <link linkend="v4l2-encoder-cmd">v4l2_encoder_cmd</link>)
-#define VIDIOC_TRY_ENCODER_CMD  _IOWR('V', 78, struct <link linkend="v4l2-encoder-cmd">v4l2_encoder_cmd</link>)
-#endif
-
-#if 1
-/* Experimental, meant for debugging, testing and internal use.
-   Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
-   You must be root to use these ioctls. Never use these in applications! */
-#define VIDIOC_DBG_S_REGISTER    _IOW('V', 79, struct <link linkend="v4l2-dbg-register">v4l2_dbg_register</link>)
-#define VIDIOC_DBG_G_REGISTER   _IOWR('V', 80, struct <link linkend="v4l2-dbg-register">v4l2_dbg_register</link>)
-
-/* Experimental, meant for debugging, testing and internal use.
-   Never use this ioctl in applications! */
-#define VIDIOC_DBG_G_CHIP_IDENT _IOWR('V', 81, struct <link linkend="v4l2-dbg-chip-ident">v4l2_dbg_chip_ident</link>)
-#endif
-
-#define VIDIOC_S_HW_FREQ_SEEK    _IOW('V', 82, struct <link linkend="v4l2-hw-freq-seek">v4l2_hw_freq_seek</link>)
-#define VIDIOC_ENUM_DV_PRESETS  _IOWR('V', 83, struct <link linkend="v4l2-dv-enum-preset">v4l2_dv_enum_preset</link>)
-#define VIDIOC_S_DV_PRESET      _IOWR('V', 84, struct <link linkend="v4l2-dv-preset">v4l2_dv_preset</link>)
-#define VIDIOC_G_DV_PRESET      _IOWR('V', 85, struct <link linkend="v4l2-dv-preset">v4l2_dv_preset</link>)
-#define VIDIOC_QUERY_DV_PRESET  _IOR('V',  86, struct <link linkend="v4l2-dv-preset">v4l2_dv_preset</link>)
-#define VIDIOC_S_DV_TIMINGS     _IOWR('V', 87, struct <link linkend="v4l2-dv-timings">v4l2_dv_timings</link>)
-#define VIDIOC_G_DV_TIMINGS     _IOWR('V', 88, struct <link linkend="v4l2-dv-timings">v4l2_dv_timings</link>)
-#define VIDIOC_DQEVENT           _IOR('V', 89, struct <link linkend="v4l2-event">v4l2_event</link>)
-#define VIDIOC_SUBSCRIBE_EVENT   _IOW('V', 90, struct <link linkend="v4l2-event-subscription">v4l2_event_subscription</link>)
-#define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct <link linkend="v4l2-event-subscription">v4l2_event_subscription</link>)
-
-/* Reminder: when adding new ioctls please add support for them to
-   drivers/media/video/v4l2-compat-ioctl32.c as well! */
-
-#define BASE_VIDIOC_PRIVATE     192             /* 192-255 are private */
-
-#endif /* __LINUX_VIDEODEV2_H */
-</programlisting>
-- 
1.7.1

