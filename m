Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47286 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab1EYIOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 04:14:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Premi, Sanjeev" <premi@ti.com>
Subject: Re: [PATCH] omap3: isp: fix compiler warning
Date: Wed, 25 May 2011 10:14:46 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1305734811-2354-1-git-send-email-premi@ti.com> <201105222125.51967.laurent.pinchart@ideasonboard.com> <B85A65D85D7EB246BE421B3FB0FBB593024D09B451@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024D09B451@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105251014.47204.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sanjeev,

On Monday 23 May 2011 20:09:58 Premi, Sanjeev wrote:
> On Monday, May 23, 2011 12:56 AM Laurent Pinchart wrote:
> > On Saturday 21 May 2011 12:55:32 Mauro Carvalho Chehab wrote:
> > > Em 18-05-2011 13:06, Sanjeev Premi escreveu:

[snip]

> > > > @@ -387,7 +387,7 @@ static inline void isp_isr_dbg(struct
> > > > isp_device *isp, u32 irqstatus)
> > > > 
> > > >  	};
> > > >  	int i;
> > > > 
> > > > -	dev_dbg(isp->dev, "");
> > > > +	printk(KERN_DEBUG "%s:\n", dev_driver_string(isp->dev));
> > 
> > The original code doesn't include any \n. Is there a
> > particular reason why you
> > want to add one ?
> 
> [sp] Sorry, that's a mistake out of habit.
>      Another way to fix warning would be to make the string meaningful:
> 
> -	dev_dbg(isp->dev, "");
> +	dev_dbg (isp->dev, "ISP_IRQ:");
> 
>      Is this better?

That looks good to me. I'll queue your patch in my tree (with a space after 
the colon). Thanks.

-- 
Regards,

Laurent Pinchart
