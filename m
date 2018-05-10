Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47621 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756679AbeEJK43 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 06:56:29 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] qm1d1b0004: fix a warning about an unused default_cfg var
Date: Thu, 10 May 2018 06:56:23 -0400
Message-Id: <3b7158d61a27b7701356969c6fed353a7c67b45e.1525949774.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by gcc:

	drivers/media/tuners/qm1d1b0004.c:62:39: warning: 'default_cfg' defined but not used [-Wunused-const-variable=]
	 static const struct qm1d1b0004_config default_cfg = {
	                                       ^~~~~~~~~~~

This var is currently unused. So, comment it out.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/tuners/qm1d1b0004.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/tuners/qm1d1b0004.c b/drivers/media/tuners/qm1d1b0004.c
index 9dac1b875c18..b4495cc1626b 100644
--- a/drivers/media/tuners/qm1d1b0004.c
+++ b/drivers/media/tuners/qm1d1b0004.c
@@ -59,10 +59,12 @@
 #define QM1D1B0004_XTL_FREQ 4000
 #define QM1D1B0004_LPF_FALLBACK 30000
 
+#if 0 /* Currently unused */
 static const struct qm1d1b0004_config default_cfg = {
 	.lpf_freq = QM1D1B0004_CFG_LPF_DFLT,
 	.half_step = false,
 };
+#endif
 
 struct qm1d1b0004_state {
 	struct qm1d1b0004_config cfg;
-- 
2.17.0
