Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA363C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 713C62075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZK8nXvpA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfAIIql (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 03:46:41 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53111 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbfAIIqk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 03:46:40 -0500
Received: by mail-wm1-f66.google.com with SMTP id m1so6720081wml.2
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 00:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p1aYYfe1Sbab/wTQ6/YLONvNDQbV1Er7aklVEWsbHqk=;
        b=ZK8nXvpAcgp/j15jB2W2ghuu0K+Z22ZSigBYJpOMqJjWm+N+YDQi+SbINhaXpRbhjl
         +fGHLlrM1NcR8/dBpQ7EGZtwxKMoc5+lH3ianAvG7aRIL+E5ePjuj8Iv91AtFgjCUxUl
         +lAccnywHODSJ5Omiak+1B2JbrY4jJjuwzWqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p1aYYfe1Sbab/wTQ6/YLONvNDQbV1Er7aklVEWsbHqk=;
        b=fQCH3yrfio2nKS7VueL1klsDFIWAxjIkmtY7Rr4zlNcx2WSuQ+dgm4mPbOqIoxNFDl
         jzR/XGazzRh9olCw128pzXo7xqo876yry/nk4dSXiPZbORGsW1fKtE4ux6Z9tAsrdTiM
         UzbJyq8sEzTg7ReKZxUjJpTer0uaoZjFtUvoJe6GyWayX+qejCoL5MkT+KSFCUGTBhIs
         7VO157AnH22J2DVZH7/VbdcHMe5WczkS/gfbNE5kMunAzYUyrXXrw9TOUQcigZQJU10i
         uT+0Y2ifWBXcW/wM70aJxt20lteFTcAXrCZ2h9JtSL+JdOp3oRVv3iE6RgZNSG73xxPf
         zw4Q==
X-Gm-Message-State: AJcUukcjArzhUPgzZMT/DEb9svAccNJNDfydPj5OynkSTEoF0tPovfYM
        2S1NyetXekR9LUh6PgJCJ4ut2llSuKA=
X-Google-Smtp-Source: ALg8bN4W1B73tashNKgY76/h07KOpUe/E6xznk7cd4wn/voopUxlMq3TOeJTXUk9eoMD/sx3nG9fvQ==
X-Received: by 2002:a1c:4807:: with SMTP id v7mr4770489wma.53.1547023599117;
        Wed, 09 Jan 2019 00:46:39 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id n82sm12776455wma.42.2019.01.09.00.46.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 00:46:38 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 1/4] venus: firmware: check fw size against DT memory region size
Date:   Wed,  9 Jan 2019 10:46:13 +0200
Message-Id: <20190109084616.17162-2-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109084616.17162-1-stanimir.varbanov@linaro.org>
References: <20190109084616.17162-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

By historical reasons we defined firmware memory size to be 6MB even
that the firmware size for all supported Venus versions is 5MBs. Correct
that by compare the required firmware size returned from mdt loader and
the one provided by DT reserved memory region. We proceed further if the
required firmware size is smaller than provided by DT memory region.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.h     |  1 +
 drivers/media/platform/qcom/venus/firmware.c | 54 +++++++++++---------
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 6382cea29185..79c7e816c706 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -134,6 +134,7 @@ struct venus_core {
 	struct video_firmware {
 		struct device *dev;
 		struct iommu_domain *iommu_domain;
+		size_t mapped_mem_size;
 	} fw;
 	struct mutex lock;
 	struct list_head instances;
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index c29acfd70c1b..6b509ffd022a 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -35,14 +35,15 @@
 
 static void venus_reset_cpu(struct venus_core *core)
 {
+	u32 fw_size = core->fw.mapped_mem_size;
 	void __iomem *base = core->base;
 
 	writel(0, base + WRAPPER_FW_START_ADDR);
-	writel(VENUS_FW_MEM_SIZE, base + WRAPPER_FW_END_ADDR);
+	writel(fw_size, base + WRAPPER_FW_END_ADDR);
 	writel(0, base + WRAPPER_CPA_START_ADDR);
-	writel(VENUS_FW_MEM_SIZE, base + WRAPPER_CPA_END_ADDR);
-	writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_START_ADDR);
-	writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_END_ADDR);
+	writel(fw_size, base + WRAPPER_CPA_END_ADDR);
+	writel(fw_size, base + WRAPPER_NONPIX_START_ADDR);
+	writel(fw_size, base + WRAPPER_NONPIX_END_ADDR);
 	writel(0x0, base + WRAPPER_CPU_CGC_DIS);
 	writel(0x0, base + WRAPPER_CPU_CLOCK_CONFIG);
 
@@ -74,6 +75,9 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 	void *mem_va;
 	int ret;
 
+	*mem_phys = 0;
+	*mem_size = 0;
+
 	dev = core->dev;
 	node = of_parse_phandle(dev->of_node, "memory-region", 0);
 	if (!node) {
@@ -85,28 +89,30 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 	if (ret)
 		return ret;
 
+	ret = request_firmware(&mdt, fwname, dev);
+	if (ret < 0)
+		return ret;
+
+	fw_size = qcom_mdt_get_size(mdt);
+	if (fw_size < 0) {
+		ret = fw_size;
+		goto err_release_fw;
+	}
+
 	*mem_phys = r.start;
 	*mem_size = resource_size(&r);
 
-	if (*mem_size < VENUS_FW_MEM_SIZE)
-		return -EINVAL;
+	if (*mem_size < fw_size || fw_size > VENUS_FW_MEM_SIZE) {
+		ret = -EINVAL;
+		goto err_release_fw;
+	}
 
 	mem_va = memremap(r.start, *mem_size, MEMREMAP_WC);
 	if (!mem_va) {
 		dev_err(dev, "unable to map memory region: %pa+%zx\n",
 			&r.start, *mem_size);
-		return -ENOMEM;
-	}
-
-	ret = request_firmware(&mdt, fwname, dev);
-	if (ret < 0)
-		goto err_unmap;
-
-	fw_size = qcom_mdt_get_size(mdt);
-	if (fw_size < 0) {
-		ret = fw_size;
-		release_firmware(mdt);
-		goto err_unmap;
+		ret = -ENOMEM;
+		goto err_release_fw;
 	}
 
 	if (core->use_tz)
@@ -116,10 +122,9 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
 		ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
 					    mem_va, *mem_phys, *mem_size, NULL);
 
-	release_firmware(mdt);
-
-err_unmap:
 	memunmap(mem_va);
+err_release_fw:
+	release_firmware(mdt);
 	return ret;
 }
 
@@ -135,6 +140,7 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
 		return -EPROBE_DEFER;
 
 	iommu = core->fw.iommu_domain;
+	core->fw.mapped_mem_size = mem_size;
 
 	ret = iommu_map(iommu, VENUS_FW_START_ADDR, mem_phys, mem_size,
 			IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV);
@@ -151,7 +157,7 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
 static int venus_shutdown_no_tz(struct venus_core *core)
 {
 	struct iommu_domain *iommu;
-	size_t unmapped;
+	size_t unmapped, mapped = core->fw.mapped_mem_size;
 	u32 reg;
 	struct device *dev = core->fw.dev;
 	void __iomem *base = core->base;
@@ -166,8 +172,8 @@ static int venus_shutdown_no_tz(struct venus_core *core)
 
 	iommu = core->fw.iommu_domain;
 
-	unmapped = iommu_unmap(iommu, VENUS_FW_START_ADDR, VENUS_FW_MEM_SIZE);
-	if (unmapped != VENUS_FW_MEM_SIZE)
+	unmapped = iommu_unmap(iommu, VENUS_FW_START_ADDR, mapped);
+	if (unmapped != mapped)
 		dev_err(dev, "failed to unmap firmware\n");
 
 	return 0;
-- 
2.17.1

