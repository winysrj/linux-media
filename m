Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab1CAPiy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 10:38:54 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p21FcsB2013459
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 10:38:54 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] tda829x: fix regression in probe functions
Date: Tue,  1 Mar 2011 10:38:48 -0500
Message-Id: <1298993928-26876-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In commit 567aba0b7997dad5fe3fb4aeb174ee9018df8c5b, the probe address
for tda8290_probe and tda8295_probe was hard-coded to 0x4b, which is the
default i2c address for those devices, but its possible for the device
to be at an alternate address, 0x42, which is the case for the HVR-1950.
If we probe the wrong address, probe fails and we have a non-working
device. We have the actual address passed into the function by way of
i2c_props, we just need to use it. Also fix up some copy/paste comment
issues and streamline debug spew a touch. Verified to restore my
HVR-1950 to full working order.

Special thanks to Ken Bass for reporting the issue in the first place,
and to both he and Gary Buhrmaster for aiding in debugging and analysis
of the problem.

Reported-by: Ken Bass <kbass@kenbass.com>
Tested-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/common/tuners/tda8290.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
index bc6a677..8c48521 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -658,13 +658,13 @@ static int tda8290_probe(struct tuner_i2c_props *i2c_props)
 #define TDA8290_ID 0x89
 	u8 reg = 0x1f, id;
 	struct i2c_msg msg_read[] = {
-		{ .addr = 0x4b, .flags = 0, .len = 1, .buf = &reg },
-		{ .addr = 0x4b, .flags = I2C_M_RD, .len = 1, .buf = &id },
+		{ .addr = i2c_props->addr, .flags = 0, .len = 1, .buf = &reg },
+		{ .addr = i2c_props->addr, .flags = I2C_M_RD, .len = 1, .buf = &id },
 	};
 
 	/* detect tda8290 */
 	if (i2c_transfer(i2c_props->adap, msg_read, 2) != 2) {
-		printk(KERN_WARNING "%s: tda8290 couldn't read register 0x%02x\n",
+		printk(KERN_WARNING "%s: couldn't read register 0x%02x\n",
 			       __func__, reg);
 		return -ENODEV;
 	}
@@ -685,13 +685,13 @@ static int tda8295_probe(struct tuner_i2c_props *i2c_props)
 #define TDA8295C2_ID 0x8b
 	u8 reg = 0x2f, id;
 	struct i2c_msg msg_read[] = {
-		{ .addr = 0x4b, .flags = 0, .len = 1, .buf = &reg },
-		{ .addr = 0x4b, .flags = I2C_M_RD, .len = 1, .buf = &id },
+		{ .addr = i2c_props->addr, .flags = 0, .len = 1, .buf = &reg },
+		{ .addr = i2c_props->addr, .flags = I2C_M_RD, .len = 1, .buf = &id },
 	};
 
-	/* detect tda8290 */
+	/* detect tda8295 */
 	if (i2c_transfer(i2c_props->adap, msg_read, 2) != 2) {
-		printk(KERN_WARNING "%s: tda8290 couldn't read register 0x%02x\n",
+		printk(KERN_WARNING "%s: couldn't read register 0x%02x\n",
 			       __func__, reg);
 		return -ENODEV;
 	}
-- 
1.7.1

