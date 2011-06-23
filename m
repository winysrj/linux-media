Return-path: <mchehab@pedra>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17213 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933471Ab1FWXUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 19:20:06 -0400
From: <achew@nvidia.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
CC: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>, <olof@lixom.net>,
	Andrew Chew <achew@nvidia.com>
Subject: [PATCH 3/6 v3] [media] ov9740: Fixed some settings
Date: Thu, 23 Jun 2011 16:19:41 -0700
Message-ID: <1308871184-6307-3-git-send-email-achew@nvidia.com>
In-Reply-To: <1308871184-6307-1-git-send-email-achew@nvidia.com>
References: <1308871184-6307-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrew Chew <achew@nvidia.com>

Based on vendor feedback, should issue a software reset at start of day.

Also, OV9740_ANALOG_CTRL15 needs to be changed so the sensor does not begin
streaming until it is ready (otherwise, results in a nonsense frame for the
initial frame).

Added a comment on using discontinuous clock.

Finally, OV9740_ISP_CTRL19 needs to be changed to really use YUYV ordering
(the previous value was for VYUY).

Signed-off-by: Andrew Chew <achew@nvidia.com>
---
 drivers/media/video/ov9740.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index d5c9061..72c6ac1d 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -68,6 +68,7 @@
 #define OV9740_ANALOG_CTRL04		0x3604
 #define OV9740_ANALOG_CTRL10		0x3610
 #define OV9740_ANALOG_CTRL12		0x3612
+#define OV9740_ANALOG_CTRL15		0x3615
 #define OV9740_ANALOG_CTRL20		0x3620
 #define OV9740_ANALOG_CTRL21		0x3621
 #define OV9740_ANALOG_CTRL22		0x3622
@@ -222,6 +223,9 @@ struct ov9740_priv {
 };
 
 static const struct ov9740_reg ov9740_defaults[] = {
+	/* Software Reset */
+	{ OV9740_SOFTWARE_RESET,	0x01 },
+
 	/* Banding Filter */
 	{ OV9740_AEC_B50_STEP_HI,	0x00 },
 	{ OV9740_AEC_B50_STEP_LO,	0xe8 },
@@ -333,6 +337,7 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_ANALOG_CTRL10,		0xa1 },
 	{ OV9740_ANALOG_CTRL12,		0x24 },
 	{ OV9740_ANALOG_CTRL22,		0x9f },
+	{ OV9740_ANALOG_CTRL15,		0xf0 },
 
 	/* Sensor Control */
 	{ OV9740_SENSOR_CTRL03,		0x42 },
@@ -385,7 +390,7 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_LN_LENGTH_PCK_LO,	0x62 },
 
 	/* MIPI Control */
-	{ OV9740_MIPI_CTRL00,		0x44 },
+	{ OV9740_MIPI_CTRL00,		0x44 }, /* 0x64 for discontinuous clk */
 	{ OV9740_MIPI_3837,		0x01 },
 	{ OV9740_MIPI_CTRL01,		0x0f },
 	{ OV9740_MIPI_CTRL03,		0x05 },
@@ -393,6 +398,9 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_VFIFO_RD_CTRL,		0x16 },
 	{ OV9740_MIPI_CTRL_3012,	0x70 },
 	{ OV9740_SC_CMMM_MIPI_CTR,	0x01 },
+
+	/* YUYV order */
+	{ OV9740_ISP_CTRL19,		0x02 },
 };
 
 static const struct ov9740_reg ov9740_regs_vga[] = {
-- 
1.7.5.4

