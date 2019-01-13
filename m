Return-Path: <SRS0=qapk=PV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C05C43387
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA4DA20850
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dizmj60C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfAMXiu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 13 Jan 2019 18:38:50 -0500
Received: from mail-io1-f47.google.com ([209.85.166.47]:35811 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfAMXit (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Jan 2019 18:38:49 -0500
Received: by mail-io1-f47.google.com with SMTP id f4so16365102ion.2
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2019 15:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gDVCS3yOqILhrg1ih/2Z/81P6yLBW1R0hMZliB2yQ6Y=;
        b=dizmj60CC9N1Gt3qz7wwX/4r9YFKkqrmK5fL1UKYbN4Edyd01RrfSXJiOT9NPrm+97
         ZBdGYR7b1igdYiyzbVv71dMsP478pX5yl8EugBSzu8aJAb/am5LPKIaddjg51piylmgg
         CXGsqOiC03+uz3oCkyxQpqT00S51yvqdrvAOQd+TrZOV5HIlSmlkr+6jD8jU/m74DkGS
         AzqOfwpREmluDE6Xkub4cbuoxry6VPXlkmWwVC6a8kA9N3l3HnjcNU3jk/D069aWMmN1
         UOxNHgZ71Xh1Ta3GWk6B2Sj54DAla+xkB8EGgwXpeC006+C569hq37v2j0iOz1A35Fy4
         PFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gDVCS3yOqILhrg1ih/2Z/81P6yLBW1R0hMZliB2yQ6Y=;
        b=BAzzTs3NzsglekC2oDjLar9W6UFBbRWbaztf1zn1yRbFeTsB0EZkAjHMprXztf3hpP
         o1ymnp+VuBlcfcC6JzWd+XQg6Cp/sr0tqaKPg3gl4xjb1KLR9qH0cgrrGblHXuDTNWGe
         4w7KKEEgz3L4KTLwzxiF2FcDQWYUOzoxBbPexgBrzJITijwIqMXIPZlGc98AVpvUjJPe
         6AocxlAkMafWf0eTP2ZUGhQ795/c6eAwNCciSYBtH59DiT3u7BV3kWvS1LRF0kJIy/21
         f4xkLp9247BR8RuEDlGkuaE4JqTA8QmYkGoKvNiT5TtQ7joC/EowXxxtvfawVQHVp70v
         m2KQ==
X-Gm-Message-State: AJcUukfcPiQEl7GrW4AGAv9E/731wIC0eMf7fvu6mXwytC73BJpWinFN
        h+lP1ALqdGBegWJ74ItB0VI=
X-Google-Smtp-Source: ALg8bN7cIJwUTMxtWu4psG5WQBxjg+e3ej/h6k6mh9LoLz6x/zn+U2eqmLXxXK+lbsBOMqvFIj3Ybw==
X-Received: by 2002:a6b:b28a:: with SMTP id b132mr14814861iof.256.1547422728634;
        Sun, 13 Jan 2019 15:38:48 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id t70sm3132285ita.17.2019.01.13.15.38.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 13 Jan 2019 15:38:47 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar 5/5] release video buffers after probing and request them again when needed
Date:   Mon, 14 Jan 2019 07:38:29 +0800
Message-Id: <1547422709-7111-5-git-send-email-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
References: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

Patch adapted from https://bugs.archlinux.org/task/44091

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 zbar/video/v4l2.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/zbar/video/v4l2.c b/zbar/video/v4l2.c
index ad6adf4..ca52e4c 100644
--- a/zbar/video/v4l2.c
+++ b/zbar/video/v4l2.c
@@ -243,6 +243,21 @@ static int v4l2_mmap_buffers (zbar_video_t *vdo)
     return(0);
 }
 
+static int v4l2_request_buffers (zbar_video_t *vdo)
+{
+    struct v4l2_requestbuffers rb;
+    memset(&rb, 0, sizeof(rb));
+    rb.count = vdo->num_images;
+    rb.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+    rb.memory = V4L2_MEMORY_USERPTR;
+    if(v4l2_ioctl(vdo->fd, VIDIOC_REQBUFS, &rb) < 0)
+        return(err_capture(vdo, SEV_ERROR, ZBAR_ERR_SYSTEM, __func__,
+                           "requesting video frame buffers (VIDIOC_REQBUFS)"));
+    if(rb.count)
+        vdo->num_images = rb.count;
+    return(0);
+}
+
 static int v4l2_set_format (zbar_video_t *vdo,
                             uint32_t fmt)
 {
@@ -334,6 +349,8 @@ static int v4l2_init (zbar_video_t *vdo,
 
     if(vdo->iomode == VIDEO_MMAP)
         return(v4l2_mmap_buffers(vdo));
+    if(vdo->iomode == VIDEO_USERPTR)
+        return(v4l2_request_buffers(vdo));
     return(0);
 }
 
-- 
2.7.4

