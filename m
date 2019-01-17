Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6681C43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A2D20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WRKhZf4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfAQQVL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:21:11 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52324 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729108AbfAQQVK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:21:10 -0500
Received: by mail-wm1-f68.google.com with SMTP id m1so1694172wml.2
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 08:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MkbOUFHDsrDG1TGvqhepL8zE+1a5aus1syCufXPfhww=;
        b=WRKhZf4RUsxe3qwNVAqkut2X4sPhjyKbKboB/6lzkNvpEPB690MAHkE9otoCgA3iCa
         sEDi+1WICELvvqYkxsUIfeEexgdDrAxRPeJ/eF/uJ05JRhnj4kyyrIouRwEqMwAe11Go
         Iv9bcBTxbyPc2omRNkdybZCKrY7uq19n5v19g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MkbOUFHDsrDG1TGvqhepL8zE+1a5aus1syCufXPfhww=;
        b=CP7LgLa6eF02d2ojurFnh6H0KiaiRnxuuxj/Vo+i41rQISQWfeW8Vp3381IwD1/f8n
         4FWQy2QybrC/TDaVsd6/u6ohPwe++ZVsLfFleURUdp8s8mDq01iWGInl4wb2fUyRn2nt
         oPkkG8pF7ehkDJc9NdHCSuIehSznkWcB42JImUGaoISF9E1ApPBeU39A8U3HSXZ2yp6J
         M8FWqnYOxDlguTUsEqAvHLU76XctORg13X+03OWtKDEU9kw8lTa6455EzD+DwBQJx4b1
         +A6ykZNw0pg+EPUoUXZ7wys0IxYxmBbnd97I9u8ddSA7E9kI9q8GbifawvCjNonOUm3y
         zUJw==
X-Gm-Message-State: AJcUukdqM3aXFIcxA7xppBbNz5POXU0WdP+43/fLGTeurlaFdDtYyKUi
        9SKiEJDbyV8hAuXvwjxzh1b9RLt5Lb8=
X-Google-Smtp-Source: ALg8bN5NqvzrDlG3B/jNNGzGdg1LJu7EDyDaSjTmT2y5zFFt2yGnY2HJWVfZtcbgY+YxrF94NnCeLw==
X-Received: by 2002:a1c:9d57:: with SMTP id g84mr12654932wme.16.1547742068013;
        Thu, 17 Jan 2019 08:21:08 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id v133sm31124734wmf.19.2019.01.17.08.21.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 08:21:07 -0800 (PST)
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
Subject: [PATCH 06/10] venus: hfi: return an error if session_init is already called
Date:   Thu, 17 Jan 2019 18:20:04 +0200
Message-Id: <20190117162008.25217-7-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This makes hfi_session_init to return an error when it is
already called without a call to hfi_session_deinit.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index eaa82af9ec09..5374655eda39 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -207,6 +207,9 @@ int hfi_session_init(struct venus_inst *inst, u32 pixfmt)
 	const struct hfi_ops *ops = core->ops;
 	int ret;
 
+	if (inst->state != INST_UNINIT)
+		return -EINVAL;
+
 	inst->hfi_codec = to_codec_type(pixfmt);
 	reinit_completion(&inst->done);
 
-- 
2.17.1

