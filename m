Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62178C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F2692070D
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MjYwPdnf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfBVLdE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:33:04 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33940 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfBVLdE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:33:04 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id CAF522D2;
        Fri, 22 Feb 2019 12:33:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550835182;
        bh=ts+epCViih6+y2nWZxLxRf1qvHc0v7GX/UBJyG3BExs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MjYwPdnfQwxUBeMwtUreEpfbhWFnyhIpMSsGTAPZfPKU+KNH/MUuL/K1QleWgUvgI
         rTZH2iUQ2SrncV25eYECtEdadQuuKZIvjo3sFsp0ykAf5jFbkH7WKBF0MOSvhw5Z8S
         FRs1Is90O8HVYQvZcUMLuwbtbPuOqwmXbVBbWbe0=
Date:   Fri, 22 Feb 2019 13:32:57 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH 6/7] v4l2-device: v4l2_device_release_subdev_node can't
 reference sd
Message-ID: <20190222113257.GO3522@pendragon.ideasonboard.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-7-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221142148.3412-7-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 21, 2019 at 03:21:47PM +0100, Hans Verkuil wrote:
> When the v4l-subdev device node is released it calls the
> v4l2_device_release_subdev_node() function which sets sd->devnode
> to NULL.
> 
> However, the v4l2_subdev struct may already be released causing this
> to write in freed memory.
> 
> Instead just use the regular video_device_release release function
> (just calls kfree) and set sd->devnode to NULL right after the
> video_unregister_device() call.

This seems a bit of a workaround. The devnode can access the subdev in
multiple ways, it should really keep a reference to the subdev to ensure
it doesn't get freed early.

> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/v4l2-core/v4l2-device.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index e0ddb9a52bd1..57a7b220fa4d 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -216,13 +216,6 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
>  
> -static void v4l2_device_release_subdev_node(struct video_device *vdev)
> -{
> -	struct v4l2_subdev *sd = video_get_drvdata(vdev);
> -	sd->devnode = NULL;
> -	kfree(vdev);
> -}
> -
>  int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>  {
>  	struct video_device *vdev;
> @@ -250,7 +243,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>  		vdev->dev_parent = sd->dev;
>  		vdev->v4l2_dev = v4l2_dev;
>  		vdev->fops = &v4l2_subdev_fops;
> -		vdev->release = v4l2_device_release_subdev_node;
> +		vdev->release = video_device_release;
>  		vdev->ctrl_handler = sd->ctrl_handler;
>  		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
>  					      sd->owner);
> @@ -319,6 +312,7 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd)
>  	}
>  #endif
>  	video_unregister_device(sd->devnode);
> +	sd->devnode = NULL;
>  	if (!sd->owner_v4l2_dev)
>  		module_put(sd->owner);
>  }

-- 
Regards,

Laurent Pinchart
