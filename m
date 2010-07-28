Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47031 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0G1JIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 05:08:14 -0400
Received: from dflp53.itg.ti.com ([128.247.5.6])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o6S98DSC019033
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 04:08:13 -0500
Received: from tidmzi-ftp.india.ext.ti.com (localhost [127.0.0.1])
	by dflp53.itg.ti.com (8.13.8/8.13.8) with SMTP id o6S98BAZ019134
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 04:08:12 -0500 (CDT)
Received: from symphonyindia.ti.com (symphony-ftp [192.168.247.11])
	by tidmzi-ftp.india.ext.ti.com (Postfix) with SMTP id DAF5C3887A
	for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 14:34:26 +0530 (IST)
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
To: linux-media@vger.kernel.org
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: [PATCH] V4L/DVB: tvp7002: fix write to H-PLL Feedback Divider LSB register
Date: Wed, 28 Jul 2010 14:17:48 +0530
Message-Id: <1280306868-28027-1-git-send-email-sudhakar.raj@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

H-PLL Feedback Divider LSB register is an 8 bit register out
of which the first 4 bits are reserved. Current code is
writing to these reserved location. This patch corrects
this issue by left shifting the values being written to the
register by 4.

This patch has been tested on DM6467 EVM with 720P-60 and
1080I-60 inputs.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
---
 drivers/media/video/tvp7002.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index 8085ac3..48f5c76 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -179,7 +179,7 @@ static const struct i2c_reg_value tvp7002_init_default[] = {
 /* Register parameters for 480P */
 static const struct i2c_reg_value tvp7002_parms_480P[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x35, TVP7002_WRITE },
-	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x0a, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0xa0, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0x02, TVP7002_WRITE },
 	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x91, TVP7002_WRITE },
@@ -223,7 +223,7 @@ static const struct i2c_reg_value tvp7002_parms_576P[] = {
 /* Register parameters for 1080I60 */
 static const struct i2c_reg_value tvp7002_parms_1080I60[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x89, TVP7002_WRITE },
-	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x08, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x80, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
 	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
@@ -245,7 +245,7 @@ static const struct i2c_reg_value tvp7002_parms_1080I60[] = {
 /* Register parameters for 1080P60 */
 static const struct i2c_reg_value tvp7002_parms_1080P60[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x89, TVP7002_WRITE },
-	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x08, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x80, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0xE0, TVP7002_WRITE },
 	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
@@ -289,7 +289,7 @@ static const struct i2c_reg_value tvp7002_parms_1080I50[] = {
 /* Register parameters for 720P60 */
 static const struct i2c_reg_value tvp7002_parms_720P60[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x67, TVP7002_WRITE },
-	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x02, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x20, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0xa0, TVP7002_WRITE },
 	{ TVP7002_HPLL_PHASE_SEL, 0x16, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x47, TVP7002_WRITE },
@@ -311,7 +311,7 @@ static const struct i2c_reg_value tvp7002_parms_720P60[] = {
 /* Register parameters for 720P50 */
 static const struct i2c_reg_value tvp7002_parms_720P50[] = {
 	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x7b, TVP7002_WRITE },
-	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x0c, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0xc0, TVP7002_WRITE },
 	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
 	{ TVP7002_HPLL_PHASE_SEL, 0x16, TVP7002_WRITE },
 	{ TVP7002_AVID_START_PIXEL_LSBS, 0x47, TVP7002_WRITE },
-- 
1.5.6

