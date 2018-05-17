Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeEQLc5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 07:32:57 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        acourbot@google.com, Vikash Garodia <vgarodia@codeaurora.org>
Subject: [PATCH 1/4] soc: qcom: mdt_loader: Add check to make scm calls
Date: Thu, 17 May 2018 17:02:17 +0530
Message-Id: <1526556740-25494-2-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
References: <1526556740-25494-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to invoke scm calls, ensure that the platform
has the required support to invoke the scm calls in
secure world.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 drivers/soc/qcom/mdt_loader.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/qcom/mdt_loader.c b/drivers/soc/qcom/mdt_loader.c
index 17b314d..db55d53 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -121,10 +121,12 @@ int qcom_mdt_load(struct device *dev, const struct firmware *fw,
 	if (!fw_name)
 		return -ENOMEM;
 
-	ret = qcom_scm_pas_init_image(pas_id, fw->data, fw->size);
-	if (ret) {
-		dev_err(dev, "invalid firmware metadata\n");
-		goto out;
+	if (qcom_scm_is_available()) {
+		ret = qcom_scm_pas_init_image(pas_id, fw->data, fw->size);
+		if (ret) {
+			dev_err(dev, "invalid firmware metadata\n");
+			goto out;
+		}
 	}
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
@@ -144,10 +146,13 @@ int qcom_mdt_load(struct device *dev, const struct firmware *fw,
 	}
 
 	if (relocate) {
-		ret = qcom_scm_pas_mem_setup(pas_id, mem_phys, max_addr - min_addr);
-		if (ret) {
-			dev_err(dev, "unable to setup relocation\n");
-			goto out;
+		if (qcom_scm_is_available()) {
+			ret = qcom_scm_pas_mem_setup(pas_id, mem_phys,
+							max_addr - min_addr);
+			if (ret) {
+				dev_err(dev, "unable to setup relocation\n");
+				goto out;
+			}
 		}
 
 		/*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
