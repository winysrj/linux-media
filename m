Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37567C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 11:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DFCA20859
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 11:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392502AbfAPLqd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 06:46:33 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34952 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392481AbfAPLq3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 06:46:29 -0500
Received: from [IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427] ([IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427])
        by smtp-cloud7.xs4all.net with ESMTPA
        id jjeMgLqfNBDyIjjeNg21JZ; Wed, 16 Jan 2019 12:46:27 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vidioc-prepare-buf.rst: drop reference to NO_CACHE flags
Message-ID: <ab63eaf9-2443-d369-af38-b3d332a237a4@xs4all.nl>
Date:   Wed, 16 Jan 2019 12:46:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGxa3wWmhB2DVNpKSyhfiXO41jzURSsZRlhMcVo+eGPZf+Bd5JRzEvg+7o+1a1LMqWozFYPJExZ9cIHGbsCjaU9wLJflj8NS8LFr1TfVAp/EJieLj8L3
 2VFCqap8mGTGLAJUIixic5fpoEf7akxpoyU4m7msCxFi9Xrv7SYf7YsaCN/XT6YdW0lTglkVlk2V1/hmruORZQl2yZy1HknrAKFQC4aPyiHgY2Rn+nvSMwBh
 OHJR8sVY+q1RxvLd9n3KrVpYWALkmj54rNy7g6k3LjE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This was never implemented, so do not document this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 Documentation/media/uapi/v4l/vidioc-prepare-buf.rst | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index 60986710967b..7c6b5f4e1011 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -43,10 +43,7 @@ Applications can optionally call the :ref:`VIDIOC_PREPARE_BUF` ioctl to
 pass ownership of the buffer to the driver before actually enqueuing it,
 using the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl, and to prepare it for future I/O. Such
 preparations may include cache invalidation or cleaning. Performing them
-in advance saves time during the actual I/O. In case such cache
-operations are not required, the application can use one of
-``V4L2_BUF_FLAG_NO_CACHE_INVALIDATE`` and
-``V4L2_BUF_FLAG_NO_CACHE_CLEAN`` flags to skip the respective step.
+in advance saves time during the actual I/O.

 The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
-- 
2.20.1

