Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:34880 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab2AQH25 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 02:28:57 -0500
Date: Tue, 17 Jan 2012 10:28:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [media] ds3000: using logical && instead of bitwise &
Message-ID: <20120117072851.GA11358@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intent here was to test if the FE_HAS_LOCK was set.  The current
test is equivalent to "if (status) { ..."

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 9387770..af65d01 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -1195,7 +1195,7 @@ static int ds3000_set_frontend(struct dvb_frontend *fe)
 
 	for (i = 0; i < 30 ; i++) {
 		ds3000_read_status(fe, &status);
-		if (status && FE_HAS_LOCK)
+		if (status & FE_HAS_LOCK)
 			break;
 
 		msleep(10);
