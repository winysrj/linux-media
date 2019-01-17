Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B69FC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A6B820652
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="PRBmAB49"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfAQQVw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:21:52 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35058 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbfAQQVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:21:06 -0500
Received: by mail-wr1-f65.google.com with SMTP id 96so11702520wrb.2
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 08:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aXeep5x7ETGFolIIRZohdiZMVYaJ9v3T7r4d/NZltdg=;
        b=PRBmAB49jSZAIg8mh24ykmR15+Iu/5sXiCDMYeUHOmk2GcLg8nlTpSwB1rA6YuJJxI
         epFkq42/j9nuo4wCqb5xVXToUmzoHuYqDdxWUAdnjYdcc6XVdS05wO8R/D0gGE/2ONoy
         y08UUdCde950E4kHPln95jtM7A5tntQFNA+BE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aXeep5x7ETGFolIIRZohdiZMVYaJ9v3T7r4d/NZltdg=;
        b=R1gBuvsPu1sCXFv9UONUxzSpkI5OaXy4lr0jfZmhM5MUWr7ngem/GkeO9WXpy8KQN5
         VPe1ELU/mrQ4okKGoLh6Bs4RrAJjUlRtwZg43hU2iZorfUGjQ8QWblicJYNTpURAFDF6
         6/LZlzqX+NFltDrXjQbtoDgzrUyYVfacXSuLL2O2VChp7ZPABT7g6/QY4B5xp9OjGMSV
         PVqtADbnrP8oYfk92xd9OiqC4kwsKtE45CRPMIQ0XcU1ZGMApzYz3MoOtvN5Z44/yM3q
         7GaqERCASX+GSEu0e+Fsco4Q+Y4/2GlZOdM6jH1i/cUv1saPeMLxsDDjW47S03LgFte0
         Ijqg==
X-Gm-Message-State: AJcUukdhYeSxUuNiViR1GO2WQoMPA3OKSCShaOXBWoqhVZHGhobWWQaT
        V4XjFs9W8+9WiHNIj1jRQDwR+DznG64=
X-Google-Smtp-Source: ALg8bN5pgpCGsysvTJ6cB40fJcHPbkNW+SWYapbHRVJkjfjeFgn2sn2XVq7SUnwnZWTW8NPD0Q0apg==
X-Received: by 2002:a5d:4d46:: with SMTP id a6mr12929529wru.28.1547742064717;
        Thu, 17 Jan 2019 08:21:04 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id v133sm31124734wmf.19.2019.01.17.08.21.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 08:21:04 -0800 (PST)
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
Subject: [PATCH 04/10] venus: hfi: add type argument to hfi flush function
Date:   Thu, 17 Jan 2019 18:20:02 +0200
Message-Id: <20190117162008.25217-5-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Make hfi_flush function to receive an argument for the type
of flush.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi.c | 4 ++--
 drivers/media/platform/qcom/venus/hfi.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 24207829982f..0b3c4a2328e4 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -384,14 +384,14 @@ int hfi_session_unload_res(struct venus_inst *inst)
 	return 0;
 }
 
-int hfi_session_flush(struct venus_inst *inst)
+int hfi_session_flush(struct venus_inst *inst, u32 type)
 {
 	const struct hfi_ops *ops = inst->core->ops;
 	int ret;
 
 	reinit_completion(&inst->done);
 
-	ret = ops->session_flush(inst, HFI_FLUSH_ALL);
+	ret = ops->session_flush(inst, type);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/platform/qcom/venus/hfi.h b/drivers/media/platform/qcom/venus/hfi.h
index 6038d8e0ab22..a216914f88bf 100644
--- a/drivers/media/platform/qcom/venus/hfi.h
+++ b/drivers/media/platform/qcom/venus/hfi.h
@@ -170,7 +170,7 @@ int hfi_session_continue(struct venus_inst *inst);
 int hfi_session_abort(struct venus_inst *inst);
 int hfi_session_load_res(struct venus_inst *inst);
 int hfi_session_unload_res(struct venus_inst *inst);
-int hfi_session_flush(struct venus_inst *inst);
+int hfi_session_flush(struct venus_inst *inst, u32 type);
 int hfi_session_set_buffers(struct venus_inst *inst,
 			    struct hfi_buffer_desc *bd);
 int hfi_session_unset_buffers(struct venus_inst *inst,
-- 
2.17.1

