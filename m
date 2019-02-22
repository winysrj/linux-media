Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189E1C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8158F206B6
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:07:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="gFs7oU/N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfBVLHy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:07:54 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33734 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfBVLHy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:07:54 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id CD76D2D2;
        Fri, 22 Feb 2019 12:07:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550833673;
        bh=A9E5YPWRpQphI4ZsJjfbcdzoxquFib+Se3HgGPzqG7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gFs7oU/NScIvPaJdhGH51jRe5jWMFbEXH/urJeA62BUMzWpsih51mSxCG3YoBPUVz
         06YA6hA1Nyaw4myae8Vv+98tTC9QixrgMeUk3PxgMAYSc5tHMINnirkpBTJSdIy1kH
         /4oKZvpCifCO5E6x++BrWKjcufIQ3DfuVLFFhNko=
Date:   Fri, 22 Feb 2019 13:07:48 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH 2/7] media-devnode: fill in media chardev kobject to ease
 debugging
Message-ID: <20190222110748.GJ3522@pendragon.ideasonboard.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-3-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221142148.3412-3-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Thu, Feb 21, 2019 at 03:21:43PM +0100, Hans Verkuil wrote:
> The media chardev kobject has no name, which made it hard to
> debug when kobject debugging is turned on.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-devnode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index 6b87a721dc49..61dc05fcc55c 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -251,6 +251,7 @@ int __must_check media_devnode_register(struct media_device *mdev,
>  	/* Part 2: Initialize the character device */
>  	cdev_init(&devnode->cdev, &media_devnode_fops);
>  	devnode->cdev.owner = owner;
> +	kobject_set_name(&devnode->cdev.kobj, "media%d", devnode->minor);
>  
>  	/* Part 3: Add the media and char device */
>  	ret = cdev_device_add(&devnode->cdev, &devnode->dev);

-- 
Regards,

Laurent Pinchart
