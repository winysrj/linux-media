Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZDAJhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 05:37:35 -0400
Date: Wed, 1 Apr 2009 06:37:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, Janne Grunau <j@jannau.net>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 5 of 8] pvrusb2: use usb_interface.dev for
 v4l2_device_register
Message-ID: <20090401063718.69e28bd2@caramujo.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0903312059100.7804@cnc.isely.net>
References: <patchbomb.1238338474@aniel>
	<20090329145908.GF17855@aniel>
	<Pine.LNX.4.64.0903312059100.7804@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Mar 2009 21:02:16 -0500 (CDT)
Mike Isely <isely@isely.net> wrote:

> 
> This patch will not at all impact the operation of the pvrusb2 driver, 
> and if associating with the USB interface's device node is preferred 
> then I'm fine with it.
> 
> Acked-by: Mike Isely <isely@pobox.com>
> 
> Mauro: Is this series going to be pulled into v4l-dvb or shall I just 
> bring this one specific change into my pvrusb2 repo?  Is there any 
> reason not to pull it?

I'll take care on it on the next time I'll apply patchwork patches. I suspect
that Janne preferred to send via email for people to better analyse the impacts.
> 
>   -Mike
> 
> 
> On Sun, 29 Mar 2009, Janne Grunau wrote:
> 
> > # HG changeset patch
> > # User Janne Grunau <j@jannau.net>
> > # Date 1238338428 -7200
> > # Node ID 2d52ac089920f9ac36960c0245442fd89a06bb75
> > # Parent  01af508490af3bc9c939c36001d6989e2c147aa0
> > pvrusb2: use usb_interface.dev for v4l2_device_register
> > 
> > Priority: normal
> > 
> > Signed-off-by: Janne Grunau <j@jannau.net>
> > 
> > diff -r 01af508490af -r 2d52ac089920 linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> > --- a/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Sun Mar 29 16:53:48 2009 +0200
> > +++ b/linux/drivers/media/video/pvrusb2/pvrusb2-hdw.c	Sun Mar 29 16:53:48 2009 +0200
> > @@ -2591,7 +2591,7 @@
> >  	hdw->ctl_read_urb = usb_alloc_urb(0,GFP_KERNEL);
> >  	if (!hdw->ctl_read_urb) goto fail;
> >  
> > -	if (v4l2_device_register(&usb_dev->dev, &hdw->v4l2_dev) != 0) {
> > +	if (v4l2_device_register(&intf->dev, &hdw->v4l2_dev) != 0) {
> >  		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
> >  			   "Error registering with v4l core, giving up");
> >  		goto fail;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 




Cheers,
Mauro
