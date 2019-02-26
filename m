Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BC4C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 08:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8381C213A2
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 08:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G6orb5RZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfBZIR4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 03:17:56 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43800 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfBZIR4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 03:17:56 -0500
Received: by mail-pg1-f196.google.com with SMTP id l11so5837892pgq.10
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 00:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h7KevRVPo+hBsoX2D7HquAddJWIJsCpaQaFi/gj4bQA=;
        b=G6orb5RZk9sO9ABrDcK199DFK4C9AAsu87tY4paUJOuhn7iJ5Ef6Pu44tpJSWjH9uv
         Yc/KdkmBU5URL4Po6W37LFRyaygbKszQKs/khfG9vlme7gje9iavWZe6nI8AsPWFd7SI
         CJmH4ERxsk1iMBL3CXW1ZBYSRojEbaX7KfZeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h7KevRVPo+hBsoX2D7HquAddJWIJsCpaQaFi/gj4bQA=;
        b=sreLY+5YcZsN9Cdu5so6hebILeBSCtgAi07gffdUtRhR2+zykJLIeV4VmRY7bB+6oZ
         DjcEPRD2c/ViUCUvp6ha4YTj2NETz1INHY2CYZ1atxP3e+qVGPopkYDb5HMgncW9kox5
         jau4GzZQ47YZ+yJXZg+pt1oSG5exEgP/RqS4zkbWhafk18h5zk49QznCyfSwgNvf61CC
         GpHSjmDTlolqpzH+lm2LDzo8VJnsIytEECDYe5iNq56ja7vjL8H10+7eQNW/0O8h1wXO
         umro+eFQPqrhkSOqXhWhVNOTKxzC+R0ztJAU+/97t0RwhdG/n42/0s5vmxdBOYd5cPsn
         dj4g==
X-Gm-Message-State: AHQUAuZCXMdUBWOmzke/zTOZA1AsRCkcgszBXI1GnPGOz5L9zu+E3Bst
        XB1PwfqbACe0lddqDbZxdk3R9Q==
X-Google-Smtp-Source: AHgI3Ibbpw+OZ+OcY7+PBcTCpf+BzEa5CeBwHRbErxn3dHMw9Yx2rta3IuG0Gt+ZF4163Z/UrWa+9g==
X-Received: by 2002:aa7:87c6:: with SMTP id i6mr24533096pfo.208.1551169076000;
        Tue, 26 Feb 2019 00:17:56 -0800 (PST)
Received: from acourbot.tok.corp.google.com ([2401:fa00:4:4:9712:8cf1:d0f:7d33])
        by smtp.gmail.com with ESMTPSA id y6sm11135551pfy.87.2019.02.26.00.17.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 00:17:55 -0800 (PST)
From:   Alexandre Courbot <acourbot@chromium.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: venus: core: fix max load for msm8996 and sdm845
Date:   Tue, 26 Feb 2019 17:17:46 +0900
Message-Id: <20190226081746.73667-1-acourbot@chromium.org>
X-Mailer: git-send-email 2.21.0.rc2.261.ga7da99ff1b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Patch commit de5a0bafcfc4 ("media: venus: core: correct maximum hardware
load for sdm845") meant to increase the maximum hardware load for sdm845,
but ended up changing the one for msm8996 instead.

Fixes: de5a0bafcfc4 ("media: venus: core: correct maximum hardware load for sdm845")

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/qcom/venus/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 739366744e0f..435c7b68bbed 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -455,7 +455,7 @@ static const struct venus_resources msm8996_res = {
 	.reg_tbl_size = ARRAY_SIZE(msm8996_reg_preset),
 	.clks = {"core", "iface", "bus", "mbus" },
 	.clks_num = 4,
-	.max_load = 3110400,	/* 4096x2160@90 */
+	.max_load = 2563200,
 	.hfi_version = HFI_VERSION_3XX,
 	.vmem_id = VIDC_RESOURCE_NONE,
 	.vmem_size = 0,
@@ -478,7 +478,7 @@ static const struct venus_resources sdm845_res = {
 	.freq_tbl_size = ARRAY_SIZE(sdm845_freq_table),
 	.clks = {"core", "iface", "bus" },
 	.clks_num = 3,
-	.max_load = 2563200,
+	.max_load = 3110400,	/* 4096x2160@90 */
 	.hfi_version = HFI_VERSION_4XX,
 	.vmem_id = VIDC_RESOURCE_NONE,
 	.vmem_size = 0,
-- 
2.21.0.rc2.261.ga7da99ff1b-goog

