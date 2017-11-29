Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52878 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752517AbdK2TIx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:53 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 17/22] media: rcar_jpu: fix two kernel-doc markups
Date: Wed, 29 Nov 2017 14:08:35 -0500
Message-Id: <d37d7e01565adba9a029c05a628d924a92fcce48.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On kernel-doc, struct declarations should be declared as "struct foo".

Fix the following warnings:
	drivers/media/platform/rcar_jpu.c:265: warning: cannot understand function prototype: 'struct jpu_q_data '
	drivers/media/platform/rcar_jpu.c:281: warning: cannot understand function prototype: 'struct jpu_ctx '

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/rcar_jpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 070bac36d766..f6092ae45912 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -257,7 +257,7 @@ struct jpu_fmt {
 };
 
 /**
- * jpu_q_data - parameters of one queue
+ * struct jpu_q_data - parameters of one queue
  * @fmtinfo: driver-specific format of this queue
  * @format: multiplanar format of this queue
  * @sequence: sequence number
@@ -269,7 +269,7 @@ struct jpu_q_data {
 };
 
 /**
- * jpu_ctx - the device context data
+ * struct jpu_ctx - the device context data
  * @jpu: JPEG IP device for this context
  * @encoder: compression (encode) operation or decompression (decode)
  * @compr_quality: destination image quality in compression (encode) mode
-- 
2.14.3
