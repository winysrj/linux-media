Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaCCJtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 04:49:25 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/4] [media] dvb_frontend: better handle lna set errors
Date: Mon,  3 Mar 2014 06:48:46 -0300
Message-Id: <1393840127-22081-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393840127-22081-1-git-send-email-m.chehab@samsung.com>
References: <1393840127-22081-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If an attempt to set LNA fails, restore the cache to LNA_AUTO,
in order to make it to reflect the current LNA status.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 1f925e856974..2d32c13ade7b 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1882,6 +1882,8 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		c->lna = tvp->u.data;
 		if (fe->ops.set_lna)
 			r = fe->ops.set_lna(fe);
+		if (r < 0)
+			c->lna = LNA_AUTO;
 		break;
 
 	default:
-- 
1.8.5.3

