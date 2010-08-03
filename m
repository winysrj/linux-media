Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail179.messagelabs.com ([85.158.139.35]:51557 "HELO
	mail179.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755325Ab0HCITB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 04:19:01 -0400
From: mats.randgaard@tandberg.com
To: linux-media@vger.kernel.org
Cc: sudhakar.raj@ti.com, Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [PATCH 2/2] TVP7002: Changed register values.
Date: Tue,  3 Aug 2010 10:18:04 +0200
Message-Id: <1280823484-21664-3-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1280823484-21664-2-git-send-email-mats.randgaard@tandberg.com>
References: <1280823484-21664-1-git-send-email-mats.randgaard@tandberg.com>
 <1280823484-21664-2-git-send-email-mats.randgaard@tandberg.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <mats.randgaard@tandberg.com>

Register values changed according to the data sheet and Texas Instruments DaVinci_PSP_03_02_00_37.
	- TVP7002_RGB_COARSE_CLAMP_CTL changed to the default value in data sheet.
 	- TVP7002_HPLL_PHASE_SEL deleted because the registers write to reserved bits. The default value works fine.

Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
---
 drivers/media/video/tvp7002.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index 8116cd4..0f2dc98 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -127,7 +127,7 @@ static const struct i2c_reg_value tvp7002_init_default[] = {
 	{ TVP7002_ADC_SETUP, 0x50, TVP7002_WRITE },
 	{ TVP7002_COARSE_CLAMP_CTL, 0x00, TVP7002_WRITE },
 	{ TVP7002_SOG_CLAMP, 0x80, TVP7002_WRITE },
-	{ TVP7002_RGB_COARSE_CLAMP_CTL, 0x00, TVP7002_WRITE },
+	{ TVP7002_RGB_COARSE_CLAMP_CTL, 0x8c, TVP7002_WRITE },
 	{ TVP7002_SOG_COARSE_CLAMP_CTL, 0x04, TVP7002_WRITE },
 	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
 	{ 0x32, 0x18, TVP7002_RESERVED },
@@ -181,7 +181,6 @@ static const struct i2c_reg_value tvp7002_parms_480P[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x35, TVP7002_WRITE },
 	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0xa0, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0x02, TVP7002_WRITE },
-	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x91, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_MSBS, 0x00, TVP7002_WRITE },
 	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x0B, TVP7002_WRITE },
@@ -203,7 +202,6 @@ static const struct i2c_reg_value tvp7002_parms_576P[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x36, TVP7002_WRITE },
 	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x00, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0x18, TVP7002_WRITE },
-	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x9B, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_MSBS, 0x00, TVP7002_WRITE },
 	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x0F, TVP7002_WRITE },
@@ -225,7 +223,6 @@ static const struct i2c_reg_value tvp7002_parms_1080I60[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x89, TVP7002_WRITE },
 	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x80, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
-	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
 	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x8a, TVP7002_WRITE },
@@ -247,7 +244,6 @@ static const struct i2c_reg_value tvp7002_parms_1080P60[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x89, TVP7002_WRITE },
 	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x80, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0xE0, TVP7002_WRITE },
-	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
 	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x8a, TVP7002_WRITE },
@@ -269,7 +265,6 @@ static const struct i2c_reg_value tvp7002_parms_1080I50[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0xa5, TVP7002_WRITE },
 	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x00, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
-	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
 	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x8a, TVP7002_WRITE },
@@ -291,7 +286,6 @@ static const struct i2c_reg_value tvp7002_parms_720P60[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x67, TVP7002_WRITE },
 	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x20, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0xa0, TVP7002_WRITE },
-	{ TVP7002_HPLL_PHASE_SEL, 0x16, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x47, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
 	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x4B, TVP7002_WRITE },
@@ -313,7 +307,6 @@ static const struct i2c_reg_value tvp7002_parms_720P50[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x7b, TVP7002_WRITE },
 	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0xc0, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
-	{ TVP7002_HPLL_PHASE_SEL, 0x16, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x47, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
 	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x4B, TVP7002_WRITE },
-- 
1.6.4.2

