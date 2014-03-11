Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54894 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaCKKi3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 06:38:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] drx-j: use ber_count var
Date: Tue, 11 Mar 2014 07:37:35 -0300
Message-Id: <1394534255-2672-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/drx39xyj/drxj.c: In function 'ctrl_get_qam_sig_quality':
drivers/media/dvb-frontends/drx39xyj/drxj.c:9468:6: warning: variable 'ber_cnt' set but not used [-Wunused-but-set-variable]
  u32 ber_cnt = 0; /* BER count */
      ^

By reading the comment, it is said that BER should be calculated as:
	qam_pre_rs_ber = frac_times1e6( ber_cnt, rs_bit_cnt );

Also, it makes sense to take the mantissa into account, so fix the
code to do what's commented.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 0c0e9f3b108f..41d4bfe66764 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -9583,7 +9583,7 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 	if (m > (rs_bit_cnt >> (e + 1)) || (rs_bit_cnt >> e) == 0)
 		qam_pre_rs_ber = 500000 * rs_bit_cnt >> e;
 	else
-		qam_pre_rs_ber = m;
+		qam_pre_rs_ber = ber_cnt;
 
 	/* post RS BER = 1000000* (11.17 * FEC_OC_SNC_FAIL_COUNT__A) /  */
 	/*               (1504.0 * FEC_OC_SNC_FAIL_PERIOD__A)  */
-- 
1.8.5.3

