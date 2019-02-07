Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238BFC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4FE32080F
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfBGJS7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:18:59 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38651 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726691AbfBGJS7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 04:18:59 -0500
Received: from [IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5] ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rfpggHhXPRO5ZrfphgrQRd; Thu, 07 Feb 2019 10:18:57 +0100
Subject: Re: [PATCH 5/6] omap3isp: fix sparse warning
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-6-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <3748564a-6efe-f008-bb17-1977d2575c68@xs4all.nl>
Date:   Thu, 7 Feb 2019 10:18:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190207091338.55705-6-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNyu4IQ7E/lTkcHiydR7XPzh3riDOrOrX2olWInWC2UjaUBJjmu7vqawvIv00cWjuBuXkVqnWwjWVbuGwogd4VlLenuwj9L0npqHN672uxdJO+R3lVYW
 nMddyItYjCU2kPIxiVxTYQ0D0LmASAcyaCR59C1XxTHdsTYcihLYNGemht9g1IhmZFKAhQ6mvsADDDXJayukfI8kxxJHcSj4rvnO7Wh9XwYCls4qp7LNDuop
 YfKi2qjxra9RELacGiZFNS+cPK0v5kpKxIJKw6ArhmelttFYxMBrCEVG2cC0HeTqxp+cafue+jF8IXcnsG07LfyM8K11bvOSC3Gzm58X9TR6X6bcQhPzQ+C1
 S5XyiHm7PRkA2pNWWhgO39W/xJ2Jl+/ukjzL4cLoIq3KHTPSUnbNyNeqdt8mAd8Sg/86770G
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/7/19 10:13 AM, Hans Verkuil wrote:
> drivers/media/platform/omap3isp/ispvideo.c:1013:15: warning: unknown expression (4 0)

I should add this text to the commit log:

The combination of the v4l2_subdev_call and media_entity_to_v4l2_subdev macros
became too complex for sparse. So first assign the result of
media_entity_to_v4l2_subdev to a struct v4l2_subdev *sd variable, then
use that in v4l2_subdev_call.

Regards,

	Hans

> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index 078d64114b24..911dfad90d32 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -974,6 +974,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  	struct media_entity *source = NULL;
>  	struct media_entity *sink;
>  	struct v4l2_subdev_format fmt;
> +	struct v4l2_subdev *sd;
>  	struct v4l2_ext_controls ctrls;
>  	struct v4l2_ext_control ctrl;
>  	unsigned int i;
> @@ -1010,8 +1011,8 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  
>  	fmt.pad = source_pad->index;
>  	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(sink),
> -			       pad, get_fmt, NULL, &fmt);
> +	sd = media_entity_to_v4l2_subdev(sink);
> +	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
>  	if (unlikely(ret < 0)) {
>  		dev_warn(isp->dev, "get_fmt returned null!\n");
>  		return ret;
> 

