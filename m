Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41170 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753645AbeFLTp1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 15:45:27 -0400
Date: Tue, 12 Jun 2018 20:44:40 +0100
From: emil.velikov@collabora.com
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
Subject: Re: [RFC 2/2] vim2m: add media device
Message-ID: <20180612194440.GB20814@arch-x1c3.cbg.collabora.co.uk>
References: <20180612104827.11565-1-ezequiel@collabora.com>
 <20180612104827.11565-3-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180612104827.11565-3-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,  

On Tue, Jun 12, 2018 at 07:48:27AM -0300, Ezequiel Garcia wrote:

> @@ -1013,10 +1016,10 @@ static int vim2m_probe(struct platform_device *pdev)
>  	vfd->lock = &dev->dev_mutex;
>  	vfd->v4l2_dev = &dev->v4l2_dev;
>  
> -	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +	ret = video_register_device(vfd, VFL_TYPE_MEM2MEM, 0);
Shouldn't the original type be used when building without
CONFIG_MEDIA_CONTROLLER?


> @@ -1050,6 +1076,11 @@ static int vim2m_remove(struct platform_device *pdev)
>  	struct vim2m_dev *dev = platform_get_drvdata(pdev);
>  
>  	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
Gut suggests that media_device_unregister() should be called here.

Then again my experience in media/ is limited so I could be miles off
;-)


HTH
Emil
