Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5AEC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 491112147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfBHIt1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:49:27 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:39822 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbfBHIt1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 03:49:27 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id s1qdgyjYOBDyIs1qfgLZv6; Fri, 08 Feb 2019 09:49:26 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-subdev.h: v4l2_subdev_call: use temp __sd variable
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <c3a4c93b-e331-b049-fddf-7f7196bc362a@xs4all.nl>
Date:   Fri, 8 Feb 2019 09:49:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfP32R5AACT3v0ypSR+947Djk9IshTEexbc0O7ewue6NZQ9YHQv9ISEOD7htCB21ei6mdn09+kPS17fz3tWL4hFqNCNmC9fF/HSfLvnVh43Jm6Pt449pb
 jqhyIU0IRR1fQE4aVExAonXnSNwyL/aMlDAxzrIY5GvqX3OCp+Rul0LSG+xO/5zpG1te3tIeVxCysnkgnV2KH8wG+kj+P9ePD1W2jgSoHQbm5vu30ZfxU3w6
 f3jp5xhiRUoaiUWyVLuq64D/kIP8ay98ZwL6rDoTJt+nRQpxVxV86Oz2KMaDpQMJcbkogTxKCGw9ga94JkNqNa7fBcmhr5ENcKFlTw6Kr9sBaac3wreSfuBK
 MOZnj3wa
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The sd argument of this macro can be a more complex expression. Since it
is used 5 times in the macro it can be evaluated that many times as well.

So assign it to a temp variable in the beginning and use that instead.

This also avoids any potential side-effects of evaluating sd.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 47af609dc8f1..34da094a3f40 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -1093,13 +1093,14 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
  */
 #define v4l2_subdev_call(sd, o, f, args...)				\
 	({								\
+		struct v4l2_subdev *__sd = (sd);			\
 		int __result;						\
-		if (!(sd))						\
+		if (!__sd)						\
 			__result = -ENODEV;				\
-		else if (!((sd)->ops->o && (sd)->ops->o->f))		\
+		else if (!(__sd->ops->o && __sd->ops->o->f))		\
 			__result = -ENOIOCTLCMD;			\
 		else							\
-			__result = (sd)->ops->o->f((sd), ##args);	\
+			__result = __sd->ops->o->f(__sd, ##args);	\
 		__result;						\
 	})

