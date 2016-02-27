Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbcB0Kva (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:51:30 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Cheolhyun Park <pch851130@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] [media] drxj: don't do math if not needed
Date: Sat, 27 Feb 2016 07:51:08 -0300
Message-Id: <388e3b822807eb2600fbaab514c3759131e235d6.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
In-Reply-To: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
References: <d7bc635a625d7ab19ed5a81135044e086d330d1b.1456570258.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This should also avoid those smatch errors:
	drivers/media/dvb-frontends/drx39xyj/drxj.c:9605 ctrl_get_qam_sig_quality() debug: sval_binop_unsigned: divide by zero
	drivers/media/dvb-frontends/drx39xyj/drxj.c:9605 ctrl_get_qam_sig_quality() debug: sval_binop_unsigned: divide by zero
	drivers/media/dvb-frontends/drx39xyj/drxj.c:9605 ctrl_get_qam_sig_quality() debug: sval_binop_unsigned: divide by zero
	drivers/media/dvb-frontends/drx39xyj/drxj.c:9605 ctrl_get_qam_sig_quality() debug: sval_binop_unsigned: divide by zero
	drivers/media/dvb-frontends/drx39xyj/drxj.c:9605 ctrl_get_qam_sig_quality() debug: sval_binop_unsigned: divide by zero

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 51715421bc4f..e48b741d439e 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -9597,12 +9597,13 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 
 	   Precision errors still possible.
 	 */
-	e = post_bit_err_rs * 742686;
-	m = fec_oc_period * 100;
-	if (fec_oc_period == 0)
+	if (!fec_oc_period) {
 		qam_post_rs_ber = 0xFFFFFFFF;
-	else
+	} else {
+		e = post_bit_err_rs * 742686;
+		m = fec_oc_period * 100;
 		qam_post_rs_ber = e / m;
+	}
 
 	/* fill signal quality data structure */
 	p->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-- 
2.5.0

