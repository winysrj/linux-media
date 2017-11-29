Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50362 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754261AbdK2Kql (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:41 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 06/12] media: vpif: don't generate a kernel-doc warning on a constant
Date: Wed, 29 Nov 2017 05:46:27 -0500
Message-Id: <159308106aa0aa0873ee6e000b05db08a9413f58.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Constants documentation is not supported by kernel-doc markups.
So, change the comment label to avoid this warning:
	drivers/media/platform/davinci/vpif.c:54: warning: cannot understand function prototype: 'const struct vpif_channel_config_params vpif_ch_params[] = '

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpif.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 07e89a4985a6..16352e2263d2 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -47,8 +47,9 @@ EXPORT_SYMBOL_GPL(vpif_lock);
 void __iomem *vpif_base;
 EXPORT_SYMBOL_GPL(vpif_base);
 
-/**
+/*
  * vpif_ch_params: video standard configuration parameters for vpif
+ *
  * The table must include all presets from supported subdevices.
  */
 const struct vpif_channel_config_params vpif_ch_params[] = {
-- 
2.14.3
