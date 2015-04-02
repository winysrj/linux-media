Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59207 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbbDBNVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2015 09:21:04 -0400
Message-ID: <551D4220.7070303@xs4all.nl>
Date: Thu, 02 Apr 2015 15:20:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Lad Prabhakar <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/17] media: blackfin: bfin_capture enhancements
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com> <CAHG8p1AZMnV_ZLA1Ou=wejxwaHRObX1aAgO=xbXiwwEsJZ9EZA@mail.gmail.com>
In-Reply-To: <CAHG8p1AZMnV_ZLA1Ou=wejxwaHRObX1aAgO=xbXiwwEsJZ9EZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2015 10:18 AM, Scott Jiang wrote:
> Hi Lad and Hans,
> 
> 2015-03-08 22:40 GMT+08:00 Lad Prabhakar <prabhakar.csengg@gmail.com>:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch series, enhances blackfin capture driver with
>> vb2 helpers.
>>
>> Changes for v4:
>> 1: Improved commit message for path 4/17 and 5/17.
>> 2: Added Ack's from Scott to patches 1-15
>> 3: Two new patches 16/17 and 17/17
>>
>> Lad, Prabhakar (17):
>>   media: blackfin: bfin_capture: drop buf_init() callback
>>   media: blackfin: bfin_capture: release buffers in case
>>     start_streaming() call back fails
>>   media: blackfin: bfin_capture: set min_buffers_needed
>>   media: blackfin: bfin_capture: set vb2 buffer field
>>   media: blackfin: bfin_capture: improve queue_setup() callback
>>   media: blackfin: bfin_capture: use vb2_fop_mmap/poll
>>   media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
>>   media: blackfin: bfin_capture: use vb2_ioctl_* helpers
>>   media: blackfin: bfin_capture: make sure all buffers are returned on
>>     stop_streaming() callback
>>   media: blackfin: bfin_capture: return -ENODATA for *std calls
>>   media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
>>   media: blackfin: bfin_capture: add support for vidioc_create_bufs
>>   media: blackfin: bfin_capture: add support for VB2_DMABUF
>>   media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
>>   media: blackfin: bfin_capture: set v4l2 buffer sequence
>>   media: blackfin: bfin_capture: drop bcap_get_unmapped_area()
>>   media: blackfin: bfin_capture: embed video_device struct in
>>     bcap_device
>>
>>  drivers/media/platform/blackfin/bfin_capture.c | 348 ++++++++-----------------
>>  1 file changed, 103 insertions(+), 245 deletions(-)
>>
> 
> for patch 16/17,
> Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
> Tested-by: Scott Jiang <scott.jiang.linux@gmail.com>
> 
> Hans, I tried to use v4l2-compliance but it failed to compile. Sorry
> for telling you it have passed compilation because I forgot to use
> blackfin toolchain.
> ./configure --without-jpeg  --host=bfin-linux-uclibc --disable-libv4l
> 
> The main problem is there is no argp.h in uClibc, how to disable checking this?
> 
> checking for argp.h... no
> configure: error: Cannot continue: argp.h not found
> 
> Scott
> 

Hi Scott,

Can you try this patch for v4l-utils? It makes argp optional, and it should
allow v4l2-compliance to compile with uclibc (unless there are more problems).

I'm no autoconf guru, so I'm not certain if everything is correct, but it
seemed to do its job when I remove argp.h from my system.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

---
diff --git a/configure.ac b/configure.ac
index 330479c..0bf9154 100644
--- a/configure.ac
+++ b/configure.ac
@@ -253,14 +253,17 @@ dl_saved_libs=$LIBS
   AC_SUBST([DLOPEN_LIBS])
 LIBS=$dl_saved_libs
 
-AC_CHECK_HEADER([argp.h],,AC_MSG_ERROR(Cannot continue: argp.h not found))
+#AC_CHECK_HEADER([argp.h],,AC_MSG_ERROR(Cannot continue: argp.h not found))
+AC_CHECK_HEADER([argp.h], [argp=yes], [argp=no])
+AS_IF([test "x$argp" = "xyes"],
 argp_saved_libs=$LIBS
   AC_SEARCH_LIBS([argp_parse],
                  [argp],
                  [test "$ac_cv_search_argp_parse" = "none required" || ARGP_LIBS=$ac_cv_search_argp_parse],
                  [AC_MSG_ERROR([unable to find the argp_parse() function])])
   AC_SUBST([ARGP_LIBS])
-LIBS=$argp_saved_libs
+LIBS=$argp_saved_libs)
+AM_CONDITIONAL([HAVE_ARGP], [test x$argp = xyes])
 
 AC_CHECK_HEADER([linux/i2c-dev.h], [linux_i2c_dev=yes], [linux_i2c_dev=no])
 AM_CONDITIONAL([HAVE_LINUX_I2C_DEV], [test x$linux_i2c_dev = xyes])
diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 0bfa33e..f87ed3e 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -2,7 +2,6 @@ noinst_PROGRAMS = \
 	ioctl-test		\
 	sliced-vbi-test		\
 	sliced-vbi-detect	\
-	v4l2grab		\
 	driver-test		\
 	stress-buffer		\
 	capture-example
@@ -11,9 +10,12 @@ if HAVE_X11
 noinst_PROGRAMS += pixfmt-test
 endif
 
+if HAVE_ARGP
+noinst_PROGRAMS += v4l2grab
 if HAVE_GLU
 noinst_PROGRAMS += v4l2gl
 endif
+endif
 
 driver_test_SOURCES = driver-test.c
 driver_test_LDADD = ../../utils/libv4l2util/libv4l2util.la
diff --git a/utils/decode_tm6000/Makefile.am b/utils/decode_tm6000/Makefile.am
index ac4e85e..845e35e 100644
--- a/utils/decode_tm6000/Makefile.am
+++ b/utils/decode_tm6000/Makefile.am
@@ -1,4 +1,6 @@
+if HAVE_ARGP
 bin_PROGRAMS = decode_tm6000
 decode_tm6000_SOURCES = decode_tm6000.c
 decode_tm6000_LDADD = ../libv4l2util/libv4l2util.la
 decode_tm6000_LDFLAGS = $(ARGP_LIBS)
+endif
diff --git a/utils/dvb/Makefile.am b/utils/dvb/Makefile.am
index 6aae408..32c9fb9 100644
--- a/utils/dvb/Makefile.am
+++ b/utils/dvb/Makefile.am
@@ -1,3 +1,4 @@
+if HAVE_ARGP
 bin_PROGRAMS = dvb-fe-tool dvbv5-zap dvbv5-scan dvb-format-convert
 man_MANS = dvb-fe-tool.1 dvbv5-zap.1 dvbv5-scan.1 dvb-format-convert.1
 
@@ -18,4 +19,4 @@ dvb_format_convert_LDADD = ../../lib/libdvbv5/libdvbv5.la
 dvb_format_convert_LDFLAGS = $(ARGP_LIBS) -lm
 
 EXTRA_DIST = README
-
+endif
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index f6a0773..1238e4b 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -1,3 +1,4 @@
+if HAVE_ARGP
 bin_PROGRAMS = ir-keytable
 man_MANS = ir-keytable.1
 sysconf_DATA = rc_maps.cfg
@@ -12,6 +13,7 @@ EXTRA_DIST = 70-infrared.rules rc_keymaps gen_keytables.pl ir-keytable.1 rc_maps
 # custom target
 install-data-local:
 	$(install_sh) -d "$(DESTDIR)$(keytableuserdir)"
+endif
 
 sync-with-kernel:
 	@if [ ! -f $(KERNEL_DIR)/usr/include/linux/input.h ]; then \
diff --git a/utils/v4l2-sysfs-path/Makefile.am b/utils/v4l2-sysfs-path/Makefile.am
index 6ef4228..e72e439 100644
--- a/utils/v4l2-sysfs-path/Makefile.am
+++ b/utils/v4l2-sysfs-path/Makefile.am
@@ -1,4 +1,6 @@
+if HAVE_ARGP
 bin_PROGRAMS = v4l2-sysfs-path
 v4l2_sysfs_path_SOURCES = v4l2-sysfs-path.c
 v4l2_sysfs_path_LDADD = ../libmedia_dev/libmedia_dev.la
 v4l2_sysfs_path_LDFLAGS = $(ARGP_LIBS)
+endif

