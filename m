Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51522C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2414921019
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfCMOqr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:46:47 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38362 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfCMOqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 10:46:47 -0400
Received: from [IPv6:2001:420:44c1:2579:e8a7:494:d652:7065] ([IPv6:2001:420:44c1:2579:e8a7:494:d652:7065])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 459WhlODF4HFn459ahPnfv; Wed, 13 Mar 2019 15:46:46 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Dafna Hirschfeld <dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vicodec: remove WARN_ON(1) from get_q_data()
Message-ID: <73d1847a-775e-5d53-4bfb-7933bbec33de@xs4all.nl>
Date:   Wed, 13 Mar 2019 15:46:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJ6Svn1ABuDSB9zRbQ+/V8TsRQv7pNHwKUJObTnZcI0QpjRAKcY92C7ASvhtlCBbiULrsgep8GEz9lna00q9W0D1C0u5RkbHowJ+zDqjLfEQXMkKUcp3
 pYGH8hE3YAuTs2CBF3aPJ6jVafzrtAKbO9C8M/HOJfR23GpUeUjY2rbTLXCCGZ7UekjL8839r6keTh/WbvLEtMkq8pIv3HNCkULfziobKt7oV0sfFmxeaXRQ
 Q+j+G/LZzPyUlfBW/BRELIMRXavsitzN0q0hiQZ+7kQWlzGYd3WEgwXB1+NEcKFTzq/j1GFtYcM0KkRwcDmMjA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some functions like enum_fmt use the buffer type as was passed
from userspace, which might cause the switch to fall into the
default case. Just drop the WARN_ON(1) to avoid kernel log pollution.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vicodec/vicodec-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index d7636fe9e174..075927dba614 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -148,7 +148,6 @@ static struct vicodec_q_data *get_q_data(struct vicodec_ctx *ctx,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		return &ctx->q_data[V4L2_M2M_DST];
 	default:
-		WARN_ON(1);
 		break;
 	}
 	return NULL;
-- 
2.20.1

