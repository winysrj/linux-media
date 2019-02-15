Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5B3C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D0521A80
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dSBqh6f6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394893AbfBONGS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:06:18 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55915 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394890AbfBONGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:06:18 -0500
Received: by mail-wm1-f67.google.com with SMTP id r17so9784806wmh.5
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 05:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uvmy35hFkjzQOS1mgFxZVeKidzlnTbqbeCkhrfz7Mw4=;
        b=dSBqh6f6Vw0arEvqPzDXXNQJ9YQgCIL65L4/LNzogYwVV1Uyq2u6JJpzZ0abl1+eRo
         17Bb8gtwKTjO3zQjvug3byA0jvVd/okQTNKReo2JyrSyWaGg0iSr3OfEpJTg0gmjiBtL
         rC2q5GzgKbXnz5qMSHiZzoQ975b1Z9BO7Er5kiuAtWzTatOePhWHiHxVzVkqksjQ0VdH
         45o8vWt0kmmKhjZzA7AmEJPszI0iNeIRhdJtC+bX9uYXRXRF0DHb2iEpabunmgDc77zu
         2RWUiqpcIrY9CKxUhsisP53yIOABb5COhdnBaRNqDkJnWUeIuj254SkZdFVAmuOWaGCr
         HlaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uvmy35hFkjzQOS1mgFxZVeKidzlnTbqbeCkhrfz7Mw4=;
        b=nXk+rphWf+/mtVRjc1ywzatV8z6+lIjQASzXPKnLK4aUycJ9kYLWz82VDnVq09tfQ6
         karlRgc43u0GBSykZ+Y2pZBDHU9GZd3X7iOugFEruIw49Tj+m9kiywcfpE1+yReMNwOJ
         caTZhzvLrttnQq7TaU6aKRNagx6262rwCb5CXdSk51dMdWRBrH21g+XBumcT5zuC6pvc
         41RPy6rk6xeNjfkfAXuyOA9dK89VJugjelOyVQWtXzrO3XJhgKynOEbw7/+Tt/o2jX0j
         r9NpoGrTO4m1r3UElWwc3Zk7OP29ui65EBLFkdn9oMUYVkzExKuMTihI9eKSR+lcMkFk
         ibvw==
X-Gm-Message-State: AHQUAuac1S3Wm2xe4mw5kt/OwcpoLj3cLVWmc7TFSxaz/+18403vSYmh
        PPl/uRZnmDSAIWMmXHzlJ0dRiagaP1c=
X-Google-Smtp-Source: AHgI3IaTLP0FK/vxbdh5BIRhOK7dYzFnnndQMw+zTanstOjJ/r2uIOqoIZbv69IWS7nAXGm/3++X9w==
X-Received: by 2002:a1c:f916:: with SMTP id x22mr6851400wmh.87.1550235976267;
        Fri, 15 Feb 2019 05:06:16 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id n6sm2091065wrt.23.2019.02.15.05.06.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 05:06:15 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 01/10] media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon failure
Date:   Fri, 15 Feb 2019 05:05:01 -0800
Message-Id: <20190215130509.86290-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190215130509.86290-1-dafna3@gmail.com>
References: <20190215130509.86290-1-dafna3@gmail.com>
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
index 7825c8d66498..ff75f84011f8 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3904,18 +3904,19 @@ void v4l2_ctrl_request_complete(struct media_request *req,
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
@@ -3924,10 +3925,10 @@ void v4l2_ctrl_request_setup(struct media_request *req,
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
 
@@ -3995,12 +3996,15 @@ void v4l2_ctrl_request_setup(struct media_request *req,
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

