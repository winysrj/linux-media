Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:13211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab1GKB7q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:46 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xjNp011640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:45 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKb030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:45 -0400
Date: Sun, 10 Jul 2011 22:58:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/21] [media] em28xx-i2c: Add a read after I2C write
Message-ID: <20110710225857.23dff9d8@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

All I2C logs we got for em28xx does that. With Terratec H5, at
400MHz speed, it seems that this is required, to avoid having
troubles at the I2C bus.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index 548d2df..36f5a9b 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -181,16 +181,25 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, unsigned char addr,
 
 /*
  * em28xx_i2c_send_bytes()
- * untested for more than 4 bytes
  */
 static int em28xx_i2c_send_bytes(void *data, unsigned char addr, char *buf,
 				 short len, int stop)
 {
 	int wrcount = 0;
 	struct em28xx *dev = (struct em28xx *)data;
+	int write_timeout, ret;
 
 	wrcount = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
 
+	/* Seems to be required after a write */
+	for (write_timeout = EM2800_I2C_WRITE_TIMEOUT; write_timeout > 0;
+	     write_timeout -= 5) {
+		ret = dev->em28xx_read_reg(dev, 0x05);
+		if (!ret)
+			break;
+		msleep(5);
+	}
+
 	return wrcount;
 }
 
-- 
1.7.1


