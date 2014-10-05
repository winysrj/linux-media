Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41370 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaJERhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 13:37:38 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so4065742pad.33
        for <linux-media@vger.kernel.org>; Sun, 05 Oct 2014 10:37:38 -0700 (PDT)
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?="
	<info@are.ma>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, m.chehab@samsung.com, mchehab@osg.samsung.com,
	hdegoede@redhat.com, laurent.pinchart@ideasonboard.com,
	mkrufky@linuxtv.org, sylvester.nawrocki@gmail.com,
	g.liakhovetski@gmx.de, peter.senna@gmail.com
Subject: [PATCH 1/1] Kconfig: cosmetic improvement
Date: Mon,  6 Oct 2014 02:37:34 +0900
Message-Id: <766263dfa0c03ad90e912828fdd7e0cb391e5ae1.1412530212.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PT1 & PT3 are wrongly categorized, fix it
Add comment that PT3 needs FE & tuners

This patch can be applied immediately

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-frontends/Kconfig | 4 ++--
 drivers/media/pci/pt3/Kconfig       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 5a13454..0c59825 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -621,7 +621,7 @@ config DVB_S5H1411
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
 
-comment "ISDB-T (terrestrial) frontends"
+comment "ISDB-S (satellite) & ISDB-T (terrestrial) frontends"
 	depends on DVB_CORE
 
 config DVB_S921
@@ -653,7 +653,7 @@ config DVB_TC90522
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
-	  A Toshiba TC90522 2xISDB-T + 2xISDB-S demodulator.
+	  Toshiba TC90522 2xISDB-S 8PSK + 2xISDB-T OFDM demodulator.
 	  Say Y when you want to support this frontend.
 
 comment "Digital terrestrial only tuners/PLL"
diff --git a/drivers/media/pci/pt3/Kconfig b/drivers/media/pci/pt3/Kconfig
index 16c208a..f7b7210 100644
--- a/drivers/media/pci/pt3/Kconfig
+++ b/drivers/media/pci/pt3/Kconfig
@@ -6,5 +6,5 @@ config DVB_PT3
 	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for Earthsoft PT3 PCIe cards.
-
+	  You need to enable frontend (TC90522) & tuners (QM1D1C0042, MXL301RF)
 	  Say Y or M if you own such a device and want to use it.
-- 
1.8.4.5

