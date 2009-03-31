Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:41126 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbZCaXRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 19:17:19 -0400
Received: by bwz17 with SMTP id 17so2605725bwz.37
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 16:17:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <208cbae30903270844r55d0d48eidb5a9ad6f8309f53@mail.gmail.com>
References: <208cbae30903270844r55d0d48eidb5a9ad6f8309f53@mail.gmail.com>
Date: Wed, 1 Apr 2009 03:17:15 +0400
Message-ID: <208cbae30903311617x35b3af1dmf9036be228ce5d52@mail.gmail.com>
Subject: Re: trouble with v4l-dvb compilation, compat.h: redefinition of
	'usb_endpoint_type'
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 27, 2009 at 7:44 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> Hello,
>
> I went to /usr/src/linux and run "git pull" (so i get 2.6.29-git1),
> and make new kernel.
> Then i updated v4l-dvb repository(hg pull, hg update) and configured
> to compile, for example dsbr100 radio driver.
> I get such message:
>
> tux v4l-dvb # make
> make -C /w/new/v4l-dvb/v4l
> make[1]: Entering directory `/w/new/v4l-dvb/v4l'
> ./scripts/make_myconfig.pl
> make[1]: Leaving directory `/w/new/v4l-dvb/v4l'
> make[1]: Entering directory `/w/new/v4l-dvb/v4l'
> perl scripts/make_config_compat.pl /lib/modules/2.6.29/source
> ./.myconfig ./config-compat.h
> creating symbolic links...
> Kernel build directory is /lib/modules/2.6.29/build
> make -C /lib/modules/2.6.29/build SUBDIRS=/w/new/v4l-dvb/v4l  modules
> make[2]: Entering directory `/usr/src/linux-2.6'
>  CC [M]  /w/new/v4l-dvb/v4l/tuner-xc2028.o
>  CC [M]  /w/new/v4l-dvb/v4l/tuner-simple.o
>  CC [M]  /w/new/v4l-dvb/v4l/tuner-types.o
>  CC [M]  /w/new/v4l-dvb/v4l/mt20xx.o
>  CC [M]  /w/new/v4l-dvb/v4l/tda8290.o
>  CC [M]  /w/new/v4l-dvb/v4l/tea5767.o
>  CC [M]  /w/new/v4l-dvb/v4l/tea5761.o
>  CC [M]  /w/new/v4l-dvb/v4l/tda9887.o
>  CC [M]  /w/new/v4l-dvb/v4l/xc5000.o
>  CC [M]  /w/new/v4l-dvb/v4l/mc44s803.o
>  CC [M]  /w/new/v4l-dvb/v4l/v4l2-dev.o
>  CC [M]  /w/new/v4l-dvb/v4l/v4l2-ioctl.o
>  CC [M]  /w/new/v4l-dvb/v4l/v4l2-device.o
>  CC [M]  /w/new/v4l-dvb/v4l/v4l2-subdev.o
>  LD [M]  /w/new/v4l-dvb/v4l/videodev.o
>  CC [M]  /w/new/v4l-dvb/v4l/v4l2-int-device.o
>  CC [M]  /w/new/v4l-dvb/v4l/v4l2-common.o
> /w/new/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_i2c_new_subdev':
> /w/new/v4l-dvb/v4l/v4l2-common.c:834: warning: format not a string
> literal and no format arguments
> /w/new/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_i2c_new_probed_subdev':
> /w/new/v4l-dvb/v4l/v4l2-common.c:902: warning: format not a string
> literal and no format arguments
>  CC [M]  /w/new/v4l-dvb/v4l/v4l1-compat.o
>  CC [M]  /w/new/v4l-dvb/v4l/dsbr100.o
> In file included from /w/new/v4l-dvb/v4l/dsbr100.c:94:
> /w/new/v4l-dvb/v4l/compat.h:396: error: redefinition of 'usb_endpoint_type'
> include/linux/usb/ch9.h:377: error: previous definition of
> 'usb_endpoint_type' was here
> make[3]: *** [/w/new/v4l-dvb/v4l/dsbr100.o] Error 1
> make[2]: *** [_module_/w/new/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/w/new/v4l-dvb/v4l'
> make: *** [all] Error 2
> tux v4l-dvb #
>
> Well, i have such messages for radio-si470x and radio-mr800 too.
> This drivers compile ok in kernel from kernel.org.
> As i understand this is compat.h trouble ?

In case if someone interesting i did such change that made it works:

diff -r 5567e82c34a0 v4l/compat.h
--- a/v4l/compat.h      Tue Mar 31 07:24:14 2009 -0300
+++ b/v4l/compat.h      Wed Apr 01 03:08:17 2009 +0400
@@ -393,10 +393,7 @@
 #endif

 #ifdef NEED_USB_ENDPOINT_TYPE
-static inline int usb_endpoint_type(const struct usb_endpoint_descriptor *epd)
-{
-       return epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
-}
+#include <linux/usb/ch9.h>
 #endif
 #endif /* __LINUX_USB_H */

I understand that this is probably wrong approach.
It's very likely connected with patch
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4d6914b72966862f37de634299a80ca2a4b1829f

USB: Move definitions from usb.h to usb/ch9.h

The functions:

usb_endpoint_dir_in(epd)
usb_endpoint_dir_out(epd)
usb_endpoint_is_bulk_in(epd)
usb_endpoint_is_bulk_out(epd)
usb_endpoint_is_int_in(epd)
usb_endpoint_is_int_out(epd)
usb_endpoint_is_isoc_in(epd)
usb_endpoint_is_isoc_out(epd)
usb_endpoint_num(epd)
usb_endpoint_type(epd)
usb_endpoint_xfer_bulk(epd)
usb_endpoint_xfer_control(epd)
usb_endpoint_xfer_int(epd)
usb_endpoint_xfer_isoc(epd)

are moved from include/linux/usb.h to include/linux/usb/ch9.h.
include/linux/usb/ch9.h makes more sense for these functions because they
only depend on constants that are defined in this file.

-- 
Best regards, Klimov Alexey
