Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF057C00319
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB1E220652
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oa8szHa8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfBXJC7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:02:59 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51815 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbfBXJC6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:02:58 -0500
Received: by mail-wm1-f68.google.com with SMTP id n19so5395881wmi.1
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iPmSdIbe4trCHxbnuMCBZC6tC1phNVbZzz8x8XUekG8=;
        b=oa8szHa8SYd9PKka+9lsntlo4y930h1AP3sfVqONgE2h8177G+MfvQM16rRwhdW1YE
         JBdjdTR9vdq3UDPb+znSSF/33T8uC3cGl1EEXR5FqTn9hI2/awF/zDqM+iD39JECIqVE
         Oz07Ax7XsddSG9XPVsRM+AuTjutIeBVOoWOLXNsWXSqzFlOcWEg0ORlHIpPZb2jDx9lQ
         Cx6L8nsBB9FPz1m7yNRudcdgH+hMNtseEtBGW+ngmBsBHHp7uEg9F/yxXNHqMKT9Jugt
         gqmH6QduPNNHZIsT1Ej36iAfcu04kRv3IwJief03iWVJZaZG8oMP0zSPL7ZTook+2Vbw
         DT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iPmSdIbe4trCHxbnuMCBZC6tC1phNVbZzz8x8XUekG8=;
        b=QLkMlZ9uT29ghHL2Gx1SYJ/qNc4uJByZ1oofjnS5z2MP0+vDuDO87RdVOvs8APbzdW
         HxIar43lvF93Uv1Bgif89haW0w3x5rWJRkAUjGO+yGJ+znSE8Urytw1HDG3fyNdaSIMA
         wZbuGYS6n8cBF+uFF5YERFqcvi/60PzgZXO5sOUEpIeDUDT+RnFmRhbAo0YH8b4RkF2o
         m7hAouehUuzwTX1VsM/gEYw1zburVrPgDEVGz8QdbO9DE3M3MueTaC/CCxlmZTN9hv7r
         c4e/7M2/W/wttuLRwqF1zvmmS2pmf9Yu82ecRSVizAOYbuSG9ZFkGSWU9TfoVHRM/y/2
         PkwQ==
X-Gm-Message-State: AHQUAuYvu1o0uqQYgrGAjYJs6Rgh3r0NKFGveg9BJ4RhJDX4LVXIZIxz
        atqb6G5ZpvN0hk6a3Nw6sWvB0o6jUdE=
X-Google-Smtp-Source: AHgI3IZRBN7n4GPDHsVpQ1uZuYlGCwZbAClZgIrwe6XCpFMPfaVG7GwjRnCZR8nPoV86VkygGVs/rA==
X-Received: by 2002:a1c:2283:: with SMTP id i125mr7156939wmi.24.1550998976610;
        Sun, 24 Feb 2019 01:02:56 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.02.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:02:56 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 05/18] media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon failure
Date:   Sun, 24 Feb 2019 01:02:22 -0800
Message-Id: <20190224090234.19723-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
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

