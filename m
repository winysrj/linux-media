Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B5DC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7277E21908
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 14:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfBGOiG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:38:06 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:55111 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726979AbfBGOiF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 09:38:05 -0500
Received: from [IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5] ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rkoUgMa5yRO5ZrkoWgsoaH; Thu, 07 Feb 2019 15:38:04 +0100
Subject: [PATCH 7/6] omap4iss: fix sparse warning
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-7-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <546e17e7-310c-faaf-ae13-a1b005f40579@xs4all.nl>
Date:   Thu, 7 Feb 2019 15:38:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190207091338.55705-7-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIBL8N9ONSPn9kutImsKPmIgEfo03oJGduaLUJCiSGk35f9GRbNBWxWGWjTJ+j1pIXnEJkgCaZ/whtK+Llh9ieTXbbuZEBz2iqDIlPeA2EB/pH8Wa+yE
 L7jqqjzdTA/5Jdtax7nRd8snnVEMjTB9664sullS6AEelKza/uh2MO1JUO6BrrF3qX5KRFZoU/cv9G/+rR+TndpOIHL4YRH/ZDs6s5mz1YpKh/RAgcPV2zoS
 YxVeVaF/JSnhxS3vMaJbwbsg99ZlbJ5tCgHRlv+7BwqMWnuj8EWQDhcRUJEUFMmjDCKB9PNixhEZIKoj6ChL+70hooEhDsL3ckZaeKiv+vCxfb13OR0MapVU
 xBajjj/9DjgTbmFWGbRRdX8uqStrBt8cCElXcL2eYTXfEN5WdmbEC9sq1568RQpaJV7tXU+2
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Same fix as for omap3isp. I discovered that staging drivers weren't built by the
daily build, so I never noticed these warnings.
---
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index c8be1db532ab..fd702947cdb8 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -124,6 +124,7 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,
 {
 	struct iss_device *iss =
 		container_of(pipe, struct iss_video, pipe)->iss;
+	struct v4l2_subdev *sd;
 	struct v4l2_subdev_format fmt;
 	struct v4l2_ctrl *ctrl;
 	int ret;
@@ -138,8 +139,8 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,

 	fmt.pad = link->source->index;
 	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink->entity),
-			       pad, get_fmt, NULL, &fmt);
+	sd = media_entity_to_v4l2_subdev(link->sink->entity);
+	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 	if (ret < 0)
 		return -EPIPE;

