Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab0L3PBN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 10:01:13 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBUF1DHR023731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 10:01:13 -0500
Received: from gaivota (vpn-8-148.rdu.redhat.com [10.11.8.148])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBUF17dn007751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 10:01:10 -0500
Date: Thu, 30 Dec 2010 13:00:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] ivtv-i2c: Fix two wanrings
Message-ID: <20101230130041.71357141@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Fix two gcc warnings:

drivers/media/video/ivtv/ivtv-i2c.c:170: warning: cast from pointer to integer of different size
drivers/media/video/ivtv/ivtv-i2c.c:171: warning: cast from pointer to integer of different size
$ gcc --version
gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-48)

They seem bogus, but, as the original code also has problems with
LE/BE, just change its implementation to be clear.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 2bed430..e103b8f 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -167,8 +167,8 @@ static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	keybuf[2] &= 0x7f;
 	keybuf[3] |= 0x80;
 
-	*ir_key = (u32) keybuf;
-	*ir_raw = (u32) keybuf;
+	*ir_key = keybuf[3] | keybuf[2] << 8 | keybuf[1] << 16 |keybuf[0] << 24;
+	*ir_raw = *ir_key;
 
 	return 1;
 }
-- 
1.7.3.4

