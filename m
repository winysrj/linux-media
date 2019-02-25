Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACFAC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C974D2147C
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPOJpWJp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfBYWUE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:20:04 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41484 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfBYWUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:20:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id n2so11698947wrw.8
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iPmSdIbe4trCHxbnuMCBZC6tC1phNVbZzz8x8XUekG8=;
        b=NPOJpWJp8IvR1QYJ/EFHN4VQ+rt2hh4bn88OdUixkeG6I3QZyKrPcPGbhj2W2tP3Ax
         3fYfVJ7QumokCf7lGwoCKPvVqA7SECl+4lL0voAuYj1bbbK77yimNwFWPSyqNmz/9WsY
         3oqCS6a3DibFyjT/9rPWTZjpNtUtjMeV5vuC96YCIhxqGi1IzZ8u3V9tC1N+aQoIMGHE
         acKEiqxlKCeapaPRWcz55svjhh35rfWX5Q44fl/uyvwiCP236TBAVVYaEOghuOauXQSH
         6ZBXp2Rd1LkQm8TzdrJG0wThWIaB7YQgYw4A71h0jMMhs7MqzJ5t1METYVOJzw8f9eD3
         4wXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iPmSdIbe4trCHxbnuMCBZC6tC1phNVbZzz8x8XUekG8=;
        b=D9YWdBaRnDtzAX7YHcCPNu4MADApAuDkJKhgEeHS6CNYKTVMY5YxXTUzej0aehaf6T
         H8jjr1AVq9YcHLkM8aCqYOiM/a17SveJNe+NaLY3gSMiK6HxZ6rDIVlNK0IRrYunlM80
         i6Er0oaQ2vnRetDw1gE9kUl+uTt9H1zpBKrdda/7sCtAcsqJtYqSxM7t4NyJxkHPFpo6
         8nK4kH/d9Z/4toKPd9mfEmmE5Je1dWGoaOdqWioza9X7Tjkndd6H9MpY4SFdYrj3BRNV
         WjatbCLhmH6K5EZ3uybtl65bV+H79rKkrHJ2uchSiaWQCMbjnzVGzm1dh9482yKKY6wf
         ikuQ==
X-Gm-Message-State: AHQUAuZRIl+oxyq6OqGmlH8FcRz5XZZnJzq41Lp3LC+S5Mstn6XNms3k
        fy1TN0le+jtw20d9U3Wyv7x63DxHWLc=
X-Google-Smtp-Source: AHgI3IZFOJya8z76XC2eYureV1OrVWq8u7/Znqkgw4vMED+yhcvKTpOUcPScC+2R7Mxy3gyHCHq9Pw==
X-Received: by 2002:a5d:4710:: with SMTP id y16mr13916348wrq.305.1551133200344;
        Mon, 25 Feb 2019 14:20:00 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.19.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:19:59 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 06/21] media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon failure
Date:   Mon, 25 Feb 2019 14:19:30 -0800
Message-Id: <20190225221933.121653-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225221933.121653-1-dafna3@gmail.com>
References: <20190225221933.121653-1-dafna3@gmail.com>
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

