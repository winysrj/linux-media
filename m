Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85E2C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8781C218D3
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:45:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="XfZYARbt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfBGPp2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:45:28 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48442 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfBGPp2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 10:45:28 -0500
Received: from pendragon.ideasonboard.com (d51A4137F.access.telenet.be [81.164.19.127])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4A3ED2EF;
        Thu,  7 Feb 2019 16:45:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549554326;
        bh=NWL9kAsFCOIIOQ8fQBmYvOFCMLd/6dRYpXDmxIgKGwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XfZYARbt4/zTrnB7FklwDMJOyp0/dVcOU/zyTWxojwT5mz81QdsnrEW7nfdmBW3bj
         UJkXS//MJNmtyeWiEs6FqgBdZbQ4jID8InPN+CruWY7mgxttEzaiclubOHoYvm8QHN
         Iu4+uG4w0fw+JLsdeKBZe2vIJJcm+oU7AJGX7lDM=
Date:   Thu, 7 Feb 2019 17:45:20 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH 5/6] omap3isp: fix sparse warning
Message-ID: <20190207154520.GF5378@pendragon.ideasonboard.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-6-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190207091338.55705-6-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 07, 2019 at 10:13:37AM +0100, Hans Verkuil wrote:
> drivers/media/platform/omap3isp/ispvideo.c:1013:15: warning: unknown expression (4 0)
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

This is really a workaround for an issue in smath, and I don't like it.
Where will we draw the line if we accept it ? Will we start rejecting
all nested function calls or macros because we have a tooling issue ?
This one really needs to be fixed in smatch, the code is totally fine.

>  	if (unlikely(ret < 0)) {
>  		dev_warn(isp->dev, "get_fmt returned null!\n");
>  		return ret;

-- 
Regards,

Laurent Pinchart
