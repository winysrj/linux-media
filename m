Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaIXODH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 10:03:07 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 4/4] [media] qm1d1c0042: fix frequency calculus
Date: Wed, 24 Sep 2014 11:02:29 -0300
Message-Id: <4450f003086a9d346977f9461c1070cb01a9fd90.1411567328.git.mchehab@osg.samsung.com>
In-Reply-To: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
References: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
In-Reply-To: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
References: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset aee9cf18e96e broke the frequency calculus. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 2a990f406cf5..18bc745ed108 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -235,8 +235,8 @@ static int qm1d1c0042_set_params(struct dvb_frontend *fe)
 	 * sd = b          (b >= 0)
 	 *      1<<22 + b  (b < 0)
 	 */
-	b = (s32)div64_s64(((s64) freq) << 20,
-			   state->cfg.xtal_freq - (((s64) a) << 20));
+	b = (s32)div64_s64(((s64) freq) << 20, state->cfg.xtal_freq)
+			   - (((s64) a) << 20);
 
 	if (b >= 0)
 		sd = b;
-- 
1.9.3

