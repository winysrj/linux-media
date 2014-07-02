Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbaGBPwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 11:52:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 8/9] dib0700: Optimize the AGC settings for dib8096gp
Date: Wed,  2 Jul 2014 12:52:22 -0300
Message-Id: <1404316343-23856-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
References: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replicate the settings found at the windows driver for Mygica S870.
Those should improve tuning with real signals.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index baffa8fe09ef..aad725b23feb 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -1426,7 +1426,7 @@ static struct dibx000_agc_config dib8090_agc_config[2] = {
 	.thlock = 118,
 
 	.wbd_inv = 0,
-	.wbd_ref = 3530,
+	.wbd_ref = 958,
 	.wbd_sel = 1,
 	.wbd_alpha = 5,
 
@@ -1500,11 +1500,11 @@ static struct dibx000_agc_config dib8090_agc_config[2] = {
 };
 
 static struct dibx000_bandwidth_config dib8090_pll_config_12mhz = {
-	.internal = 54000,
+	.internal = 60000,
 	.sampling = 13500,
 
 	.pll_prediv = 1,
-	.pll_ratio = 18,
+	.pll_ratio = 20,
 	.pll_range = 3,
 	.pll_reset = 1,
 	.pll_bypass = 0,
@@ -1518,7 +1518,7 @@ static struct dibx000_bandwidth_config dib8090_pll_config_12mhz = {
 	.sad_cfg = (3 << 14) | (1 << 12) | (599 << 0),
 
 	.ifreq = (0 << 25) | 0,
-	.timf = 20199727,
+	.timf = 18179755,
 
 	.xtal_hz = 12000000,
 };
@@ -1559,7 +1559,7 @@ static struct dib8000_config dib809x_dib8000_config[2] = {
 	.output_mode = OUTMODE_MPEG2_FIFO,
 	.drives = 0x2d98,
 	.diversity_delay = 48,
-	.refclksel = 3,
+	.refclksel = 1,
 	}, {
 	.output_mpeg2_in_188_bytes = 1,
 
-- 
1.9.3

