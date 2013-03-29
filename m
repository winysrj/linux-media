Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3626 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3C2VWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 17:22:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] si476x: Fix some config dependencies and a compile warnings
Date: Fri, 29 Mar 2013 22:22:24 +0100
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303292222.24181.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

radio-si476x depends on SND and SND_SOC, the mfd driver should select
REGMAP_I2C.

Also fix a small compile warning in a debug message:

drivers/mfd/si476x-i2c.c: In function ‘si476x_core_drain_rds_fifo’:
drivers/mfd/si476x-i2c.c:391:4: warning: field width specifier ‘*’ expects argument of type ‘int’, but argument 4 has type ‘long unsigned int’ [-Wformat]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 28ded24..fef427e 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -20,7 +20,7 @@ source "drivers/media/radio/si470x/Kconfig"
 
 config RADIO_SI476X
 	tristate "Silicon Laboratories Si476x I2C FM Radio"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && SND && SND_SOC
 	select MFD_CORE
 	select MFD_SI476X_CORE
 	select SND_SOC_SI476X
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9b80e1e..2f97ad1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -980,6 +980,7 @@ config MFD_SI476X_CORE
 	tristate "Support for Silicon Laboratories 4761/64/68 AM/FM radio."
 	depends on I2C
 	select MFD_CORE
+	select REGMAP_I2C
 	help
 	  This is the core driver for the SI476x series of AM/FM
 	  radio. This MFD driver connects the radio-si476x V4L2 module
diff --git a/drivers/mfd/si476x-i2c.c b/drivers/mfd/si476x-i2c.c
index 118c6b1..f5bc8e4 100644
--- a/drivers/mfd/si476x-i2c.c
+++ b/drivers/mfd/si476x-i2c.c
@@ -389,7 +389,7 @@ static void si476x_core_drain_rds_fifo(struct work_struct *work)
 			kfifo_in(&core->rds_fifo, report.rds,
 				 sizeof(report.rds));
 			dev_dbg(&core->client->dev, "RDS data:\n %*ph\n",
-				sizeof(report.rds), report.rds);
+				(int)sizeof(report.rds), report.rds);
 		}
 		dev_dbg(&core->client->dev, "Drrrrained!\n");
 		wake_up_interruptible(&core->rds_read_queue);
