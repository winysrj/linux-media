Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZHOThc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 15:37:32 -0400
Received: from 189-46-174-98.dsl.telesp.net.br ([189.46.174.98] helo=caramujo.chehab.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1McP4F-00067J-8N
	for linux-media@vger.kernel.org; Sat, 15 Aug 2009 19:37:33 +0000
Date: Sat, 15 Aug 2009 16:37:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] Document libv4l at V4L2 API specs
Message-ID: <20090815163726.5f4bae41@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since applications aren't prepared to handle all V4L2 available formats,
an effort is done to have a library capable of understanding especially
the proprietary formats.

This patch documents this library, and adds v4l2grab.c as an example on
how to use it.

Parts of the text are based at the libv4l README file (c) by Hans de Goede.

Thanks to Hans de Goede <hdegoede@redhat.com> for his good work with libv4l.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff -r ee300d3178c4 .hgignore
--- a/.hgignore	Fri Aug 14 01:48:42 2009 -0300
+++ b/.hgignore	Sat Aug 15 16:32:08 2009 -0300
@@ -66,6 +66,8 @@
 v4l2-spec/entities.sgml$
 v4l2-spec/.*\.stamp$
 v4l2-spec/indices.sgml$
+v4l2-spec/libv4l-fmt.sgml$
+v4l2-spec/v4l2grab.c.sgml$
 v4l2-spec/v4l2-single$
 v4l2-spec/v4l2$
 v4l2-spec/v4l2.pdf$
diff -r ee300d3178c4 v4l2-apps/test/v4l2grab.c
--- a/v4l2-apps/test/v4l2grab.c	Fri Aug 14 01:48:42 2009 -0300
+++ b/v4l2-apps/test/v4l2grab.c	Sat Aug 15 16:32:08 2009 -0300
@@ -1,5 +1,5 @@
 /* V4L2 video picture grabber
-   Copyright (C) 2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+   Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@infradead.org>
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
diff -r ee300d3178c4 v4l2-spec/Makefile
--- a/v4l2-spec/Makefile	Fri Aug 14 01:48:42 2009 -0300
+++ b/v4l2-spec/Makefile	Sat Aug 15 16:32:08 2009 -0300
@@ -5,6 +5,7 @@
 SGMLS = \
 	biblio.sgml \
 	capture.c.sgml \
+	v4l2grab.c.sgml \
 	common.sgml \
 	compat.sgml \
 	controls.sgml \
@@ -20,6 +21,7 @@
 	dev-sliced-vbi.sgml \
 	dev-teletext.sgml \
 	driver.sgml \
+	libv4l.sgml \
 	entities.sgml \
 	fdl-appendix.sgml \
 	func-close.sgml \
@@ -323,6 +325,12 @@
 	-e "s/\(V4L2_PIX_FMT_[A-Z0-9_]\+\) /<link linkend=\"\1\">\1<\/link> /g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta"
 
+libv4l-fmt.sgml:
+	cat ../v4l2-apps/libv4l/libv4lconvert/*.c| \
+	perl -ne 'if (m/(V4L2_PIX_FMT_[^\s\;\\)\,:]+)/) { printf "<link linkend=\"$$1\"><constant>$$1</constant></link>,\n"; };' \
+	|sort|uniq| \
+	sed  -e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" > $@
+
 capture.c.sgml: ../v4l2-apps/test/capture-example.c Makefile
 	echo "<programlisting>" > $@
 	expand --tabs=8 < $< | \
@@ -330,6 +338,13 @@
 	  sed 's/i\.e\./&ie;/' >> $@
 	echo "</programlisting>" >> $@
 
+v4l2grab.c.sgml: ../v4l2-apps/test/v4l2grab.c Makefile
+	echo "<programlisting>" > $@
+	expand --tabs=8 < $< | \
+	  sed $(ESCAPE) $(DOCUMENTED) | \
+	  sed 's/i\.e\./&ie;/' >> $@
+	echo "</programlisting>" >> $@
+
 videodev2.h.sgml: ../linux/include/linux/videodev2.h Makefile
 	echo "<programlisting>" > $@
 	expand --tabs=8 < $< | \
@@ -488,6 +503,7 @@
 	rm -f *.stamp
 	rm -f videodev2.h.sgml
 	rm -f capture.c.sgml
+	rm -f v4l2grab.c.sgml
 	rm -f capture
 	rm -f indices.sgml entities.sgml
 	rm -rf v4l2 v4l2-single v4l2.pdf
diff -r ee300d3178c4 v4l2-spec/libv4l.sgml
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-spec/libv4l.sgml	Sat Aug 15 16:32:08 2009 -0300
@@ -0,0 +1,143 @@
+<title>Libv4l Userspace Library</title>
+<section id="libv4l-introduction">
+	<title>Introduction</title>
+
+	<para>libv4l is a collection of libraries which adds a thin abstraction
+layer on op of video4linux2 devices. The purpose of this (thin) layer is to make
+it easy for application writers to support a wide variety of devices without
+having to write seperate code for different devices in the same class.</para>
+<para>An example of using libv4l is provided by
+<link linkend='v4l2grab-example'>v4l2grab</link>.
+</para>
+
+	<para>libv4l consists of 3 different libraries:</para>
+	<section>
+		<title>libv4lconvert</title>
+
+		<para>libv4lconvert is a library that converts different
+several different pixelformats found at V4L2 drivers into a few common RGB and
+YUY formats.</para>
+		<para>It currently accepts the following V4L2 driver formats:
+<link linkend="V4L2-PIX-FMT-BGR24"><constant>V4L2_PIX_FMT_BGR24</constant></link>,
+<link linkend="V4L2-PIX-FMT-HM12"><constant>V4L2_PIX_FMT_HM12</constant></link>,
+<link linkend="V4L2-PIX-FMT-JPEG"><constant>V4L2_PIX_FMT_JPEG</constant></link>,
+<link linkend="V4L2-PIX-FMT-MJPEG"><constant>V4L2_PIX_FMT_MJPEG</constant></link>,
+<link linkend="V4L2-PIX-FMT-MR97310A"><constant>V4L2_PIX_FMT_MR97310A</constant></link>,
+<link linkend="V4L2-PIX-FMT-OV511"><constant>V4L2_PIX_FMT_OV511</constant></link>,
+<link linkend="V4L2-PIX-FMT-OV518"><constant>V4L2_PIX_FMT_OV518</constant></link>,
+<link linkend="V4L2-PIX-FMT-PAC207"><constant>V4L2_PIX_FMT_PAC207</constant></link>,
+<link linkend="V4L2-PIX-FMT-PJPG"><constant>V4L2_PIX_FMT_PJPG</constant></link>,
+<link linkend="V4L2-PIX-FMT-RGB24"><constant>V4L2_PIX_FMT_RGB24</constant></link>,
+<link linkend="V4L2-PIX-FMT-SBGGR8"><constant>V4L2_PIX_FMT_SBGGR8</constant></link>,
+<link linkend="V4L2-PIX-FMT-SGBRG8"><constant>V4L2_PIX_FMT_SGBRG8</constant></link>,
+<link linkend="V4L2-PIX-FMT-SGRBG8"><constant>V4L2_PIX_FMT_SGRBG8</constant></link>,
+<link linkend="V4L2-PIX-FMT-SN9C10X"><constant>V4L2_PIX_FMT_SN9C10X</constant></link>,
+<link linkend="V4L2-PIX-FMT-SN9C20X-I420"><constant>V4L2_PIX_FMT_SN9C20X_I420</constant></link>,
+<link linkend="V4L2-PIX-FMT-SPCA501"><constant>V4L2_PIX_FMT_SPCA501</constant></link>,
+<link linkend="V4L2-PIX-FMT-SPCA505"><constant>V4L2_PIX_FMT_SPCA505</constant></link>,
+<link linkend="V4L2-PIX-FMT-SPCA508"><constant>V4L2_PIX_FMT_SPCA508</constant></link>,
+<link linkend="V4L2-PIX-FMT-SPCA561"><constant>V4L2_PIX_FMT_SPCA561</constant></link>,
+<link linkend="V4L2-PIX-FMT-SQ905C"><constant>V4L2_PIX_FMT_SQ905C</constant></link>,
+<constant>V4L2_PIX_FMT_SRGGB8</constant>,
+<link linkend="V4L2-PIX-FMT-UYVY"><constant>V4L2_PIX_FMT_UYVY</constant></link>,
+<link linkend="V4L2-PIX-FMT-YUV420"><constant>V4L2_PIX_FMT_YUV420</constant></link>,
+<link linkend="V4L2-PIX-FMT-YUYV"><constant>V4L2_PIX_FMT_YUYV</constant></link>,
+<link linkend="V4L2-PIX-FMT-YVU420"><constant>V4L2_PIX_FMT_YVU420</constant></link>,
+and <link linkend="V4L2-PIX-FMT-YVYU"><constant>V4L2_PIX_FMT_YVYU</constant></link>.
+</para>
+		<para>Later on libv4lconvert was expanded to also be able to do
+various	video processing functions improve webcam video quality on a software
+basis. The video processing is plit in to 2 parts: libv4lconvert/control and
+libv4lconvert/processing.</para>
+
+		<para>The control part is used to offer video controls which can
+be used	to control he video processing functions made available by
+	libv4lconvert/processing. These controls are stored application wide
+(untill	reboot) by using a persistent shared memory object.</para>
+
+		<para>libv4lconvert/processing offers the actual video
+processing functionality.</para>
+	</section>
+	<section>
+		<title>libv4l1</title>
+		<para>This library offers functions that can by used to quickly
+make v4l1 applications work with v4l2 devices. These functions work exactly
+like the normal open/close/etc, except that libv4l1 does full emulation of
+the v4l1 api on top of v4l2 drivers, in case of v4l1 drivers it
+will just pass calls through.</para>
+		<para>Since those functions are emulations of the old V4L1 API,
+it shouldn't be used on new applications.</para>
+	</section>
+	<section>
+		<title>libv4l2</title>
+		<para>This library should be used on all modern V4L2 application
+		</para>
+		<para>It provides handles to call V4L2 open/ioctl/close/poll
+methods. Instead of just providing the raw output of the device, it enhances
+the calls in the sense that it will use libv4lconvert to provide more video
+formats and to enhance the image quality.</para>
+		<para>On most cases, libv4l2 just passes the calls directly
+through to the v4l2 driver, intercepting the calls to
+<link linkend='VIDIOC-G-FMT'><constant>VIDIOC_TRY_FMT</constant></link>,
+<link linkend='VIDIOC-G-FMT'><constant>VIDIOC_G_FMT</constant></link> and
+<link linkend='VIDIOC-G-FMT'><constant>VIDIOC_S_FMT</constant></link> in order
+to emulate the formats <link linkend="V4L2-PIX-FMT-BGR24"><constant>V4L2_PIX_FMT_BGR24</constant></link>,
+<link linkend="V4L2-PIX-FMT-RGB24"><constant>V4L2_PIX_FMT_RGB24</constant></link>,
+<link linkend="V4L2-PIX-FMT-YUV420"><constant>V4L2_PIX_FMT_YUV420</constant></link>,
+and <link linkend="V4L2-PIX-FMT-YVU420"><constant>V4L2_PIX_FMT_YVU420</constant></link>,
+if they aren't available at the driver.
+<link linkend='VIDIOC-ENUM-FMT'><constant>VIDIOC_ENUM_FMT</constant></link> keep
+enumerating the hardware supported formats.
+</para>
+		<section id="libv4l-ops">
+			<title>Libv4l device control functions</title>
+			<para>The common file operation methods are provided by
+libv4l. They work like the non-v4l2 ones:</para>
+			<para>v4l2_open(const char *file, int oflag, ...) -
+operates like the standard <link linkend='func-open'>open()</link> function.
+</para>
+
+			<para>int v4l2_close(int fd) -
+operates like the standard <link linkend='func-close'>close()</link> function.
+</para>
+
+			<para>int v4l2_dup(int fd) -
+operates like the standard dup() function, duplicating a file handler.
+</para>
+
+			<para>int v4l2_ioctl (int fd, unsigned long int request, ...) -
+operates like the standard <link linkend='func-ioctl'>ioctl()</link> function.
+</para>
+
+			<para>int v4l2_read (int fd, void* buffer, size_t n) -
+operates like the standard <link linkend='func-read'>read()</link> function.
+</para>
+
+			<para>void v4l2_mmap(void *start, size_t length, int prot, int flags, int fd, int64_t offset); -
+operates like the standard <link linkend='func-mmap'>mmap()</link> function.
+</para>
+
+			<para>int v4l2_munmap(void *_start, size_t length); -
+operates like the standard <link linkend='func-munmap'>munmap()</link> function.
+</para>
+		</section>
+	</section>
+	<section>
+
+		<title>v4l1compat.so wrapper library</title>
+
+		<para>This library intercept calls to V4L2
+open/close/ioctl/mmap/mmunmap operations and redirects to the libv4lX
+counterparts, by using LD_PRELOAD=/usr/lib/v4l1compat.so.</para>
+		<para>It allows usage of binary legacy applications that
+still don't use libv4l.</para>
+	</section>
+
+</section>
+<!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "v4l2.sgml"
+indent-tabs-mode: nil
+End:
+-->
diff -r ee300d3178c4 v4l2-spec/v4l2.sgml
--- a/v4l2-spec/v4l2.sgml	Fri Aug 14 01:48:42 2009 -0300
+++ b/v4l2-spec/v4l2.sgml	Sat Aug 15 16:32:08 2009 -0300
@@ -25,7 +25,7 @@
 <book id="v4l2spec">
   <bookinfo>
     <title>Video for Linux Two API Specification</title>
-    <subtitle>Revision 0.26</subtitle>
+    <subtitle>Revision 0.27</subtitle>
 
     <authorgroup>
       <author>
@@ -92,6 +92,18 @@
       </author>
     </authorgroup>
 
+      <author>
+	<firstname>Mauro</firstname>
+	<surname>Carvalho Chehab</surname>
+	<contrib>Documented libv4l, designed and added v4l2grab example
+	</contrib>
+	<affiliation>
+	  <address>
+	    <email>mchehab@redhat.com</email>
+	  </address>
+	</affiliation>
+      </author>
+
     <copyright>
       <year>1999</year>
       <year>2000</year>
@@ -105,12 +117,13 @@
       <year>2008</year>
       <year>2009</year>
       <holder>Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin
-Rubli, Andy Walls</holder>
+Rubli, Andy Walls, Mauro Carvalho Chehab</holder>
     </copyright>
 
     <legalnotice>
       <para>This document is copyrighted &copy; 1999-2009 by Bill
-Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, and Andy Walls.</para>
+Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls and
+Mauro Carvalho Chehab.</para>
 
       <para>Permission is granted to copy, distribute and/or modify
 this document under the terms of the GNU Free Documentation License,
@@ -131,6 +144,13 @@
 applications. -->
 
       <revision>
+	<revnumber>0.27</revnumber>
+	<date>2009-08-15</date>
+	<authorinitials>mcc</authorinitials>
+	<revremark>Added libv4l documentation and v4l2grab example.</revremark>
+      </revision>
+
+      <revision>
 	<revnumber>0.26</revnumber>
 	<date>2009-06-15</date>
 	<authorinitials>hv</authorinitials>
@@ -471,6 +491,10 @@
     &sub-driver;
   </chapter>
 
+  <chapter id="libv4l">
+    &sub-libv4l;
+  </chapter>
+
   <chapter id="compat">
     &sub-compat;
   </chapter>
@@ -485,6 +509,14 @@
     &sub-capture-c;
   </appendix>
 
+  <appendix id="v4l2grab-example">
+    <title>Video Grabber example using libv4l</title>
+    <para>This program demonstrates how to grab V4L2 images in ppm format by
+using libv4l handlers. The advantage is that this grabber can potentially work
+with any V4L2 driver.</para>
+    &sub-v4l2grab-c;
+  </appendix>
+
   &sub-fdl-appendix;
 
   &sub-indices;
