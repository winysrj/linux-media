Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40973 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3JMKNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Oct 2013 06:13:47 -0400
Date: Sun, 13 Oct 2013 11:13:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] media/i2c: ths8200: fix build failure with gcc 4.5.4
Message-ID: <20131013101333.GA25034@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v3.12-rc fails to build with this error:

drivers/media/i2c/ths8200.c:49:2: error: unknown field 'bt' specified in initializer
drivers/media/i2c/ths8200.c:50:3: error: field name not in record or union initializer
drivers/media/i2c/ths8200.c:50:3: error: (near initialization for 'ths8200_timings_cap.reserved')
drivers/media/i2c/ths8200.c:51:3: error: field name not in record or union initializer
drivers/media/i2c/ths8200.c:51:3: error: (near initialization for 'ths8200_timings_cap.reserved')
...

with gcc 4.5.4.  This error was not detected in builds prior to v3.12-rc.
This patch fixes this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/i2c/ths8200.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index a58a8f6..5ae2a4f 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -46,13 +46,17 @@ struct ths8200_state {
 
 static const struct v4l2_dv_timings_cap ths8200_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
-	.bt = {
-		.max_width = 1920,
-		.max_height = 1080,
-		.min_pixelclock = 25000000,
-		.max_pixelclock = 148500000,
-		.standards = V4L2_DV_BT_STD_CEA861,
-		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE,
+	/* Allow gcc 4.5.4 to build this */
+	.reserved = { },
+	{
+		.bt = {
+			.max_width = 1920,
+			.max_height = 1080,
+			.min_pixelclock = 25000000,
+			.max_pixelclock = 148500000,
+			.standards = V4L2_DV_BT_STD_CEA861,
+			.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE,
+		},
 	},
 };
 

