Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38608 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1EVTZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 15:25:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] omap3: isp: fix compiler warning
Date: Sun, 22 May 2011 21:25:51 +0200
Cc: Sanjeev Premi <premi@ti.com>, linux-media@vger.kernel.org
References: <1305734811-2354-1-git-send-email-premi@ti.com> <4DD79A24.5080107@redhat.com>
In-Reply-To: <4DD79A24.5080107@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105222125.51967.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro and Sanjeev,

On Saturday 21 May 2011 12:55:32 Mauro Carvalho Chehab wrote:
> Em 18-05-2011 13:06, Sanjeev Premi escreveu:
> > This patch fixes this compiler warning:
> >   drivers/media/video/omap3isp/isp.c: In function 'isp_isr_dbg':
> >   drivers/media/video/omap3isp/isp.c:392:2: warning: zero-length
> >   
> >    gnu_printf format string
> > 
> > Since printk() is used in next few statements, same was used
> > here as well.
> > 
> > Signed-off-by: Sanjeev Premi <premi@ti.com>
> > Cc: laurent.pinchart@ideasonboard.com
> > ---
> > 
> >  Actually full block can be converted to dev_dbg()
> >  as well; but i am not sure about original intent
> >  of the mix.
> >  
> >  Based on comments, i can resubmit with all prints
> >  converted to dev_dbg.
> 
> It is probably better to convert the full block to dev_dbg.

You can't insert a KERN_CONT with dev_dbg().

> >  drivers/media/video/omap3isp/isp.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/isp.c
> > b/drivers/media/video/omap3isp/isp.c index 503bd79..1d38d96 100644
> > --- a/drivers/media/video/omap3isp/isp.c
> > +++ b/drivers/media/video/omap3isp/isp.c
> > @@ -387,7 +387,7 @@ static inline void isp_isr_dbg(struct isp_device
> > *isp, u32 irqstatus)
> > 
> >  	};
> >  	int i;
> > 
> > -	dev_dbg(isp->dev, "");
> > +	printk(KERN_DEBUG "%s:\n", dev_driver_string(isp->dev));

The original code doesn't include any \n. Is there a particular reason why you 
want to add one ?

> >  	for (i = 0; i < ARRAY_SIZE(name); i++) {
> >  	
> >  		if ((1 << i) & irqstatus)

-- 
Regards,

Laurent Pinchart
