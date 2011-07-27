Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab1G0U3t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 16:29:49 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6RKTn2H017657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 16:29:49 -0400
Received: from localhost.localdomain (vpn-227-4.phx2.redhat.com [10.3.227.4])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6RKTkxv009397
	for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 16:29:48 -0400
Date: Wed, 27 Jul 2011 17:29:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] drxk: Fix read debug message
Message-ID: <20110727172933.0ced5d66@redhat.com>
In-Reply-To: <cover.1311798269.git.mchehab@redhat.com>
References: <cover.1311798269.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 5b22c1f..85332e8 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -355,13 +355,7 @@ static int i2c_read(struct i2c_adapter *adap,
 		{.addr = adr, .flags = I2C_M_RD,
 		 .buf = answ, .len = alen}
 	};
-	dprintk(3, ":");
-	if (debug > 2) {
-		int i;
-		for (i = 0; i < len; i++)
-			printk(KERN_CONT " %02x", msg[i]);
-		printk(KERN_CONT "\n");
-	}
+
 	status = i2c_transfer(adap, msgs, 2);
 	if (status != 2) {
 		if (debug > 2)
@@ -374,9 +368,12 @@ static int i2c_read(struct i2c_adapter *adap,
 	}
 	if (debug > 2) {
 		int i;
-		printk(KERN_CONT ": Read ");
+		dprintk(2, ": read from ");
 		for (i = 0; i < len; i++)
 			printk(KERN_CONT " %02x", msg[i]);
+		printk(KERN_CONT "Value = ");
+		for (i = 0; i < alen; i++)
+			printk(KERN_CONT " %02x", answ[i]);
 		printk(KERN_CONT "\n");
 	}
 	return 0;
@@ -1075,7 +1072,7 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 		state->m_hasIRQN = false;
 		break;
 	default:
-		printk(KERN_ERR "drxk: DeviceID not supported = %02x\n",
+		printk(KERN_ERR "drxk: DeviceID 0x%02x not supported\n",
 			((sioTopJtagidLo >> 12) & 0xFF));
 		status = -EINVAL;
 		goto error2;
-- 
1.7.1


