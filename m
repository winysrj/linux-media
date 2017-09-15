Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:49244 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751190AbdIOQCY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 12:02:24 -0400
Subject: [PATCH 2/2] [media] c8sectpfe: Improve two size determinations in
 c8sectpfe_frontend_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Patrice Chotard <patrice.chotard@st.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <3e5fcfbe-828a-8c15-12d4-c74e8a1f20f1@users.sourceforge.net>
Message-ID: <432261cc-ecf1-0673-b8e2-9ca317ceb772@users.sourceforge.net>
Date: Fri, 15 Sep 2017 18:02:14 +0200
MIME-Version: 1.0
In-Reply-To: <3e5fcfbe-828a-8c15-12d4-c74e8a1f20f1@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 17:30:38 +0200

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
index 1b23b188cd65..c3b09a9e30ec 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
@@ -164,12 +164,10 @@ int c8sectpfe_frontend_attach(struct dvb_frontend **fe,
 		tda18212 = devm_kzalloc(c8sectpfe->device,
-					sizeof(struct tda18212_config),
+					sizeof(*tda18212),
 					GFP_KERNEL);
 		if (!tda18212)
 			return -ENOMEM;
 
-		memcpy(tda18212, &tda18212_conf,
-			sizeof(struct tda18212_config));
-
+		memcpy(tda18212, &tda18212_conf, sizeof(*tda18212));
 		tda18212->fe = (*fe);
 
 		tda18212_info.platform_data = tda18212;
-- 
2.14.1
