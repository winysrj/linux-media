Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B3AC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 797B120C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5Fta34l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbfBZRFk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:40 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40785 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbfBZRFj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id q1so14807256wrp.7
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iPmSdIbe4trCHxbnuMCBZC6tC1phNVbZzz8x8XUekG8=;
        b=d5Fta34lX3qS/YTR1EF5qWYEGjz3zYj/UszZ/WPu1nA8LyG9L+m2e0ho1hZ+YXRwO0
         XpU5KWGWxBbgncSowCHIfgauxkw1rWRtpgX36cgBWRXVq/GXcujV7f2NTrxBJxzrEfQv
         jOpGeE3BRTpnR/D/oRdmpp5/jRlkc6LvDkbjrQu8LO2V4ZKPt6s2Wu5DUYrXW/J5WKYS
         8Oxdjnsld2BjKr1ke72qhh/InLByRW4UO/+H0da91qzCroPAkGd1YTiHbpzCYbnhpmeZ
         fJzy6LjD5QNYJdWdPBEJXOy8wvjOB0/XMcjIe8wRPHmFLmZi+cNH4iE5wFfMj21fN3dn
         +g9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iPmSdIbe4trCHxbnuMCBZC6tC1phNVbZzz8x8XUekG8=;
        b=gykP4fd+AoCfJZgfmHO6iBRnV08KqlmGTqPm8i0/nJkGD3rOzA/K7rE6vJ4uDT3ZxQ
         DmoYX7W+rRWF4MnP/PrkT2T2JHfyNI6eb1kcj7rP95jZUYzeEzpsptKzpCg70K2sb7l4
         oxlDbJqSWEHSCcfkpg8lNgD3tAnZxBxV4+Dr5Mo4MpR44eKKKma0o1VPEvIxhwX8wtPP
         XLzD+/PWY65XwohgMBrZ7if/OYlcvaVuO5udeMrVUVBskmwNhx4ty996fl+344ZG1Ogt
         cHGYkVpqnDMIJfJAtBmifG7oHsOK5kfdqe7kQHNVniq064tqxeg3m7EkvLeuZ4NB8AJ+
         cbCg==
X-Gm-Message-State: AHQUAuZUP52Hu5VQmj4yzTYFcki9lR/sgxYRWeYFAUxWhkq3TtSbbvJI
        +Q99IA2nFxZrSktFiFX9FltafgHYd28=
X-Google-Smtp-Source: AHgI3IZ0M0ChA5vEE6a3Txi3cT3YNw/iPIo5DpvTJzxf7zPTrLrxT5dGFIcUfP4wYhHPFocJqjTY4w==
X-Received: by 2002:a5d:500c:: with SMTP id e12mr18234288wrt.27.1551200737521;
        Tue, 26 Feb 2019 09:05:37 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:36 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 06/21] media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon failure
Date:   Tue, 26 Feb 2019 09:04:59 -0800
Message-Id: <20190226170514.86127-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If one of the controls fails to set,
then 'v4l2_ctrl_request_setup'
immediately returns with the error code.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 18 +++++++++++-------
 include/media/v4l2-ctrls.h           |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b79d3bbd8350..54d66dbc2a31 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3899,18 +3899,19 @@ void v4l2_ctrl_request_complete(struct media_request *req,
 }
 EXPORT_SYMBOL(v4l2_ctrl_request_complete);
 
-void v4l2_ctrl_request_setup(struct media_request *req,
+int v4l2_ctrl_request_setup(struct media_request *req,
 			     struct v4l2_ctrl_handler *main_hdl)
 {
 	struct media_request_object *obj;
 	struct v4l2_ctrl_handler *hdl;
 	struct v4l2_ctrl_ref *ref;
+	int ret = 0;
 
 	if (!req || !main_hdl)
-		return;
+		return 0;
 
 	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
-		return;
+		return -EBUSY;
 
 	/*
 	 * Note that it is valid if nothing was found. It means
@@ -3919,10 +3920,10 @@ void v4l2_ctrl_request_setup(struct media_request *req,
 	 */
 	obj = media_request_object_find(req, &req_ops, main_hdl);
 	if (!obj)
-		return;
+		return 0;
 	if (obj->completed) {
 		media_request_object_put(obj);
-		return;
+		return -EBUSY;
 	}
 	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
 
@@ -3990,12 +3991,15 @@ void v4l2_ctrl_request_setup(struct media_request *req,
 				update_from_auto_cluster(master);
 		}
 
-		try_or_set_cluster(NULL, master, true, 0);
-
+		ret = try_or_set_cluster(NULL, master, true, 0);
 		v4l2_ctrl_unlock(master);
+
+		if (ret)
+			break;
 	}
 
 	media_request_object_put(obj);
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_ctrl_request_setup);
 
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index d63cf227b0ab..c40dcf79b5b9 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1127,7 +1127,7 @@ __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
  * applying control values in a request is only applicable to memory-to-memory
  * devices.
  */
-void v4l2_ctrl_request_setup(struct media_request *req,
+int v4l2_ctrl_request_setup(struct media_request *req,
 			     struct v4l2_ctrl_handler *parent);
 
 /**
-- 
2.17.1

