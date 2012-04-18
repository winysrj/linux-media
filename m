Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:47068 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2DRG4L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 02:56:11 -0400
Date: Wed, 18 Apr 2012 09:55:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] pluto2: remove some dead code
Message-ID: <20120418065551.GD12831@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

buf[] is a 4 character array.  Perhaps this was some debugging code from
back in the day?

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index e1f20c2..f148b19 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -481,14 +481,6 @@ static int lg_tdtpe001p_tuner_set_params(struct dvb_frontend *fe)
 	if (p->bandwidth_hz == 8000000)
 		buf[3] |= 0x08;
 
-	if (sizeof(buf) == 6) {
-		buf[4] = buf[2];
-		buf[4] &= ~0x1c;
-		buf[4] |=  0x18;
-
-		buf[5] = (0 << 7) | (2 << 4);
-	}
-
 	msg.addr = I2C_ADDR_TUA6034 >> 1;
 	msg.flags = 0;
 	msg.buf = buf;
