Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6E5C2F3A6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B78402085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfAUNck (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:40 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:46931 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728797AbfAUNch (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:37 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgpgPCKO; Mon, 21 Jan 2019 14:32:35 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 8/8] v4l2-common: drop v4l2_get_timestamp
Date:   Mon, 21 Jan 2019 14:32:29 +0100
Message-Id: <20190121133229.33893-9-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
References: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHJdqdM1aTPcvwsYFeS1YIfWDZyUwcw8+6+3C10VZjMgiB1NYCQaaZdB3EM5Vks01ujzzVO1btt2s3w23lmHEvZiXmmR4ur0yUk1nVo0blSobiou3XUK
 4X86fdHlekNmBTfVQF/VZBqrKNguy8PocBz33ChDpjj9ULDfE6Kh0WSbK+LUFV+JnmoN0mqYOAajJQvsr13D6zS8BxF+nbUVUQWfps7v8JFqCl1rYGZGIEzL
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

This function is no longer used, so drop it.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-common.c | 10 ----------
 include/media/v4l2-common.h           |  9 ---------
 2 files changed, 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 50763fb42a1b..663730f088cd 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -398,16 +398,6 @@ __v4l2_find_nearest_size(const void *array, size_t array_size,
 }
 EXPORT_SYMBOL_GPL(__v4l2_find_nearest_size);
 
-void v4l2_get_timestamp(struct timeval *tv)
-{
-	struct timespec ts;
-
-	ktime_get_ts(&ts);
-	tv->tv_sec = ts.tv_sec;
-	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
-}
-EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
-
 int v4l2_g_parm_cap(struct video_device *vdev,
 		    struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 {
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 0c511ed8ffb0..2b93cb281fa5 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -361,15 +361,6 @@ __v4l2_find_nearest_size(const void *array, size_t array_size,
 			 size_t entry_size, size_t width_offset,
 			 size_t height_offset, s32 width, s32 height);
 
-/**
- * v4l2_get_timestamp - helper routine to get a timestamp to be used when
- *	filling streaming metadata. Internally, it uses ktime_get_ts(),
- *	which is the recommended way to get it.
- *
- * @tv: pointer to &struct timeval to be filled.
- */
-void v4l2_get_timestamp(struct timeval *tv);
-
 /**
  * v4l2_g_parm_cap - helper routine for vidioc_g_parm to fill this in by
  *      calling the g_frame_interval op of the given subdev. It only works
-- 
2.20.1

