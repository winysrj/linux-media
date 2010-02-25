Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782Ab0BYCeX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 21:34:23 -0500
Message-ID: <4B85E18B.5000103@redhat.com>
Date: Wed, 24 Feb 2010 23:33:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH 0/4] DocBook additions for V4L new formats
References: <4B7C2203.1000707@redhat.com> <4B7CA679.40906@oracle.com> <4B7DBFF8.1050300@oracle.com>
In-Reply-To: <4B7DBFF8.1050300@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Randy Dunlap wrote:
> On 02/17/10 18:31, Randy Dunlap wrote:
>> On 02/17/10 09:06, Mauro Carvalho Chehab wrote:
>>> Adds DocBook items for Bayer and two proprietary formats used on gspca.
>>>
>>> In the past, a few targets were generated at the Mercurial development
>>> tree. However, at the beginning of this year, we moved to use -git as
>>> the primary resource. So, the Makefile logic to autogenerate those
>>> targets needs to be moved to git as well.
>>>
>>> While here, I noticed that DocBook is too verbose to generate the
>>> htmldocs target. So, make it less verbose, if V=0.
>>>
>>> Guennadi Liakhovetski (1):
>>>   V4L/DVB: v4l: document new Bayer and monochrome pixel formats
>>>
>>> Mauro Carvalho Chehab (3):
>>>   DocBook/Makefile: Make it less verbose
>>>   DocBook: Add rules to auto-generate some media docbooks
>>>   DocBook/v4l/pixfmt.xml: Add missing formats for gspca cpia1 and
>>>     sn9c2028 drivers
>> Hi Mauro,
>>
>> Patches 1 & 3 are OK.
>>
>> I'm having problems with patch 2/4 when I use O=DOCDIR on the make command
>> (which I always do).  videodev2.h.xml is not being generated, and after
>> that it goes downhill.
>>
>> I will let you know more when I have more info, or you or Guennadi can send
>> a fixup patch for that.
>>
> 
> I'm not making any progress on this.
> "make O=DOCDIR htmldocs" needs to work, but it does not:
> 

The enclosed patch should fix the build after applying the 4 patches from the series.

Tomorrow, I'll take a look at the index.html issue.


Fix makefile
    
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 1c796fc..4ebe4e1 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -14,7 +14,7 @@ DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
 	    mac80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
-	    tracepoint.xml media.xml
+	    tracepoint.xml media_tmp/media.xml
 
 ###
 # The build process is as follows (targets):
@@ -32,10 +32,10 @@ PS_METHOD	= $(prefer-db2x)
 
 ###
 # The targets that may be used.
-PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs xmldoclinks mediaprep
+PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs mediaprep
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
-xmldocs: $(BOOKS) xmldoclinks
+xmldocs: $(BOOKS)
 sgmldocs: xmldocs
 
 PS := $(patsubst %.xml, %.ps, $(BOOKS))
@@ -48,23 +48,10 @@ HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
 htmldocs: $(HTML)
 	@$($(quiet)cmd_build_main_index)
 	@$($(call build_main_index))
-	@($(call build_images))
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
 
-build_images = mkdir -p $(objtree)/Documentation/DocBook/media/ && \
-	       cp $(srctree)/Documentation/DocBook/dvb/*.png $(srctree)/Documentation/DocBook/v4l/*.gif $(objtree)/Documentation/DocBook/media/
-
-xmldoclinks:
-ifneq ($(objtree),$(srctree))
-	for dep in dvb v4l; do \
-		rm -f $(objtree)/Documentation/DocBook/$$dep \
-		&& ln -s $(srctree)/Documentation/DocBook/$$dep $(objtree)/Documentation/DocBook/ \
-		|| exit; \
-	done
-endif
-
 installmandocs: mandocs
 	mkdir -p /usr/local/man/man9/
 	install Documentation/DocBook/man/*.9.gz /usr/local/man/man9/
@@ -100,7 +87,7 @@ endef
 	$(call if_changed_rule,docproc)
 
 ###
-#Read in all saved dependency files 
+#Read in all saved dependency files
 cmd_files := $(wildcard $(foreach f,$(BOOKS),$(dir $(f)).$(notdir $(f)).cmd))
 
 ifneq ($(cmd_files),)
@@ -239,10 +226,9 @@ clean-files := $(DOCBOOKS) \
 	$(patsubst %.xml, %.pdf,  $(DOCBOOKS)) \
 	$(patsubst %.xml, %.html, $(DOCBOOKS)) \
 	$(patsubst %.xml, %.9,    $(DOCBOOKS)) \
-	$(MEDIA_TEMP) \
 	$(index)
 
-clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man
+clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man 
 
 cleandocs:
 	$(Q)rm -f $(call objectify, $(clean-files))
@@ -260,134 +246,133 @@ cleandocs:
 
 SHELL=/bin/bash
 
+MEDIA_DIR=$(objtree)/Documentation/DocBook/media_tmp
+
 V4L_SGMLS = \
-	v4l/biblio.xml \
-	v4l/common.xml \
-	v4l/compat.xml \
-	v4l/controls.xml \
-	v4l/dev-capture.xml \
-	v4l/dev-codec.xml \
-	v4l/dev-effect.xml \
-	v4l/dev-osd.xml \
-	v4l/dev-output.xml \
-	v4l/dev-overlay.xml \
-	v4l/dev-radio.xml \
-	v4l/dev-raw-vbi.xml \
-	v4l/dev-rds.xml \
-	v4l/dev-sliced-vbi.xml \
-	v4l/dev-teletext.xml \
-	v4l/driver.xml \
-	v4l/libv4l.xml \
-	v4l/remote_controllers.xml \
-	v4l/fdl-appendix.xml \
-	v4l/func-close.xml \
-	v4l/func-ioctl.xml \
-	v4l/func-mmap.xml \
-	v4l/func-munmap.xml \
-	v4l/func-open.xml \
-	v4l/func-poll.xml \
-	v4l/func-read.xml \
-	v4l/func-select.xml \
-	v4l/func-write.xml \
-	v4l/io.xml \
-	v4l/pixfmt-grey.xml \
-	v4l/pixfmt-nv12.xml \
-	v4l/pixfmt-nv16.xml \
-	v4l/pixfmt-packed-rgb.xml \
-	v4l/pixfmt-packed-yuv.xml \
-	v4l/pixfmt-sbggr16.xml \
-	v4l/pixfmt-sbggr8.xml \
-	v4l/pixfmt-sgbrg8.xml \
-	v4l/pixfmt-sgrbg8.xml \
-	v4l/pixfmt-uyvy.xml \
-	v4l/pixfmt-vyuy.xml \
-	v4l/pixfmt-y16.xml \
-	v4l/pixfmt-y41p.xml \
-	v4l/pixfmt-yuv410.xml \
-	v4l/pixfmt-yuv411p.xml \
-	v4l/pixfmt-yuv420.xml \
-	v4l/pixfmt-yuv422p.xml \
-	v4l/pixfmt-yuyv.xml \
-	v4l/pixfmt-yvyu.xml \
-	v4l/pixfmt-srggb10.xml \
-	v4l/pixfmt-srggb8.xml \
-	v4l/pixfmt-y10.xml \
-	v4l/pixfmt.xml \
-	v4l/vidioc-cropcap.xml \
-	v4l/vidioc-dbg-g-register.xml \
-	v4l/vidioc-encoder-cmd.xml \
-	v4l/vidioc-enum-fmt.xml \
-	v4l/vidioc-enum-frameintervals.xml \
-	v4l/vidioc-enum-framesizes.xml \
-	v4l/vidioc-enumaudio.xml \
-	v4l/vidioc-enumaudioout.xml \
-	v4l/vidioc-enuminput.xml \
-	v4l/vidioc-enumoutput.xml \
-	v4l/vidioc-enum-dv-presets.xml \
-	v4l/vidioc-g-dv-preset.xml \
-	v4l/vidioc-query-dv-preset.xml \
-	v4l/vidioc-g-dv-timings.xml \
-	v4l/vidioc-enumstd.xml \
-	v4l/vidioc-g-audio.xml \
-	v4l/vidioc-g-audioout.xml \
-	v4l/vidioc-dbg-g-chip-ident.xml \
-	v4l/vidioc-g-crop.xml \
-	v4l/vidioc-g-ctrl.xml \
-	v4l/vidioc-g-enc-index.xml \
-	v4l/vidioc-g-ext-ctrls.xml \
-	v4l/vidioc-g-fbuf.xml \
-	v4l/vidioc-g-fmt.xml \
-	v4l/vidioc-g-frequency.xml \
-	v4l/vidioc-g-input.xml \
-	v4l/vidioc-g-jpegcomp.xml \
-	v4l/vidioc-g-modulator.xml \
-	v4l/vidioc-g-output.xml \
-	v4l/vidioc-g-parm.xml \
-	v4l/vidioc-g-priority.xml \
-	v4l/vidioc-g-sliced-vbi-cap.xml \
-	v4l/vidioc-g-std.xml \
-	v4l/vidioc-g-tuner.xml \
-	v4l/vidioc-log-status.xml \
-	v4l/vidioc-overlay.xml \
-	v4l/vidioc-qbuf.xml \
-	v4l/vidioc-querybuf.xml \
-	v4l/vidioc-querycap.xml \
-	v4l/vidioc-queryctrl.xml \
-	v4l/vidioc-querystd.xml \
-	v4l/vidioc-reqbufs.xml \
-	v4l/vidioc-s-hw-freq-seek.xml \
-	v4l/vidioc-streamon.xml \
-	v4l/capture.c.xml \
-	v4l/keytable.c.xml \
-	v4l/v4l2grab.c.xml \
-	v4l/videodev2.h.xml \
-	v4l/v4l2.xml
+	biblio.xml \
+	common.xml \
+	compat.xml \
+	controls.xml \
+	dev-capture.xml \
+	dev-codec.xml \
+	dev-effect.xml \
+	dev-osd.xml \
+	dev-output.xml \
+	dev-overlay.xml \
+	dev-radio.xml \
+	dev-raw-vbi.xml \
+	dev-rds.xml \
+	dev-sliced-vbi.xml \
+	dev-teletext.xml \
+	driver.xml \
+	libv4l.xml \
+	remote_controllers.xml \
+	fdl-appendix.xml \
+	func-close.xml \
+	func-ioctl.xml \
+	func-mmap.xml \
+	func-munmap.xml \
+	func-open.xml \
+	func-poll.xml \
+	func-read.xml \
+	func-select.xml \
+	func-write.xml \
+	io.xml \
+	pixfmt-grey.xml \
+	pixfmt-nv12.xml \
+	pixfmt-nv16.xml \
+	pixfmt-packed-rgb.xml \
+	pixfmt-packed-yuv.xml \
+	pixfmt-sbggr16.xml \
+	pixfmt-sbggr8.xml \
+	pixfmt-sgbrg8.xml \
+	pixfmt-sgrbg8.xml \
+	pixfmt-uyvy.xml \
+	pixfmt-vyuy.xml \
+	pixfmt-y16.xml \
+	pixfmt-y41p.xml \
+	pixfmt-yuv410.xml \
+	pixfmt-yuv411p.xml \
+	pixfmt-yuv420.xml \
+	pixfmt-yuv422p.xml \
+	pixfmt-yuyv.xml \
+	pixfmt-yvyu.xml \
+	pixfmt-srggb10.xml \
+	pixfmt-srggb8.xml \
+	pixfmt-y10.xml \
+	pixfmt.xml \
+	vidioc-cropcap.xml \
+	vidioc-dbg-g-register.xml \
+	vidioc-encoder-cmd.xml \
+	vidioc-enum-fmt.xml \
+	vidioc-enum-frameintervals.xml \
+	vidioc-enum-framesizes.xml \
+	vidioc-enumaudio.xml \
+	vidioc-enumaudioout.xml \
+	vidioc-enuminput.xml \
+	vidioc-enumoutput.xml \
+	vidioc-enum-dv-presets.xml \
+	vidioc-g-dv-preset.xml \
+	vidioc-query-dv-preset.xml \
+	vidioc-g-dv-timings.xml \
+	vidioc-enumstd.xml \
+	vidioc-g-audio.xml \
+	vidioc-g-audioout.xml \
+	vidioc-dbg-g-chip-ident.xml \
+	vidioc-g-crop.xml \
+	vidioc-g-ctrl.xml \
+	vidioc-g-enc-index.xml \
+	vidioc-g-ext-ctrls.xml \
+	vidioc-g-fbuf.xml \
+	vidioc-g-fmt.xml \
+	vidioc-g-frequency.xml \
+	vidioc-g-input.xml \
+	vidioc-g-jpegcomp.xml \
+	vidioc-g-modulator.xml \
+	vidioc-g-output.xml \
+	vidioc-g-parm.xml \
+	vidioc-g-priority.xml \
+	vidioc-g-sliced-vbi-cap.xml \
+	vidioc-g-std.xml \
+	vidioc-g-tuner.xml \
+	vidioc-log-status.xml \
+	vidioc-overlay.xml \
+	vidioc-qbuf.xml \
+	vidioc-querybuf.xml \
+	vidioc-querycap.xml \
+	vidioc-queryctrl.xml \
+	vidioc-querystd.xml \
+	vidioc-reqbufs.xml \
+	vidioc-s-hw-freq-seek.xml \
+	vidioc-streamon.xml \
+	capture.c.xml \
+	keytable.c.xml \
+	v4l2grab.c.xml \
+	videodev2.h.xml \
+	v4l2.xml
 
 DVB_SGMLS = \
-	dvb/intro.xml \
-	dvb/frontend.xml \
-	dvb/dvbproperty.xml \
-	dvb/demux.xml \
-	dvb/video.xml \
-	dvb/audio.xml \
-	dvb/ca.xml \
-	dvb/net.xml \
-	dvb/kdapi.xml \
-	dvb/examples.xml \
-	dvb/frontend.h.xml \
-	dvb/dvbapi.xml
+	intro.xml \
+	frontend.xml \
+	dvbproperty.xml \
+	demux.xml \
+	video.xml \
+	audio.xml \
+	ca.xml \
+	net.xml \
+	kdapi.xml \
+	examples.xml \
+	frontend.h.xml \
+	dvbapi.xml
 
 MEDIA_TEMP =  media-entities.tmpl \
 	      media-indices.tmpl \
-	      v4l/videodev2.h.xml \
-	      dvb/frontend.h.xml
+	      videodev2.h.xml \
+	      frontend.h.xml
 
-MEDIA_TEMP_OBJ := $(addprefix $(obj)/,$(MEDIA_TEMP))
+MEDIA_TEMP_OBJ := $(addprefix $(MEDIA_DIR)/,$(MEDIA_TEMP))
 
-$(obj)/media.xml: $(obj)/media.tmpl $(MEDIA_TEMP_OBJ) FORCE
-	$(call if_changed_rule,docproc)
-
-MEDIA_SGMLS =  $(V4L_SGMLS) $(DVB_SGMLS) $(MEDIA_TEMP)
+MEDIA_SGMLS =   $(addprefix ./,$(V4L_SGMLS)) $(addprefix ./,$(DVB_SGMLS)) $(addprefix ./,$(MEDIA_TEMP))
 
 FUNCS = \
 	close \
@@ -608,7 +593,21 @@ DVB_DOCUMENTED = \
 	-e "s,\(define \)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g"
 
-$(obj)/v4l/videodev2.h.xml: $(srctree)/include/linux/videodev2.h
+
+#
+# Media targets and dependencies
+#
+
+$(obj)/media_tmp/media.xml: $(obj)/media.tmpl $(MEDIA_TEMP_OBJ) FORCE
+	$(call if_changed_rule,docproc)
+
+$(MEDIA_DIR)/v4l2.xml:
+	mkdir -p $(MEDIA_DIR)
+	cp $(srctree)/Documentation/DocBook/dvb/*.png $(srctree)/Documentation/DocBook/v4l/*.gif $(MEDIA_DIR)/
+	ln -sf $(srctree)/Documentation/DocBook/v4l/*xml $(MEDIA_DIR)/
+	ln -sf $(srctree)/Documentation/DocBook/dvb/*xml $(MEDIA_DIR)/
+
+$(MEDIA_DIR)/videodev2.h.xml: $(srctree)/include/linux/videodev2.h $(MEDIA_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
@@ -619,7 +618,7 @@ $(obj)/v4l/videodev2.h.xml: $(srctree)/include/linux/videodev2.h
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(obj)/dvb/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h
+$(MEDIA_DIR)/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h $(MEDIA_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(					\
 	echo "<programlisting>") > $@
@@ -630,7 +629,7 @@ $(obj)/dvb/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h
 	@(					\
 	echo "</programlisting>") >> $@
 
-$(obj)/media-entities.tmpl:
+$(MEDIA_DIR)/media-entities.tmpl: $(MEDIA_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(								\
 	echo "<!-- Generated file! Do not edit. -->") >$@
@@ -648,7 +647,7 @@ $(obj)/media-entities.tmpl:
 	@(								\
 	for ident in $(IOCTLS) ; do					\
 	  entity=`echo $$ident | tr _ -` ;				\
-	  id=`grep "<refname>$$ident" $(obj)/v4l/vidioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
+	  id=`grep "<refname>$$ident" $(MEDIA_DIR)/vidioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
 	  echo "<!ENTITY $$entity \"<link"				\
 	    "linkend='$$id'><constant>$$ident</constant></link>\">"	\
 	  >>$@ ;							\
@@ -691,7 +690,7 @@ $(obj)/media-entities.tmpl:
 	  entity=`echo "$$file" | sed $(FILENAME) -e s/"^([^-]*)"/sub\1/` ; \
 	  if ! echo "$$file" |						\
 	    grep -q -E -e '^(func|vidioc|pixfmt)-' ; then		\
-	    echo "<!ENTITY sub-$$entity SYSTEM \"$$file\">" >>$@ ;	\
+	    echo "<!ENTITY sub-$$entity SYSTEM \"./$$file\">" >>$@ ;	\
 	  fi ;								\
 	done)
 	@(								\
@@ -701,13 +700,13 @@ $(obj)/media-entities.tmpl:
 	  if echo "$$file" |						\
 	    grep -q -E -e '(func|vidioc|pixfmt)-' ; then		\
 	    entity=`echo "$$file" |sed $(FILENAME)` ;			\
-	    echo "<!ENTITY $$entity SYSTEM \"$$file\">" >>$@ ;		\
+	    echo "<!ENTITY $$entity SYSTEM \"./$$file\">" >>$@ ;	\
 	  fi ;								\
 	done)
 
 # Jade can auto-generate a list-of-tables, which includes all structs,
 # but we only want data types, all types, and sorted please.
-$(obj)/media-indices.tmpl:
+$(MEDIA_DIR)/media-indices.tmpl: $(MEDIA_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
 	@(								\
 	echo "<!-- Generated file! Do not edit. -->") >$@
