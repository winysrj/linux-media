Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75BDC43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B59DD20684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFLNX6IS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfCFVOO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:14 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38933 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfCFVON (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:13 -0500
Received: by mail-wm1-f68.google.com with SMTP id z84so7269077wmg.4
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xn/leO81Z+je5q1Sd1KppKwTC88UQ3HKERQZBlOYoHo=;
        b=iFLNX6IS93voYIacU2xDgx2Bialpf7RMAYJ/l8QAgKIAGK5FyJBCphnhtzwSbc2KV3
         hf8jCjW8WzEwaaY63LFJHcTqvgZ9a24Rz3HNMJ1F1YX6EKtrpXSvCSywwr+zRYbz2sDN
         xxqo/RwamQ/qbYWXtUFIYaaupQ50Nk87wZLx1YVXOS13piaO9mMBmJXoed+IR6faQq70
         ilT/ocWTsq9ixGEODQ36O5wMhYB7YxxuerzxdAvqaSfxmOeIBpu2XtgYDpq10TMV8WwO
         cABSs5y6fk19nIWRsIuTgY93LDJqUlh0j7Ohj9lmG6CYl/wsi+NZt/wX6TyMYKzIJmbv
         BZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xn/leO81Z+je5q1Sd1KppKwTC88UQ3HKERQZBlOYoHo=;
        b=t7CGq8MePtluzvrXbUMf8hPlnebJ63dMHBOP5T7notWpQpnOgyOoYzZXlvIPKYoByf
         BEXlasHzqqGjwDJHMOnARhlpmdgBKWF2ijGdPa4ysUgwFqnSS8huHDYE6U6wH0Ll+h4S
         U7Fgwk0UuzQP1f/hfUzBWV2okHhriskQl87g9MpJxzC7U4RahXCcw60lpo5fAM6NUynV
         gIDoIOcaEOt1+e9rNn5YwAPpb/wCVk6Kx/AdZr33FF6fOibfu2GAruCx5u9Zxnts1iaZ
         MJZDu3af/ZZan1+6pnuCzW+BbvS3w/P4LxvZZJuBS6pWlJRzqTE2P6Bx3VgoBqT0ZKS4
         oUqg==
X-Gm-Message-State: APjAAAUMcAdUaM1YKuts1L/znWCQ91D+cnVp3kl4H0+o7C2u+DXuV5Do
        1lqxBYSEV+JT8liYGPK03q5fNV43f3w=
X-Google-Smtp-Source: APXvYqweoqTS1CDFSigo/wpwZ4tZuCFaqNsRX2UyKSoa9OpbK5Vv0VrWuoNU6CR7vN2RzZj2edPwKQ==
X-Received: by 2002:a1c:f709:: with SMTP id v9mr3622935wmh.134.1551906851616;
        Wed, 06 Mar 2019 13:14:11 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:10 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 06/23] media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon failure
Date:   Wed,  6 Mar 2019 13:13:26 -0800
Message-Id: <20190306211343.15302-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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
index e5cae37ced2d..200f8a66ecaa 100644
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

