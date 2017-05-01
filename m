Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41399 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755918AbdEAQKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:10:04 -0400
Subject: [PATCH 2/7] rc-core: img-ir - leave the internals of rc_dev alone
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:10:01 +0200
Message-ID: <149365500184.13489.11044955347596165186.stgit@zeus.hardeman.nu>
In-Reply-To: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changing the protocol does not imply that the keymap changes.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/img-ir/img-ir-hw.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 431d33b36fb0..8d1439622533 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -702,10 +702,6 @@ static void img_ir_set_protocol(struct img_ir_priv *priv, u64 proto)
 {
 	struct rc_dev *rdev = priv->hw.rdev;
 
-	spin_lock_irq(&rdev->rc_map.lock);
-	rdev->rc_map.rc_type = __ffs64(proto);
-	spin_unlock_irq(&rdev->rc_map.lock);
-
 	mutex_lock(&rdev->lock);
 	rdev->enabled_protocols = proto;
 	rdev->allowed_wakeup_protocols = proto;
