Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:41212 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3GOKm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 06:42:58 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so11091393pbc.35
        for <linux-media@vger.kernel.org>; Mon, 15 Jul 2013 03:42:57 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, rusty@rustcorp.com.au,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] sh_veu: Replace PTR_RET with PTR_ERR_OR_ZERO
Date: Mon, 15 Jul 2013 15:57:07 +0530
Message-Id: <1373884027-24846-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PTR_RET is now deprecated. Use PTR_ERR_OR_ZERO instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Compile tested and based on the following tree:
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git (PTR_RET)

Dependent on [1]
[1] http://lkml.indiana.edu/hypermail/linux/kernel/1306.2/00010.html
---
 drivers/media/platform/sh_veu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index aa4cca3..744e43b 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -359,7 +359,7 @@ static int sh_veu_context_init(struct sh_veu_dev *veu)
 	veu->m2m_ctx = v4l2_m2m_ctx_init(veu->m2m_dev, veu,
 					 sh_veu_queue_init);
 
-	return PTR_RET(veu->m2m_ctx);
+	return PTR_ERR_OR_ZERO(veu->m2m_ctx);
 }
 
 static int sh_veu_querycap(struct file *file, void *priv,
-- 
1.7.9.5

