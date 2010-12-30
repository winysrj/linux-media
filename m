Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:56430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab0L3Lp2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 06:45:28 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBUBjR84001143
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 06:45:28 -0500
Received: from gaivota (vpn-8-93.rdu.redhat.com [10.11.8.93])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBUBjLCk031659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 06:45:25 -0500
Date: Thu, 30 Dec 2010 09:45:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] bttv-input: Add a note about PV951 RC
Message-ID: <20101230094511.07827552@gaivota>
In-Reply-To: <cover.1293709356.git.mchehab@redhat.com>
References: <cover.1293709356.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

When comparing lirc-i2c and ir-kbd-i2c/bttv-input logic, a difference
was noticed. As lirc-i2c will be removed soon, store the difference on
a comment inside ir-kbd-i2c, in order to preserve the knowledge we
have about that remote controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 7f48306..97793b9 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -354,6 +354,18 @@ static int get_key_pv951(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 		return 0;
 	dprintk(KERN_INFO DEVNAME ": key %02x\n", b);
 
+	/*
+	 * NOTE:
+	 * lirc_i2c maps the pv951 code as:
+	 *	addr = 0x61D6
+	 * 	cmd = bit_reverse (b)
+	 * So, it seems that this device uses NEC extended
+	 * I decided to not fix the table, due to two reasons:
+	 * 	1) Without the actual device, this is only a guess;
+	 * 	2) As the addr is not reported via I2C, nor can be changed,
+	 * 	   the device is bound to the vendor-provided RC.
+	 */
+
 	*ir_key = b;
 	*ir_raw = b;
 	return 1;
-- 
1.7.3.4


