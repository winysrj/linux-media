Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:60787 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab1EWSKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 14:10:07 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 23 May 2011 23:39:58 +0530
Subject: RE: [PATCH] omap3: isp: fix compiler warning
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D09B451@dbde02.ent.ti.com>
References: <1305734811-2354-1-git-send-email-premi@ti.com>
 <4DD79A24.5080107@redhat.com>
 <201105222125.51967.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105222125.51967.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
> Sent: Monday, May 23, 2011 12:56 AM
> To: Mauro Carvalho Chehab
> Cc: Premi, Sanjeev; linux-media@vger.kernel.org
> Subject: Re: [PATCH] omap3: isp: fix compiler warning
> 
> Hi Mauro and Sanjeev,
> 
> On Saturday 21 May 2011 12:55:32 Mauro Carvalho Chehab wrote:
> > Em 18-05-2011 13:06, Sanjeev Premi escreveu:
> > > This patch fixes this compiler warning:
> > >   drivers/media/video/omap3isp/isp.c: In function 'isp_isr_dbg':
> > >   drivers/media/video/omap3isp/isp.c:392:2: warning: zero-length
> > >   
> > >    gnu_printf format string
> > > 
> > > Since printk() is used in next few statements, same was used
> > > here as well.
> > > 
> > > Signed-off-by: Sanjeev Premi <premi@ti.com>
> > > Cc: laurent.pinchart@ideasonboard.com
> > > ---
> > > 
> > >  Actually full block can be converted to dev_dbg()
> > >  as well; but i am not sure about original intent
> > >  of the mix.
> > >  
> > >  Based on comments, i can resubmit with all prints
> > >  converted to dev_dbg.
> > 
> > It is probably better to convert the full block to dev_dbg.
> 
> You can't insert a KERN_CONT with dev_dbg().

[sp] I did realize that hence changed only the call to dev_dbg.

> 
> > >  drivers/media/video/omap3isp/isp.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/omap3isp/isp.c
> > > b/drivers/media/video/omap3isp/isp.c index 503bd79..1d38d96 100644
> > > --- a/drivers/media/video/omap3isp/isp.c
> > > +++ b/drivers/media/video/omap3isp/isp.c
> > > @@ -387,7 +387,7 @@ static inline void isp_isr_dbg(struct 
> isp_device
> > > *isp, u32 irqstatus)
> > > 
> > >  	};
> > >  	int i;
> > > 
> > > -	dev_dbg(isp->dev, "");
> > > +	printk(KERN_DEBUG "%s:\n", dev_driver_string(isp->dev));
> 
> The original code doesn't include any \n. Is there a 
> particular reason why you 
> want to add one ?

[sp] Sorry, that's a mistake out of habit.
     Another way to fix warning would be to make the string meaningful:

-	dev_dbg(isp->dev, "");
+	dev_dbg (isp->dev, "ISP_IRQ:");

     Is this better?

~sanjeev

> 
> > >  	for (i = 0; i < ARRAY_SIZE(name); i++) {
> > >  	
> > >  		if ((1 << i) & irqstatus)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 