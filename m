Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62788C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A4CB20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ID+4hV60"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbfAQQVG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:21:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38538 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbfAQQVF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:21:05 -0500
Received: by mail-wm1-f68.google.com with SMTP id m22so1703641wml.3
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 08:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TJaSy4d66OCwtAmSCJDYHgEl9smQdDOgylQ4NVN0QXo=;
        b=ID+4hV60rYEImVqLh4qgQz1UgmPaRxLzYdRwnU4ZLrAWeZhYUqbByJWdJ5777bmiXZ
         mSnWIYtg4i51E3WXGfHI6TdGplIp6oVz2BJxqycq9eB45/uW6h7hYimHqgGysFitTX78
         U3PSKD/M3i+bJwPqa+g332x9LsIEf/eAvp8PA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TJaSy4d66OCwtAmSCJDYHgEl9smQdDOgylQ4NVN0QXo=;
        b=EXno4wp1xzIuF6WA1t2sSzNd8TBCuNWJMQHx/CIp/dREB6498rCxUoyk8dBYK84nZy
         ksbJUexu3xR1afl7GZZBKQouXWM4nDrMBsgjBHjWAH37oab+xtkrYeT/yTIa+XcGwRKW
         OU5B7CXnERt9VzFkV47CuaAy/ZHotuPZgDmfQfxv8xUZr3V6JGzAQKQeLDhrMy9WasIY
         iUj+rOQfihFNWtVSCUSdok7JMuM6ijCo+gIT8vuh6it+PEKLMcyNZE1G7rLQtOQ8JB7E
         tK5ao68biSUEL32dy05FSkzuJeJVxyrbKFEjypKEEf8tiUrdwfqHWwV+HQEPo8b4P87+
         //6Q==
X-Gm-Message-State: AJcUukcUBFZUrnjwy7LpwA6HtqHdhuUO/sn1uvPjkOvTk8LT0i4JsWNh
        zV8F3OI2pUR/JTswvEg8vjxwu7H7Wis=
X-Google-Smtp-Source: ALg8bN5OJVAUl0X9y58yn19C3GFfJepnyqa93kpGMGcMXEVjFQ59M+W/2UjbnrON/hVEeE1AtxksXQ==
X-Received: by 2002:a1c:2856:: with SMTP id o83mr13280390wmo.45.1547742062957;
        Thu, 17 Jan 2019 08:21:02 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id v133sm31124734wmf.19.2019.01.17.08.21.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 08:21:02 -0800 (PST)
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
Subject: [PATCH 03/10] venus: helpers: export few helper functions
Date:   Thu, 17 Jan 2019 18:20:01 +0200
Message-Id: <20190117162008.25217-4-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Here we export few helper function to use them from decoder to
implement more granular control needed for stateful Codec API
compliance.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 29 ++++++++++++---------
 drivers/media/platform/qcom/venus/helpers.h |  7 +++++
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 86105de81af2..f33bbfea3576 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -88,7 +88,7 @@ bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
 }
 EXPORT_SYMBOL_GPL(venus_helper_check_codec);
 
-static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
+int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
 {
 	struct intbuf *buf;
 	int ret = 0;
@@ -109,6 +109,7 @@ static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
 fail:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(venus_helper_queue_dpb_bufs);
 
 int venus_helper_free_dpb_bufs(struct venus_inst *inst)
 {
@@ -287,7 +288,7 @@ static const unsigned int intbuf_types_4xx[] = {
 	HFI_BUFFER_INTERNAL_PERSIST_1,
 };
 
-static int intbufs_alloc(struct venus_inst *inst)
+int venus_helper_intbufs_alloc(struct venus_inst *inst)
 {
 	const unsigned int *intbuf;
 	size_t arr_sz, i;
@@ -313,11 +314,13 @@ static int intbufs_alloc(struct venus_inst *inst)
 	intbufs_unset_buffers(inst);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(venus_helper_intbufs_alloc);
 
-static int intbufs_free(struct venus_inst *inst)
+int venus_helper_intbufs_free(struct venus_inst *inst)
 {
 	return intbufs_unset_buffers(inst);
 }
+EXPORT_SYMBOL_GPL(venus_helper_intbufs_free);
 
 static u32 load_per_instance(struct venus_inst *inst)
 {
@@ -348,7 +351,7 @@ static u32 load_per_type(struct venus_core *core, u32 session_type)
 	return mbs_per_sec;
 }
 
-static int load_scale_clocks(struct venus_core *core)
+int venus_helper_load_scale_clocks(struct venus_core *core)
 {
 	const struct freq_tbl *table = core->res->freq_tbl;
 	unsigned int num_rows = core->res->freq_tbl_size;
@@ -397,6 +400,7 @@ static int load_scale_clocks(struct venus_core *core)
 	dev_err(dev, "failed to set clock rate %lu (%d)\n", freq, ret);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(venus_helper_load_scale_clocks);
 
 static void fill_buffer_desc(const struct venus_buffer *buf,
 			     struct hfi_buffer_desc *bd, bool response)
@@ -481,7 +485,7 @@ static bool is_dynamic_bufmode(struct venus_inst *inst)
 	return caps->cap_bufs_mode_dynamic;
 }
 
-static int session_unregister_bufs(struct venus_inst *inst)
+int venus_helper_unregister_bufs(struct venus_inst *inst)
 {
 	struct venus_buffer *buf, *n;
 	struct hfi_buffer_desc bd;
@@ -498,6 +502,7 @@ static int session_unregister_bufs(struct venus_inst *inst)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(venus_helper_unregister_bufs);
 
 static int session_register_bufs(struct venus_inst *inst)
 {
@@ -1018,8 +1023,8 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
 	if (inst->streamon_out & inst->streamon_cap) {
 		ret = hfi_session_stop(inst);
 		ret |= hfi_session_unload_res(inst);
-		ret |= session_unregister_bufs(inst);
-		ret |= intbufs_free(inst);
+		ret |= venus_helper_unregister_bufs(inst);
+		ret |= venus_helper_intbufs_free(inst);
 		ret |= hfi_session_deinit(inst);
 
 		if (inst->session_error || core->sys_error)
@@ -1030,7 +1035,7 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
 
 		venus_helper_free_dpb_bufs(inst);
 
-		load_scale_clocks(core);
+		venus_helper_load_scale_clocks(core);
 		INIT_LIST_HEAD(&inst->registeredbufs);
 	}
 
@@ -1050,7 +1055,7 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
 	struct venus_core *core = inst->core;
 	int ret;
 
-	ret = intbufs_alloc(inst);
+	ret = venus_helper_intbufs_alloc(inst);
 	if (ret)
 		return ret;
 
@@ -1058,7 +1063,7 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
 	if (ret)
 		goto err_bufs_free;
 
-	load_scale_clocks(core);
+	venus_helper_load_scale_clocks(core);
 
 	ret = hfi_session_load_res(inst);
 	if (ret)
@@ -1079,9 +1084,9 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
 err_unload_res:
 	hfi_session_unload_res(inst);
 err_unreg_bufs:
-	session_unregister_bufs(inst);
+	venus_helper_unregister_bufs(inst);
 err_bufs_free:
-	intbufs_free(inst);
+	venus_helper_intbufs_free(inst);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(venus_helper_vb2_start_streaming);
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 2475f284f396..24faae5abd93 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -18,6 +18,7 @@
 #include <media/videobuf2-v4l2.h>
 
 struct venus_inst;
+struct venus_core;
 
 bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt);
 struct vb2_v4l2_buffer *venus_helper_find_buf(struct venus_inst *inst,
@@ -62,4 +63,10 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst);
 int venus_helper_free_dpb_bufs(struct venus_inst *inst);
 int venus_helper_power_enable(struct venus_core *core, u32 session_type,
 			      bool enable);
+int venus_helper_intbufs_alloc(struct venus_inst *inst);
+int venus_helper_intbufs_free(struct venus_inst *inst);
+int venus_helper_intbufs_realloc(struct venus_inst *inst);
+int venus_helper_queue_dpb_bufs(struct venus_inst *inst);
+int venus_helper_unregister_bufs(struct venus_inst *inst);
+int venus_helper_load_scale_clocks(struct venus_core *core);
 #endif
-- 
2.17.1

