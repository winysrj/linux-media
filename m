Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEC0C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 814C421726
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="E2Ze6TIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfAIIqo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 03:46:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35990 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729965AbfAIIqn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 03:46:43 -0500
Received: by mail-wm1-f66.google.com with SMTP id p6so7205765wmc.1
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 00:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k4RL04dCWBEEiRneWm+s6fPFvXmhyEUAvF7ZZsTQAKI=;
        b=E2Ze6TIfo+LPyuH/G0b3V4EeUGV5UuYUgXTsoeZm8TvnFXgxyTeptTjCc3KBQ/2LqZ
         2EAVEQu8R8zishLal8B0Tbg7rzvra2CaRYpGEpEP3bDTdYPaRowC8VYj6AgnaJnlk0z3
         s7ZrrP5fNutXS9bgAcxfovIqBa/Dpsl6vPnAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k4RL04dCWBEEiRneWm+s6fPFvXmhyEUAvF7ZZsTQAKI=;
        b=TxU0pi+3gO4/qFwTFhqXoUTmG9ZtG1fDlKWFgIDIRPPXfRa1PG7d52ca0ye07EILuJ
         hJpU29fvdDxTNmlvNuVMiC/wIL1oDGQnK7Fzx7D5zTQOfeLwMEQFDzlSltpUEIMVtVC6
         gAo6kFZifIfPl0EClQCYnL9A/qeB5Nnyegc2dVe+Ro20yFVrHwH23FUdqD/ofxhf0bVh
         7KXiukWFlaTM6VZ5MROl1yZg8nmo/AapdUnMKW+4HumdteybJ5FgmrppIHDKadJ7nQ8g
         2WKjm+uyU04N8Q9xKYc1E2o86GKbschj8s42OzYUQ97cQWc+20kBmCqfg7+2+AjrPD6z
         kVrw==
X-Gm-Message-State: AJcUukeUUzGUs0ZtcByx5eYwN3AFjaSseOHYThgj7bWxsGthdzBH6C6w
        AY/Deajuy0ia8lWyIm2x4CUd2Cp9OlY=
X-Google-Smtp-Source: ALg8bN7jwiJwbPyAYcxqnoLwTzP+P5GY6RlYE4niBN5d5Yd13yjCudvy7f9Ab1EaUTd7vN5pAQ2oCA==
X-Received: by 2002:a1c:4046:: with SMTP id n67mr4387280wma.123.1547023601122;
        Wed, 09 Jan 2019 00:46:41 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id n82sm12776455wma.42.2019.01.09.00.46.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 00:46:40 -0800 (PST)
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
Subject: [PATCH 2/4] venus: core: corect maximum hardware load for sdm845
Date:   Wed,  9 Jan 2019 10:46:14 +0200
Message-Id: <20190109084616.17162-3-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109084616.17162-1-stanimir.varbanov@linaro.org>
References: <20190109084616.17162-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This corects maximum hardware load constant in per SoC resources
for sdm845 aka Venus v4.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index cb411eb85ee4..d95185ea32c3 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -455,7 +455,7 @@ static const struct venus_resources msm8996_res = {
 	.reg_tbl_size = ARRAY_SIZE(msm8996_reg_preset),
 	.clks = {"core", "iface", "bus", "mbus" },
 	.clks_num = 4,
-	.max_load = 2563200,
+	.max_load = 3110400,	/* 4096x2160@90 */
 	.hfi_version = HFI_VERSION_3XX,
 	.vmem_id = VIDC_RESOURCE_NONE,
 	.vmem_size = 0,
-- 
2.17.1

