Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab1GNWKG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:10:06 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6EMA6c2020721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 18:10:06 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 8/9] [media] mceusb: report actual tx frequencies
Date: Thu, 14 Jul 2011 18:09:53 -0400
Message-Id: <1310681394-3530-9-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rather than dumping out hex values, lets print the actual calculated
frequency and period the hardware has been configured for. After this
change:

[ 2643.276215] mceusb 3-1:1.0: tx data: 9f 07 (length=2)
[ 2643.276218] mceusb 3-1:1.0: Get carrier mode and freq
[ 2643.277206] mceusb 3-1:1.0: rx data: 9f 06 01 42 (length=4)
[ 2643.277209] mceusb 3-1:1.0: Got carrier of 37037 Hz (period 27us)

Matches up perfectly with the table in Microsoft's docs.

Of course, I've noticed on one of my devices that the MS-recommended
default value of 1 for carrier pre-scaler and 66 for carrier period was
butchered, and instead of converting 66 to hex (0x42 like above), they
put in 0x66, so the hardware reports a default carrier of 24390Hz.
Fortunately, I guess, this particular device is rx-only, but I wouldn't
put it past other hw to screw up here too.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index bbd79c0..fa1d182 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -517,6 +517,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	u8 cmd, subcmd, data1, data2, data3, data4, data5;
 	struct device *dev = ir->dev;
 	int i, start, skip = 0;
+	u32 carrier, period;
 
 	if (!debug)
 		return;
@@ -614,9 +615,14 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			dev_info(dev, "Resp to 9f 05 of 0x%02x 0x%02x\n",
 				 data1, data2);
 			break;
-		case MCE_CMD_SETIRCFS:
-			dev_info(dev, "%s carrier mode and freq of "
-				 "0x%02x 0x%02x\n", inout, data1, data2);
+		case MCE_RSP_EQIRCFS:
+			period = DIV_ROUND_CLOSEST(
+					(1 << data1 * 2) * (data2 + 1), 10);
+			if (!period)
+				break;
+			carrier = (1000 * 1000) / period;
+			dev_info(dev, "%s carrier of %u Hz (period %uus)\n",
+				 inout, carrier, period);
 			break;
 		case MCE_CMD_GETIRCFS:
 			dev_info(dev, "Get carrier mode and freq\n");
@@ -627,9 +633,9 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 			break;
 		case MCE_RSP_EQIRTIMEOUT:
 			/* value is in units of 50us, so x*50/1000 ms */
+			period = ((data1 << 8) | data2) * MCE_TIME_UNIT / 1000;
 			dev_info(dev, "%s receive timeout of %d ms\n",
-				 inout,
-				 ((data1 << 8) | data2) * MCE_TIME_UNIT / 1000);
+				 inout, period);
 			break;
 		case MCE_CMD_GETIRTIMEOUT:
 			dev_info(dev, "Get receive timeout\n");
-- 
1.7.1

