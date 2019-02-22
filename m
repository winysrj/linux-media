Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C91C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FE64206B6
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:20:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MahHcDcu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfBVLUY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:20:24 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33858 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVLUX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:20:23 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C93512D2;
        Fri, 22 Feb 2019 12:20:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550834422;
        bh=VRfCrDzwJxNadNoRneXNPajXrG+HRQdI8lAJ8cR1FA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MahHcDcuRdBxKFeDWZ1QzDtwCOG4veANkV1AjONuBT1ScqOZ04ScA5xBmK9uE6yOr
         BGYXNZOVAFTMlnFnxiRv9gnLaHhdH2EHBOHeCgzQ0gtrVMOG+4w44BZNqiv945MKte
         sbX0pJgTcNWD1fK2nSHw7C52Uj/jz7RlabD2fBRk=
Date:   Fri, 22 Feb 2019 13:20:17 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH 5/7] vim2m: replace devm_kzalloc by kzalloc
Message-ID: <20190222112017.GN3522@pendragon.ideasonboard.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-6-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221142148.3412-6-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 21, 2019 at 03:21:46PM +0100, Hans Verkuil wrote:
> It is not possible to use devm_kzalloc since that memory is
> freed immediately when the device instance is unbound.
> 
> Various objects like the video device may still be in use
> since someone has the device node open, and when that is closed
> it expects the memory to be around.
> 
> So use kzalloc and release it at the appropriate time.

You're opening a can of worms, we have tons of drivers that use
devm_kzalloc() :-) I however believe this is the right course of action.

> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/platform/vim2m.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index a27d3052bb62..bfb3e3eb48d1 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -1087,6 +1087,16 @@ static int vim2m_release(struct file *file)
>  	return 0;
>  }
>  
> +static void vim2m_device_release(struct video_device *vdev)
> +{
> +	struct vim2m_dev *dev = container_of(vdev, struct vim2m_dev, vfd);
> +
> +	dprintk(dev, "Releasing last dev\n");

Do we really need a debug printk here ?

> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	v4l2_m2m_release(dev->m2m_dev);
> +	kfree(dev);
> +}
> +
>  static const struct v4l2_file_operations vim2m_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= vim2m_open,
> @@ -1102,7 +1112,7 @@ static const struct video_device vim2m_videodev = {
>  	.fops		= &vim2m_fops,
>  	.ioctl_ops	= &vim2m_ioctl_ops,
>  	.minor		= -1,
> -	.release	= video_device_release_empty,
> +	.release	= vim2m_device_release,
>  	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
>  };
>  
> @@ -1123,13 +1133,13 @@ static int vim2m_probe(struct platform_device *pdev)
>  	struct video_device *vfd;
>  	int ret;
>  
> -	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>  	if (!dev)
>  		return -ENOMEM;
>  
>  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>  	if (ret)
> -		return ret;
> +		goto unreg_free;
>  
>  	atomic_set(&dev->num_inst, 0);
>  	mutex_init(&dev->dev_mutex);
> @@ -1192,6 +1202,8 @@ static int vim2m_probe(struct platform_device *pdev)
>  	video_unregister_device(&dev->vfd);
>  unreg_v4l2:
>  	v4l2_device_unregister(&dev->v4l2_dev);
> +unreg_free:

I'd call the label error_free, and rename the other ones with an error_
prefix, as you don't register anything here.

With these two small issues fixes,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +	kfree(dev);
>  
>  	return ret;
>  }
> @@ -1207,9 +1219,7 @@ static int vim2m_remove(struct platform_device *pdev)
>  	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
>  	media_device_cleanup(&dev->mdev);
>  #endif
> -	v4l2_m2m_release(dev->m2m_dev);
>  	video_unregister_device(&dev->vfd);
> -	v4l2_device_unregister(&dev->v4l2_dev);
>  
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart
