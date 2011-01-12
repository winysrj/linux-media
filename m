Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1ALSEx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 13:04:53 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0CI4rNt018186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 13:04:53 -0500
Received: from pedra (vpn-234-205.phx2.redhat.com [10.3.234.205])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0CI3oVQ005945
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 13:04:52 -0500
Date: Wed, 12 Jan 2011 18:03:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] ir-kbd-i2c: Make IR debug messages more useful
Message-ID: <20110112180345.04204ee3@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index c87b6bc..b173e40 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -244,15 +244,17 @@ static void ir_key_poll(struct IR_i2c *ir)
 	static u32 ir_key, ir_raw;
 	int rc;
 
-	dprintk(2,"ir_poll_key\n");
+	dprintk(3, "%s\n", __func__);
 	rc = ir->get_key(ir, &ir_key, &ir_raw);
 	if (rc < 0) {
 		dprintk(2,"error\n");
 		return;
 	}
 
-	if (rc)
+	if (rc) {
+		dprintk(1, "%s: keycode = 0x%04x\n", __func__, ir_key);
 		rc_keydown(ir->rc, ir_key, 0);
+	}
 }
 
 static void ir_work(struct work_struct *work)
-- 
1.7.1


