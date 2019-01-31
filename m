Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3334C169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 13:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE91D218D3
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 13:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732948AbfAaNVt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:21:49 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52701 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732644AbfAaNVt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 08:21:49 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id pCHogCniSNR5ypCHrgQFn8; Thu, 31 Jan 2019 14:21:47 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Dafna Hirschfeld <dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vicodec: support SOURCE_CHANGE event for decoders only
Message-ID: <9d563c98-33a5-d0fd-a88c-63fda56adf79@xs4all.nl>
Date:   Thu, 31 Jan 2019 14:21:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOkIaR952bsMqt/VpGL2HhJ0XwqsWKVmIxruh4vIP/7KjiFYFntGgKw7ecl7KwKXSydNcFN309kzlS5eMspkl8n0xVABarEs5+4LZv1Rqtnsi0Wzc9QL
 U/w2QwfgBV81ZPpnu2FHpQmkn2GJ3Z+1lIxeCTPDTQ5jpOBrxeyltq7+4VqQGmJXRRxvdOxzjTUQbj2xCnJC8ZEaqxewnX23ZEU=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The SOURCE_CHANGE event is decoder specific, so don't allow it for
encoders.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vicodec/vicodec-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 3703b587e25e..d5a054167538 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1113,9 +1113,14 @@ static int vicodec_enum_framesizes(struct file *file, void *fh,
 static int vicodec_subscribe_event(struct v4l2_fh *fh,
 				const struct v4l2_event_subscription *sub)
 {
+	struct vicodec_ctx *ctx = container_of(fh, struct vicodec_ctx, fh);
+
 	switch (sub->type) {
-	case V4L2_EVENT_EOS:
 	case V4L2_EVENT_SOURCE_CHANGE:
+		if (ctx->is_enc)
+			return -EINVAL;
+		/* fall through */
+	case V4L2_EVENT_EOS:
 		return v4l2_event_subscribe(fh, sub, 0, NULL);
 	default:
 		return v4l2_ctrl_subscribe_event(fh, sub);
-- 
2.20.1

