Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:52130 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761618AbdJQM1m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 08:27:42 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, prabhakar.csengg@gmail.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 2/2] [media] davinci: make ccdc_hw_device structures const
Date: Tue, 17 Oct 2017 14:27:25 +0200
Message-Id: <1508243245-30849-3-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1508243245-30849-1-git-send-email-bhumirks@gmail.com>
References: <1508243245-30849-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these structures const as they are only getting passed to the
functions vpfe_{register/unregister}_ccdc_device having the argument as
const.

Structures found using Coccinelle and changes done by hand.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/davinci/dm355_ccdc.c  | 2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c | 2 +-
 drivers/media/platform/davinci/isif.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index 6d492dc..89cb309 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -841,7 +841,7 @@ static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
 	return 0;
 }
 
-static struct ccdc_hw_device ccdc_hw_dev = {
+static const struct ccdc_hw_device ccdc_hw_dev = {
 	.name = "DM355 CCDC",
 	.owner = THIS_MODULE,
 	.hw_ops = {
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 3b2d8a9..5fa0a1f 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -776,7 +776,7 @@ static void ccdc_restore_context(void)
 	regw(ccdc_ctx[CCDC_VP_OUT >> 2], CCDC_VP_OUT);
 	regw(ccdc_ctx[CCDC_PCR >> 2], CCDC_PCR);
 }
-static struct ccdc_hw_device ccdc_hw_dev = {
+static const struct ccdc_hw_device ccdc_hw_dev = {
 	.name = "DM6446 CCDC",
 	.owner = THIS_MODULE,
 	.hw_ops = {
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index 5813b49..d5ff584 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1000,7 +1000,7 @@ static int isif_close(struct device *device)
 	return 0;
 }
 
-static struct ccdc_hw_device isif_hw_dev = {
+static const struct ccdc_hw_device isif_hw_dev = {
 	.name = "ISIF",
 	.owner = THIS_MODULE,
 	.hw_ops = {
-- 
1.9.1
