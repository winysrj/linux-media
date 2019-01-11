Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAC5C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 11:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 922502146F
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 11:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbfAKLhG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 06:37:06 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:35250 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728595AbfAKLhG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 06:37:06 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hv7XgsOhNNR5yhv7Yg9xl8; Fri, 11 Jan 2019 12:37:05 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: do not implement VIDIOC_S_PARM for output streams
Message-ID: <fc0e18f4-b499-60b4-d750-12beb06f98ce@xs4all.nl>
Date:   Fri, 11 Jan 2019 12:37:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJueUG/y39UWMKpHnr61dvHfMiI6VWKk3g8T1paG6I48R03J9mk9mZ2egOD/2dXZV9ORfS6Z/2+qYnlqL1cDosqkbxseDYdZilCzm6N63ETpmb2/zUq3
 7nke5cWIY4ISK0k+76g8YU6Jfj3wNKZe9aApnSJYaBxX3z4bS2kjTuFkjDindWLmqPxpLAmowRwgjEyN48pq2bv9oGtGwQmoUCNARdCEziumn1lch1oRtS1N
 KDeKDTrM6qh9PKdOXg7ldknJyX0cDcOme2snxwzD1Cc=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

v4l2_compliance gave a warning for the S_PARM test for output streams:

warn: v4l2-test-formats.cpp(1235): S_PARM is supported for buftype 2, but not for ENUM_FRAMEINTERVALS

The reason is that vivid mapped s_parm for output streams to g_parm. But if
S_PARM doesn't actually change anything, then it shouldn't be enabled at all.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index c931f007e5b0..7da5720b47a2 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -371,7 +371,7 @@ static int vidioc_s_parm(struct file *file, void *fh,

 	if (vdev->vfl_dir == VFL_DIR_RX)
 		return vivid_vid_cap_s_parm(file, fh, parm);
-	return vivid_vid_out_g_parm(file, fh, parm);
+	return -ENOTTY;
 }

 static int vidioc_log_status(struct file *file, void *fh)
