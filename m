Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60542 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab2JAQ3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 12:29:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] MAINTAINERS: add modules I am responsible
Date: Mon,  1 Oct 2012 19:28:46 +0300
Message-Id: <1349108926-6425-2-git-send-email-crope@iki.fi>
In-Reply-To: <1349108926-6425-1-git-send-email-crope@iki.fi>
References: <1349108926-6425-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All those are media modules, mostly digital television drivers.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 MAINTAINERS | 231 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 231 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0750c24..8c8839d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -184,6 +184,16 @@ S:	Maintained
 F:	Documentation/filesystems/9p.txt
 F:	fs/9p/
 
+A8293 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/a8293*
+
 AACRAID SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
 L:	linux-scsi@vger.kernel.org
@@ -391,6 +401,26 @@ M:	Riccardo Facchetti <fizban@tin.it>
 S:	Maintained
 F:	sound/oss/aedsp16.c
 
+AF9013 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/af9013*
+
+AF9033 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/af9033*
+
 AFFS FILE SYSTEM
 L:	linux-fsdevel@vger.kernel.org
 S:	Orphan
@@ -2116,6 +2146,16 @@ S:	Maintained
 F:	Documentation/video4linux/cx18.txt
 F:	drivers/media/pci/cx18/
 
+CXD2820R MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/cxd2820r*
+
 CXGB3 ETHERNET DRIVER (CXGB3)
 M:	Divy Le Ray <divy@chelsio.com>
 L:	netdev@vger.kernel.org
@@ -2469,6 +2509,97 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wan/dscc4.c
 
+DVB_USB_AF9015 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/af9015*
+
+DVB_USB_AF9035 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/af9035*
+
+DVB_USB_ANYSEE MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/anysee*
+
+DVB_USB_AU6610 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/au6610*
+
+DVB_USB_CE6230 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/ce6230*
+
+DVB_USB_CYPRESS_FIRMWARE MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/cypress_firmware*
+
+DVB_USB_EC168 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/ec168*
+
+DVB_USB_RTL28XXU MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/rtl28xxu*
+
+DVB_USB_V2 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/dvb-usb-v2/dvb_usb*
+F:	drivers/media/usb/dvb-usb-v2/usb_urb.c
+
 DYNAMIC DEBUG
 M:	Jason Baron <jbaron@redhat.com>
 S:	Maintained
@@ -2480,6 +2611,16 @@ M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/tty/serial/dz.*
 
+E4000 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/tuners/e4000*
+
 EATA-DMA SCSI DRIVER
 M:	Michael Neuffer <mike@i-Connect.Net>
 L:	linux-eata@i-connect.net
@@ -2508,6 +2649,16 @@ S:	Maintained
 F:	include/linux/netfilter_bridge/ebt_*.h
 F:	net/bridge/netfilter/ebt*.c
 
+EC100 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/ec100*
+
 ECRYPT FILE SYSTEM
 M:	Tyler Hicks <tyhicks@canonical.com>
 M:	Dustin Kirkland <dustin.kirkland@gazzang.com>
@@ -2781,6 +2932,16 @@ S:	Maintained
 F:	drivers/media/tuners/fc0011.h
 F:	drivers/media/tuners/fc0011.c
 
+FC2580 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/tuners/fc2580*
+
 FANOTIFY
 M:	Eric Paris <eparis@redhat.com>
 S:	Maintained
@@ -3220,6 +3381,16 @@ L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/parisc/harmony.*
 
+HD29L2 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/hd29l2*
+
 HEWLETT-PACKARD SMART2 RAID DRIVER
 M:	Chirag Kantharia <chirag.kantharia@hp.com>
 L:	iss_storagedev@hp.com
@@ -5638,6 +5809,16 @@ F:	fs/qnx4/
 F:	include/linux/qnx4_fs.h
 F:	include/linux/qnxtypes.h
 
+QT1010 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/tuners/qt1010*
+
 QUALCOMM HEXAGON ARCHITECTURE
 M:	Richard Kuo <rkuo@codeaurora.org>
 L:	linux-hexagon@vger.kernel.org
@@ -5804,6 +5985,16 @@ F:	include/linux/rose.h
 F:	include/net/rose.h
 F:	net/rose/
 
+RTL2830 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/rtl2830*
+
 RTL8180 WIRELESS DRIVER
 M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
@@ -6769,6 +6960,36 @@ W:	http://tcp-lp-mod.sourceforge.net/
 S:	Maintained
 F:	net/ipv4/tcp_lp.c
 
+TDA10071 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/dvb-frontends/tda10071*
+
+TDA18212 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/tuners/tda18212*
+
+TDA18218 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/tuners/tda18218*
+
 TEAM DRIVER
 M:	Jiri Pirko <jpirko@redhat.com>
 L:	netdev@vger.kernel.org
@@ -6959,6 +7180,16 @@ F:	include/linux/serial_core.h
 F:	include/linux/serial.h
 F:	include/linux/tty.h
 
+TUA9001 MEDIA DRIVER
+M:	Antti Palosaari <crope@iki.fi>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://palosaari.fi/linux/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+T:	git git://linuxtv.org/anttip/media_tree.git
+S:	Maintained
+F:	drivers/media/tuners/tua9001*
+
 TULIP NETWORK DRIVERS
 M:	Grant Grundler <grundler@parisc-linux.org>
 L:	netdev@vger.kernel.org
-- 
1.7.11.4

