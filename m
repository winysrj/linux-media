Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4793EC43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 13:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0782F21872
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 13:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbeLRNhL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:37:11 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:58712 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbeLRNhL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 08:37:11 -0500
Received: from [IPv6:2001:983:e9a7:1:fde7:94a4:18d3:95d6] ([IPv6:2001:983:e9a7:1:fde7:94a4:18d3:95d6])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ZFYagEYSDeA2FZFYbgOPKZ; Tue, 18 Dec 2018 14:37:09 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-ctrls.c/uvc: zero v4l2_event
Message-ID: <7ae211a5-29e2-0458-befc-20ef391d87e0@xs4all.nl>
Date:   Tue, 18 Dec 2018 14:37:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHVh9ckoTXiUAeoQx5JJ8E6honqbCwj/pljKw2Zz3AvaAZTlmxPVyAKbEnE6zMQ1wAgITSS8ClsF9s/ZrIwDm8PFE+xnd50F7UBC2yfDx8YvbW2qkcts
 SQMUzu5pKWKPjvz3pFa0zfEdk9aYcd0BTG8+99JbLEl1n07bvt5/KnG0TD/RV+weDhpVQ6gBSSng8CEkbfMcoUP8A14Q1mUCec7glEeSWDFGED0ijOFw70RD
 nEErHlGbLYAw9f286+HHjN4R5G9pjul+pdU4pJObzrripVVWu4ZmNdXU16TMJEiTvYZlB4okFTExXV75ANZbsqOgFN+UEeSUzdUMzgH1dSkHNgFh48nNrDBW
 YWmphRZ3LEwT2tpVJT9V4cSqwbgsFQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Control events can leak kernel memory since they do not fully zero the
event. The same code is present in both v4l2-ctrls.c and uvc_ctrl.c, so
fix both.

It appears that all other event code is properly zeroing the structure,
it's these two places.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: syzbot+4f021cf3697781dbd9fb@syzkaller.appspotmail.com
---
For details see: https://syzkaller.appspot.com/bug?extid=4f021cf3697781dbd9fb
---
diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index d45415cbe6e7..14cff91b7aea 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1212,7 +1212,7 @@ static void uvc_ctrl_fill_event(struct uvc_video_chain *chain,

 	__uvc_query_v4l2_ctrl(chain, ctrl, mapping, &v4l2_ctrl);

-	memset(ev->reserved, 0, sizeof(ev->reserved));
+	memset(ev, 0, sizeof(*ev));
 	ev->type = V4L2_EVENT_CTRL;
 	ev->id = v4l2_ctrl.id;
 	ev->u.ctrl.value = value;
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5e3806feb5d7..8a82427c4d54 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1387,7 +1387,7 @@ static u32 user_flags(const struct v4l2_ctrl *ctrl)

 static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 changes)
 {
-	memset(ev->reserved, 0, sizeof(ev->reserved));
+	memset(ev, 0, sizeof(*ev));
 	ev->type = V4L2_EVENT_CTRL;
 	ev->id = ctrl->id;
 	ev->u.ctrl.changes = changes;
