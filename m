Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47553 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaIIMFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 08:05:45 -0400
Date: Tue, 9 Sep 2014 15:05:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] dvb: si21xx: buffer overflow in si21_writeregs()
Message-ID: <20140909120528.GA19760@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"len" is user controlled and can be up to 255.  Anything more than 59
will cause a buffer overflow so we need to add a test for that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-frontends/si21xx.c b/drivers/media/dvb-frontends/si21xx.c
index 73b47cc..16850e2 100644
--- a/drivers/media/dvb-frontends/si21xx.c
+++ b/drivers/media/dvb-frontends/si21xx.c
@@ -236,6 +236,9 @@ static int si21_writeregs(struct si21xx_state *state, u8 reg1,
 				.len = len + 1
 	};
 
+	if (len > sizeof(buf) - 1)
+		return -EINVAL;
+
 	msg.buf[0] =  reg1;
 	memcpy(msg.buf + 1, data, len);
 
