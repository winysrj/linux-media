Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50653 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbeEDKEh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 06:04:37 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Harry Wei <harryxiyou@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Brian Warner <brian.warner@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Benoit Parrot <bparrot@ti.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Bhumika Goyal <bhumirks@gmail.com>, Sean Young <sean@mess.org>,
        Brad Love <brad@nextdimension.cc>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Yong Zhi <yong.zhi@intel.com>, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kamil Rytarowski <n54@gmx.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        linux-doc@vger.kernel.org, linux-kernel@zh-kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] MAINTAINERS & files: Canonize the e-mails I use at files
Date: Fri,  4 May 2018 06:04:17 -0400
Message-Id: <85bfc919e068ea7bb1e9b533ac6f60798844a5c0.1525428104.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From now on, I'll start using my @kernel.org as my development e-mail.

As such, let's remove the entries that point to the old
mchehab@s-opensource.com at MAINTAINERS file.

For the files written with a copyright with mchehab@s-opensource,
let's keep Samsung on their names, using mchehab+samsung@kernel.org,
in order to keep pointing to my employer, with sponsors the work.

For the files written before I join Samsung (on July, 4 2013),
let's just use mchehab@kernel.org.

For bug reports, we can simply point to just kernel.org, as
this will reach my mchehab+samsung inbox anyway.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Brian Warner <brian.warner@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/doc-guide/parse-headers.rst       |  4 ++--
 Documentation/media/uapi/rc/keytable.c.rst      |  2 +-
 Documentation/media/uapi/v4l/v4l2grab.c.rst     |  2 +-
 Documentation/sphinx/parse-headers.pl           |  4 ++--
 .../zh_CN/video4linux/v4l2-framework.txt        |  4 ++--
 MAINTAINERS                                     | 17 -----------------
 drivers/media/i2c/saa7115.c                     |  2 +-
 drivers/media/i2c/saa711x_regs.h                |  2 +-
 drivers/media/i2c/tda7432.c                     |  2 +-
 drivers/media/i2c/tvp5150.c                     |  2 +-
 drivers/media/i2c/tvp5150_reg.h                 |  2 +-
 drivers/media/i2c/tvp7002.c                     |  2 +-
 drivers/media/i2c/tvp7002_reg.h                 |  2 +-
 drivers/media/media-devnode.c                   |  2 +-
 drivers/media/pci/bt8xx/bttv-audio-hook.c       |  2 +-
 drivers/media/pci/bt8xx/bttv-audio-hook.h       |  2 +-
 drivers/media/pci/bt8xx/bttv-cards.c            |  4 ++--
 drivers/media/pci/bt8xx/bttv-driver.c           |  2 +-
 drivers/media/pci/bt8xx/bttv-i2c.c              |  2 +-
 drivers/media/pci/cx23885/cx23885-input.c       |  2 +-
 drivers/media/pci/cx88/cx88-alsa.c              |  4 ++--
 drivers/media/pci/cx88/cx88-blackbird.c         |  2 +-
 drivers/media/pci/cx88/cx88-core.c              |  2 +-
 drivers/media/pci/cx88/cx88-i2c.c               |  2 +-
 drivers/media/pci/cx88/cx88-video.c             |  2 +-
 drivers/media/radio/radio-aimslab.c             |  2 +-
 drivers/media/radio/radio-aztech.c              |  2 +-
 drivers/media/radio/radio-gemtek.c              |  2 +-
 drivers/media/radio/radio-maxiradio.c           |  2 +-
 drivers/media/radio/radio-rtrack2.c             |  2 +-
 drivers/media/radio/radio-sf16fmi.c             |  2 +-
 drivers/media/radio/radio-terratec.c            |  2 +-
 drivers/media/radio/radio-trust.c               |  2 +-
 drivers/media/radio/radio-typhoon.c             |  2 +-
 drivers/media/radio/radio-zoltrix.c             |  2 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c   |  2 +-
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c |  2 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c     |  2 +-
 drivers/media/rc/keymaps/rc-kaiomy.c            |  2 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c |  2 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c     |  2 +-
 drivers/media/tuners/tea5761.c                  |  4 ++--
 drivers/media/tuners/tea5767.c                  |  4 ++--
 drivers/media/tuners/tuner-xc2028-types.h       |  2 +-
 drivers/media/tuners/tuner-xc2028.c             |  4 ++--
 drivers/media/tuners/tuner-xc2028.h             |  2 +-
 drivers/media/usb/em28xx/em28xx-camera.c        |  2 +-
 drivers/media/usb/em28xx/em28xx-cards.c         |  2 +-
 drivers/media/usb/em28xx/em28xx-core.c          |  4 ++--
 drivers/media/usb/em28xx/em28xx-dvb.c           |  4 ++--
 drivers/media/usb/em28xx/em28xx-i2c.c           |  2 +-
 drivers/media/usb/em28xx/em28xx-input.c         |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c         |  4 ++--
 drivers/media/usb/em28xx/em28xx.h               |  2 +-
 drivers/media/usb/gspca/zc3xx-reg.h             |  2 +-
 drivers/media/usb/tm6000/tm6000-cards.c         |  2 +-
 drivers/media/usb/tm6000/tm6000-core.c          |  2 +-
 drivers/media/usb/tm6000/tm6000-i2c.c           |  2 +-
 drivers/media/usb/tm6000/tm6000-regs.h          |  2 +-
 drivers/media/usb/tm6000/tm6000-usb-isoc.h      |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c         |  2 +-
 drivers/media/usb/tm6000/tm6000.h               |  2 +-
 drivers/media/v4l2-core/v4l2-dev.c              |  4 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c            |  2 +-
 drivers/media/v4l2-core/videobuf-core.c         |  6 +++---
 drivers/media/v4l2-core/videobuf-dma-contig.c   |  2 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c       |  6 +++---
 drivers/media/v4l2-core/videobuf-vmalloc.c      |  4 ++--
 include/media/i2c/tvp7002.h                     |  2 +-
 include/media/videobuf-core.h                   |  4 ++--
 include/media/videobuf-dma-sg.h                 |  4 ++--
 include/media/videobuf-vmalloc.h                |  2 +-
 scripts/extract_xc3028.pl                       |  2 +-
 scripts/split-man.pl                            |  2 +-
 74 files changed, 92 insertions(+), 109 deletions(-)

diff --git a/Documentation/doc-guide/parse-headers.rst b/Documentation/doc-guide/parse-headers.rst
index 96a0423d5dba..82a3e43b6864 100644
--- a/Documentation/doc-guide/parse-headers.rst
+++ b/Documentation/doc-guide/parse-headers.rst
@@ -177,14 +177,14 @@ BUGS
 ****
 
 
-Report bugs to Mauro Carvalho Chehab <mchehab@s-opensource.com>
+Report bugs to Mauro Carvalho Chehab <mchehab@kernel.org>
 
 
 COPYRIGHT
 *********
 
 
-Copyright (c) 2016 by Mauro Carvalho Chehab <mchehab@s-opensource.com>.
+Copyright (c) 2016 by Mauro Carvalho Chehab <mchehab+samsung@kernel.org>.
 
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 
diff --git a/Documentation/media/uapi/rc/keytable.c.rst b/Documentation/media/uapi/rc/keytable.c.rst
index e6ce1e3f5a78..217237f93b37 100644
--- a/Documentation/media/uapi/rc/keytable.c.rst
+++ b/Documentation/media/uapi/rc/keytable.c.rst
@@ -7,7 +7,7 @@ file: uapi/v4l/keytable.c
 
     /* keytable.c - This program allows checking/replacing keys at IR
 
-       Copyright (C) 2006-2009 Mauro Carvalho Chehab <mchehab@infradead.org>
+       Copyright (C) 2006-2009 Mauro Carvalho Chehab <mchehab@kernel.org>
 
        This program is free software; you can redistribute it and/or modify
        it under the terms of the GNU General Public License as published by
diff --git a/Documentation/media/uapi/v4l/v4l2grab.c.rst b/Documentation/media/uapi/v4l/v4l2grab.c.rst
index 5aabd0b7b089..f0d0ab6abd41 100644
--- a/Documentation/media/uapi/v4l/v4l2grab.c.rst
+++ b/Documentation/media/uapi/v4l/v4l2grab.c.rst
@@ -6,7 +6,7 @@ file: media/v4l/v4l2grab.c
 .. code-block:: c
 
     /* V4L2 video picture grabber
-       Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@infradead.org>
+       Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@kernel.org>
 
        This program is free software; you can redistribute it and/or modify
        it under the terms of the GNU General Public License as published by
diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index a958d8b5e99d..d410f47567e9 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -387,11 +387,11 @@ tree for more details.
 
 =head1 BUGS
 
-Report bugs to Mauro Carvalho Chehab <mchehab@s-opensource.com>
+Report bugs to Mauro Carvalho Chehab <mchehab@kernel.org>
 
 =head1 COPYRIGHT
 
-Copyright (c) 2016 by Mauro Carvalho Chehab <mchehab@s-opensource.com>.
+Copyright (c) 2016 by Mauro Carvalho Chehab <mchehab+samsung@kernel.org>.
 
 License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
 
diff --git a/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt b/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
index 698660b7f21f..c77c0f060864 100644
--- a/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
+++ b/Documentation/translations/zh_CN/video4linux/v4l2-framework.txt
@@ -6,7 +6,7 @@ communicating in English you can also ask the Chinese maintainer for
 help.  Contact the Chinese maintainer if this translation is outdated
 or if there is a problem with the translation.
 
-Maintainer: Mauro Carvalho Chehab <mchehab@infradead.org>
+Maintainer: Mauro Carvalho Chehab <mchehab@kernel.org>
 Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
 ---------------------------------------------------------------------
 Documentation/video4linux/v4l2-framework.txt 的中文翻译
@@ -14,7 +14,7 @@ Documentation/video4linux/v4l2-framework.txt 的中文翻译
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
 译存在问题，请联系中文版维护者。
-英文版维护者： Mauro Carvalho Chehab <mchehab@infradead.org>
+英文版维护者： Mauro Carvalho Chehab <mchehab@kernel.org>
 中文版维护者： 傅炜 Fu Wei <tekkamanninja@gmail.com>
 中文版翻译者： 傅炜 Fu Wei <tekkamanninja@gmail.com>
 中文版校译者： 傅炜 Fu Wei <tekkamanninja@gmail.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 0a1410d5a621..50f54b0cda91 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2549,7 +2549,6 @@ F:	Documentation/devicetree/bindings/sound/axentia,*
 F:	sound/soc/atmel/tse850-pcm5142.c
 
 AZ6007 DVB DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -3078,7 +3077,6 @@ F:	include/linux/btrfs*
 F:	include/uapi/linux/btrfs*
 
 BTTV VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -3807,7 +3805,6 @@ S:	Maintained
 F:	drivers/media/dvb-frontends/cx24120*
 
 CX88 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -5045,7 +5042,6 @@ F:	drivers/edac/thunderx_edac*
 
 EDAC-CORE
 M:	Borislav Petkov <bp@alien8.de>
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-edac@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-next
@@ -5074,7 +5070,6 @@ S:	Maintained
 F:	drivers/edac/fsl_ddr_edac.*
 
 EDAC-GHES
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
@@ -5091,21 +5086,18 @@ S:	Maintained
 F:	drivers/edac/i5000_edac.c
 
 EDAC-I5400
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	drivers/edac/i5400_edac.c
 
 EDAC-I7300
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	drivers/edac/i7300_edac.c
 
 EDAC-I7CORE
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
@@ -5155,7 +5147,6 @@ S:	Maintained
 F:	drivers/edac/r82600_edac.c
 
 EDAC-SBRIDGE
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
@@ -5214,7 +5205,6 @@ S:	Maintained
 F:	drivers/net/ethernet/ibm/ehea/
 
 EM28XX VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -8852,7 +8842,6 @@ F:	Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
 F:	drivers/staging/media/tegra-vde/
 
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
@@ -12240,7 +12229,6 @@ S:	Odd Fixes
 F:	drivers/media/i2c/saa6588*
 
 SAA7134 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -12744,7 +12732,6 @@ S:	Maintained
 F:	drivers/media/radio/si4713/radio-usb-si4713.c
 
 SIANO DVB DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -13734,7 +13721,6 @@ S:	Maintained
 F:	drivers/media/i2c/tda9840*
 
 TEA5761 TUNER DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -13743,7 +13729,6 @@ S:	Odd fixes
 F:	drivers/media/tuners/tea5761.*
 
 TEA5767 TUNER DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -14160,7 +14145,6 @@ F:	Documentation/networking/tlan.txt
 F:	drivers/net/ethernet/ti/tlan.*
 
 TM6000 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
@@ -15387,7 +15371,6 @@ S:	Maintained
 F:	arch/x86/entry/vdso/
 
 XC2028/3028 TUNER DRIVER
-M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 L:	linux-media@vger.kernel.org
 W:	https://linuxtv.org
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index e216cd768409..b07114b5efb2 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -20,7 +20,7 @@
 //
 // VBI support (2004) and cleanups (2005) by Hans Verkuil <hverkuil@xs4all.nl>
 //
-// Copyright (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+// Copyright (c) 2005-2006 Mauro Carvalho Chehab <mchehab@kernel.org>
 //	SAA7111, SAA7113 and SAA7118 support
 
 #include "saa711x_regs.h"
diff --git a/drivers/media/i2c/saa711x_regs.h b/drivers/media/i2c/saa711x_regs.h
index a50d480e101a..44fabe08234d 100644
--- a/drivers/media/i2c/saa711x_regs.h
+++ b/drivers/media/i2c/saa711x_regs.h
@@ -2,7 +2,7 @@
  * SPDX-License-Identifier: GPL-2.0+
  * saa711x - Philips SAA711x video decoder register specifications
  *
- * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 #define R_00_CHIP_VERSION                             0x00
diff --git a/drivers/media/i2c/tda7432.c b/drivers/media/i2c/tda7432.c
index 1c5c61d829d6..9b4f21237810 100644
--- a/drivers/media/i2c/tda7432.c
+++ b/drivers/media/i2c/tda7432.c
@@ -8,7 +8,7 @@
  * Muting and tone control by Jonathan Isom <jisom@ematic.com>
  *
  * Copyright (c) 2000 Eric Sandeen <eric_sandeen@bigfoot.com>
- * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  * This code is placed under the terms of the GNU General Public License
  * Based on tda9855.c by Steve VanDeBogart (vandebo@uclink.berkeley.edu)
  * Which was based on tda8425.c by Greg Alexander (c) 1998
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 2476d812f669..1734ed4ede33 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -2,7 +2,7 @@
 //
 // tvp5150 - Texas Instruments TVP5150A/AM1 and TVP5151 video decoder driver
 //
-// Copyright (c) 2005,2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+// Copyright (c) 2005,2006 Mauro Carvalho Chehab <mchehab@kernel.org>
 
 #include <dt-bindings/media/tvp5150.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/i2c/tvp5150_reg.h b/drivers/media/i2c/tvp5150_reg.h
index c43b7b844021..d3a764cae1a0 100644
--- a/drivers/media/i2c/tvp5150_reg.h
+++ b/drivers/media/i2c/tvp5150_reg.h
@@ -3,7 +3,7 @@
  *
  * tvp5150 - Texas Instruments TVP5150A/AM1 video decoder registers
  *
- * Copyright (c) 2005,2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Copyright (c) 2005,2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 #define TVP5150_VD_IN_SRC_SEL_1      0x00 /* Video input source selection #1 */
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index a26c1a3f7183..4599b7e28a8d 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -5,7 +5,7 @@
  * Author: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
  *
  * This code is partially based upon the TVP5150 driver
- * written by Mauro Carvalho Chehab (mchehab@infradead.org),
+ * written by Mauro Carvalho Chehab <mchehab@kernel.org>,
  * the TVP514x driver written by Vaibhav Hiremath <hvaibhav@ti.com>
  * and the TVP7002 driver in the TI LSP 2.10.00.14. Revisions by
  * Muralidharan Karicheri and Snehaprabha Narnakaje (TI).
diff --git a/drivers/media/i2c/tvp7002_reg.h b/drivers/media/i2c/tvp7002_reg.h
index 3c8c8b0a6a4c..7f56ba689dfe 100644
--- a/drivers/media/i2c/tvp7002_reg.h
+++ b/drivers/media/i2c/tvp7002_reg.h
@@ -5,7 +5,7 @@
  * Author: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
  *
  * This code is partially based upon the TVP5150 driver
- * written by Mauro Carvalho Chehab (mchehab@infradead.org),
+ * written by Mauro Carvalho Chehab <mchehab@kernel.org>,
  * the TVP514x driver written by Vaibhav Hiremath <hvaibhav@ti.com>
  * and the TVP7002 driver in the TI LSP 2.10.00.14
  *
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 67ac51eff15c..6b87a721dc49 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2010 Nokia Corporation
  *
  * Based on drivers/media/video/v4l2_dev.c code authored by
- *	Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
+ *	Mauro Carvalho Chehab <mchehab@kernel.org> (version 2)
  *	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
  *
  * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
diff --git a/drivers/media/pci/bt8xx/bttv-audio-hook.c b/drivers/media/pci/bt8xx/bttv-audio-hook.c
index 9f1f9169fb5b..346fc7f58839 100644
--- a/drivers/media/pci/bt8xx/bttv-audio-hook.c
+++ b/drivers/media/pci/bt8xx/bttv-audio-hook.c
@@ -1,7 +1,7 @@
 /*
  * Handlers for board audio hooks, splitted from bttv-cards
  *
- * Copyright (c) 2006 Mauro Carvalho Chehab (mchehab@infradead.org)
+ * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  * This code is placed under the terms of the GNU General Public License
  */
 
diff --git a/drivers/media/pci/bt8xx/bttv-audio-hook.h b/drivers/media/pci/bt8xx/bttv-audio-hook.h
index 159d07adeff8..be16a537a03a 100644
--- a/drivers/media/pci/bt8xx/bttv-audio-hook.h
+++ b/drivers/media/pci/bt8xx/bttv-audio-hook.h
@@ -1,7 +1,7 @@
 /*
  * Handlers for board audio hooks, splitted from bttv-cards
  *
- * Copyright (c) 2006 Mauro Carvalho Chehab (mchehab@infradead.org)
+ * Copyright (c) 2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  * This code is placed under the terms of the GNU General Public License
  */
 
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 1902732f90e1..2616243b2c49 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -2447,7 +2447,7 @@ struct tvcard bttv_tvcards[] = {
 	},
 		/* ---- card 0x88---------------------------------- */
 	[BTTV_BOARD_ACORP_Y878F] = {
-		/* Mauro Carvalho Chehab <mchehab@infradead.org> */
+		/* Mauro Carvalho Chehab <mchehab@kernel.org> */
 		.name		= "Acorp Y878F",
 		.video_inputs	= 3,
 		/* .audio_inputs= 1, */
@@ -2688,7 +2688,7 @@ struct tvcard bttv_tvcards[] = {
 	},
 	[BTTV_BOARD_ENLTV_FM_2] = {
 		/* Encore TV Tuner Pro ENL TV-FM-2
-		   Mauro Carvalho Chehab <mchehab@infradead.org */
+		   Mauro Carvalho Chehab <mchehab@kernel.org> */
 		.name           = "Encore ENL TV-FM-2",
 		.video_inputs   = 3,
 		/* .audio_inputs= 1, */
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 707f57a9f940..de3f44b8dec6 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -13,7 +13,7 @@
     (c) 2005-2006 Nickolay V. Shmyrev <nshmyrev@yandex.ru>
 
     Fixes to be fully V4L2 compliant by
-    (c) 2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+    (c) 2006 Mauro Carvalho Chehab <mchehab@kernel.org>
 
     Cropping and overscan support
     Copyright (C) 2005, 2006 Michael H. Schimek <mschimek@gmx.at>
diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index eccd1e3d717a..c76823eb399d 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -8,7 +8,7 @@
 			   & Marcus Metzler (mocm@thp.uni-koeln.de)
     (c) 1999-2003 Gerd Knorr <kraxel@bytesex.org>
 
-    (c) 2005 Mauro Carvalho Chehab <mchehab@infradead.org>
+    (c) 2005 Mauro Carvalho Chehab <mchehab@kernel.org>
 	- Multituner support and i2c address binding
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index be49589a61d2..395ff9bba759 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -13,7 +13,7 @@
  *  Copyright (C) 2008 <srinivasa.deevi at conexant dot com>
  *  Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
  *		       Markus Rechberger <mrechberger@gmail.com>
- *		       Mauro Carvalho Chehab <mchehab@infradead.org>
+ *		       Mauro Carvalho Chehab <mchehab@kernel.org>
  *		       Sascha Sommer <saschasommer@freenet.de>
  *  Copyright (C) 2004, 2005 Chris Pascoe
  *  Copyright (C) 2003, 2004 Gerd Knorr
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index ab09bb55cf45..8a28fda703a2 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -4,7 +4,7 @@
  *
  *    (c) 2007 Trent Piepho <xyzzy@speakeasy.org>
  *    (c) 2005,2006 Ricardo Cerqueira <v4l@cerqueira.org>
- *    (c) 2005 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *    (c) 2005 Mauro Carvalho Chehab <mchehab@kernel.org>
  *    Based on a dummy cx88 module by Gerd Knorr <kraxel@bytesex.org>
  *    Based on dummy.c by Jaroslav Kysela <perex@perex.cz>
  *
@@ -103,7 +103,7 @@ MODULE_PARM_DESC(index, "Index value for cx88x capture interface(s).");
 
 MODULE_DESCRIPTION("ALSA driver module for cx2388x based TV cards");
 MODULE_AUTHOR("Ricardo Cerqueira");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(CX88_VERSION);
 
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 0e0952e60795..7a4876cf9f08 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -5,7 +5,7 @@
  *    (c) 2004 Jelle Foks <jelle@foks.us>
  *    (c) 2004 Gerd Knorr <kraxel@bytesex.org>
  *
- *    (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+ *    (c) 2005-2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  *        - video_ioctl2 conversion
  *
  *  Includes parts from the ivtv driver <http://sourceforge.net/projects/ivtv/>
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 8bfa5b7ed91b..60988e95b637 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -4,7 +4,7 @@
  *
  * (c) 2003 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
  *
- * (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * (c) 2005-2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  *     - Multituner support
  *     - video_ioctl2 conversion
  *     - PAL/M fixes
diff --git a/drivers/media/pci/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
index f7692775fb5a..99f88a05a7c9 100644
--- a/drivers/media/pci/cx88/cx88-i2c.c
+++ b/drivers/media/pci/cx88/cx88-i2c.c
@@ -8,7 +8,7 @@
  * (c) 2002 Yurij Sysoev <yurij@naturesoft.net>
  * (c) 1999-2003 Gerd Knorr <kraxel@bytesex.org>
  *
- * (c) 2005 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * (c) 2005 Mauro Carvalho Chehab <mchehab@kernel.org>
  *	- Multituner support and i2c address binding
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 9be682cdb644..7b113bad70d2 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -5,7 +5,7 @@
  *
  * (c) 2003-04 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
  *
- * (c) 2005-2006 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * (c) 2005-2006 Mauro Carvalho Chehab <mchehab@kernel.org>
  *	- Multituner support
  *	- video_ioctl2 conversion
  *	- PAL/M fixes
diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 5ef635e72e10..4c52ac6d8bc5 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -4,7 +4,7 @@
  * Copyright 1997 M. Kirkwood
  *
  * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
- * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@kernel.org>
  * Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index 9e12c6027359..840b7d60462b 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -2,7 +2,7 @@
  * radio-aztech.c - Aztech radio card driver
  *
  * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@xs4all.nl>
- * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@kernel.org>
  * Adapted to support the Video for Linux API by
  * Russell Kroll <rkroll@exploits.org>.  Based on original tuner code by:
  *
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 3ff4c4e1435f..f051f8694ab9 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -15,7 +15,7 @@
  *    Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
  * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
- * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@kernel.org>
  *
  * Note: this card seems to swap the left and right audio channels!
  *
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 95f06f3b35dc..e4e758739246 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -27,7 +27,7 @@
  * BUGS:
  *   - card unmutes if you change frequency
  *
- * (c) 2006, 2007 by Mauro Carvalho Chehab <mchehab@infradead.org>:
+ * (c) 2006, 2007 by Mauro Carvalho Chehab <mchehab@kernel.org>:
  *	- Conversion to V4L2 API
  *      - Uses video_ioctl2 for parsing and to add debug support
  */
diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-rtrack2.c
index abeaedd8d437..5a1470eb753e 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -7,7 +7,7 @@
  * Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
  * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
- * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@kernel.org>
  *
  * Fully tested with actual hardware and the v4l2-compliance tool.
  */
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index fc4e63d36e4c..4f9b97edd9eb 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -13,7 +13,7 @@
  *  No volume control - only mute/unmute - you have to use line volume
  *  control on SB-part of SF16-FMI/SF16-FMP/SF16-FMD
  *
- * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 #include <linux/kernel.h>	/* __setup			*/
diff --git a/drivers/media/radio/radio-terratec.c b/drivers/media/radio/radio-terratec.c
index 4f116ea294fb..1af8f29cc7d1 100644
--- a/drivers/media/radio/radio-terratec.c
+++ b/drivers/media/radio/radio-terratec.c
@@ -17,7 +17,7 @@
  *  Volume Control is done digitally
  *
  * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
- * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 #include <linux/module.h>	/* Modules			*/
diff --git a/drivers/media/radio/radio-trust.c b/drivers/media/radio/radio-trust.c
index 26a8c6002121..a4bad322ffff 100644
--- a/drivers/media/radio/radio-trust.c
+++ b/drivers/media/radio/radio-trust.c
@@ -12,7 +12,7 @@
  * Scott McGrath    (smcgrath@twilight.vtc.vsc.edu)
  * William McGrath  (wmcgrath@twilight.vtc.vsc.edu)
  *
- * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 #include <stdarg.h>
diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/radio-typhoon.c
index eb72a4d13758..d0d67ad85b8f 100644
--- a/drivers/media/radio/radio-typhoon.c
+++ b/drivers/media/radio/radio-typhoon.c
@@ -25,7 +25,7 @@
  * The frequency change is necessary since the card never seems to be
  * completely silent.
  *
- * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 #include <linux/module.h>	/* Modules                        */
diff --git a/drivers/media/radio/radio-zoltrix.c b/drivers/media/radio/radio-zoltrix.c
index 026e88eef29c..6007cd09b328 100644
--- a/drivers/media/radio/radio-zoltrix.c
+++ b/drivers/media/radio/radio-zoltrix.c
@@ -27,7 +27,7 @@
  * 2002-07-15 - Fix Stereo typo
  *
  * 2006-07-24 - Converted to V4L2 API
- *		by Mauro Carvalho Chehab <mchehab@infradead.org>
+ *		by Mauro Carvalho Chehab <mchehab@kernel.org>
  *
  * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@cisco.com>
  *
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index f6977df1a75b..d275d98d066a 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -12,7 +12,7 @@
  *
  * On Avermedia M135A with IR model RM-JX, the same codes exist on both
  * Positivo (BR) and original IR, initial version and remote control codes
- * added by Mauro Carvalho Chehab <mchehab@infradead.org>
+ * added by Mauro Carvalho Chehab <mchehab@kernel.org>
  *
  * Positivo also ships Avermedia M135A with model RM-K6, extra control
  * codes added by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index e4e78c1f4123..057c13b765ef 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 
 /* Encore ENLTV-FM v5.3
-   Mauro Carvalho Chehab <mchehab@infradead.org>
+   Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 static struct rc_map_table encore_enltv_fm53[] = {
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index c3d4437a6fda..cd0555924456 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 
 /* Encore ENLTV2-FM  - silver plastic - "Wand Media" written at the botton
-    Mauro Carvalho Chehab <mchehab@infradead.org> */
+    Mauro Carvalho Chehab <mchehab@kernel.org> */
 
 static struct rc_map_table encore_enltv2[] = {
 	{ 0x4c, KEY_POWER2 },
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index f0f88df18606..a00051339842 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 
 /* Kaiomy TVnPC U2
-   Mauro Carvalho Chehab <mchehab@infradead.org>
+   Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 static struct rc_map_table kaiomy[] = {
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index 453e04377de7..db5edde3eeb1 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 
 /* Kworld Plus TV Analog Lite PCI IR
-   Mauro Carvalho Chehab <mchehab@infradead.org>
+   Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 static struct rc_map_table kworld_plus_tv_analog[] = {
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index 791130f108ff..e4e34f2ccf74 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 
 /*
-   Mauro Carvalho Chehab <mchehab@infradead.org>
+   Mauro Carvalho Chehab <mchehab@kernel.org>
    present on PV MPEG 8000GT
  */
 
diff --git a/drivers/media/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
index 88b3e80c38ad..d78a2bdb3e36 100644
--- a/drivers/media/tuners/tea5761.c
+++ b/drivers/media/tuners/tea5761.c
@@ -2,7 +2,7 @@
 // For Philips TEA5761 FM Chip
 // I2C address is always 0x20 (0x10 at 7-bit mode).
 //
-// Copyright (c) 2005-2007 Mauro Carvalho Chehab (mchehab@infradead.org)
+// Copyright (c) 2005-2007 Mauro Carvalho Chehab <mchehab@kernel.org>
 
 #include <linux/i2c.h>
 #include <linux/slab.h>
@@ -337,5 +337,5 @@ EXPORT_SYMBOL_GPL(tea5761_attach);
 EXPORT_SYMBOL_GPL(tea5761_autodetection);
 
 MODULE_DESCRIPTION("Philips TEA5761 FM tuner driver");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
index 2b2c064d7dc3..016d0d5ec50b 100644
--- a/drivers/media/tuners/tea5767.c
+++ b/drivers/media/tuners/tea5767.c
@@ -2,7 +2,7 @@
 // For Philips TEA5767 FM Chip used on some TV Cards like Prolink Pixelview
 // I2C address is always 0xC0.
 //
-// Copyright (c) 2005 Mauro Carvalho Chehab (mchehab@infradead.org)
+// Copyright (c) 2005 Mauro Carvalho Chehab <mchehab@kernel.org>
 //
 // tea5767 autodetection thanks to Torsten Seeboth and Atsushi Nakagawa
 // from their contributions on DScaler.
@@ -469,5 +469,5 @@ EXPORT_SYMBOL_GPL(tea5767_attach);
 EXPORT_SYMBOL_GPL(tea5767_autodetection);
 
 MODULE_DESCRIPTION("Philips TEA5767 FM tuner driver");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/tuners/tuner-xc2028-types.h b/drivers/media/tuners/tuner-xc2028-types.h
index bb0437c36c03..50d017a4822a 100644
--- a/drivers/media/tuners/tuner-xc2028-types.h
+++ b/drivers/media/tuners/tuner-xc2028-types.h
@@ -5,7 +5,7 @@
  * This file includes internal tipes to be used inside tuner-xc2028.
  * Shouldn't be included outside tuner-xc2028
  *
- * Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
+ * Copyright (c) 2007-2008 Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 /* xc3028 firmware types */
diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index fca85e08ebd7..84744e138982 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // tuner-xc2028
 //
-// Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
+// Copyright (c) 2007-2008 Mauro Carvalho Chehab <mchehab@kernel.org>
 //
 // Copyright (c) 2007 Michel Ludwig (michel.ludwig@gmail.com)
 //       - frontend interface
@@ -1518,7 +1518,7 @@ EXPORT_SYMBOL(xc2028_attach);
 
 MODULE_DESCRIPTION("Xceive xc2028/xc3028 tuner driver");
 MODULE_AUTHOR("Michel Ludwig <michel.ludwig@gmail.com>");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
 MODULE_FIRMWARE(XC3028L_DEFAULT_FIRMWARE);
diff --git a/drivers/media/tuners/tuner-xc2028.h b/drivers/media/tuners/tuner-xc2028.h
index 03fd6d4233a4..7b58bc06e35c 100644
--- a/drivers/media/tuners/tuner-xc2028.h
+++ b/drivers/media/tuners/tuner-xc2028.h
@@ -2,7 +2,7 @@
  * SPDX-License-Identifier: GPL-2.0
  * tuner-xc2028
  *
- * Copyright (c) 2007-2008 Mauro Carvalho Chehab (mchehab@infradead.org)
+ * Copyright (c) 2007-2008 Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 #ifndef __TUNER_XC2028_H__
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 3c2694a16ed1..d1e66b503f4d 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -2,7 +2,7 @@
 //
 // em28xx-camera.c - driver for Empia EM25xx/27xx/28xx USB video capture devices
 //
-// Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@infradead.org>
+// Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@kernel.org>
 // Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
 //
 // This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6e0e67d23876..7c3203d7044b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -5,7 +5,7 @@
 //
 // Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
 //		      Markus Rechberger <mrechberger@gmail.com>
-//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Mauro Carvalho Chehab <mchehab@kernel.org>
 //		      Sascha Sommer <saschasommer@freenet.de>
 // Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
 //
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 36d341fb65dd..f28995383090 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -4,7 +4,7 @@
 //
 // Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
 //		      Markus Rechberger <mrechberger@gmail.com>
-//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Mauro Carvalho Chehab <mchehab@kernel.org>
 //		      Sascha Sommer <saschasommer@freenet.de>
 // Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
 //
@@ -32,7 +32,7 @@
 
 #define DRIVER_AUTHOR "Ludovico Cavedon <cavedon@sssup.it>, " \
 		      "Markus Rechberger <mrechberger@gmail.com>, " \
-		      "Mauro Carvalho Chehab <mchehab@infradead.org>, " \
+		      "Mauro Carvalho Chehab <mchehab@kernel.org>, " \
 		      "Sascha Sommer <saschasommer@freenet.de>"
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a54cb8dc52c9..3f493e0b0716 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -2,7 +2,7 @@
 //
 // DVB device driver for em28xx
 //
-// (c) 2008-2011 Mauro Carvalho Chehab <mchehab@infradead.org>
+// (c) 2008-2011 Mauro Carvalho Chehab <mchehab@kernel.org>
 //
 // (c) 2008 Devin Heitmueller <devin.heitmueller@gmail.com>
 //	- Fixes for the driver to properly work with HVR-950
@@ -63,7 +63,7 @@
 #include "tc90522.h"
 #include "qm1d1c0042.h"
 
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION(DRIVER_DESC " - digital TV interface");
 MODULE_VERSION(EM28XX_VERSION);
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9151bccd859a..6458682bc6e2 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -4,7 +4,7 @@
 //
 // Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
 //		      Markus Rechberger <mrechberger@gmail.com>
-//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Mauro Carvalho Chehab <mchehab@kernel.org>
 //		      Sascha Sommer <saschasommer@freenet.de>
 // Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
 //
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 2dc1be00b8b8..f84a1208d5d3 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -4,7 +4,7 @@
 //
 // Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
 //		      Markus Rechberger <mrechberger@gmail.com>
-//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Mauro Carvalho Chehab <mchehab@kernel.org>
 //		      Sascha Sommer <saschasommer@freenet.de>
 //
 // This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index d70ee13cc52e..68571bf36d28 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -5,7 +5,7 @@
 //
 // Copyright (C) 2005 Ludovico Cavedon <cavedon@sssup.it>
 //		      Markus Rechberger <mrechberger@gmail.com>
-//		      Mauro Carvalho Chehab <mchehab@infradead.org>
+//		      Mauro Carvalho Chehab <mchehab@kernel.org>
 //		      Sascha Sommer <saschasommer@freenet.de>
 // Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
 //
@@ -44,7 +44,7 @@
 
 #define DRIVER_AUTHOR "Ludovico Cavedon <cavedon@sssup.it>, " \
 		      "Markus Rechberger <mrechberger@gmail.com>, " \
-		      "Mauro Carvalho Chehab <mchehab@infradead.org>, " \
+		      "Mauro Carvalho Chehab <mchehab@kernel.org>, " \
 		      "Sascha Sommer <saschasommer@freenet.de>"
 
 static unsigned int isoc_debug;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 63c7c6124707..b0378e77ddff 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 2005 Markus Rechberger <mrechberger@gmail.com>
  *		      Ludovico Cavedon <cavedon@sssup.it>
- *		      Mauro Carvalho Chehab <mchehab@infradead.org>
+ *		      Mauro Carvalho Chehab <mchehab@kernel.org>
  * Copyright (C) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
  *
  * Based on the em2800 driver from Sascha Sommer <saschasommer@freenet.de>
diff --git a/drivers/media/usb/gspca/zc3xx-reg.h b/drivers/media/usb/gspca/zc3xx-reg.h
index a1bd94e8ce52..71fda38e85e0 100644
--- a/drivers/media/usb/gspca/zc3xx-reg.h
+++ b/drivers/media/usb/gspca/zc3xx-reg.h
@@ -1,7 +1,7 @@
 /*
  * zc030x registers
  *
- * Copyright (c) 2008 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Copyright (c) 2008 Mauro Carvalho Chehab <mchehab@kernel.org>
  *
  * The register aliases used here came from this driver:
  *	http://zc0302.sourceforge.net/zc0302.php
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 70939e96b856..23df50aa0a4a 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // tm6000-cards.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 //
-// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@kernel.org>
 
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/drivers/media/usb/tm6000/tm6000-core.c b/drivers/media/usb/tm6000/tm6000-core.c
index 23a1332d98e6..d3229aa45fcb 100644
--- a/drivers/media/usb/tm6000/tm6000-core.c
+++ b/drivers/media/usb/tm6000/tm6000-core.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // tm6000-core.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 //
-// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@kernel.org>
 //
 // Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
 //     - DVB-T support
diff --git a/drivers/media/usb/tm6000/tm6000-i2c.c b/drivers/media/usb/tm6000/tm6000-i2c.c
index c9a62bbff27a..659b63febf85 100644
--- a/drivers/media/usb/tm6000/tm6000-i2c.c
+++ b/drivers/media/usb/tm6000/tm6000-i2c.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // tm6000-i2c.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 //
-// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@kernel.org>
 //
 // Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
 //	- Fix SMBus Read Byte command
diff --git a/drivers/media/usb/tm6000/tm6000-regs.h b/drivers/media/usb/tm6000/tm6000-regs.h
index 21587fcf11e3..d10424673db9 100644
--- a/drivers/media/usb/tm6000/tm6000-regs.h
+++ b/drivers/media/usb/tm6000/tm6000-regs.h
@@ -2,7 +2,7 @@
  * SPDX-License-Identifier: GPL-2.0
  * tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
- * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 /*
diff --git a/drivers/media/usb/tm6000/tm6000-usb-isoc.h b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
index 5c615b0a7a46..b275dbce3a1b 100644
--- a/drivers/media/usb/tm6000/tm6000-usb-isoc.h
+++ b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
@@ -2,7 +2,7 @@
  * SPDX-License-Identifier: GPL-2.0
  * tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
- * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@kernel.org>
  */
 
 #include <linux/videodev2.h>
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index b2399d4266da..aa85fe31c835 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // tm6000-video.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 //
-// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@kernel.org>
 //
 // Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
 //	- Fixed module load/unload
diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
index e1e45770e28d..0864ed7314eb 100644
--- a/drivers/media/usb/tm6000/tm6000.h
+++ b/drivers/media/usb/tm6000/tm6000.h
@@ -2,7 +2,7 @@
  * SPDX-License-Identifier: GPL-2.0
  * tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
- * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
+ * Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@kernel.org>
  *
  * Copyright (c) 2007 Michel Ludwig <michel.ludwig@gmail.com>
  *	- DVB-T support
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 1d0b2208e8fb..c080dcc75393 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -10,7 +10,7 @@
  *	2 of the License, or (at your option) any later version.
  *
  * Authors:	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
- *              Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
+ *              Mauro Carvalho Chehab <mchehab@kernel.org> (version 2)
  *
  * Fixes:	20000516  Claudio Matsuoka <claudio@conectiva.com>
  *		- Added procfs support
@@ -1072,7 +1072,7 @@ static void __exit videodev_exit(void)
 subsys_initcall(videodev_init);
 module_exit(videodev_exit)
 
-MODULE_AUTHOR("Alan Cox, Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Alan Cox, Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_DESCRIPTION("Device registrar for Video4Linux drivers v2");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(VIDEO_MAJOR);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f48c505550e0..de5d96dbe69e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -9,7 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  *
  * Authors:	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
- *              Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
+ *              Mauro Carvalho Chehab <mchehab@kernel.org> (version 2)
  */
 
 #include <linux/mm.h>
diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index 2b3981842b4b..7491b337002c 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -1,11 +1,11 @@
 /*
  * generic helper functions for handling video4linux capture buffers
  *
- * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2007 Mauro Carvalho Chehab, <mchehab@kernel.org>
  *
  * Highly based on video-buf written originally by:
  * (c) 2001,02 Gerd Knorr <kraxel@bytesex.org>
- * (c) 2006 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2006 Mauro Carvalho Chehab, <mchehab@kernel.org>
  * (c) 2006 Ted Walther and John Sokol
  *
  * This program is free software; you can redistribute it and/or modify
@@ -38,7 +38,7 @@ static int debug;
 module_param(debug, int, 0644);
 
 MODULE_DESCRIPTION("helper module to manage video4linux buffers");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_LICENSE("GPL");
 
 #define dprintk(level, fmt, arg...)					\
diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index e02353e340dd..f46132504d88 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -7,7 +7,7 @@
  * Copyright (c) 2008 Magnus Damm
  *
  * Based on videobuf-vmalloc.c,
- * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2007 Mauro Carvalho Chehab, <mchehab@kernel.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index add2edb23eac..7770034aae28 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -6,11 +6,11 @@
  * into PAGE_SIZE chunks).  They also assume the driver does not need
  * to touch the video data.
  *
- * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2007 Mauro Carvalho Chehab, <mchehab@kernel.org>
  *
  * Highly based on video-buf written originally by:
  * (c) 2001,02 Gerd Knorr <kraxel@bytesex.org>
- * (c) 2006 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2006 Mauro Carvalho Chehab, <mchehab@kernel.org>
  * (c) 2006 Ted Walther and John Sokol
  *
  * This program is free software; you can redistribute it and/or modify
@@ -48,7 +48,7 @@ static int debug;
 module_param(debug, int, 0644);
 
 MODULE_DESCRIPTION("helper module to manage video4linux dma sg buffers");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_LICENSE("GPL");
 
 #define dprintk(level, fmt, arg...)					\
diff --git a/drivers/media/v4l2-core/videobuf-vmalloc.c b/drivers/media/v4l2-core/videobuf-vmalloc.c
index 2ff7fcc77b11..45fe781aeeec 100644
--- a/drivers/media/v4l2-core/videobuf-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf-vmalloc.c
@@ -6,7 +6,7 @@
  * into PAGE_SIZE chunks).  They also assume the driver does not need
  * to touch the video data.
  *
- * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2007 Mauro Carvalho Chehab, <mchehab@kernel.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -41,7 +41,7 @@ static int debug;
 module_param(debug, int, 0644);
 
 MODULE_DESCRIPTION("helper module to manage video4linux vmalloc buffers");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@kernel.org>");
 MODULE_LICENSE("GPL");
 
 #define dprintk(level, fmt, arg...)					\
diff --git a/include/media/i2c/tvp7002.h b/include/media/i2c/tvp7002.h
index 5ee007c1cead..cb213c136089 100644
--- a/include/media/i2c/tvp7002.h
+++ b/include/media/i2c/tvp7002.h
@@ -5,7 +5,7 @@
  * Author: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
  *
  * This code is partially based upon the TVP5150 driver
- * written by Mauro Carvalho Chehab (mchehab@infradead.org),
+ * written by Mauro Carvalho Chehab <mchehab@kernel.org>,
  * the TVP514x driver written by Vaibhav Hiremath <hvaibhav@ti.com>
  * and the TVP7002 driver in the TI LSP 2.10.00.14
  *
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 0bda0adc744f..60a664febba0 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -1,11 +1,11 @@
 /*
  * generic helper functions for handling video4linux capture buffers
  *
- * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2007 Mauro Carvalho Chehab, <mchehab@kernel.org>
  *
  * Highly based on video-buf written originally by:
  * (c) 2001,02 Gerd Knorr <kraxel@bytesex.org>
- * (c) 2006 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2006 Mauro Carvalho Chehab, <mchehab@kernel.org>
  * (c) 2006 Ted Walther and John Sokol
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index d8b27854e3bf..01bd142b979d 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -6,11 +6,11 @@
  * into PAGE_SIZE chunks).  They also assume the driver does not need
  * to touch the video data.
  *
- * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2007 Mauro Carvalho Chehab, <mchehab@kernel.org>
  *
  * Highly based on video-buf written originally by:
  * (c) 2001,02 Gerd Knorr <kraxel@bytesex.org>
- * (c) 2006 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2006 Mauro Carvalho Chehab, <mchehab@kernel.org>
  * (c) 2006 Ted Walther and John Sokol
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/media/videobuf-vmalloc.h b/include/media/videobuf-vmalloc.h
index 486a97efdb56..36c6a4ad3504 100644
--- a/include/media/videobuf-vmalloc.h
+++ b/include/media/videobuf-vmalloc.h
@@ -6,7 +6,7 @@
  * into PAGE_SIZE chunks).  They also assume the driver does not need
  * to touch the video data.
  *
- * (c) 2007 Mauro Carvalho Chehab, <mchehab@infradead.org>
+ * (c) 2007 Mauro Carvalho Chehab, <mchehab@kernel.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/scripts/extract_xc3028.pl b/scripts/extract_xc3028.pl
index 61d9b256c658..a1c51b7e4baf 100755
--- a/scripts/extract_xc3028.pl
+++ b/scripts/extract_xc3028.pl
@@ -1,6 +1,6 @@
 #!/usr/bin/env perl
 
-# Copyright (c) Mauro Carvalho Chehab <mchehab@infradead.org>
+# Copyright (c) Mauro Carvalho Chehab <mchehab@kernel.org>
 # Released under GPLv2
 #
 # In order to use, you need to:
diff --git a/scripts/split-man.pl b/scripts/split-man.pl
index bfe16cbe42df..c3db607ee9ec 100755
--- a/scripts/split-man.pl
+++ b/scripts/split-man.pl
@@ -1,7 +1,7 @@
 #!/usr/bin/perl
 # SPDX-License-Identifier: GPL-2.0
 #
-# Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
+# Author: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 #
 # Produce manpages from kernel-doc.
 # See Documentation/doc-guide/kernel-doc.rst for instructions
-- 
2.17.0
