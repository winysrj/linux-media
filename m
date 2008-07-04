Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64CCl6b004252
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 08:12:47 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64CCT01012627
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 08:12:30 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEk9N-0008Ex-1w
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 14:12:29 +0200
Message-ID: <486E1388.2060602@hhs.nl>
Date: Fri, 04 Jul 2008 14:11:52 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------030403000102060805080401"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-makefile-improvements.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------030403000102060805080401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Makefile improvements:
* Split DESTDIR into DESTDIR and PREFIX as used in most makefiles out there
* Add LIBDIR variable to allow installation in <prefix>/lib64 for example
* Install the wrappers in <libdir>/libv4l instead of directly under libdir,
   as they are not libraries meant for linking
* preserve timestamps of header files when installing them

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans



--------------030403000102060805080401
Content-Type: text/plain;
 name="libv4l-makefile-improvements.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-makefile-improvements.patch"

Makefile improvements:
* Split DESTDIR into DESTDIR and PREFIX as used in most makefiles out there
* Add LIBDIR variable to allow installation in <prefix>/lib64 for example
* Install the wrappers in <libdir>/libv4l instead of directly under libdir,
  as they are not libraries meant for linking
* preserve timestamps of header files when installing them

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r d4e241f9a06c v4l2-apps/lib/libv4l/README
--- a/v4l2-apps/lib/libv4l/README	Fri Jul 04 13:21:38 2008 +0200
+++ b/v4l2-apps/lib/libv4l/README	Fri Jul 04 13:52:07 2008 +0200
@@ -59,11 +59,12 @@
 counterparts.
 
 The preloadable libv4l1 wrapper which adds v4l2 device compatibility to v4l1
-applications is called v4l1compat.so. The preloadable libv4l1 wrapper which
-adds v4l2 device compatibility to v4l1 applications is called v4l2convert.so
+applications is called v4l1compat.so. The preloadable libv4l2 wrapper which
+adds support for various pixelformats to v4l2 applications is called
+v4l2convert.so.
 
 Example usage (after install in default location):
-$ export LD_PRELOAD=/usr/local/lib/v4l1compat.so
+$ export LD_PRELOAD=/usr/local/lib/libv4l/v4l1compat.so
 $ camorama
 
 
@@ -71,9 +72,12 @@
 -------------------------
 
 Simple type the following commands from the libv4l-x.y.z directory
-(adjusting DESTDIR as desired):
+(adjusting PREFIX as desired):
 make
-make install DESTDIR=/usr/local
+make install PREFIX=/usr/local
+
+Note: make install also supports the DESTDIR=... paramter for installation
+into chroots.
 
 
 FAQ
diff -r d4e241f9a06c v4l2-apps/lib/libv4l/libv4l1/Makefile
--- a/v4l2-apps/lib/libv4l/libv4l1/Makefile	Fri Jul 04 13:21:38 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/Makefile	Fri Jul 04 13:52:07 2008 +0200
@@ -19,8 +19,12 @@
 LIB_RELEASE = 0
 endif
 
-ifeq ($(DESTDIR),)
-DESTDIR = /usr/local
+ifeq ($(PREFIX),)
+PREFIX = /usr/local
+endif
+
+ifeq ($(LIBDIR),)
+LIBDIR = $(PREFIX)/lib
 endif
 
 all: $(TARGETS)
@@ -31,15 +35,14 @@
 $(V4L1COMPAT): $(V4L1COMPAT_O) $(V4L1_LIB)
 
 install: all
-	mkdir -p $(DESTDIR)/include
-	cp $(INCLUDES) $(DESTDIR)/include
-	mkdir -p $(DESTDIR)/lib
-	cp $(V4L1_LIB).$(LIB_RELEASE) $(DESTDIR)/lib
-	cd $(DESTDIR)/lib && \
+	mkdir -p $(DESTDIR)$(PREFIX)/include
+	install -p -m 644 $(INCLUDES) $(DESTDIR)$(PREFIX)/include
+	mkdir -p $(DESTDIR)$(LIBDIR)/libv4l
+	install -m 755 $(V4L1_LIB).$(LIB_RELEASE) $(DESTDIR)$(LIBDIR)
+	cd $(DESTDIR)$(LIBDIR) && \
 	  ln -f -s $(V4L1_LIB).$(LIB_RELEASE) $(V4L1_LIB)
-	cp $(V4L1COMPAT).$(LIB_RELEASE) $(DESTDIR)/lib
-	cd $(DESTDIR)/lib && \
-	  ln -f -s $(V4L1COMPAT).$(LIB_RELEASE) $(V4L1COMPAT)
+	install -m 755 $(V4L1COMPAT).$(LIB_RELEASE) \
+	  $(DESTDIR)$(LIBDIR)/libv4l/$(V4L1COMPAT)
 
 clean::
 	rm -f *.so* *.o log *~
diff -r d4e241f9a06c v4l2-apps/lib/libv4l/libv4l2/Makefile
--- a/v4l2-apps/lib/libv4l/libv4l2/Makefile	Fri Jul 04 13:21:38 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/Makefile	Fri Jul 04 13:52:07 2008 +0200
@@ -19,8 +19,12 @@
 LIB_RELEASE = 0
 endif
 
-ifeq ($(DESTDIR),)
-DESTDIR = /usr/local
+ifeq ($(PREFIX),)
+PREFIX = /usr/local
+endif
+
+ifeq ($(LIBDIR),)
+LIBDIR = $(PREFIX)/lib
 endif
 
 all: $(TARGETS)
@@ -30,15 +34,14 @@
 $(V4L2CONVERT): $(V4L2CONVERT_O) $(V4L2_LIB)
 
 install: all
-	mkdir -p $(DESTDIR)/include
-	cp $(INCLUDES) $(DESTDIR)/include
-	mkdir -p $(DESTDIR)/lib
-	cp $(V4L2_LIB).$(LIB_RELEASE) $(DESTDIR)/lib
-	cd $(DESTDIR)/lib && \
+	mkdir -p $(DESTDIR)$(PREFIX)/include
+	install -p -m 644 $(INCLUDES) $(DESTDIR)$(PREFIX)/include
+	mkdir -p $(DESTDIR)$(LIBDIR)/libv4l
+	install -m 755 $(V4L2_LIB).$(LIB_RELEASE) $(DESTDIR)$(LIBDIR)
+	cd $(DESTDIR)$(LIBDIR) && \
 	  ln -f -s $(V4L2_LIB).$(LIB_RELEASE) $(V4L2_LIB)
-	cp $(V4L2CONVERT).$(LIB_RELEASE) $(DESTDIR)/lib
-	cd $(DESTDIR)/lib && \
-	  ln -f -s $(V4L2CONVERT).$(LIB_RELEASE) $(V4L2CONVERT)
+	install -m 755 $(V4L2CONVERT).$(LIB_RELEASE) \
+	  $(DESTDIR)$(LIBDIR)/libv4l/$(V4L2CONVERT)
 
 clean::
 	rm -f *.so* *.o log *~
diff -r d4e241f9a06c v4l2-apps/lib/libv4l/libv4lconvert/Makefile
--- a/v4l2-apps/lib/libv4l/libv4lconvert/Makefile	Fri Jul 04 13:21:38 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/Makefile	Fri Jul 04 13:52:07 2008 +0200
@@ -18,8 +18,12 @@
 LIB_RELEASE = 0
 endif
 
-ifeq ($(DESTDIR),)
-DESTDIR = /usr/local
+ifeq ($(PREFIX),)
+PREFIX = /usr/local
+endif
+
+ifeq ($(LIBDIR),)
+LIBDIR = $(PREFIX)/lib
 endif
 
 all: $(TARGETS)
@@ -27,11 +31,11 @@
 $(CONVERT_LIB): $(CONVERT_OBJS)
 
 install: all
-	mkdir -p $(DESTDIR)/include
-	cp $(INCLUDES) $(DESTDIR)/include
-	mkdir -p $(DESTDIR)/lib
-	cp $(CONVERT_LIB).$(LIB_RELEASE) $(DESTDIR)/lib
-	cd $(DESTDIR)/lib && \
+	mkdir -p $(DESTDIR)$(PREFIX)/include
+	install -p -m 644 $(INCLUDES) $(DESTDIR)$(PREFIX)/include
+	mkdir -p $(DESTDIR)$(LIBDIR)
+	install -m 755 $(CONVERT_LIB).$(LIB_RELEASE) $(DESTDIR)$(LIBDIR)
+	cd $(DESTDIR)$(LIBDIR) && \
 	  ln -f -s $(CONVERT_LIB).$(LIB_RELEASE) $(CONVERT_LIB)
 
 clean::

--------------030403000102060805080401
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030403000102060805080401--
