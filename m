Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733Ab1FAKwj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 06:52:39 -0400
Message-ID: <4DE619F1.6020807@redhat.com>
Date: Wed, 01 Jun 2011 07:52:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] DocBook: Add rules to auto-generate some
 media docbook
References: <96c3a1277523b929bd27f5d68d5f40e2a0e5bdf3.1306337174.git.mchehab@redhat.com>	<20110525122642.7b4f381f@pedra> <20110525201027.57e2acc4.rdunlap@xenotime.net>
In-Reply-To: <20110525201027.57e2acc4.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Randy,

Em 26-05-2011 00:10, Randy Dunlap escreveu:
> On Wed, 25 May 2011 12:26:42 -0300 Mauro Carvalho Chehab wrote:
> 
>> Auto-generate the videodev2.h.xml,frontend.h.xml and the indexes.
>>
>> Some logic at the Makefile helps us to identify when a symbol is missing,
>> like for example:
>>
>> Error: no ID for constraint linkend: V4L2-PIX-FMT-JPGL.
> 
> 
> a.  Still get that message..  is that OK?
> 
> b.  In the generated index.html file, "media" is listed first, but it should be
> listed in alphabetical order, not first.
> 
> c.  The generated files are (hidden) in .tmpmedia/
> 
> d.  The link from the top-level index.html file to "media" is to
> media/index.html, but the file is actually in .tmpmedia/media/index.html
> 
> e.  patches 1/3 and 2/3 are OK.
> 
> 
> Please build docs with and without using "O=builddir" and test that.
> 
> I'm looking over the generated output now and will let you know if I see
> any other problems.

Fixed the pointed issues. I also moved the media-specific stuff into another
Makefile. I opted to include it into the DocBook Makefile, as otherwise, I would
need to duplicate the xml conversion stuff into the media/Makefile.

Patch is enclosed.

Cheers,
Mauro

-

[media] DocBook: Move all media docbook stuff into its own directory

This patch addresses several issues pointed by Randy Dunlap
<rdunlap@xenotime.net> at changeset ece722c:

- In the generated index.html file, "media" is listed first, but it
  should be listed in alphabetical order, not first.

- The generated files are (hidden) in .tmpmedia/

- The link from the top-level index.html file to "media" is to
  media/index.html, but the file is actually in .tmpmedia/media/index.html

- Please build docs with and without using "O=builddir" and test that.

- Would it be possible for media to have its own Makefile instead of
  merging into this one?

Due to the way cleandocs target works, I had to rename the media DocBook
to media_api, otherwise cleandocs would remove the /media directory.

Thanks-to: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/.gitignore b/Documentation/DocBook/.gitignore
index 679034c..2c8c882 100644
--- a/Documentation/DocBook/.gitignore
+++ b/Documentation/DocBook/.gitignore
@@ -8,4 +8,13 @@
 *.dvi
 *.log
 *.out
-media/
+crop.gif
+dvbstb.png
+fieldseq_bt.gif
+fieldseq_tb.gif
+media-indices.tmpl
+nv12mt.gif
+nv12mt_example.gif
+vbi_525.gif
+vbi_625.gif
+vbi_hsync.gif
diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 595bdd3..5125277 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -6,8 +6,6 @@
 # To add a new book the only step required is to add the book to the
 # list of DOCBOOKS.
 
-TMPMEDIA=.tmpmedia
-
 DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
 	    kernel-hacking.xml kernel-locking.xml deviceiobook.xml \
 	    writing_usb_driver.xml networking.xml \
@@ -16,7 +14,9 @@ DOCBOOKS := z8530book.xml mcabook.xml device-drivers.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
 	    80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
-	    tracepoint.xml $(TMPMEDIA)/media.xml drm.xml
+	    tracepoint.xml drm.xml media_api.xml
+
+include $(srctree)/Documentation/DocBook/media/Makefile
 
 ###
 # The build process is as follows (targets):
@@ -34,7 +34,7 @@ PS_METHOD	= $(prefer-db2x)
 
 ###
 # The targets that may be used.
-PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs mediaprep
+PHONY += xmldocs sgmldocs psdocs pdfdocs htmldocs mandocs installmandocs cleandocs
 
 BOOKS := $(addprefix $(obj)/,$(DOCBOOKS))
 xmldocs: $(BOOKS)
@@ -228,9 +228,9 @@ clean-files := $(DOCBOOKS) \
 	$(patsubst %.xml, %.9,    $(DOCBOOKS)) \
 	$(index)
 
-clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man $(MEDIA_DIR)
+clean-dirs := $(patsubst %.xml,%,$(DOCBOOKS)) man
 
-cleandocs:
+cleandocs: cleanmediadocs
 	$(Q)rm -f $(call objectify, $(clean-files))
 	$(Q)rm -rf $(call objectify, $(clean-dirs))
 
@@ -238,252 +238,3 @@ cleandocs:
 # information in a variable se we can use it in if_changed and friends.
 
 .PHONY: $(PHONY)
-
-
-#
-# Media build rules - Auto-generates media contents/indexes and *.h xml's
-#
-
-SHELL=/bin/bash
-
-MEDIA_DIR=$(objtree)/Documentation/DocBook/$(TMPMEDIA)
-
-V4L_SGMLS = \
-	$(shell ls $(srctree)/Documentation/DocBook/v4l/*.xml|perl -ne 'print "$$1 " if (m,.*/(.*)\n,)') \
-	capture.c.xml \
-	keytable.c.xml \
-	v4l2grab.c.xml
-
-DVB_SGMLS = \
-	$(shell ls $(srctree)/Documentation/DocBook/dvb/*.xml|perl -ne 'print "$$1 " if (m,.*/(.*)\n,)')
-
-MEDIA_TEMP =  media-entities.tmpl \
-	      media-indices.tmpl \
-	      videodev2.h.xml \
-	      frontend.h.xml
-
-MEDIA_SGMLS =  $(addprefix ./,$(V4L_SGMLS)) $(addprefix ./,$(DVB_SGMLS)) $(addprefix ./,$(MEDIA_TEMP))
-
-MEDIA_TEMP_OBJ := $(addprefix $(MEDIA_DIR)/,$(MEDIA_TEMP))
-
-FUNCS = \
-	close \
-	ioctl \
-	mmap \
-	munmap \
-	open \
-	poll \
-	read \
-	select \
-	write \
-
-IOCTLS = \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/media.h) \
-	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/v4l2-subdev.h) \
-	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
-	VIDIOC_SUBDEV_S_FRAME_INTERVAL \
-	VIDIOC_SUBDEV_ENUM_MBUS_CODE \
-	VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
-	VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
-
-TYPES = \
-	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/linux/videodev2.h)
-
-ENUMS = \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h) \
-	$(shell perl -ne 'print "$$1 " if /^enum\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h)
-
-STRUCTS = \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/videodev2.h) \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/media.h) \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-subdev.h) \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/linux/v4l2-mediabus.h)
-
-ERRORS = \
-	EACCES \
-	EAGAIN \
-	EBADF \
-	EBUSY \
-	EFAULT \
-	EIO \
-	EINTR \
-	EINVAL \
-	ENFILE \
-	ENOMEM \
-	ENOSPC \
-	ENOTTY \
-	ENXIO \
-	EMFILE \
-	EPERM \
-	ERANGE \
-	EPIPE \
-
-ESCAPE = \
-	-e "s/&/\\&amp;/g" \
-	-e "s/</\\&lt;/g" \
-	-e "s/>/\\&gt;/g"
-
-FILENAME = \
-	-e s,"^[^\/]*/",, \
-	-e s/"\\.xml"// \
-	-e s/"\\.tmpl"// \
-	-e s/\\\./-/g \
-	-e s/"^func-"// \
-	-e s/"^pixfmt-"// \
-	-e s/"^vidioc-"//
-
-# Generate references to these structs in videodev2.h.xml.
-DOCUMENTED = \
-	-e "s/\(enum *\)v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type\)/\1<link linkend=\"\2\">v4l2_mpeg_cx2341x_video_\2<\/link>/g" \
-	-e "s/\(\(enum\|struct\) *\)\(v4l2_[a-zA-Z0-9_]*\)/\1<link linkend=\"\3\">\3<\/link>/g" \
-	-e "s/\(V4L2_PIX_FMT_[A-Z0-9_]\+\) /<link linkend=\"\1\">\1<\/link> /g" \
-	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
-	-e "s/v4l2\-mpeg\-vbi\-ITV0/v4l2-mpeg-vbi-itv0-1/g"
-
-DVB_DOCUMENTED = \
-	-e "s,\(define \)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
-	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g"
-
-
-#
-# Media targets and dependencies
-#
-
-$(obj)/$(TMPMEDIA)/media.xml: $(obj)/media.tmpl $(MEDIA_TEMP_OBJ) FORCE
-	$(call if_changed_rule,docproc)
-
-$(MEDIA_DIR)/v4l2.xml:
-	@$($(quiet)gen_xml)
-	@(mkdir -p $(MEDIA_DIR))
-	@(cp $(srctree)/Documentation/DocBook/dvb/*.png $(srctree)/Documentation/DocBook/v4l/*.gif $(MEDIA_DIR)/)
-	@(ln -sf $(srctree)/Documentation/DocBook/v4l/*xml $(MEDIA_DIR)/)
-	@(ln -sf $(srctree)/Documentation/DocBook/dvb/*xml $(MEDIA_DIR)/)
-
-$(MEDIA_DIR)/videodev2.h.xml: $(srctree)/include/linux/videodev2.h $(MEDIA_DIR)/v4l2.xml
-	@$($(quiet)gen_xml)
-	@(					\
-	echo "<programlisting>") > $@
-	@(					\
-	expand --tabs=8 < $< |			\
-	  sed $(ESCAPE) $(DOCUMENTED) |		\
-	  sed 's/i\.e\./&ie;/') >> $@
-	@(					\
-	echo "</programlisting>") >> $@
-
-$(MEDIA_DIR)/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h $(MEDIA_DIR)/v4l2.xml
-	@$($(quiet)gen_xml)
-	@(					\
-	echo "<programlisting>") > $@
-	@(					\
-	expand --tabs=8 < $< |			\
-	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
-	  sed 's/i\.e\./&ie;/') >> $@
-	@(					\
-	echo "</programlisting>") >> $@
-
-$(MEDIA_DIR)/media-entities.tmpl: $(MEDIA_DIR)/v4l2.xml
-	@$($(quiet)gen_xml)
-	@(								\
-	echo "<!-- Generated file! Do not edit. -->") >$@
-	@(								\
-	echo -e "\n<!-- Functions -->") >>$@
-	@(								\
-	for ident in $(FUNCS) ; do					\
-	  entity=`echo $$ident | tr _ -` ;				\
-	  echo "<!ENTITY func-$$entity \"<link"				\
-	    "linkend='func-$$entity'><function>$$ident()</function></link>\">" \
-	  >>$@ ;							\
-	done)
-	@(								\
-	echo -e "\n<!-- Ioctls -->") >>$@
-	@(								\
-	for ident in $(IOCTLS) ; do					\
-	  entity=`echo $$ident | tr _ -` ;				\
-	  id=`grep "<refname>$$ident" $(MEDIA_DIR)/vidioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
-	  echo "<!ENTITY $$entity \"<link"				\
-	    "linkend='$$id'><constant>$$ident</constant></link>\">"	\
-	  >>$@ ;							\
-	done)
-	@(								\
-	echo -e "\n<!-- Types -->") >>$@
-	@(								\
-	for ident in $(TYPES) ; do					\
-	  entity=`echo $$ident | tr _ -` ;				\
-	  echo "<!ENTITY $$entity \"<link"				\
-	    "linkend='$$entity'>$$ident</link>\">" >>$@ ;		\
-	done)
-	@(								\
-	echo -e "\n<!-- Enums -->") >>$@
-	@(								\
-	for ident in $(ENUMS) ; do					\
-	  entity=`echo $$ident | sed -e "s/v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type\)/\1/" | tr _ -` ; \
-	  echo "<!ENTITY $$entity \"enum&nbsp;<link"			\
-	    "linkend='$$entity'>$$ident</link>\">" >>$@ ;		\
-	done)
-	@(								\
-	echo -e "\n<!-- Structures -->") >>$@
-	@(								\
-	for ident in $(STRUCTS) ; do					\
-	  entity=`echo $$ident | tr _ - | sed s/v4l2-mpeg-vbi-ITV0/v4l2-mpeg-vbi-itv0-1/g` ; \
-	  echo "<!ENTITY $$entity \"struct&nbsp;<link"			\
-	    "linkend='$$entity'>$$ident</link>\">" >>$@ ;		\
-	done)
-	@(								\
-	echo -e "\n<!-- Error Codes -->") >>$@
-	@(								\
-	for ident in $(ERRORS) ; do					\
-	  echo "<!ENTITY $$ident \"<errorcode>$$ident</errorcode>"	\
-	    "error code\">" >>$@ ;					\
-	done)
-	@(								\
-	echo -e "\n<!-- Subsections -->") >>$@
-	@(								\
-	for file in $(MEDIA_SGMLS) ; do					\
-	  entity=`echo "$$file" | sed $(FILENAME) -e s/"^([^-]*)"/sub\1/` ; \
-	  if ! echo "$$file" |						\
-	    grep -q -E -e '^(func|vidioc|pixfmt)-' ; then		\
-	    echo "<!ENTITY sub-$$entity SYSTEM \"$$file\">" >>$@ ;	\
-	  fi ;								\
-	done)
-	@(								\
-	echo -e "\n<!-- Function Reference -->") >>$@
-	@(								\
-	for file in $(MEDIA_SGMLS) ; do					\
-	  if echo "$$file" |						\
-	    grep -q -E -e '(func|vidioc|pixfmt)-' ; then		\
-	    entity=`echo "$$file" |sed $(FILENAME)` ;			\
-	    echo "<!ENTITY $$entity SYSTEM \"$$file\">" >>$@ ;	\
-	  fi ;								\
-	done)
-
-# Jade can auto-generate a list-of-tables, which includes all structs,
-# but we only want data types, all types, and sorted please.
-$(MEDIA_DIR)/media-indices.tmpl: $(MEDIA_DIR)/v4l2.xml
-	@$($(quiet)gen_xml)
-	@(								\
-	echo "<!-- Generated file! Do not edit. -->") >$@
-	@(								\
-	echo -e "\n<index><title>List of Types</title>") >>$@
-	@(								\
-	for ident in $(TYPES) ; do					\
-	  id=`echo $$ident | tr _ -` ;					\
-	  echo "<indexentry><primaryie><link"				\
-	    "linkend='$$id'>$$ident</link></primaryie></indexentry>" >>$@ ; \
-	done)
-	@(								\
-	for ident in $(ENUMS) ; do					\
-	  id=`echo $$ident | sed -e "s/v4l2_mpeg_cx2341x_video_\([a-z]*_spatial_filter_type\)/\1/" | tr _ -`; \
-	  echo "<indexentry><primaryie>enum&nbsp;<link"			\
-	    "linkend='$$id'>$$ident</link></primaryie></indexentry>" >>$@ ; \
-	done)
-	@(								\
-	for ident in $(STRUCTS) ; do					\
-	  id=`echo $$ident | tr _ - | sed s/v4l2-mpeg-vbi-ITV0/v4l2-mpeg-vbi-itv0-1/g` ; \
-	  echo "<indexentry><primaryie>struct&nbsp;<link"		\
-	    "linkend='$$id'>$$ident</link></primaryie></indexentry>" >>$@ ; \
-	done)
-	@(								\
-	echo "</index>") >>$@
diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
deleted file mode 100644
index e5fe094..0000000
--- a/Documentation/DocBook/media-entities.tmpl
+++ /dev/null
@@ -1,464 +0,0 @@
-<!-- Generated file! Do not edit. -->
-
-<!-- Functions -->
-<!ENTITY func-close "<link linkend='func-close'><function>close()</function></link>">
-<!ENTITY func-ioctl "<link linkend='func-ioctl'><function>ioctl()</function></link>">
-<!ENTITY func-mmap "<link linkend='func-mmap'><function>mmap()</function></link>">
-<!ENTITY func-munmap "<link linkend='func-munmap'><function>munmap()</function></link>">
-<!ENTITY func-open "<link linkend='func-open'><function>open()</function></link>">
-<!ENTITY func-poll "<link linkend='func-poll'><function>poll()</function></link>">
-<!ENTITY func-read "<link linkend='func-read'><function>read()</function></link>">
-<!ENTITY func-select "<link linkend='func-select'><function>select()</function></link>">
-<!ENTITY func-write "<link linkend='func-write'><function>write()</function></link>">
-
-<!ENTITY media-func-close "<link linkend='media-func-close'><function>close()</function></link>">
-<!ENTITY media-func-ioctl "<link linkend='media-func-ioctl'><function>ioctl()</function></link>">
-<!ENTITY media-func-open "<link linkend='media-func-open'><function>open()</function></link>">
-
-<!-- Ioctls -->
-<!ENTITY VIDIOC-CROPCAP "<link linkend='vidioc-cropcap'><constant>VIDIOC_CROPCAP</constant></link>">
-<!ENTITY VIDIOC-DBG-G-CHIP-IDENT "<link linkend='vidioc-dbg-g-chip-ident'><constant>VIDIOC_DBG_G_CHIP_IDENT</constant></link>">
-<!ENTITY VIDIOC-DBG-G-REGISTER "<link linkend='vidioc-dbg-g-register'><constant>VIDIOC_DBG_G_REGISTER</constant></link>">
-<!ENTITY VIDIOC-DBG-S-REGISTER "<link linkend='vidioc-dbg-g-register'><constant>VIDIOC_DBG_S_REGISTER</constant></link>">
-<!ENTITY VIDIOC-DQBUF "<link linkend='vidioc-qbuf'><constant>VIDIOC_DQBUF</constant></link>">
-<!ENTITY VIDIOC-DQEVENT "<link linkend='vidioc-dqevent'><constant>VIDIOC_DQEVENT</constant></link>">
-<!ENTITY VIDIOC-ENCODER-CMD "<link linkend='vidioc-encoder-cmd'><constant>VIDIOC_ENCODER_CMD</constant></link>">
-<!ENTITY VIDIOC-ENUMAUDIO "<link linkend='vidioc-enumaudio'><constant>VIDIOC_ENUMAUDIO</constant></link>">
-<!ENTITY VIDIOC-ENUMAUDOUT "<link linkend='vidioc-enumaudioout'><constant>VIDIOC_ENUMAUDOUT</constant></link>">
-<!ENTITY VIDIOC-ENUMINPUT "<link linkend='vidioc-enuminput'><constant>VIDIOC_ENUMINPUT</constant></link>">
-<!ENTITY VIDIOC-ENUMOUTPUT "<link linkend='vidioc-enumoutput'><constant>VIDIOC_ENUMOUTPUT</constant></link>">
-<!ENTITY VIDIOC-ENUMSTD "<link linkend='vidioc-enumstd'><constant>VIDIOC_ENUMSTD</constant></link>">
-<!ENTITY VIDIOC-ENUM-DV-PRESETS "<link linkend='vidioc-enum-dv-presets'><constant>VIDIOC_ENUM_DV_PRESETS</constant></link>">
-<!ENTITY VIDIOC-ENUM-FMT "<link linkend='vidioc-enum-fmt'><constant>VIDIOC_ENUM_FMT</constant></link>">
-<!ENTITY VIDIOC-ENUM-FRAMEINTERVALS "<link linkend='vidioc-enum-frameintervals'><constant>VIDIOC_ENUM_FRAMEINTERVALS</constant></link>">
-<!ENTITY VIDIOC-ENUM-FRAMESIZES "<link linkend='vidioc-enum-framesizes'><constant>VIDIOC_ENUM_FRAMESIZES</constant></link>">
-<!ENTITY VIDIOC-G-AUDIO "<link linkend='vidioc-g-audio'><constant>VIDIOC_G_AUDIO</constant></link>">
-<!ENTITY VIDIOC-G-AUDOUT "<link linkend='vidioc-g-audioout'><constant>VIDIOC_G_AUDOUT</constant></link>">
-<!ENTITY VIDIOC-G-CROP "<link linkend='vidioc-g-crop'><constant>VIDIOC_G_CROP</constant></link>">
-<!ENTITY VIDIOC-G-CTRL "<link linkend='vidioc-g-ctrl'><constant>VIDIOC_G_CTRL</constant></link>">
-<!ENTITY VIDIOC-G-DV-PRESET "<link linkend='vidioc-g-dv-preset'><constant>VIDIOC_G_DV_PRESET</constant></link>">
-<!ENTITY VIDIOC-G-DV-TIMINGS "<link linkend='vidioc-g-dv-timings'><constant>VIDIOC_G_DV_TIMINGS</constant></link>">
-<!ENTITY VIDIOC-G-ENC-INDEX "<link linkend='vidioc-g-enc-index'><constant>VIDIOC_G_ENC_INDEX</constant></link>">
-<!ENTITY VIDIOC-G-EXT-CTRLS "<link linkend='vidioc-g-ext-ctrls'><constant>VIDIOC_G_EXT_CTRLS</constant></link>">
-<!ENTITY VIDIOC-G-FBUF "<link linkend='vidioc-g-fbuf'><constant>VIDIOC_G_FBUF</constant></link>">
-<!ENTITY VIDIOC-G-FMT "<link linkend='vidioc-g-fmt'><constant>VIDIOC_G_FMT</constant></link>">
-<!ENTITY VIDIOC-G-FREQUENCY "<link linkend='vidioc-g-frequency'><constant>VIDIOC_G_FREQUENCY</constant></link>">
-<!ENTITY VIDIOC-G-INPUT "<link linkend='vidioc-g-input'><constant>VIDIOC_G_INPUT</constant></link>">
-<!ENTITY VIDIOC-G-JPEGCOMP "<link linkend='vidioc-g-jpegcomp'><constant>VIDIOC_G_JPEGCOMP</constant></link>">
-<!ENTITY VIDIOC-G-MPEGCOMP "<link linkend=''><constant>VIDIOC_G_MPEGCOMP</constant></link>">
-<!ENTITY VIDIOC-G-MODULATOR "<link linkend='vidioc-g-modulator'><constant>VIDIOC_G_MODULATOR</constant></link>">
-<!ENTITY VIDIOC-G-OUTPUT "<link linkend='vidioc-g-output'><constant>VIDIOC_G_OUTPUT</constant></link>">
-<!ENTITY VIDIOC-G-PARM "<link linkend='vidioc-g-parm'><constant>VIDIOC_G_PARM</constant></link>">
-<!ENTITY VIDIOC-G-PRIORITY "<link linkend='vidioc-g-priority'><constant>VIDIOC_G_PRIORITY</constant></link>">
-<!ENTITY VIDIOC-G-SLICED-VBI-CAP "<link linkend='vidioc-g-sliced-vbi-cap'><constant>VIDIOC_G_SLICED_VBI_CAP</constant></link>">
-<!ENTITY VIDIOC-G-STD "<link linkend='vidioc-g-std'><constant>VIDIOC_G_STD</constant></link>">
-<!ENTITY VIDIOC-G-TUNER "<link linkend='vidioc-g-tuner'><constant>VIDIOC_G_TUNER</constant></link>">
-<!ENTITY VIDIOC-LOG-STATUS "<link linkend='vidioc-log-status'><constant>VIDIOC_LOG_STATUS</constant></link>">
-<!ENTITY VIDIOC-OVERLAY "<link linkend='vidioc-overlay'><constant>VIDIOC_OVERLAY</constant></link>">
-<!ENTITY VIDIOC-QBUF "<link linkend='vidioc-qbuf'><constant>VIDIOC_QBUF</constant></link>">
-<!ENTITY VIDIOC-QUERYBUF "<link linkend='vidioc-querybuf'><constant>VIDIOC_QUERYBUF</constant></link>">
-<!ENTITY VIDIOC-QUERYCAP "<link linkend='vidioc-querycap'><constant>VIDIOC_QUERYCAP</constant></link>">
-<!ENTITY VIDIOC-QUERYCTRL "<link linkend='vidioc-queryctrl'><constant>VIDIOC_QUERYCTRL</constant></link>">
-<!ENTITY VIDIOC-QUERYMENU "<link linkend='vidioc-queryctrl'><constant>VIDIOC_QUERYMENU</constant></link>">
-<!ENTITY VIDIOC-QUERYSTD "<link linkend='vidioc-querystd'><constant>VIDIOC_QUERYSTD</constant></link>">
-<!ENTITY VIDIOC-QUERY-DV-PRESET "<link linkend='vidioc-query-dv-preset'><constant>VIDIOC_QUERY_DV_PRESET</constant></link>">
-<!ENTITY VIDIOC-REQBUFS "<link linkend='vidioc-reqbufs'><constant>VIDIOC_REQBUFS</constant></link>">
-<!ENTITY VIDIOC-STREAMOFF "<link linkend='vidioc-streamon'><constant>VIDIOC_STREAMOFF</constant></link>">
-<!ENTITY VIDIOC-STREAMON "<link linkend='vidioc-streamon'><constant>VIDIOC_STREAMON</constant></link>">
-<!ENTITY VIDIOC-SUBSCRIBE-EVENT "<link linkend='vidioc-subscribe-event'><constant>VIDIOC_SUBSCRIBE_EVENT</constant></link>">
-<!ENTITY VIDIOC-S-AUDIO "<link linkend='vidioc-g-audio'><constant>VIDIOC_S_AUDIO</constant></link>">
-<!ENTITY VIDIOC-S-AUDOUT "<link linkend='vidioc-g-audioout'><constant>VIDIOC_S_AUDOUT</constant></link>">
-<!ENTITY VIDIOC-S-CROP "<link linkend='vidioc-g-crop'><constant>VIDIOC_S_CROP</constant></link>">
-<!ENTITY VIDIOC-S-CTRL "<link linkend='vidioc-g-ctrl'><constant>VIDIOC_S_CTRL</constant></link>">
-<!ENTITY VIDIOC-S-DV-PRESET "<link linkend='vidioc-g-dv-preset'><constant>VIDIOC_S_DV_PRESET</constant></link>">
-<!ENTITY VIDIOC-S-DV-TIMINGS "<link linkend='vidioc-g-dv-timings'><constant>VIDIOC_S_DV_TIMINGS</constant></link>">
-<!ENTITY VIDIOC-S-EXT-CTRLS "<link linkend='vidioc-g-ext-ctrls'><constant>VIDIOC_S_EXT_CTRLS</constant></link>">
-<!ENTITY VIDIOC-S-FBUF "<link linkend='vidioc-g-fbuf'><constant>VIDIOC_S_FBUF</constant></link>">
-<!ENTITY VIDIOC-S-FMT "<link linkend='vidioc-g-fmt'><constant>VIDIOC_S_FMT</constant></link>">
-<!ENTITY VIDIOC-S-FREQUENCY "<link linkend='vidioc-g-frequency'><constant>VIDIOC_S_FREQUENCY</constant></link>">
-<!ENTITY VIDIOC-S-HW-FREQ-SEEK "<link linkend='vidioc-s-hw-freq-seek'><constant>VIDIOC_S_HW_FREQ_SEEK</constant></link>">
-<!ENTITY VIDIOC-S-INPUT "<link linkend='vidioc-g-input'><constant>VIDIOC_S_INPUT</constant></link>">
-<!ENTITY VIDIOC-S-JPEGCOMP "<link linkend='vidioc-g-jpegcomp'><constant>VIDIOC_S_JPEGCOMP</constant></link>">
-<!ENTITY VIDIOC-S-MPEGCOMP "<link linkend=''><constant>VIDIOC_S_MPEGCOMP</constant></link>">
-<!ENTITY VIDIOC-S-MODULATOR "<link linkend='vidioc-g-modulator'><constant>VIDIOC_S_MODULATOR</constant></link>">
-<!ENTITY VIDIOC-S-OUTPUT "<link linkend='vidioc-g-output'><constant>VIDIOC_S_OUTPUT</constant></link>">
-<!ENTITY VIDIOC-S-PARM "<link linkend='vidioc-g-parm'><constant>VIDIOC_S_PARM</constant></link>">
-<!ENTITY VIDIOC-S-PRIORITY "<link linkend='vidioc-g-priority'><constant>VIDIOC_S_PRIORITY</constant></link>">
-<!ENTITY VIDIOC-S-STD "<link linkend='vidioc-g-std'><constant>VIDIOC_S_STD</constant></link>">
-<!ENTITY VIDIOC-S-TUNER "<link linkend='vidioc-g-tuner'><constant>VIDIOC_S_TUNER</constant></link>">
-<!ENTITY VIDIOC-SUBDEV-ENUM-FRAME-SIZE "<link linkend='vidioc-subdev-enum-frame-size'><constant>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</constant></link>">
-<!ENTITY VIDIOC-SUBDEV-ENUM-MBUS-CODE "<link linkend='vidioc-subdev-enum-mbus-code'><constant>VIDIOC_SUBDEV_ENUM_MBUS_CODE</constant></link>">
-<!ENTITY VIDIOC-SUBDEV-G-CROP "<link linkend='vidioc-subdev-g-crop'><constant>VIDIOC_SUBDEV_G_CROP</constant></link>">
-<!ENTITY VIDIOC-SUBDEV-G-FMT "<link linkend='vidioc-subdev-g-fmt'><constant>VIDIOC_SUBDEV_G_FMT</constant></link>">
-<!ENTITY VIDIOC-SUBDEV-G-FRAME-INTERVAL "<link linkend='vidioc-subdev-g-frame-interval'><constant>VIDIOC_SUBDEV_G_FRAME_INTERVAL</constant></link>">
-<!ENTITY VIDIOC-SUBDEV-S-CROP "<link linkend='vidioc-subdev-g-crop'><constant>VIDIOC_SUBDEV_S_CROP</constant></link>">
-<!ENTITY VIDIOC-SUBDEV-S-FMT "<link linkend='vidioc-subdev-g-fmt'><constant>VIDIOC_SUBDEV_S_FMT</constant></link>">
-<!ENTITY VIDIOC-SUBDEV-S-FRAME-INTERVAL "<link linkend='vidioc-subdev-g-frame-interval'><constant>VIDIOC_SUBDEV_S_FRAME_INTERVAL</constant></link>">
-<!ENTITY VIDIOC-TRY-ENCODER-CMD "<link linkend='vidioc-encoder-cmd'><constant>VIDIOC_TRY_ENCODER_CMD</constant></link>">
-<!ENTITY VIDIOC-TRY-EXT-CTRLS "<link linkend='vidioc-g-ext-ctrls'><constant>VIDIOC_TRY_EXT_CTRLS</constant></link>">
-<!ENTITY VIDIOC-TRY-FMT "<link linkend='vidioc-g-fmt'><constant>VIDIOC_TRY_FMT</constant></link>">
-<!ENTITY VIDIOC-UNSUBSCRIBE-EVENT "<link linkend='vidioc-subscribe-event'><constant>VIDIOC_UNSUBSCRIBE_EVENT</constant></link>">
-
-<!ENTITY MEDIA-IOC-DEVICE-INFO "<link linkend='media-ioc-device-info'><constant>MEDIA_IOC_DEVICE_INFO</constant></link>">
-<!ENTITY MEDIA-IOC-ENUM-ENTITIES "<link linkend='media-ioc-enum-entities'><constant>MEDIA_IOC_ENUM_ENTITIES</constant></link>">
-<!ENTITY MEDIA-IOC-ENUM-LINKS "<link linkend='media-ioc-enum-links'><constant>MEDIA_IOC_ENUM_LINKS</constant></link>">
-<!ENTITY MEDIA-IOC-SETUP-LINK "<link linkend='media-ioc-setup-link'><constant>MEDIA_IOC_SETUP_LINK</constant></link>">
-
-<!-- Types -->
-<!ENTITY v4l2-std-id "<link linkend='v4l2-std-id'>v4l2_std_id</link>">
-
-<!-- Enums -->
-<!ENTITY v4l2-buf-type "enum&nbsp;<link linkend='v4l2-buf-type'>v4l2_buf_type</link>">
-<!ENTITY v4l2-colorspace "enum&nbsp;<link linkend='v4l2-colorspace'>v4l2_colorspace</link>">
-<!ENTITY v4l2-ctrl-type "enum&nbsp;<link linkend='v4l2-ctrl-type'>v4l2_ctrl_type</link>">
-<!ENTITY v4l2-exposure-auto-type "enum&nbsp;<link linkend='v4l2-exposure-auto-type'>v4l2_exposure_auto_type</link>">
-<!ENTITY v4l2-field "enum&nbsp;<link linkend='v4l2-field'>v4l2_field</link>">
-<!ENTITY v4l2-frmivaltypes "enum&nbsp;<link linkend='v4l2-frmivaltypes'>v4l2_frmivaltypes</link>">
-<!ENTITY v4l2-frmsizetypes "enum&nbsp;<link linkend='v4l2-frmsizetypes'>v4l2_frmsizetypes</link>">
-<!ENTITY v4l2-mbus-pixelcode "enum&nbsp;<link linkend='v4l2-mbus-pixelcode'>v4l2_mbus_pixelcode</link>">
-<!ENTITY v4l2-memory "enum&nbsp;<link linkend='v4l2-memory'>v4l2_memory</link>">
-<!ENTITY v4l2-mpeg-audio-ac3-bitrate "enum&nbsp;<link linkend='v4l2-mpeg-audio-ac3-bitrate'>v4l2_mpeg_audio_ac3_bitrate</link>">
-<!ENTITY v4l2-mpeg-audio-crc "enum&nbsp;<link linkend='v4l2-mpeg-audio-crc'>v4l2_mpeg_audio_crc</link>">
-<!ENTITY v4l2-mpeg-audio-emphasis "enum&nbsp;<link linkend='v4l2-mpeg-audio-emphasis'>v4l2_mpeg_audio_emphasis</link>">
-<!ENTITY v4l2-mpeg-audio-encoding "enum&nbsp;<link linkend='v4l2-mpeg-audio-encoding'>v4l2_mpeg_audio_encoding</link>">
-<!ENTITY v4l2-mpeg-audio-l1-bitrate "enum&nbsp;<link linkend='v4l2-mpeg-audio-l1-bitrate'>v4l2_mpeg_audio_l1_bitrate</link>">
-<!ENTITY v4l2-mpeg-audio-l2-bitrate "enum&nbsp;<link linkend='v4l2-mpeg-audio-l2-bitrate'>v4l2_mpeg_audio_l2_bitrate</link>">
-<!ENTITY v4l2-mpeg-audio-l3-bitrate "enum&nbsp;<link linkend='v4l2-mpeg-audio-l3-bitrate'>v4l2_mpeg_audio_l3_bitrate</link>">
-<!ENTITY v4l2-mpeg-audio-mode "enum&nbsp;<link linkend='v4l2-mpeg-audio-mode'>v4l2_mpeg_audio_mode</link>">
-<!ENTITY v4l2-mpeg-audio-mode-extension "enum&nbsp;<link linkend='v4l2-mpeg-audio-mode-extension'>v4l2_mpeg_audio_mode_extension</link>">
-<!ENTITY v4l2-mpeg-audio-sampling-freq "enum&nbsp;<link linkend='v4l2-mpeg-audio-sampling-freq'>v4l2_mpeg_audio_sampling_freq</link>">
-<!ENTITY chroma-spatial-filter-type "enum&nbsp;<link linkend='chroma-spatial-filter-type'>v4l2_mpeg_cx2341x_video_chroma_spatial_filter_type</link>">
-<!ENTITY luma-spatial-filter-type "enum&nbsp;<link linkend='luma-spatial-filter-type'>v4l2_mpeg_cx2341x_video_luma_spatial_filter_type</link>">
-<!ENTITY v4l2-mpeg-cx2341x-video-median-filter-type "enum&nbsp;<link linkend='v4l2-mpeg-cx2341x-video-median-filter-type'>v4l2_mpeg_cx2341x_video_median_filter_type</link>">
-<!ENTITY v4l2-mpeg-cx2341x-video-spatial-filter-mode "enum&nbsp;<link linkend='v4l2-mpeg-cx2341x-video-spatial-filter-mode'>v4l2_mpeg_cx2341x_video_spatial_filter_mode</link>">
-<!ENTITY v4l2-mpeg-cx2341x-video-temporal-filter-mode "enum&nbsp;<link linkend='v4l2-mpeg-cx2341x-video-temporal-filter-mode'>v4l2_mpeg_cx2341x_video_temporal_filter_mode</link>">
-<!ENTITY v4l2-mpeg-stream-type "enum&nbsp;<link linkend='v4l2-mpeg-stream-type'>v4l2_mpeg_stream_type</link>">
-<!ENTITY v4l2-mpeg-stream-vbi-fmt "enum&nbsp;<link linkend='v4l2-mpeg-stream-vbi-fmt'>v4l2_mpeg_stream_vbi_fmt</link>">
-<!ENTITY v4l2-mpeg-video-aspect "enum&nbsp;<link linkend='v4l2-mpeg-video-aspect'>v4l2_mpeg_video_aspect</link>">
-<!ENTITY v4l2-mpeg-video-bitrate-mode "enum&nbsp;<link linkend='v4l2-mpeg-video-bitrate-mode'>v4l2_mpeg_video_bitrate_mode</link>">
-<!ENTITY v4l2-mpeg-video-encoding "enum&nbsp;<link linkend='v4l2-mpeg-video-encoding'>v4l2_mpeg_video_encoding</link>">
-<!ENTITY v4l2-power-line-frequency "enum&nbsp;<link linkend='v4l2-power-line-frequency'>v4l2_power_line_frequency</link>">
-<!ENTITY v4l2-priority "enum&nbsp;<link linkend='v4l2-priority'>v4l2_priority</link>">
-<!ENTITY v4l2-subdev-format-whence "enum&nbsp;<link linkend='v4l2-subdev-format-whence'>v4l2_subdev_format_whence</link>">
-<!ENTITY v4l2-tuner-type "enum&nbsp;<link linkend='v4l2-tuner-type'>v4l2_tuner_type</link>">
-<!ENTITY v4l2-preemphasis "enum&nbsp;<link linkend='v4l2-preemphasis'>v4l2_preemphasis</link>">
-
-<!-- Structures -->
-<!ENTITY v4l2-audio "struct&nbsp;<link linkend='v4l2-audio'>v4l2_audio</link>">
-<!ENTITY v4l2-audioout "struct&nbsp;<link linkend='v4l2-audioout'>v4l2_audioout</link>">
-<!ENTITY v4l2-bt-timings "struct&nbsp;<link linkend='v4l2-bt-timings'>v4l2_bt_timings</link>">
-<!ENTITY v4l2-buffer "struct&nbsp;<link linkend='v4l2-buffer'>v4l2_buffer</link>">
-<!ENTITY v4l2-plane "struct&nbsp;<link linkend='v4l2-plane'>v4l2_plane</link>">
-<!ENTITY v4l2-capability "struct&nbsp;<link linkend='v4l2-capability'>v4l2_capability</link>">
-<!ENTITY v4l2-captureparm "struct&nbsp;<link linkend='v4l2-captureparm'>v4l2_captureparm</link>">
-<!ENTITY v4l2-clip "struct&nbsp;<link linkend='v4l2-clip'>v4l2_clip</link>">
-<!ENTITY v4l2-control "struct&nbsp;<link linkend='v4l2-control'>v4l2_control</link>">
-<!ENTITY v4l2-crop "struct&nbsp;<link linkend='v4l2-crop'>v4l2_crop</link>">
-<!ENTITY v4l2-cropcap "struct&nbsp;<link linkend='v4l2-cropcap'>v4l2_cropcap</link>">
-<!ENTITY v4l2-dbg-chip-ident "struct&nbsp;<link linkend='v4l2-dbg-chip-ident'>v4l2_dbg_chip_ident</link>">
-<!ENTITY v4l2-dbg-match "struct&nbsp;<link linkend='v4l2-dbg-match'>v4l2_dbg_match</link>">
-<!ENTITY v4l2-dbg-register "struct&nbsp;<link linkend='v4l2-dbg-register'>v4l2_dbg_register</link>">
-<!ENTITY v4l2-dv-enum-preset "struct&nbsp;<link linkend='v4l2-dv-enum-preset'>v4l2_dv_enum_preset</link>">
-<!ENTITY v4l2-dv-preset "struct&nbsp;<link linkend='v4l2-dv-preset'>v4l2_dv_preset</link>">
-<!ENTITY v4l2-dv-timings "struct&nbsp;<link linkend='v4l2-dv-timings'>v4l2_dv_timings</link>">
-<!ENTITY v4l2-enc-idx "struct&nbsp;<link linkend='v4l2-enc-idx'>v4l2_enc_idx</link>">
-<!ENTITY v4l2-enc-idx-entry "struct&nbsp;<link linkend='v4l2-enc-idx-entry'>v4l2_enc_idx_entry</link>">
-<!ENTITY v4l2-encoder-cmd "struct&nbsp;<link linkend='v4l2-encoder-cmd'>v4l2_encoder_cmd</link>">
-<!ENTITY v4l2-event "struct&nbsp;<link linkend='v4l2-event'>v4l2_event</link>">
-<!ENTITY v4l2-event-subscription "struct&nbsp;<link linkend='v4l2-event-subscription'>v4l2_event_subscription</link>">
-<!ENTITY v4l2-event-vsync "struct&nbsp;<link linkend='v4l2-event-vsync'>v4l2_event_vsync</link>">
-<!ENTITY v4l2-ext-control "struct&nbsp;<link linkend='v4l2-ext-control'>v4l2_ext_control</link>">
-<!ENTITY v4l2-ext-controls "struct&nbsp;<link linkend='v4l2-ext-controls'>v4l2_ext_controls</link>">
-<!ENTITY v4l2-fmtdesc "struct&nbsp;<link linkend='v4l2-fmtdesc'>v4l2_fmtdesc</link>">
-<!ENTITY v4l2-format "struct&nbsp;<link linkend='v4l2-format'>v4l2_format</link>">
-<!ENTITY v4l2-fract "struct&nbsp;<link linkend='v4l2-fract'>v4l2_fract</link>">
-<!ENTITY v4l2-framebuffer "struct&nbsp;<link linkend='v4l2-framebuffer'>v4l2_framebuffer</link>">
-<!ENTITY v4l2-frequency "struct&nbsp;<link linkend='v4l2-frequency'>v4l2_frequency</link>">
-<!ENTITY v4l2-frmival-stepwise "struct&nbsp;<link linkend='v4l2-frmival-stepwise'>v4l2_frmival_stepwise</link>">
-<!ENTITY v4l2-frmivalenum "struct&nbsp;<link linkend='v4l2-frmivalenum'>v4l2_frmivalenum</link>">
-<!ENTITY v4l2-frmsize-discrete "struct&nbsp;<link linkend='v4l2-frmsize-discrete'>v4l2_frmsize_discrete</link>">
-<!ENTITY v4l2-frmsize-stepwise "struct&nbsp;<link linkend='v4l2-frmsize-stepwise'>v4l2_frmsize_stepwise</link>">
-<!ENTITY v4l2-frmsizeenum "struct&nbsp;<link linkend='v4l2-frmsizeenum'>v4l2_frmsizeenum</link>">
-<!ENTITY v4l2-hw-freq-seek "struct&nbsp;<link linkend='v4l2-hw-freq-seek'>v4l2_hw_freq_seek</link>">
-<!ENTITY v4l2-input "struct&nbsp;<link linkend='v4l2-input'>v4l2_input</link>">
-<!ENTITY v4l2-jpegcompression "struct&nbsp;<link linkend='v4l2-jpegcompression'>v4l2_jpegcompression</link>">
-<!ENTITY v4l2-mbus-framefmt "struct&nbsp;<link linkend='v4l2-mbus-framefmt'>v4l2_mbus_framefmt</link>">
-<!ENTITY v4l2-modulator "struct&nbsp;<link linkend='v4l2-modulator'>v4l2_modulator</link>">
-<!ENTITY v4l2-mpeg-vbi-fmt-ivtv "struct&nbsp;<link linkend='v4l2-mpeg-vbi-fmt-ivtv'>v4l2_mpeg_vbi_fmt_ivtv</link>">
-<!ENTITY v4l2-output "struct&nbsp;<link linkend='v4l2-output'>v4l2_output</link>">
-<!ENTITY v4l2-outputparm "struct&nbsp;<link linkend='v4l2-outputparm'>v4l2_outputparm</link>">
-<!ENTITY v4l2-pix-format "struct&nbsp;<link linkend='v4l2-pix-format'>v4l2_pix_format</link>">
-<!ENTITY v4l2-pix-format-mplane "struct&nbsp;<link linkend='v4l2-pix-format-mplane'>v4l2_pix_format_mplane</link>">
-<!ENTITY v4l2-plane-pix-format "struct&nbsp;<link linkend='v4l2-plane-pix-format'>v4l2_plane_pix_format</link>">
-<!ENTITY v4l2-queryctrl "struct&nbsp;<link linkend='v4l2-queryctrl'>v4l2_queryctrl</link>">
-<!ENTITY v4l2-querymenu "struct&nbsp;<link linkend='v4l2-querymenu'>v4l2_querymenu</link>">
-<!ENTITY v4l2-rect "struct&nbsp;<link linkend='v4l2-rect'>v4l2_rect</link>">
-<!ENTITY v4l2-requestbuffers "struct&nbsp;<link linkend='v4l2-requestbuffers'>v4l2_requestbuffers</link>">
-<!ENTITY v4l2-sliced-vbi-cap "struct&nbsp;<link linkend='v4l2-sliced-vbi-cap'>v4l2_sliced_vbi_cap</link>">
-<!ENTITY v4l2-sliced-vbi-data "struct&nbsp;<link linkend='v4l2-sliced-vbi-data'>v4l2_sliced_vbi_data</link>">
-<!ENTITY v4l2-sliced-vbi-format "struct&nbsp;<link linkend='v4l2-sliced-vbi-format'>v4l2_sliced_vbi_format</link>">
-<!ENTITY v4l2-subdev-frame-interval "struct&nbsp;<link linkend='v4l2-subdev-frame-interval'>v4l2_subdev_frame_interval</link>">
-<!ENTITY v4l2-subdev-frame-interval-enum "struct&nbsp;<link linkend='v4l2-subdev-frame-interval-enum'>v4l2_subdev_frame_interval_enum</link>">
-<!ENTITY v4l2-subdev-frame-size-enum "struct&nbsp;<link linkend='v4l2-subdev-frame-size-enum'>v4l2_subdev_frame_size_enum</link>">
-<!ENTITY v4l2-subdev-crop "struct&nbsp;<link linkend='v4l2-subdev-crop'>v4l2_subdev_crop</link>">
-<!ENTITY v4l2-subdev-format "struct&nbsp;<link linkend='v4l2-subdev-format'>v4l2_subdev_format</link>">
-<!ENTITY v4l2-subdev-mbus-code-enum "struct&nbsp;<link linkend='v4l2-subdev-mbus-code-enum'>v4l2_subdev_mbus_code_enum</link>">
-<!ENTITY v4l2-standard "struct&nbsp;<link linkend='v4l2-standard'>v4l2_standard</link>">
-<!ENTITY v4l2-streamparm "struct&nbsp;<link linkend='v4l2-streamparm'>v4l2_streamparm</link>">
-<!ENTITY v4l2-timecode "struct&nbsp;<link linkend='v4l2-timecode'>v4l2_timecode</link>">
-<!ENTITY v4l2-tuner "struct&nbsp;<link linkend='v4l2-tuner'>v4l2_tuner</link>">
-<!ENTITY v4l2-vbi-format "struct&nbsp;<link linkend='v4l2-vbi-format'>v4l2_vbi_format</link>">
-<!ENTITY v4l2-window "struct&nbsp;<link linkend='v4l2-window'>v4l2_window</link>">
-
-<!ENTITY media-device-info "struct&nbsp;<link linkend='media-device-info'>media_device_info</link>">
-<!ENTITY media-entity-desc "struct&nbsp;<link linkend='media-entity-desc'>media_entity_desc</link>">
-<!ENTITY media-links-enum "struct&nbsp;<link linkend='media-links-enum'>media_links_enum</link>">
-<!ENTITY media-pad-desc "struct&nbsp;<link linkend='media-pad-desc'>media_pad_desc</link>">
-<!ENTITY media-link-desc "struct&nbsp;<link linkend='media-link-desc'>media_link_desc</link>">
-
-<!-- Error Codes -->
-<!ENTITY EACCES "<errorcode>EACCES</errorcode> error code">
-<!ENTITY EAGAIN "<errorcode>EAGAIN</errorcode> error code">
-<!ENTITY EBADF "<errorcode>EBADF</errorcode> error code">
-<!ENTITY EBUSY "<errorcode>EBUSY</errorcode> error code">
-<!ENTITY EFAULT "<errorcode>EFAULT</errorcode> error code">
-<!ENTITY EIO "<errorcode>EIO</errorcode> error code">
-<!ENTITY EINTR "<errorcode>EINTR</errorcode> error code">
-<!ENTITY EINVAL "<errorcode>EINVAL</errorcode> error code">
-<!ENTITY ENFILE "<errorcode>ENFILE</errorcode> error code">
-<!ENTITY ENOMEM "<errorcode>ENOMEM</errorcode> error code">
-<!ENTITY ENOSPC "<errorcode>ENOSPC</errorcode> error code">
-<!ENTITY ENOTTY "<errorcode>ENOTTY</errorcode> error code">
-<!ENTITY ENXIO "<errorcode>ENXIO</errorcode> error code">
-<!ENTITY EMFILE "<errorcode>EMFILE</errorcode> error code">
-<!ENTITY EPERM "<errorcode>EPERM</errorcode> error code">
-<!ENTITY EPIPE "<errorcode>EPIPE</errorcode> error code">
-<!ENTITY ERANGE "<errorcode>ERANGE</errorcode> error code">
-
-<!-- Subsections -->
-<!ENTITY sub-biblio SYSTEM "v4l/biblio.xml">
-<!ENTITY sub-common SYSTEM "v4l/common.xml">
-<!ENTITY sub-planar-apis SYSTEM "v4l/planar-apis.xml">
-<!ENTITY sub-compat SYSTEM "v4l/compat.xml">
-<!ENTITY sub-controls SYSTEM "v4l/controls.xml">
-<!ENTITY sub-dev-capture SYSTEM "v4l/dev-capture.xml">
-<!ENTITY sub-dev-codec SYSTEM "v4l/dev-codec.xml">
-<!ENTITY sub-dev-event SYSTEM "v4l/dev-event.xml">
-<!ENTITY sub-dev-effect SYSTEM "v4l/dev-effect.xml">
-<!ENTITY sub-dev-osd SYSTEM "v4l/dev-osd.xml">
-<!ENTITY sub-dev-output SYSTEM "v4l/dev-output.xml">
-<!ENTITY sub-dev-overlay SYSTEM "v4l/dev-overlay.xml">
-<!ENTITY sub-dev-radio SYSTEM "v4l/dev-radio.xml">
-<!ENTITY sub-dev-raw-vbi SYSTEM "v4l/dev-raw-vbi.xml">
-<!ENTITY sub-dev-rds SYSTEM "v4l/dev-rds.xml">
-<!ENTITY sub-dev-sliced-vbi SYSTEM "v4l/dev-sliced-vbi.xml">
-<!ENTITY sub-dev-subdev SYSTEM "v4l/dev-subdev.xml">
-<!ENTITY sub-dev-teletext SYSTEM "v4l/dev-teletext.xml">
-<!ENTITY sub-driver SYSTEM "v4l/driver.xml">
-<!ENTITY sub-libv4l SYSTEM "v4l/libv4l.xml">
-<!ENTITY sub-lirc_device_interface SYSTEM "v4l/lirc_device_interface.xml">
-<!ENTITY sub-remote_controllers SYSTEM "v4l/remote_controllers.xml">
-<!ENTITY sub-fdl-appendix SYSTEM "v4l/fdl-appendix.xml">
-<!ENTITY sub-close SYSTEM "v4l/func-close.xml">
-<!ENTITY sub-ioctl SYSTEM "v4l/func-ioctl.xml">
-<!ENTITY sub-mmap SYSTEM "v4l/func-mmap.xml">
-<!ENTITY sub-munmap SYSTEM "v4l/func-munmap.xml">
-<!ENTITY sub-open SYSTEM "v4l/func-open.xml">
-<!ENTITY sub-poll SYSTEM "v4l/func-poll.xml">
-<!ENTITY sub-read SYSTEM "v4l/func-read.xml">
-<!ENTITY sub-select SYSTEM "v4l/func-select.xml">
-<!ENTITY sub-write SYSTEM "v4l/func-write.xml">
-<!ENTITY sub-io SYSTEM "v4l/io.xml">
-<!ENTITY sub-grey SYSTEM "v4l/pixfmt-grey.xml">
-<!ENTITY sub-m420 SYSTEM "v4l/pixfmt-m420.xml">
-<!ENTITY sub-nv12 SYSTEM "v4l/pixfmt-nv12.xml">
-<!ENTITY sub-nv12m SYSTEM "v4l/pixfmt-nv12m.xml">
-<!ENTITY sub-nv12mt SYSTEM "v4l/pixfmt-nv12mt.xml">
-<!ENTITY sub-nv16 SYSTEM "v4l/pixfmt-nv16.xml">
-<!ENTITY sub-packed-rgb SYSTEM "v4l/pixfmt-packed-rgb.xml">
-<!ENTITY sub-packed-yuv SYSTEM "v4l/pixfmt-packed-yuv.xml">
-<!ENTITY sub-sbggr16 SYSTEM "v4l/pixfmt-sbggr16.xml">
-<!ENTITY sub-sbggr8 SYSTEM "v4l/pixfmt-sbggr8.xml">
-<!ENTITY sub-sgbrg8 SYSTEM "v4l/pixfmt-sgbrg8.xml">
-<!ENTITY sub-sgrbg8 SYSTEM "v4l/pixfmt-sgrbg8.xml">
-<!ENTITY sub-uyvy SYSTEM "v4l/pixfmt-uyvy.xml">
-<!ENTITY sub-vyuy SYSTEM "v4l/pixfmt-vyuy.xml">
-<!ENTITY sub-y16 SYSTEM "v4l/pixfmt-y16.xml">
-<!ENTITY sub-y41p SYSTEM "v4l/pixfmt-y41p.xml">
-<!ENTITY sub-yuv410 SYSTEM "v4l/pixfmt-yuv410.xml">
-<!ENTITY sub-yuv411p SYSTEM "v4l/pixfmt-yuv411p.xml">
-<!ENTITY sub-yuv420 SYSTEM "v4l/pixfmt-yuv420.xml">
-<!ENTITY sub-yuv420m SYSTEM "v4l/pixfmt-yuv420m.xml">
-<!ENTITY sub-yuv422p SYSTEM "v4l/pixfmt-yuv422p.xml">
-<!ENTITY sub-yuyv SYSTEM "v4l/pixfmt-yuyv.xml">
-<!ENTITY sub-yvyu SYSTEM "v4l/pixfmt-yvyu.xml">
-<!ENTITY sub-srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
-<!ENTITY sub-srggb12 SYSTEM "v4l/pixfmt-srggb12.xml">
-<!ENTITY sub-srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
-<!ENTITY sub-y10 SYSTEM "v4l/pixfmt-y10.xml">
-<!ENTITY sub-y12 SYSTEM "v4l/pixfmt-y12.xml">
-<!ENTITY sub-y10b SYSTEM "v4l/pixfmt-y10b.xml">
-<!ENTITY sub-pixfmt SYSTEM "v4l/pixfmt.xml">
-<!ENTITY sub-cropcap SYSTEM "v4l/vidioc-cropcap.xml">
-<!ENTITY sub-dbg-g-register SYSTEM "v4l/vidioc-dbg-g-register.xml">
-<!ENTITY sub-encoder-cmd SYSTEM "v4l/vidioc-encoder-cmd.xml">
-<!ENTITY sub-enum-fmt SYSTEM "v4l/vidioc-enum-fmt.xml">
-<!ENTITY sub-enum-frameintervals SYSTEM "v4l/vidioc-enum-frameintervals.xml">
-<!ENTITY sub-enum-framesizes SYSTEM "v4l/vidioc-enum-framesizes.xml">
-<!ENTITY sub-enumaudio SYSTEM "v4l/vidioc-enumaudio.xml">
-<!ENTITY sub-enumaudioout SYSTEM "v4l/vidioc-enumaudioout.xml">
-<!ENTITY sub-enuminput SYSTEM "v4l/vidioc-enuminput.xml">
-<!ENTITY sub-enumoutput SYSTEM "v4l/vidioc-enumoutput.xml">
-<!ENTITY sub-enum-dv-presets SYSTEM "v4l/vidioc-enum-dv-presets.xml">
-<!ENTITY sub-g-dv-preset SYSTEM "v4l/vidioc-g-dv-preset.xml">
-<!ENTITY sub-query-dv-preset SYSTEM "v4l/vidioc-query-dv-preset.xml">
-<!ENTITY sub-g-dv-timings SYSTEM "v4l/vidioc-g-dv-timings.xml">
-<!ENTITY sub-enumstd SYSTEM "v4l/vidioc-enumstd.xml">
-<!ENTITY sub-g-audio SYSTEM "v4l/vidioc-g-audio.xml">
-<!ENTITY sub-g-audioout SYSTEM "v4l/vidioc-g-audioout.xml">
-<!ENTITY sub-dbg-g-chip-ident SYSTEM "v4l/vidioc-dbg-g-chip-ident.xml">
-<!ENTITY sub-g-crop SYSTEM "v4l/vidioc-g-crop.xml">
-<!ENTITY sub-g-ctrl SYSTEM "v4l/vidioc-g-ctrl.xml">
-<!ENTITY sub-g-enc-index SYSTEM "v4l/vidioc-g-enc-index.xml">
-<!ENTITY sub-g-ext-ctrls SYSTEM "v4l/vidioc-g-ext-ctrls.xml">
-<!ENTITY sub-g-fbuf SYSTEM "v4l/vidioc-g-fbuf.xml">
-<!ENTITY sub-g-fmt SYSTEM "v4l/vidioc-g-fmt.xml">
-<!ENTITY sub-g-frequency SYSTEM "v4l/vidioc-g-frequency.xml">
-<!ENTITY sub-g-input SYSTEM "v4l/vidioc-g-input.xml">
-<!ENTITY sub-g-jpegcomp SYSTEM "v4l/vidioc-g-jpegcomp.xml">
-<!ENTITY sub-g-modulator SYSTEM "v4l/vidioc-g-modulator.xml">
-<!ENTITY sub-g-output SYSTEM "v4l/vidioc-g-output.xml">
-<!ENTITY sub-g-parm SYSTEM "v4l/vidioc-g-parm.xml">
-<!ENTITY sub-g-priority SYSTEM "v4l/vidioc-g-priority.xml">
-<!ENTITY sub-g-sliced-vbi-cap SYSTEM "v4l/vidioc-g-sliced-vbi-cap.xml">
-<!ENTITY sub-g-std SYSTEM "v4l/vidioc-g-std.xml">
-<!ENTITY sub-g-tuner SYSTEM "v4l/vidioc-g-tuner.xml">
-<!ENTITY sub-log-status SYSTEM "v4l/vidioc-log-status.xml">
-<!ENTITY sub-overlay SYSTEM "v4l/vidioc-overlay.xml">
-<!ENTITY sub-qbuf SYSTEM "v4l/vidioc-qbuf.xml">
-<!ENTITY sub-querybuf SYSTEM "v4l/vidioc-querybuf.xml">
-<!ENTITY sub-querycap SYSTEM "v4l/vidioc-querycap.xml">
-<!ENTITY sub-queryctrl SYSTEM "v4l/vidioc-queryctrl.xml">
-<!ENTITY sub-querystd SYSTEM "v4l/vidioc-querystd.xml">
-<!ENTITY sub-reqbufs SYSTEM "v4l/vidioc-reqbufs.xml">
-<!ENTITY sub-s-hw-freq-seek SYSTEM "v4l/vidioc-s-hw-freq-seek.xml">
-<!ENTITY sub-streamon SYSTEM "v4l/vidioc-streamon.xml">
-<!ENTITY sub-subdev-enum-frame-interval SYSTEM "v4l/vidioc-subdev-enum-frame-interval.xml">
-<!ENTITY sub-subdev-enum-frame-size SYSTEM "v4l/vidioc-subdev-enum-frame-size.xml">
-<!ENTITY sub-subdev-enum-mbus-code SYSTEM "v4l/vidioc-subdev-enum-mbus-code.xml">
-<!ENTITY sub-subdev-formats SYSTEM "v4l/subdev-formats.xml">
-<!ENTITY sub-subdev-g-crop SYSTEM "v4l/vidioc-subdev-g-crop.xml">
-<!ENTITY sub-subdev-g-fmt SYSTEM "v4l/vidioc-subdev-g-fmt.xml">
-<!ENTITY sub-subdev-g-frame-interval SYSTEM "v4l/vidioc-subdev-g-frame-interval.xml">
-<!ENTITY sub-capture-c SYSTEM "v4l/capture.c.xml">
-<!ENTITY sub-keytable-c SYSTEM "v4l/keytable.c.xml">
-<!ENTITY sub-v4l2grab-c SYSTEM "v4l/v4l2grab.c.xml">
-<!ENTITY sub-videodev2-h SYSTEM "v4l/videodev2.h.xml">
-<!ENTITY sub-v4l2 SYSTEM "v4l/v4l2.xml">
-<!ENTITY sub-dqevent SYSTEM "v4l/vidioc-dqevent.xml">
-<!ENTITY sub-subscribe-event SYSTEM "v4l/vidioc-subscribe-event.xml">
-<!ENTITY sub-intro SYSTEM "dvb/intro.xml">
-<!ENTITY sub-frontend SYSTEM "dvb/frontend.xml">
-<!ENTITY sub-dvbproperty SYSTEM "dvb/dvbproperty.xml">
-<!ENTITY sub-demux SYSTEM "dvb/demux.xml">
-<!ENTITY sub-video SYSTEM "dvb/video.xml">
-<!ENTITY sub-audio SYSTEM "dvb/audio.xml">
-<!ENTITY sub-ca SYSTEM "dvb/ca.xml">
-<!ENTITY sub-net SYSTEM "dvb/net.xml">
-<!ENTITY sub-kdapi SYSTEM "dvb/kdapi.xml">
-<!ENTITY sub-examples SYSTEM "dvb/examples.xml">
-<!ENTITY sub-frontend-h SYSTEM "dvb/frontend.h.xml">
-<!ENTITY sub-dvbapi SYSTEM "dvb/dvbapi.xml">
-<!ENTITY sub-media SYSTEM "media.xml">
-<!ENTITY sub-media-entities SYSTEM "media-entities.tmpl">
-<!ENTITY sub-media-indices SYSTEM "media-indices.tmpl">
-
-<!ENTITY sub-media-controller SYSTEM "v4l/media-controller.xml">
-<!ENTITY sub-media-func-open SYSTEM "v4l/media-func-open.xml">
-<!ENTITY sub-media-func-close SYSTEM "v4l/media-func-close.xml">
-<!ENTITY sub-media-func-ioctl SYSTEM "v4l/media-func-ioctl.xml">
-<!ENTITY sub-media-ioc-device-info SYSTEM "v4l/media-ioc-device-info.xml">
-<!ENTITY sub-media-ioc-enum-entities SYSTEM "v4l/media-ioc-enum-entities.xml">
-<!ENTITY sub-media-ioc-enum-links SYSTEM "v4l/media-ioc-enum-links.xml">
-<!ENTITY sub-media-ioc-setup-link SYSTEM "v4l/media-ioc-setup-link.xml">
-
-<!-- Function Reference -->
-<!ENTITY close SYSTEM "v4l/func-close.xml">
-<!ENTITY ioctl SYSTEM "v4l/func-ioctl.xml">
-<!ENTITY mmap SYSTEM "v4l/func-mmap.xml">
-<!ENTITY munmap SYSTEM "v4l/func-munmap.xml">
-<!ENTITY open SYSTEM "v4l/func-open.xml">
-<!ENTITY poll SYSTEM "v4l/func-poll.xml">
-<!ENTITY read SYSTEM "v4l/func-read.xml">
-<!ENTITY select SYSTEM "v4l/func-select.xml">
-<!ENTITY write SYSTEM "v4l/func-write.xml">
-<!ENTITY grey SYSTEM "v4l/pixfmt-grey.xml">
-<!ENTITY nv12 SYSTEM "v4l/pixfmt-nv12.xml">
-<!ENTITY nv12m SYSTEM "v4l/pixfmt-nv12m.xml">
-<!ENTITY nv16 SYSTEM "v4l/pixfmt-nv16.xml">
-<!ENTITY packed-rgb SYSTEM "v4l/pixfmt-packed-rgb.xml">
-<!ENTITY packed-yuv SYSTEM "v4l/pixfmt-packed-yuv.xml">
-<!ENTITY sbggr16 SYSTEM "v4l/pixfmt-sbggr16.xml">
-<!ENTITY sbggr8 SYSTEM "v4l/pixfmt-sbggr8.xml">
-<!ENTITY sgbrg8 SYSTEM "v4l/pixfmt-sgbrg8.xml">
-<!ENTITY sgrbg8 SYSTEM "v4l/pixfmt-sgrbg8.xml">
-<!ENTITY uyvy SYSTEM "v4l/pixfmt-uyvy.xml">
-<!ENTITY vyuy SYSTEM "v4l/pixfmt-vyuy.xml">
-<!ENTITY y16 SYSTEM "v4l/pixfmt-y16.xml">
-<!ENTITY y41p SYSTEM "v4l/pixfmt-y41p.xml">
-<!ENTITY yuv410 SYSTEM "v4l/pixfmt-yuv410.xml">
-<!ENTITY yuv411p SYSTEM "v4l/pixfmt-yuv411p.xml">
-<!ENTITY yuv420 SYSTEM "v4l/pixfmt-yuv420.xml">
-<!ENTITY yuv420m SYSTEM "v4l/pixfmt-yuv420m.xml">
-<!ENTITY yuv422p SYSTEM "v4l/pixfmt-yuv422p.xml">
-<!ENTITY yuyv SYSTEM "v4l/pixfmt-yuyv.xml">
-<!ENTITY yvyu SYSTEM "v4l/pixfmt-yvyu.xml">
-<!ENTITY srggb10 SYSTEM "v4l/pixfmt-srggb10.xml">
-<!ENTITY srggb8 SYSTEM "v4l/pixfmt-srggb8.xml">
-<!ENTITY y10 SYSTEM "v4l/pixfmt-y10.xml">
-<!ENTITY cropcap SYSTEM "v4l/vidioc-cropcap.xml">
-<!ENTITY dbg-g-register SYSTEM "v4l/vidioc-dbg-g-register.xml">
-<!ENTITY encoder-cmd SYSTEM "v4l/vidioc-encoder-cmd.xml">
-<!ENTITY enum-fmt SYSTEM "v4l/vidioc-enum-fmt.xml">
-<!ENTITY enum-frameintervals SYSTEM "v4l/vidioc-enum-frameintervals.xml">
-<!ENTITY enum-framesizes SYSTEM "v4l/vidioc-enum-framesizes.xml">
-<!ENTITY enumaudio SYSTEM "v4l/vidioc-enumaudio.xml">
-<!ENTITY enumaudioout SYSTEM "v4l/vidioc-enumaudioout.xml">
-<!ENTITY enuminput SYSTEM "v4l/vidioc-enuminput.xml">
-<!ENTITY enumoutput SYSTEM "v4l/vidioc-enumoutput.xml">
-<!ENTITY enum-dv-presets SYSTEM "v4l/vidioc-enum-dv-presets.xml">
-<!ENTITY g-dv-preset SYSTEM "v4l/vidioc-g-dv-preset.xml">
-<!ENTITY query-dv-preset SYSTEM "v4l/vidioc-query-dv-preset.xml">
-<!ENTITY g-dv-timings SYSTEM "v4l/vidioc-g-dv-timings.xml">
-<!ENTITY enumstd SYSTEM "v4l/vidioc-enumstd.xml">
-<!ENTITY g-audio SYSTEM "v4l/vidioc-g-audio.xml">
-<!ENTITY g-audioout SYSTEM "v4l/vidioc-g-audioout.xml">
-<!ENTITY dbg-g-chip-ident SYSTEM "v4l/vidioc-dbg-g-chip-ident.xml">
-<!ENTITY g-crop SYSTEM "v4l/vidioc-g-crop.xml">
-<!ENTITY g-ctrl SYSTEM "v4l/vidioc-g-ctrl.xml">
-<!ENTITY g-enc-index SYSTEM "v4l/vidioc-g-enc-index.xml">
-<!ENTITY g-ext-ctrls SYSTEM "v4l/vidioc-g-ext-ctrls.xml">
-<!ENTITY g-fbuf SYSTEM "v4l/vidioc-g-fbuf.xml">
-<!ENTITY g-fmt SYSTEM "v4l/vidioc-g-fmt.xml">
-<!ENTITY g-frequency SYSTEM "v4l/vidioc-g-frequency.xml">
-<!ENTITY g-input SYSTEM "v4l/vidioc-g-input.xml">
-<!ENTITY g-jpegcomp SYSTEM "v4l/vidioc-g-jpegcomp.xml">
-<!ENTITY g-modulator SYSTEM "v4l/vidioc-g-modulator.xml">
-<!ENTITY g-output SYSTEM "v4l/vidioc-g-output.xml">
-<!ENTITY g-parm SYSTEM "v4l/vidioc-g-parm.xml">
-<!ENTITY g-priority SYSTEM "v4l/vidioc-g-priority.xml">
-<!ENTITY g-sliced-vbi-cap SYSTEM "v4l/vidioc-g-sliced-vbi-cap.xml">
-<!ENTITY g-std SYSTEM "v4l/vidioc-g-std.xml">
-<!ENTITY g-tuner SYSTEM "v4l/vidioc-g-tuner.xml">
-<!ENTITY log-status SYSTEM "v4l/vidioc-log-status.xml">
-<!ENTITY overlay SYSTEM "v4l/vidioc-overlay.xml">
-<!ENTITY qbuf SYSTEM "v4l/vidioc-qbuf.xml">
-<!ENTITY querybuf SYSTEM "v4l/vidioc-querybuf.xml">
-<!ENTITY querycap SYSTEM "v4l/vidioc-querycap.xml">
-<!ENTITY queryctrl SYSTEM "v4l/vidioc-queryctrl.xml">
-<!ENTITY querystd SYSTEM "v4l/vidioc-querystd.xml">
-<!ENTITY reqbufs SYSTEM "v4l/vidioc-reqbufs.xml">
-<!ENTITY s-hw-freq-seek SYSTEM "v4l/vidioc-s-hw-freq-seek.xml">
-<!ENTITY streamon SYSTEM "v4l/vidioc-streamon.xml">
-<!ENTITY dqevent SYSTEM "v4l/vidioc-dqevent.xml">
-<!ENTITY subscribe_event SYSTEM "v4l/vidioc-subscribe-event.xml">
diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
new file mode 100644
index 0000000..baeea17
--- /dev/null
+++ b/Documentation/DocBook/media/Makefile
@@ -0,0 +1,259 @@
+###
+# Media build rules - Auto-generates media contents/indexes and *.h xml's
+#
+
+SHELL=/bin/bash
+
+MEDIA_OBJ_DIR=$(objtree)/Documentation/DocBook/
+MEDIA_SRC_DIR=$(srctree)/Documentation/DocBook/media
+
+MEDIA_TEMP =  media-entities.tmpl \
+	      media-indices.tmpl \
+	      videodev2.h.xml \
+	      v4l2.xml \
+	      frontend.h.xml
+
+IMGFILES := $(addprefix $(MEDIA_OBJ_DIR)/media/, $(notdir $(shell ls $(MEDIA_SRC_DIR)/*/*.gif $(MEDIA_SRC_DIR)/*/*.png)))
+GENFILES := $(addprefix $(MEDIA_OBJ_DIR)/, $(MEDIA_TEMP))
+
+PHONY += cleanmediadocs mediaindexdocs
+
+cleanmediadocs:
+	-@rm `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(IMGFILES)
+
+$(obj)/media_api.xml: $(GENFILES) FORCE
+
+#$(MEDIA_OBJ_DIR)/media_api.html: $(MEDIA_OBJ_DIR)/media_api.xml
+#$(MEDIA_OBJ_DIR)/media_api.pdf: $(MEDIA_OBJ_DIR)/media_api.xml
+#$(MEDIA_OBJ_DIR)/media_api.ps: $(MEDIA_OBJ_DIR)/media_api.xml
+
+V4L_SGMLS = \
+	$(shell ls $(MEDIA_SRC_DIR)/v4l/*.xml|perl -ne 'print "$$1 " if (m,.*/(.*)\n,)') \
+	capture.c.xml \
+	keytable.c.xml \
+	v4l2grab.c.xml
+
+DVB_SGMLS = \
+	$(shell ls $(MEDIA_SRC_DIR)/dvb/*.xml|perl -ne 'print "$$1 " if (m,.*/(.*)\n,)')
+
+MEDIA_SGMLS =  $(addprefix ./,$(V4L_SGMLS)) $(addprefix ./,$(DVB_SGMLS)) $(addprefix ./,$(MEDIA_TEMP))
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
+$(MEDIA_OBJ_DIR)/v4l2.xml:
+	@$($(quiet)gen_xml)
+	@(mkdir -p $(MEDIA_OBJ_DIR)/media)
+	@(cp $(MEDIA_SRC_DIR)/dvb/*.png $(MEDIA_SRC_DIR)/v4l/*.gif $(MEDIA_OBJ_DIR)/media/)
+	@(ln -sf $(MEDIA_SRC_DIR)/v4l/*xml $(MEDIA_OBJ_DIR)/)
+	@(ln -sf $(MEDIA_SRC_DIR)/dvb/*xml $(MEDIA_OBJ_DIR)/)
+
+$(MEDIA_OBJ_DIR)/videodev2.h.xml: $(srctree)/include/linux/videodev2.h $(MEDIA_OBJ_DIR)/v4l2.xml
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
+$(MEDIA_OBJ_DIR)/frontend.h.xml: $(srctree)/include/linux/dvb/frontend.h $(MEDIA_OBJ_DIR)/v4l2.xml
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
+$(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
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
+	  id=`grep "<refname>$$ident" $(MEDIA_OBJ_DIR)/vidioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
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
+$(MEDIA_OBJ_DIR)/media-indices.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
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
+
diff --git a/Documentation/DocBook/dvb/.gitignore b/Documentation/DocBook/media/dvb/.gitignore
similarity index 100%
rename from Documentation/DocBook/dvb/.gitignore
rename to Documentation/DocBook/media/dvb/.gitignore
diff --git a/Documentation/DocBook/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
similarity index 100%
rename from Documentation/DocBook/dvb/audio.xml
rename to Documentation/DocBook/media/dvb/audio.xml
diff --git a/Documentation/DocBook/dvb/ca.xml b/Documentation/DocBook/media/dvb/ca.xml
similarity index 100%
rename from Documentation/DocBook/dvb/ca.xml
rename to Documentation/DocBook/media/dvb/ca.xml
diff --git a/Documentation/DocBook/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
similarity index 100%
rename from Documentation/DocBook/dvb/demux.xml
rename to Documentation/DocBook/media/dvb/demux.xml
diff --git a/Documentation/DocBook/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
similarity index 100%
rename from Documentation/DocBook/dvb/dvbapi.xml
rename to Documentation/DocBook/media/dvb/dvbapi.xml
diff --git a/Documentation/DocBook/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
similarity index 100%
rename from Documentation/DocBook/dvb/dvbproperty.xml
rename to Documentation/DocBook/media/dvb/dvbproperty.xml
diff --git a/Documentation/DocBook/dvb/examples.xml b/Documentation/DocBook/media/dvb/examples.xml
similarity index 100%
rename from Documentation/DocBook/dvb/examples.xml
rename to Documentation/DocBook/media/dvb/examples.xml
diff --git a/Documentation/DocBook/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
similarity index 100%
rename from Documentation/DocBook/dvb/frontend.xml
rename to Documentation/DocBook/media/dvb/frontend.xml
diff --git a/Documentation/DocBook/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
similarity index 100%
rename from Documentation/DocBook/dvb/intro.xml
rename to Documentation/DocBook/media/dvb/intro.xml
diff --git a/Documentation/DocBook/dvb/kdapi.xml b/Documentation/DocBook/media/dvb/kdapi.xml
similarity index 100%
rename from Documentation/DocBook/dvb/kdapi.xml
rename to Documentation/DocBook/media/dvb/kdapi.xml
diff --git a/Documentation/DocBook/dvb/net.xml b/Documentation/DocBook/media/dvb/net.xml
similarity index 100%
rename from Documentation/DocBook/dvb/net.xml
rename to Documentation/DocBook/media/dvb/net.xml
diff --git a/Documentation/DocBook/dvb/video.xml b/Documentation/DocBook/media/dvb/video.xml
similarity index 100%
rename from Documentation/DocBook/dvb/video.xml
rename to Documentation/DocBook/media/dvb/video.xml
diff --git a/Documentation/DocBook/v4l/.gitignore b/Documentation/DocBook/media/v4l/.gitignore
similarity index 100%
rename from Documentation/DocBook/v4l/.gitignore
rename to Documentation/DocBook/media/v4l/.gitignore
diff --git a/Documentation/DocBook/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
similarity index 100%
rename from Documentation/DocBook/v4l/biblio.xml
rename to Documentation/DocBook/media/v4l/biblio.xml
diff --git a/Documentation/DocBook/v4l/capture.c.xml b/Documentation/DocBook/media/v4l/capture.c.xml
similarity index 100%
rename from Documentation/DocBook/v4l/capture.c.xml
rename to Documentation/DocBook/media/v4l/capture.c.xml
diff --git a/Documentation/DocBook/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
similarity index 100%
rename from Documentation/DocBook/v4l/common.xml
rename to Documentation/DocBook/media/v4l/common.xml
diff --git a/Documentation/DocBook/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
similarity index 100%
rename from Documentation/DocBook/v4l/compat.xml
rename to Documentation/DocBook/media/v4l/compat.xml
diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
similarity index 100%
rename from Documentation/DocBook/v4l/controls.xml
rename to Documentation/DocBook/media/v4l/controls.xml
diff --git a/Documentation/DocBook/v4l/dev-capture.xml b/Documentation/DocBook/media/v4l/dev-capture.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-capture.xml
rename to Documentation/DocBook/media/v4l/dev-capture.xml
diff --git a/Documentation/DocBook/v4l/dev-codec.xml b/Documentation/DocBook/media/v4l/dev-codec.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-codec.xml
rename to Documentation/DocBook/media/v4l/dev-codec.xml
diff --git a/Documentation/DocBook/v4l/dev-effect.xml b/Documentation/DocBook/media/v4l/dev-effect.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-effect.xml
rename to Documentation/DocBook/media/v4l/dev-effect.xml
diff --git a/Documentation/DocBook/v4l/dev-event.xml b/Documentation/DocBook/media/v4l/dev-event.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-event.xml
rename to Documentation/DocBook/media/v4l/dev-event.xml
diff --git a/Documentation/DocBook/v4l/dev-osd.xml b/Documentation/DocBook/media/v4l/dev-osd.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-osd.xml
rename to Documentation/DocBook/media/v4l/dev-osd.xml
diff --git a/Documentation/DocBook/v4l/dev-output.xml b/Documentation/DocBook/media/v4l/dev-output.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-output.xml
rename to Documentation/DocBook/media/v4l/dev-output.xml
diff --git a/Documentation/DocBook/v4l/dev-overlay.xml b/Documentation/DocBook/media/v4l/dev-overlay.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-overlay.xml
rename to Documentation/DocBook/media/v4l/dev-overlay.xml
diff --git a/Documentation/DocBook/v4l/dev-radio.xml b/Documentation/DocBook/media/v4l/dev-radio.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-radio.xml
rename to Documentation/DocBook/media/v4l/dev-radio.xml
diff --git a/Documentation/DocBook/v4l/dev-raw-vbi.xml b/Documentation/DocBook/media/v4l/dev-raw-vbi.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-raw-vbi.xml
rename to Documentation/DocBook/media/v4l/dev-raw-vbi.xml
diff --git a/Documentation/DocBook/v4l/dev-rds.xml b/Documentation/DocBook/media/v4l/dev-rds.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-rds.xml
rename to Documentation/DocBook/media/v4l/dev-rds.xml
diff --git a/Documentation/DocBook/v4l/dev-sliced-vbi.xml b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-sliced-vbi.xml
rename to Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
diff --git a/Documentation/DocBook/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-subdev.xml
rename to Documentation/DocBook/media/v4l/dev-subdev.xml
diff --git a/Documentation/DocBook/v4l/dev-teletext.xml b/Documentation/DocBook/media/v4l/dev-teletext.xml
similarity index 100%
rename from Documentation/DocBook/v4l/dev-teletext.xml
rename to Documentation/DocBook/media/v4l/dev-teletext.xml
diff --git a/Documentation/DocBook/v4l/driver.xml b/Documentation/DocBook/media/v4l/driver.xml
similarity index 100%
rename from Documentation/DocBook/v4l/driver.xml
rename to Documentation/DocBook/media/v4l/driver.xml
diff --git a/Documentation/DocBook/v4l/fdl-appendix.xml b/Documentation/DocBook/media/v4l/fdl-appendix.xml
similarity index 100%
rename from Documentation/DocBook/v4l/fdl-appendix.xml
rename to Documentation/DocBook/media/v4l/fdl-appendix.xml
diff --git a/Documentation/DocBook/v4l/func-close.xml b/Documentation/DocBook/media/v4l/func-close.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-close.xml
rename to Documentation/DocBook/media/v4l/func-close.xml
diff --git a/Documentation/DocBook/v4l/func-ioctl.xml b/Documentation/DocBook/media/v4l/func-ioctl.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-ioctl.xml
rename to Documentation/DocBook/media/v4l/func-ioctl.xml
diff --git a/Documentation/DocBook/v4l/func-mmap.xml b/Documentation/DocBook/media/v4l/func-mmap.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-mmap.xml
rename to Documentation/DocBook/media/v4l/func-mmap.xml
diff --git a/Documentation/DocBook/v4l/func-munmap.xml b/Documentation/DocBook/media/v4l/func-munmap.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-munmap.xml
rename to Documentation/DocBook/media/v4l/func-munmap.xml
diff --git a/Documentation/DocBook/v4l/func-open.xml b/Documentation/DocBook/media/v4l/func-open.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-open.xml
rename to Documentation/DocBook/media/v4l/func-open.xml
diff --git a/Documentation/DocBook/v4l/func-poll.xml b/Documentation/DocBook/media/v4l/func-poll.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-poll.xml
rename to Documentation/DocBook/media/v4l/func-poll.xml
diff --git a/Documentation/DocBook/v4l/func-read.xml b/Documentation/DocBook/media/v4l/func-read.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-read.xml
rename to Documentation/DocBook/media/v4l/func-read.xml
diff --git a/Documentation/DocBook/v4l/func-select.xml b/Documentation/DocBook/media/v4l/func-select.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-select.xml
rename to Documentation/DocBook/media/v4l/func-select.xml
diff --git a/Documentation/DocBook/v4l/func-write.xml b/Documentation/DocBook/media/v4l/func-write.xml
similarity index 100%
rename from Documentation/DocBook/v4l/func-write.xml
rename to Documentation/DocBook/media/v4l/func-write.xml
diff --git a/Documentation/DocBook/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
similarity index 100%
rename from Documentation/DocBook/v4l/io.xml
rename to Documentation/DocBook/media/v4l/io.xml
diff --git a/Documentation/DocBook/v4l/keytable.c.xml b/Documentation/DocBook/media/v4l/keytable.c.xml
similarity index 100%
rename from Documentation/DocBook/v4l/keytable.c.xml
rename to Documentation/DocBook/media/v4l/keytable.c.xml
diff --git a/Documentation/DocBook/v4l/libv4l.xml b/Documentation/DocBook/media/v4l/libv4l.xml
similarity index 100%
rename from Documentation/DocBook/v4l/libv4l.xml
rename to Documentation/DocBook/media/v4l/libv4l.xml
diff --git a/Documentation/DocBook/v4l/lirc_device_interface.xml b/Documentation/DocBook/media/v4l/lirc_device_interface.xml
similarity index 100%
rename from Documentation/DocBook/v4l/lirc_device_interface.xml
rename to Documentation/DocBook/media/v4l/lirc_device_interface.xml
diff --git a/Documentation/DocBook/v4l/media-controller.xml b/Documentation/DocBook/media/v4l/media-controller.xml
similarity index 100%
rename from Documentation/DocBook/v4l/media-controller.xml
rename to Documentation/DocBook/media/v4l/media-controller.xml
diff --git a/Documentation/DocBook/v4l/media-func-close.xml b/Documentation/DocBook/media/v4l/media-func-close.xml
similarity index 100%
rename from Documentation/DocBook/v4l/media-func-close.xml
rename to Documentation/DocBook/media/v4l/media-func-close.xml
diff --git a/Documentation/DocBook/v4l/media-func-ioctl.xml b/Documentation/DocBook/media/v4l/media-func-ioctl.xml
similarity index 100%
rename from Documentation/DocBook/v4l/media-func-ioctl.xml
rename to Documentation/DocBook/media/v4l/media-func-ioctl.xml
diff --git a/Documentation/DocBook/v4l/media-func-open.xml b/Documentation/DocBook/media/v4l/media-func-open.xml
similarity index 100%
rename from Documentation/DocBook/v4l/media-func-open.xml
rename to Documentation/DocBook/media/v4l/media-func-open.xml
diff --git a/Documentation/DocBook/v4l/media-ioc-device-info.xml b/Documentation/DocBook/media/v4l/media-ioc-device-info.xml
similarity index 100%
rename from Documentation/DocBook/v4l/media-ioc-device-info.xml
rename to Documentation/DocBook/media/v4l/media-ioc-device-info.xml
diff --git a/Documentation/DocBook/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
similarity index 100%
rename from Documentation/DocBook/v4l/media-ioc-enum-entities.xml
rename to Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
diff --git a/Documentation/DocBook/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
similarity index 100%
rename from Documentation/DocBook/v4l/media-ioc-enum-links.xml
rename to Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
diff --git a/Documentation/DocBook/v4l/media-ioc-setup-link.xml b/Documentation/DocBook/media/v4l/media-ioc-setup-link.xml
similarity index 100%
rename from Documentation/DocBook/v4l/media-ioc-setup-link.xml
rename to Documentation/DocBook/media/v4l/media-ioc-setup-link.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-grey.xml b/Documentation/DocBook/media/v4l/pixfmt-grey.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-grey.xml
rename to Documentation/DocBook/media/v4l/pixfmt-grey.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-m420.xml b/Documentation/DocBook/media/v4l/pixfmt-m420.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-m420.xml
rename to Documentation/DocBook/media/v4l/pixfmt-m420.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-nv12.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-nv12.xml
rename to Documentation/DocBook/media/v4l/pixfmt-nv12.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-nv12m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-nv12m.xml
rename to Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-nv12mt.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-nv12mt.xml
rename to Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-nv16.xml b/Documentation/DocBook/media/v4l/pixfmt-nv16.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-nv16.xml
rename to Documentation/DocBook/media/v4l/pixfmt-nv16.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-packed-rgb.xml
rename to Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-packed-yuv.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-packed-yuv.xml
rename to Documentation/DocBook/media/v4l/pixfmt-packed-yuv.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-sbggr16.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-sbggr16.xml
rename to Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-sbggr8.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-sbggr8.xml
rename to Documentation/DocBook/media/v4l/pixfmt-sbggr8.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-sgbrg8.xml b/Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-sgbrg8.xml
rename to Documentation/DocBook/media/v4l/pixfmt-sgbrg8.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-sgrbg8.xml b/Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-sgrbg8.xml
rename to Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-srggb10.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-srggb10.xml
rename to Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-srggb12.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-srggb12.xml
rename to Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-srggb8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb8.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-srggb8.xml
rename to Documentation/DocBook/media/v4l/pixfmt-srggb8.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-uyvy.xml b/Documentation/DocBook/media/v4l/pixfmt-uyvy.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-uyvy.xml
rename to Documentation/DocBook/media/v4l/pixfmt-uyvy.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-vyuy.xml b/Documentation/DocBook/media/v4l/pixfmt-vyuy.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-vyuy.xml
rename to Documentation/DocBook/media/v4l/pixfmt-vyuy.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-y10.xml b/Documentation/DocBook/media/v4l/pixfmt-y10.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-y10.xml
rename to Documentation/DocBook/media/v4l/pixfmt-y10.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-y10b.xml b/Documentation/DocBook/media/v4l/pixfmt-y10b.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-y10b.xml
rename to Documentation/DocBook/media/v4l/pixfmt-y10b.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-y12.xml b/Documentation/DocBook/media/v4l/pixfmt-y12.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-y12.xml
rename to Documentation/DocBook/media/v4l/pixfmt-y12.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-y16.xml b/Documentation/DocBook/media/v4l/pixfmt-y16.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-y16.xml
rename to Documentation/DocBook/media/v4l/pixfmt-y16.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-y41p.xml b/Documentation/DocBook/media/v4l/pixfmt-y41p.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-y41p.xml
rename to Documentation/DocBook/media/v4l/pixfmt-y41p.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-yuv410.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv410.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-yuv410.xml
rename to Documentation/DocBook/media/v4l/pixfmt-yuv410.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-yuv411p.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-yuv411p.xml
rename to Documentation/DocBook/media/v4l/pixfmt-yuv411p.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-yuv420.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-yuv420.xml
rename to Documentation/DocBook/media/v4l/pixfmt-yuv420.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-yuv420m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-yuv420m.xml
rename to Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-yuv422p.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-yuv422p.xml
rename to Documentation/DocBook/media/v4l/pixfmt-yuv422p.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-yuyv.xml b/Documentation/DocBook/media/v4l/pixfmt-yuyv.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-yuyv.xml
rename to Documentation/DocBook/media/v4l/pixfmt-yuyv.xml
diff --git a/Documentation/DocBook/v4l/pixfmt-yvyu.xml b/Documentation/DocBook/media/v4l/pixfmt-yvyu.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt-yvyu.xml
rename to Documentation/DocBook/media/v4l/pixfmt-yvyu.xml
diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
similarity index 100%
rename from Documentation/DocBook/v4l/pixfmt.xml
rename to Documentation/DocBook/media/v4l/pixfmt.xml
diff --git a/Documentation/DocBook/v4l/planar-apis.xml b/Documentation/DocBook/media/v4l/planar-apis.xml
similarity index 100%
rename from Documentation/DocBook/v4l/planar-apis.xml
rename to Documentation/DocBook/media/v4l/planar-apis.xml
diff --git a/Documentation/DocBook/v4l/remote_controllers.xml b/Documentation/DocBook/media/v4l/remote_controllers.xml
similarity index 100%
rename from Documentation/DocBook/v4l/remote_controllers.xml
rename to Documentation/DocBook/media/v4l/remote_controllers.xml
diff --git a/Documentation/DocBook/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
similarity index 100%
rename from Documentation/DocBook/v4l/subdev-formats.xml
rename to Documentation/DocBook/media/v4l/subdev-formats.xml
diff --git a/Documentation/DocBook/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
similarity index 100%
rename from Documentation/DocBook/v4l/v4l2.xml
rename to Documentation/DocBook/media/v4l/v4l2.xml
diff --git a/Documentation/DocBook/v4l/v4l2grab.c.xml b/Documentation/DocBook/media/v4l/v4l2grab.c.xml
similarity index 100%
rename from Documentation/DocBook/v4l/v4l2grab.c.xml
rename to Documentation/DocBook/media/v4l/v4l2grab.c.xml
diff --git a/Documentation/DocBook/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-cropcap.xml
rename to Documentation/DocBook/media/v4l/vidioc-cropcap.xml
diff --git a/Documentation/DocBook/v4l/vidioc-dbg-g-chip-ident.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-dbg-g-chip-ident.xml
rename to Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml
diff --git a/Documentation/DocBook/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-dbg-g-register.xml
rename to Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
diff --git a/Documentation/DocBook/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-dqevent.xml
rename to Documentation/DocBook/media/v4l/vidioc-dqevent.xml
diff --git a/Documentation/DocBook/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-encoder-cmd.xml
rename to Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enum-dv-presets.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enum-dv-presets.xml
rename to Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enum-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enum-fmt.xml
rename to Documentation/DocBook/media/v4l/vidioc-enum-fmt.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enum-frameintervals.xml b/Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enum-frameintervals.xml
rename to Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enum-framesizes.xml b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enum-framesizes.xml
rename to Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enumaudio.xml b/Documentation/DocBook/media/v4l/vidioc-enumaudio.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enumaudio.xml
rename to Documentation/DocBook/media/v4l/vidioc-enumaudio.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enumaudioout.xml b/Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enumaudioout.xml
rename to Documentation/DocBook/media/v4l/vidioc-enumaudioout.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enuminput.xml
rename to Documentation/DocBook/media/v4l/vidioc-enuminput.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enumoutput.xml b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enumoutput.xml
rename to Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
diff --git a/Documentation/DocBook/v4l/vidioc-enumstd.xml b/Documentation/DocBook/media/v4l/vidioc-enumstd.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-enumstd.xml
rename to Documentation/DocBook/media/v4l/vidioc-enumstd.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-audio.xml b/Documentation/DocBook/media/v4l/vidioc-g-audio.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-audio.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-audio.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-audioout.xml b/Documentation/DocBook/media/v4l/vidioc-g-audioout.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-audioout.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-audioout.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-crop.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-crop.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-ctrl.xml b/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-ctrl.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-dv-preset.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-dv-timings.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-enc-index.xml b/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-enc-index.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-fbuf.xml b/Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-fbuf.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-fmt.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-frequency.xml b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-frequency.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-input.xml b/Documentation/DocBook/media/v4l/vidioc-g-input.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-input.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-input.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-jpegcomp.xml b/Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-jpegcomp.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-jpegcomp.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-modulator.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-output.xml b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-output.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-output.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-parm.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-parm.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-priority.xml b/Documentation/DocBook/media/v4l/vidioc-g-priority.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-priority.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-priority.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-sliced-vbi-cap.xml b/Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-sliced-vbi-cap.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-std.xml b/Documentation/DocBook/media/v4l/vidioc-g-std.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-std.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-std.xml
diff --git a/Documentation/DocBook/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-g-tuner.xml
rename to Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
diff --git a/Documentation/DocBook/v4l/vidioc-log-status.xml b/Documentation/DocBook/media/v4l/vidioc-log-status.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-log-status.xml
rename to Documentation/DocBook/media/v4l/vidioc-log-status.xml
diff --git a/Documentation/DocBook/v4l/vidioc-overlay.xml b/Documentation/DocBook/media/v4l/vidioc-overlay.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-overlay.xml
rename to Documentation/DocBook/media/v4l/vidioc-overlay.xml
diff --git a/Documentation/DocBook/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-qbuf.xml
rename to Documentation/DocBook/media/v4l/vidioc-qbuf.xml
diff --git a/Documentation/DocBook/v4l/vidioc-query-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-query-dv-preset.xml
rename to Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
diff --git a/Documentation/DocBook/v4l/vidioc-querybuf.xml b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-querybuf.xml
rename to Documentation/DocBook/media/v4l/vidioc-querybuf.xml
diff --git a/Documentation/DocBook/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-querycap.xml
rename to Documentation/DocBook/media/v4l/vidioc-querycap.xml
diff --git a/Documentation/DocBook/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-queryctrl.xml
rename to Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
diff --git a/Documentation/DocBook/v4l/vidioc-querystd.xml b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-querystd.xml
rename to Documentation/DocBook/media/v4l/vidioc-querystd.xml
diff --git a/Documentation/DocBook/v4l/vidioc-reqbufs.xml b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-reqbufs.xml
rename to Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
diff --git a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
rename to Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-streamon.xml
rename to Documentation/DocBook/media/v4l/vidioc-streamon.xml
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml
rename to Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
rename to Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
rename to Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml
rename to Documentation/DocBook/media/v4l/vidioc-subdev-g-crop.xml
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
rename to Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml
rename to Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml
diff --git a/Documentation/DocBook/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
similarity index 100%
rename from Documentation/DocBook/v4l/vidioc-subscribe-event.xml
rename to Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
diff --git a/Documentation/DocBook/media.tmpl b/Documentation/DocBook/media_api.tmpl
similarity index 100%
rename from Documentation/DocBook/media.tmpl
rename to Documentation/DocBook/media_api.tmpl
