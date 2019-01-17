Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12E2C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 700B520855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="YesyfPrz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfAQQVD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:21:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35885 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728946AbfAQQVC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:21:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id u4so11693316wrp.3
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 08:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v0Va4+csQgOcJN11lZwiOhMnmUqAzLAsAekjb//cub4=;
        b=YesyfPrzEk7o0a3C0a5hYtBknydFXoNHH7l797s0zsZh9dnasvRDWkUDeBjG7fhtj5
         bG9SKOO3X5a7/UPjx28JbO9VvuGwnBp9sTI1YPYcwPw/CvH7dyXf37tAbuW2jc8WhJJH
         RSSi6HUxfKym5vxixl2DxxADjatnCgIcNqISA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v0Va4+csQgOcJN11lZwiOhMnmUqAzLAsAekjb//cub4=;
        b=mVOnvfeyPLFYODc6f8GBFcFoFGlsAHs5884v31Y77o4j/+OcUWy4imM4F+iu7uQ/Rr
         o0o4orOxzlv1Eo0lLmEJp4wERPy+YCSkhrNDtefGeSNrWfwh3Azki6mIgDWWkmQvmh9F
         rYj2Hxo85UnV7PrzjwMLsg7U6hMGXzcMFGbnlNVhLUDhCrENT8YzdQypjvXra0XbgcGj
         KE45gDDm5F4gmTnC4vb5QpBf2rkPRo4fslXuhqdLjmbXx0DN1urexRGU3B05UV1fK2AR
         rQPiBldTbKl2iuV28cbnGuQeXHdb53dTDuLeR07la87r4y0cE7OdlLzOHZuI/g3uklEm
         LRZw==
X-Gm-Message-State: AJcUukciIGOtbtb2f0Q+213X45ls0+A/ZNrQfm+Gd+RN9GU+pALGBt8a
        815pNCaUlmxtHZq1Ra2UqkdMUHjZWmM=
X-Google-Smtp-Source: ALg8bN4WWeJS9/XYtz8MIUdr/JdgHBV7Y9RU6WlJtMfczh8YlTKxma4OIdS8+h0u9Z50GXpUx81HRA==
X-Received: by 2002:adf:aa9c:: with SMTP id h28mr12481135wrc.216.1547742060418;
        Thu, 17 Jan 2019 08:21:00 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id v133sm31124734wmf.19.2019.01.17.08.20.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 08:20:59 -0800 (PST)
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
Subject: [PATCH 02/10] venus: helpers: fix dynamic buffer mode for v4
Date:   Thu, 17 Jan 2019 18:20:00 +0200
Message-Id: <20190117162008.25217-3-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Venus v4 doesn't send ALLOC_MODE property and thus parser doesn't
recognize it as dynamic buffer (for OUTPUT/OUTPUT2 type of buffers)
make it obvious in the helper function.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 5cad601d4c57..86105de81af2 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -467,6 +467,13 @@ static bool is_dynamic_bufmode(struct venus_inst *inst)
 	struct venus_core *core = inst->core;
 	struct venus_caps *caps;
 
+	/*
+	 * v4 doesn't send BUFFER_ALLOC_MODE_SUPPORTED property and supports
+	 * dynamic buffer mode by default for HFI_BUFFER_OUTPUT/OUTPUT2.
+	 */
+	if (IS_V4(core))
+		return true;
+
 	caps = venus_caps_by_codec(core, inst->hfi_codec, inst->session_type);
 	if (!caps)
 		return false;
-- 
2.17.1

