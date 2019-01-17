Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A05C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52BF820652
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="GAfi0Q0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfAQQVA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:21:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52198 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbfAQQU7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:20:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id b11so1698949wmj.1
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 08:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9LHQSJz9yfm2u88JHchLKxFsQP5Hy6RpXXBTLyTSlsQ=;
        b=GAfi0Q0xLT9Y0mWNKm1D4glkoqPg5bZm4Z08rk/zGccHSCsfK3Tiatu56JPM4mm3vU
         c539EMBy6xIOFXcrJ/Ntwi67vqw5MyZbawW/WZWpFniqdiJa84fRzftKsZePvlx0sC2M
         CI6lBRmVMtNWSOUNGEy2uxkhYuHL1YjcAFnVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9LHQSJz9yfm2u88JHchLKxFsQP5Hy6RpXXBTLyTSlsQ=;
        b=nJCQI8GLxYZD7GOC8IITKbDGT9rFCeNqJKJCP8/6ostn/ZkKGChS8lzU5cVQSX4yto
         Wn5vAJkYxYREljfO7YuOYddYM1ZC3lSvF+oT2+ViXeGItQ/KCLgdCtn9VMKpVdBDYOIM
         vT0TPaMks6DYMvs/Gi9k/0gtcR5Z5ktDeqqmjJCbkm9hE9H0GLLes8EdJebOTOXu0I5E
         B3vI7Q7Pogcf02AqpLEHk/KGStcYxHkQb5frU/alSFswdExw6DWc4+78hceGownOmZXR
         Ev8RZnI201W/I4fFzleJWZBp3pjlrZklcnhRfB0c9Q6uzNtNrXPgei2iYfLRgUzm1g9K
         qXiA==
X-Gm-Message-State: AJcUukdM9r2HNHCiAYLLRnP7+Ste05U8kc/dr5T8doCPR6bUhjZPrP8n
        JZF9iJnK3FNt9lZSpxpimhECJbm3LS0=
X-Google-Smtp-Source: ALg8bN6t86S+sKOHnHEpUmHx89LY6SQjk+522zuYhAGj845Df2WxO3boInh63NNpIsHvDfzoQ3nPUw==
X-Received: by 2002:a7b:c5d1:: with SMTP id n17mr12436864wmk.152.1547742057917;
        Thu, 17 Jan 2019 08:20:57 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id v133sm31124734wmf.19.2019.01.17.08.20.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 08:20:57 -0800 (PST)
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
Subject: [PATCH 01/10] venus: hfi_cmds: add more not-implemented properties
Date:   Thu, 17 Jan 2019 18:19:59 +0200
Message-Id: <20190117162008.25217-2-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add two more not-implemented properties for Venus v4.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi_cmds.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
index 87a441488e15..faf1ca0d0db4 100644
--- a/drivers/media/platform/qcom/venus/hfi_cmds.c
+++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
@@ -1214,6 +1214,8 @@ pkt_session_set_property_4xx(struct hfi_session_set_property_pkt *pkt,
 		break;
 	}
 	case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
+	case HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER:
+	case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE:
 		/* not implemented on Venus 4xx */
 		return -ENOTSUPP;
 	default:
-- 
2.17.1

