Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaCKKqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 06:46:02 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] drx-j: Fix post-BER calculus on QAM modulation
Date: Tue, 11 Mar 2014 07:45:15 -0300
Message-Id: <1394534715-20402-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two troubles there:
	1) the bit error measure were not accumulating;
	2) it was missing the bit count.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 41d4bfe66764..b8c5a851c29e 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -9620,7 +9620,8 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 		p->pre_bit_count.stat[0].uvalue += rs_bit_cnt >> e;
 	}
 
-	p->post_bit_error.stat[0].uvalue = qam_post_rs_ber;
+	p->post_bit_error.stat[0].uvalue += qam_post_rs_ber;
+	p->post_bit_count.stat[0].uvalue += rs_bit_cnt >> e;
 
 	p->block_error.stat[0].uvalue += pkt_errs;
 
-- 
1.8.5.3

