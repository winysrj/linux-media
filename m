Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:52924 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751169AbdIOQBx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 12:01:53 -0400
Subject: [PATCH 1/2] [media] c8sectpfe: Delete an error message for a failed
 memory allocation in c8sectpfe_frontend_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Patrice Chotard <patrice.chotard@st.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <3e5fcfbe-828a-8c15-12d4-c74e8a1f20f1@users.sourceforge.net>
Message-ID: <04a4e480-c7a2-fe8c-ca38-8d0b32b42307@users.sourceforge.net>
Date: Fri, 15 Sep 2017 18:01:13 +0200
MIME-Version: 1.0
In-Reply-To: <3e5fcfbe-828a-8c15-12d4-c74e8a1f20f1@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 17:20:48 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
index 2c0015b1264d..1b23b188cd65 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
@@ -166,7 +166,4 @@ int c8sectpfe_frontend_attach(struct dvb_frontend **fe,
 					GFP_KERNEL);
-		if (!tda18212) {
-			dev_err(c8sectpfe->device,
-				"%s: devm_kzalloc failed\n", __func__);
+		if (!tda18212)
 			return -ENOMEM;
-		}
 
-- 
2.14.1
