Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 12/19] drxj: comment out the unused nicam_presc_table_val table
Date: Fri, 24 Jun 2016 12:31:53 -0300
Message-Id: <01d7d436c600904edc8c521c74f1b22a8284e25b.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid this warning:

drivers/media/dvb-frontends/drx39xyj/drxj.c:1243:18: warning: 'nicam_presc_table_val' defined but not used [-Wunused-const-variable=]
 static const u16 nicam_presc_table_val[43] = {
                  ^~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index e48b741d439e..bd6d2ee0f7c9 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1240,12 +1240,15 @@ static u32 frac_times1e6(u32 N, u32 D)
 *        and rounded. For calc used formula: 16*10^(prescaleGain[dB]/20).
 *
 */
+#if 0
+/* Currently, unused as we lack support for analog TV */
 static const u16 nicam_presc_table_val[43] = {
 	1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4,
 	5, 5, 6, 6, 7, 8, 9, 10, 11, 13, 14, 16,
 	18, 20, 23, 25, 28, 32, 36, 40, 45,
 	51, 57, 64, 71, 80, 90, 101, 113, 127
 };
+#endif
 
 /*============================================================================*/
 /*==                        END HELPER FUNCTIONS                            ==*/
-- 
2.7.4


