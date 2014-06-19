Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43661 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaFSHiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 03:38:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] Update sync-with-kernel to use installed kernel headers
Date: Thu, 19 Jun 2014 09:39:35 +0200
Message-ID: <2053295.4aAnXiX32L@avalon>
In-Reply-To: <1401792019-20723-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401792019-20723-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping ?

On Tuesday 03 June 2014 12:40:19 Laurent Pinchart wrote:
> Kernel headers exported to userspace can contain kernel-specific
> statements (such as __user annotations) that are removed when installing
> the headers with 'make headers_install' in the kernel sources. Only
> those headers must be used by userspace, raw headers are private to the
> kernel.
> 
> Update the sync-with-kernel make target to use the installed headers.
> The user must install the kernel headers by running
> 
> 	make headers_install
> 
> in KERNEL_DIR prior to run sync-with-kernel.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Makefile.am                                   | 45 +++++++++++++-----------
>  contrib/freebsd/Makefile.am                   |  2 +-
>  contrib/freebsd/bsdify.sh                     |  2 +-
>  contrib/freebsd/patches/dvb-dmx-header.diff   |  8 ++---
>  contrib/freebsd/patches/dvb-osd-header.diff   |  2 +-
>  contrib/freebsd/patches/dvb-video-header.diff |  8 ++---
>  contrib/freebsd/patches/input-header.diff     |  8 ++---
>  contrib/freebsd/patches/ivtv-header.diff      |  5 ++-
>  contrib/freebsd/patches/uinput-header.diff    |  8 ++---
>  contrib/freebsd/patches/videodev2-header.diff | 13 ++++----
>  lib/libdvbv5/Makefile.am                      |  2 +-
>  lib/libdvbv5/gen_dvb_structs.pl               |  2 +-
>  utils/keytable/Makefile.am                    | 12 +++----
>  13 files changed, 55 insertions(+), 62 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 11baed1..35d0030 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -12,31 +12,32 @@ EXTRA_DIST = include COPYING.libv4l README.libv4l
> README.lib-multi-threading # custom targets
> 
>  sync-with-kernel:
> -	@if [ ! -f $(KERNEL_DIR)/include/uapi/linux/videodev2.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/fb.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-controls.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-common.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-subdev.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/v4l2-mediabus.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/ivtv.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/frontend.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/dmx.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/audio.h -o \
> -	      ! -f $(KERNEL_DIR)/include/uapi/linux/dvb/video.h ]; then \
> +	@if [ ! -f $(KERNEL_DIR)/usr/include/linux/videodev2.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/fb.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/v4l2-controls.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/v4l2-common.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/v4l2-subdev.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/v4l2-mediabus.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/ivtv.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/frontend.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/dmx.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/audio.h -o \
> +	      ! -f $(KERNEL_DIR)/usr/include/linux/dvb/video.h ]; then \
>  	  echo "Error you must set KERNEL_DIR to point to an extracted kernel
> source dir"; \ +	  echo "and run 'make headers_install' in \$$KERNEL_DIR.";
> \
>  	  exit 1; \
>  	fi
> -	cp -a $(KERNEL_DIR)/include/uapi/linux/videodev2.h
> $(top_srcdir)/include/linux -	cp -a $(KERNEL_DIR)/include/uapi/linux/fb.h
> $(top_srcdir)/include/linux -	cp -a
> $(KERNEL_DIR)/include/uapi/linux/v4l2-controls.h
> $(top_srcdir)/include/linux -	cp -a
> $(KERNEL_DIR)/include/uapi/linux/v4l2-common.h $(top_srcdir)/include/linux
> -	cp -a $(KERNEL_DIR)/include/uapi/linux/v4l2-subdev.h
> $(top_srcdir)/include/linux -	cp -a
> $(KERNEL_DIR)/include/uapi/linux/v4l2-mediabus.h
> $(top_srcdir)/include/linux -	cp -a $(KERNEL_DIR)/include/uapi/linux/ivtv.h
> $(top_srcdir)/include/linux -	cp -a
> $(KERNEL_DIR)/include/uapi/linux/dvb/frontend.h
> $(top_srcdir)/include/linux/dvb -	cp -a
> $(KERNEL_DIR)/include/uapi/linux/dvb/dmx.h $(top_srcdir)/include/linux/dvb
> -	cp -a $(KERNEL_DIR)/include/uapi/linux/dvb/audio.h
> $(top_srcdir)/include/linux/dvb -	cp -a
> $(KERNEL_DIR)/include/uapi/linux/dvb/video.h
> $(top_srcdir)/include/linux/dvb +	cp -a
> $(KERNEL_DIR)/usr/include/linux/videodev2.h $(top_srcdir)/include/linux
> +	cp -a $(KERNEL_DIR)/usr/include/linux/fb.h $(top_srcdir)/include/linux
> +	cp -a $(KERNEL_DIR)/usr/include/linux/v4l2-controls.h
> $(top_srcdir)/include/linux +	cp -a
> $(KERNEL_DIR)/usr/include/linux/v4l2-common.h $(top_srcdir)/include/linux
> +	cp -a $(KERNEL_DIR)/usr/include/linux/v4l2-subdev.h
> $(top_srcdir)/include/linux +	cp -a
> $(KERNEL_DIR)/usr/include/linux/v4l2-mediabus.h $(top_srcdir)/include/linux
> +	cp -a $(KERNEL_DIR)/usr/include/linux/ivtv.h $(top_srcdir)/include/linux
> +	cp -a $(KERNEL_DIR)/usr/include/linux/dvb/frontend.h
> $(top_srcdir)/include/linux/dvb +	cp -a
> $(KERNEL_DIR)/usr/include/linux/dvb/dmx.h $(top_srcdir)/include/linux/dvb
> +	cp -a $(KERNEL_DIR)/usr/include/linux/dvb/audio.h
> $(top_srcdir)/include/linux/dvb +	cp -a
> $(KERNEL_DIR)/usr/include/linux/dvb/video.h $(top_srcdir)/include/linux/dvb
> 
>  	$(MAKE) -C utils/keytable $@
>  	$(MAKE) -C utils/xc3028-firmware $@
> diff --git a/contrib/freebsd/Makefile.am b/contrib/freebsd/Makefile.am
> index 8ad4c01..f28be2e 100644
> --- a/contrib/freebsd/Makefile.am
> +++ b/contrib/freebsd/Makefile.am
> @@ -8,7 +8,7 @@ sync-with-kernel:
> 
>  	for i in input.h ivtv.h uinput.h videodev2.h v4l2-controls.h v4l2-
common.h
> dvb/{audio.h,ca.h,dmx.h,frontend.h,net.h,osd.h,version.h,video.h}; do \
> mkdir -p include/linux/$$(dirname $$i); \
> -	    cp $(KERNEL_DIR)/include/uapi/linux/$$i include/linux/$$i; \
> +	    cp $(KERNEL_DIR)/usr/include/linux/$$i include/linux/$$i; \
>  	done
> 
>  	for i in ivtv.h uinput.h videodev2.h
> dvb/{audio.h,ca.h,dmx.h,frontend.h,net.h,osd.h,version.h,video.h}; do \
> diff --git a/contrib/freebsd/bsdify.sh b/contrib/freebsd/bsdify.sh index
> d4652cb..286bab5 100755
> --- a/contrib/freebsd/bsdify.sh
> +++ b/contrib/freebsd/bsdify.sh
> @@ -30,7 +30,7 @@ rm -rf include .pc
> 
>  for i in input.h ivtv.h uinput.h videodev2.h v4l2-controls.h v4l2-common.h
> dvb/{audio.h,ca.h,dmx.h,frontend.h,net.h,osd.h,version.h,video.h}; do mkdir
> -p include/linux/$(dirname $i)
> -    cp $KERNEL_DIR/include/uapi/linux/$i include/linux/$i
> +    cp $KERNEL_DIR/usr/include/linux/$i include/linux/$i
>  done
> 
>  # replace kernel types
> diff --git a/contrib/freebsd/patches/dvb-dmx-header.diff
> b/contrib/freebsd/patches/dvb-dmx-header.diff index b86cb8f..4723160 100644
> --- a/contrib/freebsd/patches/dvb-dmx-header.diff
> +++ b/contrib/freebsd/patches/dvb-dmx-header.diff
> @@ -1,15 +1,13 @@
>  --- freebsd/include/linux/dvb/dmx.h.orig	2012-12-05 10:26:23.000000000
> +0100 +++ freebsd/include/linux/dvb/dmx.h	2012-12-05 10:27:35.989684418
> +0100 -@@ -24,10 +24,9 @@
> - #ifndef _UAPI_DVBDMX_H_
> - #define _UAPI_DVBDMX_H_
> +@@ -24,8 +24,9 @@
> + #ifndef _DVBDMX_H_
> + #define _DVBDMX_H_
> 
>  -#include <linux/types.h>
> --#ifndef __KERNEL__
>  +#include <stdint.h>
>  +#include <sys/types.h>
>   #include <time.h>
> --#endif
> 
> 
>   #define DMX_FILTER_SIZE 16
> diff --git a/contrib/freebsd/patches/dvb-osd-header.diff
> b/contrib/freebsd/patches/dvb-osd-header.diff index a293874..df5adbd 100644
> --- a/contrib/freebsd/patches/dvb-osd-header.diff
> +++ b/contrib/freebsd/patches/dvb-osd-header.diff
> @@ -4,7 +4,7 @@
>   #ifndef _DVBOSD_H_
>   #define _DVBOSD_H_
> 
> --#include <linux/compiler.h>
> +-
>  +#include <sys/types.h>
> 
>   typedef enum {
> diff --git a/contrib/freebsd/patches/dvb-video-header.diff
> b/contrib/freebsd/patches/dvb-video-header.diff index 7d9fc0e..c578bf9
> 100644
> --- a/contrib/freebsd/patches/dvb-video-header.diff
> +++ b/contrib/freebsd/patches/dvb-video-header.diff
> @@ -1,15 +1,13 @@
>  --- freebsd/include/linux/dvb/video.h.orig	2012-12-05 10:28:14.000000000
> +0100 +++ freebsd/include/linux/dvb/video.h	2012-12-05 10:29:13.054783858
> +0100 -@@ -24,11 +24,9 @@
> - #ifndef _UAPI_DVBVIDEO_H_
> - #define _UAPI_DVBVIDEO_H_
> +@@ -24,9 +24,9 @@
> + #ifndef _DVBVIDEO_H_
> + #define _DVBVIDEO_H_
> 
>  -#include <linux/types.h>
> --#ifndef __KERNEL__
>  +#include <sys/types.h>
>   #include <stdint.h>
>   #include <time.h>
> --#endif
> 
>   typedef enum {
>   	VIDEO_FORMAT_4_3,     /* Select 4:3 format */
> diff --git a/contrib/freebsd/patches/input-header.diff
> b/contrib/freebsd/patches/input-header.diff index db1194c..d9c7d66 100644
> --- a/contrib/freebsd/patches/input-header.diff
> +++ b/contrib/freebsd/patches/input-header.diff
> @@ -1,11 +1,10 @@
>  --- freebsd/include/linux/input.h.orig	2012-12-05 10:18:56.000000000 +0100
>  +++ freebsd/include/linux/input.h	2012-12-05 10:22:11.228350200 +0100
> -@@ -8,13 +8,49 @@
> - #ifndef _UAPI_INPUT_H
> - #define _UAPI_INPUT_H
> +@@ -8,11 +8,47 @@
> + #ifndef _INPUT_H
> + #define _INPUT_H
> 
>  -
> - #ifndef __KERNEL__
>  +#include <stdint.h>
>   #include <sys/time.h>
>   #include <sys/ioctl.h>
> @@ -46,7 +45,6 @@
>  +#define	_IOC_WRITE  IOC_IN
>  +#else
>   #include <linux/types.h>
> - #endif
>  +#endif
> 
> 
> diff --git a/contrib/freebsd/patches/ivtv-header.diff
> b/contrib/freebsd/patches/ivtv-header.diff index 549ce40..53573da 100644
> --- a/contrib/freebsd/patches/ivtv-header.diff
> +++ b/contrib/freebsd/patches/ivtv-header.diff
> @@ -1,10 +1,9 @@
>  --- a/include/linux/ivtv.h
>  +++ b/include/linux/ivtv.h
> -@@ -21,8 +21,8 @@
> - #ifndef __LINUX_IVTV_H__
> +@@ -22,7 +22,8 @@
>   #define __LINUX_IVTV_H__
> 
> --#include <linux/compiler.h>
> +
>  -#include <linux/types.h>
>  +#include <stdint.h>
>  +#include <sys/types.h>
> diff --git a/contrib/freebsd/patches/uinput-header.diff
> b/contrib/freebsd/patches/uinput-header.diff index a92f7d5..537d529 100644
> --- a/contrib/freebsd/patches/uinput-header.diff
> +++ b/contrib/freebsd/patches/uinput-header.diff
> @@ -1,10 +1,10 @@
>  --- freebsd/include/linux/uinput.h.orig	2012-12-05 10:38:23.417354136 
+0100
> +++ freebsd/include/linux/uinput.h	2012-12-05 10:38:27.832358799 +0100 -@@
> -32,7 +32,6 @@
> - #ifndef _UAPI__UINPUT_H_
> - #define _UAPI__UINPUT_H_
> +@@ -34,7 +34,6 @@
> + #ifndef __UINPUT_H_
> + #define __UINPUT_H_
> 
>  -#include <linux/types.h>
>   #include <linux/input.h>
> 
> - #define UINPUT_VERSION		3
> + #define UINPUT_VERSION		4
> diff --git a/contrib/freebsd/patches/videodev2-header.diff
> b/contrib/freebsd/patches/videodev2-header.diff index f440e65..e850746
> 100644
> --- a/contrib/freebsd/patches/videodev2-header.diff
> +++ b/contrib/freebsd/patches/videodev2-header.diff
> @@ -1,14 +1,14 @@
>  --- freebsd/include/linux/videodev2.h.orig	2012-12-05 10:23:08.000000000
> +0100 +++ freebsd/include/linux/videodev2.h	2012-12-05 10:25:46.864570965
> +0100 -@@ -57,11 +57,45 @@
> - #define _UAPI__LINUX_VIDEODEV2_H
> +@@ -56,10 +56,44 @@
> + #ifndef __LINUX_VIDEODEV2_H
> + #define __LINUX_VIDEODEV2_H
> 
> - #ifndef __KERNEL__
>  +#include <stdint.h>
>   #include <sys/time.h>
>  +#include <sys/types.h>
>  +#include <sys/ioctl.h>
> -+
> +
>  +#ifndef HAVE_LINUX_INTEGER_TYPES
>  +/* XXX remove when depending software has been updated */
>  +#ifndef __u64
> @@ -26,7 +26,7 @@
>  +
>  +#ifndef __s64
>  +typedef int64_t __s64;
> - #endif
> ++#endif
>  +#ifndef __s32
>  +typedef int32_t __s32;
>  +#endif
> @@ -38,8 +38,7 @@
>  +#endif
>  +#endif
>  +
> -+#else
> - #include <linux/compiler.h>
> ++#ifdef __KERNEL__
>   #include <linux/ioctl.h>
>   #include <linux/types.h>
>  +#endif
> diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
> index 515adc3..bb270a6 100644
> --- a/lib/libdvbv5/Makefile.am
> +++ b/lib/libdvbv5/Makefile.am
> @@ -111,4 +111,4 @@ libdvbv5_la_LIBADD = $(LTLIBICONV)
>  EXTRA_DIST = README gen_dvb_structs.pl
> 
>  sync-with-kernel:
> -	./gen_dvb_structs.pl $(KERNEL_DIR)/include/
> +	./gen_dvb_structs.pl $(KERNEL_DIR)/usr/include/
> diff --git a/lib/libdvbv5/gen_dvb_structs.pl
> b/lib/libdvbv5/gen_dvb_structs.pl index dca6b9b..1fab057 100755
> --- a/lib/libdvbv5/gen_dvb_structs.pl
> +++ b/lib/libdvbv5/gen_dvb_structs.pl
> @@ -468,7 +468,7 @@ sub output_arrays($$$$$)
>    }
>  }
> 
> -my $fe_file = "$dir/uapi/linux/dvb/frontend.h";
> +my $fe_file = "$dir/linux/dvb/frontend.h";
> 
>  copy $fe_file, "../include/dvb-frontend.h";
> 
> diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
> index 419d474..3e66eba 100644
> --- a/utils/keytable/Makefile.am
> +++ b/utils/keytable/Makefile.am
> @@ -14,7 +14,7 @@ install-data-local:
>  	$(install_sh) -d "$(DESTDIR)$(keytableuserdir)"
> 
>  sync-with-kernel:
> -	@if [ ! -f $(KERNEL_DIR)/include/uapi/linux/input.h ]; then \
> +	@if [ ! -f $(KERNEL_DIR)/usr/include/linux/input.h ]; then \
>  	  echo "Error you must set KERNEL_DIR to point to an extracted kernel
> source dir"; \ exit 1; \
>  	fi
> @@ -22,21 +22,21 @@ sync-with-kernel:
>  	@printf "struct parse_event {\n\tchar *name;\n\tunsigned int value;\n};
\n"
> > $(srcdir)/parse.h
> 
>  	@printf "struct parse_event events_type[] = {\n" >> $(srcdir)/parse.h
> -	@more $(KERNEL_DIR)/include/uapi/linux/input.h | perl -n \
> +	@more $(KERNEL_DIR)/usr/include/linux/input.h | perl -n \
>  	-e 'if (m/^\#define\s+(EV_[^\s]+)\s+(0x[\d\w]+|[\d]+)/) ' \
>  	-e '{ printf "\t{\"%s\", %s},\n",$$1,$$2 if ($$1 ne "EV_VERSION"); }' \
> 
>  	>> $(srcdir)/parse.h
> 
>  	@printf "\t{ NULL, 0}\n};\n" >> $(srcdir)/parse.h
> 
>  	@printf "struct parse_event msc_events[] = {\n" >> $(srcdir)/parse.h
> -	@more $(KERNEL_DIR)/include/uapi/linux/input.h | perl -n \
> +	@more $(KERNEL_DIR)/usr/include/linux/input.h | perl -n \
>  	-e 'if (m/^\#define\s+(MSC_[^\s]+)\s+(0x[\d\w]+|[\d]+)/) ' \
>  	-e '{ printf "\t{\"%s\", %s},\n",$$1,$$2; }' \
> 
>  	>> $(srcdir)/parse.h
> 
>  	@printf "\t{ NULL, 0}\n};\n" >> $(srcdir)/parse.h
> 
>  	@printf "struct parse_event key_events[] = {\n" >> $(srcdir)/parse.h
> -	@more $(KERNEL_DIR)/include/uapi/linux/input.h | perl -n \
> +	@more $(KERNEL_DIR)/usr/include/linux/input.h | perl -n \
>  	-e 'if (m/^\#define\s+(KEY_[^\s]+)\s+(0x[\d\w]+|[\d]+)/) ' \
>  	-e '{ printf "\t{\"%s\", %s},\n",$$1,$$2; }' \
>  	-e 'if (m/^\#define\s+(BTN_[^\s]+)\s+(0x[\d\w]+|[\d]+)/) ' \
> @@ -45,14 +45,14 @@ sync-with-kernel:
>  	@printf "\t{ NULL, 0}\n};\n" >> $(srcdir)/parse.h
> 
>  	@printf "struct parse_event rel_events[] = {\n" >> $(srcdir)/parse.h
> -	@more $(KERNEL_DIR)/include/uapi/linux/input.h | perl -n \
> +	@more $(KERNEL_DIR)/usr/include/linux/input.h | perl -n \
>  	-e 'if (m/^\#define\s+(REL_[^\s]+)\s+(0x[\d\w]+|[\d]+)/) ' \
>  	-e '{ printf "\t{\"%s\", %s},\n",$$1,$$2; }' \
> 
>  	>> $(srcdir)/parse.h
> 
>  	@printf "\t{ NULL, 0}\n};\n" >> $(srcdir)/parse.h
> 
>  	@printf "struct parse_event abs_events[] = {\n" >> $(srcdir)/parse.h
> -	@more $(KERNEL_DIR)/include/uapi/linux/input.h | perl -n \
> +	@more $(KERNEL_DIR)/usr/include/linux/input.h | perl -n \
>  	-e 'if (m/^\#define\s+(ABS_[^\s]+)\s+(0x[\d\w]+|[\d]+)/) ' \
>  	-e '{ printf "\t{\"%s\", %s},\n",$$1,$$2; }' \
> 
>  	>> $(srcdir)/parse.h

-- 
Regards,

Laurent Pinchart

