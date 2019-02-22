Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0204C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FB562075A
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="CfE3zjYB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfBVLhj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:37:39 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33968 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVLhi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:37:38 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B14A52D2;
        Fri, 22 Feb 2019 12:37:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550835456;
        bh=Xsesaqy6h2z1Aa6hLxWHRqMS/+XqLZaWmj5Gk8qI2mY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CfE3zjYBU/BHPezhrPdLdJxZeVPAM4p4jcEGJ6akhvavgjIYLG7qMRh11lufI7WzC
         AD53WQGWBdaXos8D5MlQRfIT9smZGrHWZfjDOG1b72h4TydZ1OjKJrsGtZVL4DKBFG
         p9e6AKDrXtVTckQv9oFGpva+6dmtsVNEUSRSRRNY=
Date:   Fri, 22 Feb 2019 13:37:32 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH 7/7] vimc: free vimc_cap_device when the last user
 disappears
Message-ID: <20190222113732.GP3522@pendragon.ideasonboard.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-8-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221142148.3412-8-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 21, 2019 at 03:21:48PM +0100, Hans Verkuil wrote:
> Don't free vimc_cap_device immediately, instead do this
> in the video_device release function which is called when the
> last user closes the video device. Only then is it safe to
> free the memory.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/platform/vimc/vimc-capture.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
> index ea869631a3f6..3d433361d297 100644
> --- a/drivers/media/platform/vimc/vimc-capture.c
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -338,6 +338,15 @@ static const struct media_entity_operations vimc_cap_mops = {
>  	.link_validate		= vimc_link_validate,
>  };
>  
> +static void vimc_cap_release(struct video_device *vdev)
> +{
> +	struct vimc_cap_device *vcap = container_of(vdev, struct vimc_cap_device,
> +						    vdev);
> +
> +	vimc_pads_cleanup(vcap->ved.pads);
> +	kfree(vcap);
> +}
> +
>  static void vimc_cap_comp_unbind(struct device *comp, struct device *master,
>  				 void *master_data)
>  {
> @@ -348,8 +357,6 @@ static void vimc_cap_comp_unbind(struct device *comp, struct device *master,
>  	vb2_queue_release(&vcap->queue);
>  	media_entity_cleanup(ved->ent);
>  	video_unregister_device(&vcap->vdev);
> -	vimc_pads_cleanup(vcap->ved.pads);
> -	kfree(vcap);
>  }
>  
>  static void *vimc_cap_process_frame(struct vimc_ent_device *ved,
> @@ -467,7 +474,7 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
>  	vdev = &vcap->vdev;
>  	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>  	vdev->entity.ops = &vimc_cap_mops;
> -	vdev->release = video_device_release_empty;
> +	vdev->release = vimc_cap_release;

Another use of video_device_release_empty gone, only 80+ to go ;-)

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	vdev->fops = &vimc_cap_fops;
>  	vdev->ioctl_ops = &vimc_cap_ioctl_ops;
>  	vdev->lock = &vcap->lock;

-- 
Regards,

Laurent Pinchart
