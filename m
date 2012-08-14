Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48379 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2HNGv4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 02:51:56 -0400
Date: Tue, 14 Aug 2012 09:51:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] it913x-fe: use ARRAY_SIZE() as a cleanup
Message-ID: <20120814065120.GA4791@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code looks suspicious, but it turns out that "nv" is an array of u8
so sizeof() is the same as ARRAY_SIZE().  Using ARRAY_SIZE() is more
readable though.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 708cbf1..6e1c6eb 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -199,7 +199,7 @@ static int it913x_init_tuner(struct it913x_fe_state *state)
 
 	if (reg < 0)
 		return -ENODEV;
-	else if (reg < sizeof(nv))
+	else if (reg < ARRAY_SIZE(nv))
 		nv_val = nv[reg];
 	else
 		nv_val = 2;
