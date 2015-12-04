Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbbLDMqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2015 07:46:30 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/4] MAINTAINERS: use https://linuxtv.org for LinuxTV URLs
Date: Fri,  4 Dec 2015 10:46:20 -0200
Message-Id: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While https was always supported on linuxtv.org, only in
Dec 3 2015 the website is using valid certificates.

As we're planning to drop pure http support on some
future, change all references at MAINTAINERS file
to point to the https URL instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 MAINTAINERS | 192 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 96 insertions(+), 96 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d6bba2850418..a04279769628 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -206,7 +206,7 @@ F:	include/trace/events/9p.h
 A8293 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -466,7 +466,7 @@ F:	sound/oss/aedsp16.c
 AF9013 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -476,7 +476,7 @@ F:	drivers/media/dvb-frontends/af9013*
 AF9033 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -522,7 +522,7 @@ AIMSLAB FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-aimslab*
 
@@ -536,7 +536,7 @@ F:	include/linux/*aio*.h
 AIRSPY MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -2063,7 +2063,7 @@ F:	net/ax25/
 AZ6007 DVB DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/dvb-usb-v2/az6007.c
@@ -2072,7 +2072,7 @@ AZTECH FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-aztech*
 
@@ -2125,7 +2125,7 @@ BDISP ST MEDIA DRIVER
 M:	Fabien Dessenne <fabien.dessenne@st.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Supported
 F:	drivers/media/platform/sti/bdisp
 
@@ -2518,7 +2518,7 @@ F:	fs/btrfs/
 BTTV VIDEO4LINUX DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	Documentation/video4linux/bttv/
@@ -2557,7 +2557,7 @@ CADET FM/AM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-cadet*
 
@@ -2850,7 +2850,7 @@ COBALT MEDIA DRIVER
 M:	Hans Verkuil <hans.verkuil@cisco.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Supported
 F:	drivers/media/pci/cobalt/
 
@@ -3109,7 +3109,7 @@ M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 W:	http://www.ivtvdriver.org/index.php/Cx18
 S:	Maintained
 F:	Documentation/video4linux/cx18.txt
@@ -3120,7 +3120,7 @@ CX2341X MPEG ENCODER HELPER MODULE
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/common/cx2341x*
 F:	include/media/cx2341x*
@@ -3129,7 +3129,7 @@ CX24120 MEDIA DRIVER
 M:	Jemma Denson <jdenson@gmail.com>
 M:	Patrick Boettcher <patrick.boettcher@posteo.de>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 S:	Maintained
 F:	drivers/media/dvb-frontends/cx24120*
@@ -3137,7 +3137,7 @@ F:	drivers/media/dvb-frontends/cx24120*
 CX88 VIDEO4LINUX DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	Documentation/video4linux/cx88/
@@ -3146,7 +3146,7 @@ F:	drivers/media/pci/cx88/
 CXD2820R MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3252,7 +3252,7 @@ F:	drivers/net/wan/pc300*
 CYPRESS_FIRMWARE MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3759,14 +3759,14 @@ DT3155 MEDIA DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/pci/dt3155/
 
 DVB_USB_AF9015 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3776,7 +3776,7 @@ F:	drivers/media/usb/dvb-usb-v2/af9015*
 DVB_USB_AF9035 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3786,7 +3786,7 @@ F:	drivers/media/usb/dvb-usb-v2/af9035*
 DVB_USB_ANYSEE MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3796,7 +3796,7 @@ F:	drivers/media/usb/dvb-usb-v2/anysee*
 DVB_USB_AU6610 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3806,7 +3806,7 @@ F:	drivers/media/usb/dvb-usb-v2/au6610*
 DVB_USB_CE6230 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3816,7 +3816,7 @@ F:	drivers/media/usb/dvb-usb-v2/ce6230*
 DVB_USB_CXUSB MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/media_tree.git
@@ -3826,7 +3826,7 @@ F:	drivers/media/usb/dvb-usb/cxusb*
 DVB_USB_EC168 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3836,7 +3836,7 @@ F:	drivers/media/usb/dvb-usb-v2/ec168*
 DVB_USB_GL861 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
@@ -3845,7 +3845,7 @@ F:	drivers/media/usb/dvb-usb-v2/gl861*
 DVB_USB_MXL111SF MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mkrufky/mxl111sf.git
@@ -3855,7 +3855,7 @@ F:	drivers/media/usb/dvb-usb-v2/mxl111sf*
 DVB_USB_RTL28XXU MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3865,7 +3865,7 @@ F:	drivers/media/usb/dvb-usb-v2/rtl28xxu*
 DVB_USB_V2 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3895,7 +3895,7 @@ F:	Documentation/devicetree/bindings/input/e3x0-button.txt
 E4000 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -3911,7 +3911,7 @@ F:	drivers/scsi/eata.c
 EC100 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -4135,7 +4135,7 @@ F:	drivers/net/ethernet/ibm/ehea/
 EM28XX VIDEO4LINUX DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/em28xx/
@@ -4275,7 +4275,7 @@ F:	drivers/media/tuners/fc0011.c
 FC2580 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -4644,7 +4644,7 @@ GEMTEK FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-gemtek*
 
@@ -4852,7 +4852,7 @@ HDPVR USB VIDEO ENCODER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/usb/hdpvr/
 
@@ -4871,7 +4871,7 @@ F:	drivers/tty/hvc/
 HACKRF MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -4914,7 +4914,7 @@ F:	sound/parisc/harmony.*
 HD29L2 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -5820,7 +5820,7 @@ ISA RADIO MODULE
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-isa*
 
@@ -5890,7 +5890,7 @@ F:	drivers/hwmon/it87.c
 IT913X MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -5911,7 +5911,7 @@ F:	include/uapi/linux/ivtv*
 IX2505V MEDIA DRIVER
 M:	Malcolm Priestley <tvboxspy@gmail.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 S:	Maintained
 F:	drivers/media/dvb-frontends/ix2505v*
@@ -6000,7 +6000,7 @@ KEENE FM RADIO TRANSMITTER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-keene*
 
@@ -6252,7 +6252,7 @@ F:	drivers/usb/misc/legousbtower.c
 LG2160 MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mkrufky/tuners.git
@@ -6262,7 +6262,7 @@ F:	drivers/media/dvb-frontends/lg2160.*
 LGDT3305 MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mkrufky/tuners.git
@@ -6518,7 +6518,7 @@ F:	drivers/hwmon/lm95234.c
 LME2510 MEDIA DRIVER
 M:	Malcolm Priestley <tvboxspy@gmail.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 S:	Maintained
 F:	drivers/media/usb/dvb-usb-v2/lmedm04*
@@ -6624,7 +6624,7 @@ F:	arch/m68k/hp300/
 M88DS3103 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -6634,7 +6634,7 @@ F:	drivers/media/dvb-frontends/m88ds3103*
 M88RS2000 MEDIA DRIVER
 M:	Malcolm Priestley <tvboxspy@gmail.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 S:	Maintained
 F:	drivers/media/dvb-frontends/m88rs2000*
@@ -6813,7 +6813,7 @@ MAXIRADIO FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-maxiradio*
 
@@ -6835,7 +6835,7 @@ F:	drivers/media/platform/vsp1/
 MEDIA DRIVERS FOR ASCOT2E
 M:	Sergey Kozlov <serjk@netup.ru>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 W:	http://netup.tv/
 T:	git git://linuxtv.org/media_tree.git
 S:	Supported
@@ -6844,7 +6844,7 @@ F:	drivers/media/dvb-frontends/ascot2e*
 MEDIA DRIVERS FOR CXD2841ER
 M:	Sergey Kozlov <serjk@netup.ru>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://netup.tv/
 T:	git git://linuxtv.org/media_tree.git
 S:	Supported
@@ -6853,7 +6853,7 @@ F:	drivers/media/dvb-frontends/cxd2841er*
 MEDIA DRIVERS FOR HORUS3A
 M:	Sergey Kozlov <serjk@netup.ru>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://netup.tv/
 T:	git git://linuxtv.org/media_tree.git
 S:	Supported
@@ -6862,7 +6862,7 @@ F:	drivers/media/dvb-frontends/horus3a*
 MEDIA DRIVERS FOR LNBH25
 M:	Sergey Kozlov <serjk@netup.ru>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://netup.tv/
 T:	git git://linuxtv.org/media_tree.git
 S:	Supported
@@ -6871,7 +6871,7 @@ F:	drivers/media/dvb-frontends/lnbh25*
 MEDIA DRIVERS FOR NETUP PCI UNIVERSAL DVB devices
 M:	Sergey Kozlov <serjk@netup.ru>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://netup.tv/
 T:	git git://linuxtv.org/media_tree.git
 S:	Supported
@@ -6881,7 +6881,7 @@ MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 Q:	http://patchwork.kernel.org/project/linux-media/list/
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
@@ -7042,7 +7042,7 @@ MIROSOUND PCM20 FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/radio/radio-miropcm20*
 
@@ -7078,7 +7078,7 @@ F:	drivers/iio/temperature/mlx90614.c
 MN88472 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -7089,7 +7089,7 @@ F:	drivers/media/dvb-frontends/mn88472.h
 MN88473 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -7144,7 +7144,7 @@ F:	drivers/platform/x86/msi-wmi.c
 MSI001 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -7154,7 +7154,7 @@ F:	drivers/media/tuners/msi001*
 MSI2500 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -7242,7 +7242,7 @@ F:	drivers/usb/musb/
 MXL5007T MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mkrufky/tuners.git
@@ -8735,7 +8735,7 @@ F:	include/uapi/linux/qnxtypes.h
 QT1010 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -9021,7 +9021,7 @@ F:	net/rose/
 RTL2830 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -9031,7 +9031,7 @@ F:	drivers/media/dvb-frontends/rtl2830*
 RTL2832 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -9041,7 +9041,7 @@ F:	drivers/media/dvb-frontends/rtl2832*
 RTL2832_SDR MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -9172,14 +9172,14 @@ SAA6588 RDS RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/i2c/saa6588*
 
 SAA7134 VIDEO4LINUX DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	Documentation/video4linux/*.saa7134
@@ -9614,7 +9614,7 @@ F:	drivers/misc/sgi-xp/
 SI2157 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -9624,7 +9624,7 @@ F:	drivers/media/tuners/si2157*
 SI2168 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -9635,7 +9635,7 @@ SI470X FM RADIO RECEIVER I2C DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/radio/si470x/radio-si470x-i2c.c
 
@@ -9643,7 +9643,7 @@ SI470X FM RADIO RECEIVER USB DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/si470x/radio-si470x-common.c
 F:	drivers/media/radio/si470x/radio-si470x.h
@@ -9653,7 +9653,7 @@ SI4713 FM RADIO TRANSMITTER I2C DRIVER
 M:	Eduardo Valentin <edubezval@gmail.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/radio/si4713/si4713.?
 
@@ -9661,7 +9661,7 @@ SI4713 FM RADIO TRANSMITTER PLATFORM DRIVER
 M:	Eduardo Valentin <edubezval@gmail.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/radio/si4713/radio-platform-si4713.c
 
@@ -9669,14 +9669,14 @@ SI4713 FM RADIO TRANSMITTER USB DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/si4713/radio-usb-si4713.c
 
 SIANO DVB DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/common/siano/
@@ -9742,7 +9742,7 @@ F:	drivers/i2c/busses/i2c-davinci.c
 TI DAVINCI SERIES MEDIA DRIVER
 M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
 S:	Maintained
@@ -9752,7 +9752,7 @@ F:	include/media/davinci/
 TI AM437X VPFE DRIVER
 M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
 S:	Maintained
@@ -9761,7 +9761,7 @@ F:	drivers/media/platform/am437x/
 OV2659 OMNIVISION SENSOR DRIVER
 M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
 S:	Maintained
@@ -10019,7 +10019,7 @@ F:	sound/soc/soc-generic-dmaengine-pcm.c
 SP2 MEDIA DRIVER
 M:	Olli Salonen <olli.salonen@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 S:	Maintained
 F:	drivers/media/dvb-frontends/sp2*
@@ -10381,7 +10381,7 @@ F:	net/ipv4/tcp_lp.c
 TDA10071 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -10391,7 +10391,7 @@ F:	drivers/media/dvb-frontends/tda10071*
 TDA18212 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -10401,7 +10401,7 @@ F:	drivers/media/tuners/tda18212*
 TDA18218 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -10411,7 +10411,7 @@ F:	drivers/media/tuners/tda18218*
 TDA18271 MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mkrufky/tuners.git
@@ -10421,7 +10421,7 @@ F:	drivers/media/tuners/tda18271*
 TDA827x MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mkrufky/tuners.git
@@ -10431,7 +10431,7 @@ F:	drivers/media/tuners/tda8290.*
 TDA8290 MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://github.com/mkrufky
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/mkrufky/tuners.git
@@ -10442,14 +10442,14 @@ TDA9840 MEDIA DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/i2c/tda9840*
 
 TEA5761 TUNER DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/tuners/tea5761.*
@@ -10457,7 +10457,7 @@ F:	drivers/media/tuners/tea5761.*
 TEA5767 TUNER DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/tea5767.*
@@ -10466,7 +10466,7 @@ TEA6415C MEDIA DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/i2c/tea6415c*
 
@@ -10474,7 +10474,7 @@ TEA6420 MEDIA DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/i2c/tea6420*
 
@@ -10572,7 +10572,7 @@ THANKO'S RAREMONO AM/FM/SW RADIO RECEIVER USB DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-raremono.c
 
@@ -10824,7 +10824,7 @@ F:	mm/shmem.c
 TM6000 VIDEO4LINUX DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/usb/tm6000/
@@ -10833,7 +10833,7 @@ TW68 VIDEO4LINUX DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/pci/tw68/
 
@@ -10894,7 +10894,7 @@ F:	include/uapi/linux/tty.h
 TUA9001 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org/
+W:	https://linuxtv.org
 W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
@@ -11241,7 +11241,7 @@ USB VISION DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/usb/usbvision/
 
@@ -11455,7 +11455,7 @@ VIVID VIRTUAL VIDEO DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/platform/vivid/*
 
@@ -11744,7 +11744,7 @@ F:	arch/x86/entry/vdso/
 XC2028/3028 TUNER DRIVER
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 L:	linux-media@vger.kernel.org
-W:	http://linuxtv.org
+W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/tuner-xc2028.*
@@ -11913,7 +11913,7 @@ ZR36067 VIDEO FOR LINUX DRIVER
 L:	mjpeg-users@lists.sourceforge.net
 L:	linux-media@vger.kernel.org
 W:	http://mjpeg.sourceforge.net/driver-zoran/
-T:	hg http://linuxtv.org/hg/v4l-dvb
+T:	hg https://linuxtv.org/hg/v4l-dvb
 S:	Odd Fixes
 F:	drivers/media/pci/zoran/
 
-- 
2.5.0


