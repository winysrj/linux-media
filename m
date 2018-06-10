Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:44600 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbeFJO77 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 10:59:59 -0400
Received: by mail-pl0-f68.google.com with SMTP id z9-v6so10866109plk.11
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2018 07:59:59 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] MAINTAINERS: add entries for several media drivers
Date: Sun, 10 Jun 2018 23:59:31 +0900
Message-Id: <20180610145931.8296-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

add entries for the following drivers:
- earth_pt{1,3} DVB adapter drivers
- mxl301rf DVB tuner drivers
- qm1d1{b0004, c0042} DVB tuner drivers
- tc90522 DVB demod driver

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 MAINTAINERS | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a38e24a3702..a6eafb3d0d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5008,6 +5008,18 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/e4000*
 
+EARTH_PT1 MEDIA DRIVER
+M:	Akihiro Tsukada <tskd08@gmail.com>
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/media/pci/pt1/
+
+EARTH_PT3 MEDIA DRIVER
+M:	Akihiro Tsukada <tskd08@gmail.com>
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/media/pci/pt3/
+
 EC100 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
@@ -9567,6 +9579,12 @@ L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/musb/
 
+MXL301RF MEDIA DRIVER
+M:	Akihiro Tsukada <tskd08@gmail.com>
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/media/tuners/mxl301rf*
+
 MXL5007T MEDIA DRIVER
 M:	Michael Krufky <mkrufky@linuxtv.org>
 L:	linux-media@vger.kernel.org
@@ -11614,6 +11632,18 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/qlogic/qlge/
 
+QM1D1B0004 MEDIA DRIVER
+M:	Akihiro Tsukada <tskd08@gmail.com>
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/media/tuners/qm1d1b0004*
+
+QM1D1C0042 MEDIA DRIVER
+M:	Akihiro Tsukada <tskd08@gmail.com>
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/media/tuners/qm1d1c0042*
+
 QNX4 FILESYSTEM
 M:	Anders Larsen <al@alarsen.net>
 W:	http://www.alarsen.net/linux/qnx4fs/
@@ -13661,6 +13691,12 @@ F:	include/uapi/linux/tc_act/
 F:	include/uapi/linux/tc_ematch/
 F:	net/sched/
 
+TC90522 MEDIA DRIVER
+M:	Akihiro Tsukada <tskd08@gmail.com>
+L:	linux-media@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/media/dvb-frontends/tc90522*
+
 TCP LOW PRIORITY MODULE
 M:	"Wong Hoi Sing, Edison" <hswong3i@gmail.com>
 M:	"Hung Hing Lun, Mike" <hlhung3i@gmail.com>
-- 
2.17.1
