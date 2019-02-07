Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B305C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1264721872
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 15:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="DQ7eUoMa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfBGPrR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 10:47:17 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:48472 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGPrR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 10:47:17 -0500
Received: from pendragon.ideasonboard.com (d51A4137F.access.telenet.be [81.164.19.127])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C17442EF;
        Thu,  7 Feb 2019 16:47:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549554435;
        bh=XC+gV0c4JaBKTAKh+ywpRa4P2NdYoVk6vCv9a5k4yD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DQ7eUoMaSjnXT36IBehAT6p0w45hqhmCFzYsJc3z2VZ4fpvyTKqB5aiCO0IevC5K0
         Dc6SwWlKMU73ulCnaMXr88a5z7EbeIVoQFLcIF+U2orbSqmxa5292YsuXOeV0Xqc7K
         ISGi4yZD8pikSjzAo61A3CC1Sf8xZIUvsZafbBCA=
Date:   Thu, 7 Feb 2019 17:47:14 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH 7/6] omap4iss: fix sparse warning
Message-ID: <20190207154714.GA10386@pendragon.ideasonboard.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-7-hverkuil-cisco@xs4all.nl>
 <546e17e7-310c-faaf-ae13-a1b005f40579@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <546e17e7-310c-faaf-ae13-a1b005f40579@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 07, 2019 at 03:38:02PM +0100, Hans Verkuil wrote:
> drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
> drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
> drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
> drivers/staging/media/omap4iss/iss.c:141:15: warning: unknown expression (4 0)
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> Same fix as for omap3isp. I discovered that staging drivers weren't built by the
> daily build, so I never noticed these warnings.

Same answer as for the omap3isp driver then :-) Let's fix the tool
please. Dan Carpenter has been very supportive when we reported smatch
issues in the past, let's work with him to improve the tool instead of
patching all current and future kernel code to work around the problem.

> ---
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index c8be1db532ab..fd702947cdb8 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -124,6 +124,7 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,
>  {
>  	struct iss_device *iss =
>  		container_of(pipe, struct iss_video, pipe)->iss;
> +	struct v4l2_subdev *sd;
>  	struct v4l2_subdev_format fmt;
>  	struct v4l2_ctrl *ctrl;
>  	int ret;
> @@ -138,8 +139,8 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,
> 
>  	fmt.pad = link->source->index;
>  	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(link->sink->entity),
> -			       pad, get_fmt, NULL, &fmt);
> +	sd = media_entity_to_v4l2_subdev(link->sink->entity);
> +	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
>  	if (ret < 0)
>  		return -EPIPE;
> 

-- 
Regards,

Laurent Pinchart
