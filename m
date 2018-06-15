Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36186 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966117AbeFOUCC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 16:02:02 -0400
Message-ID: <fc1baaa51043a2b3fb0d8e801061faef3cac8777.camel@collabora.com>
Subject: Re: [RFC 2/2] vim2m: add media device
From: Ezequiel Garcia <ezequiel@collabora.com>
To: emil.velikov@collabora.com
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
Date: Fri, 15 Jun 2018 17:01:53 -0300
In-Reply-To: <20180612194440.GB20814@arch-x1c3.cbg.collabora.co.uk>
References: <20180612104827.11565-1-ezequiel@collabora.com>
         <20180612104827.11565-3-ezequiel@collabora.com>
         <20180612194440.GB20814@arch-x1c3.cbg.collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-06-12 at 20:44 +0100, emil.velikov@collabora.com wrote:
> Hi Ezequiel,  
> 
> On Tue, Jun 12, 2018 at 07:48:27AM -0300, Ezequiel Garcia wrote:
> 
> > @@ -1013,10 +1016,10 @@ static int vim2m_probe(struct
> > platform_device *pdev)
> >  	vfd->lock = &dev->dev_mutex;
> >  	vfd->v4l2_dev = &dev->v4l2_dev;
> >  
> > -	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > +	ret = video_register_device(vfd, VFL_TYPE_MEM2MEM, 0);
> 
> Shouldn't the original type be used when building without
> CONFIG_MEDIA_CONTROLLER?
> 

No, the idea was to introduce a new type for mem2mem,
mainly to avoid the video2linux core from registering
mc entities.

Anyway, Hans dislikes this and suggested to drop it.

> 
> > @@ -1050,6 +1076,11 @@ static int vim2m_remove(struct
> > platform_device *pdev)
> >  	struct vim2m_dev *dev = platform_get_drvdata(pdev);
> >  
> >  	v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
> > +
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> 
> Gut suggests that media_device_unregister() should be called here.
> 
> Then again my experience in media/ is limited so I could be miles off
> ;-)
> 

Good catch, it seems it's indeed missing.

Thanks,
Eze
