Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF8FC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEAEB20652
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="gb1xWu6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfAQQVw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:21:52 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39732 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729077AbfAQQVH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:21:07 -0500
Received: by mail-wm1-f67.google.com with SMTP id y8so1676630wmi.4
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 08:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p9SShCCE56zaFl3EA7SWgswRXOkmYSJfgEKA8EbEbto=;
        b=gb1xWu6lUVHgGdfEFXpVfd+bzgNpcmapkF0kR/BtDDosirkCS38A6rKagnxFPSa1Cm
         SbeHBfJG5r7jhdYIBOu3iCPTJYBl82NoJt+oOMOEB1kCDBF9Uaq4euAlt7jEagDf94/1
         L1I3/XeeTVG+WlgsyfK9YPryHzkGrpaH9/Kyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p9SShCCE56zaFl3EA7SWgswRXOkmYSJfgEKA8EbEbto=;
        b=S7vmXYXJmvI1ZRdmDS8aB8XqHwawzwj87EFDXUOSRcPRlHYoE+0zaQgT4yV3D8x+sp
         sxpdl2JbOqiaFD9CCQJJFjh2opvY4rHlAGvGixcBBNoX8qIhrcntPr+YlYpogofD0ay5
         arqhdqE2BcLUss5NyX9eji/lg/GR1kIAxcPWb1cLo5WZjzs5CWqajv8N5b2DSxdg2jF5
         eN+WuoDL8OiRqeKWJzjFrtfeWLANug6og7udOuZB9YfPhRXfDfFV5s3SQTpWRn2bToXL
         IezmeONDO8wlGYCFXsh55IF1MhUmR/LSxOlgVIftYbC2XwUkS7MhkthgDGWSfjUFsTJu
         9ong==
X-Gm-Message-State: AJcUukf83wQ9d8UuXKLhSkI1QcLPAxXXEA5/H0PY07DsFfXh8WsS56BJ
        c+IY63zZQNw5ZiwXPrARIMNJu2p9pEc=
X-Google-Smtp-Source: ALg8bN7FsdBOJw9892MXm2Ed0NpKkDJXYoPrdndTpVJDkhachJQYzkqAeBLUA12Kl7Z363bZC4qmHg==
X-Received: by 2002:a1c:864f:: with SMTP id i76mr12143347wmd.83.1547742066369;
        Thu, 17 Jan 2019 08:21:06 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id v133sm31124734wmf.19.2019.01.17.08.21.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 08:21:05 -0800 (PST)
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
Subject: [PATCH 05/10] venus: hfi: export few HFI functions
Date:   Thu, 17 Jan 2019 18:20:03 +0200
Message-Id: <20190117162008.25217-6-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Export few HFI functions to use them from decoder to implement
more granular control needed for stateful Codec API compliance.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/hfi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 0b3c4a2328e4..eaa82af9ec09 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -285,6 +285,7 @@ int hfi_session_start(struct venus_inst *inst)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hfi_session_start);
 
 int hfi_session_stop(struct venus_inst *inst)
 {
@@ -308,6 +309,7 @@ int hfi_session_stop(struct venus_inst *inst)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hfi_session_stop);
 
 int hfi_session_continue(struct venus_inst *inst)
 {
@@ -337,6 +339,7 @@ int hfi_session_abort(struct venus_inst *inst)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hfi_session_abort);
 
 int hfi_session_load_res(struct venus_inst *inst)
 {
@@ -383,6 +386,7 @@ int hfi_session_unload_res(struct venus_inst *inst)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hfi_session_unload_res);
 
 int hfi_session_flush(struct venus_inst *inst, u32 type)
 {
-- 
2.17.1

