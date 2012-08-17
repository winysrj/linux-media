Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44892 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab2HQPES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 11:04:18 -0400
Date: Fri, 17 Aug 2012 16:04:15 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Matthijs Kooijman <matthijs@stdin.nl>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: (still) NULL pointer crashes with nuvoton_cir driver
Message-ID: <20120817150415.GC2693@zeus>
References: <20120815165153.GJ21274@login.drsnuggles.stderr.nl>
 <20120816080932.GP21274@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816080932.GP21274@login.drsnuggles.stderr.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Adding Mauro to CC has he is the maintainer)

On Thu, Aug 16, 2012 at 10:09:32AM +0200, Matthijs Kooijman wrote:
> Hi folks,
> 
> > I'm currently compiling a 3.5 kernel with just the rdev initialization
> > moved up to see if this will fix my problem at all, but I'd like your
> > view on this in the meantime as well.
> Ok, this seems to fix my problem:
> 
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -1066,6 +1066,7 @@
>         /* tx bits */
>         rdev->tx_resolution = XYZ;
>  #endif
> +       nvt->rdev = rdev;

This makes sense to me.  Note however that there are more drivers with
a similar problem (e.g., fintek-cir.c).

>  
>         ret = -EBUSY; /* now claim resources */ @@ -1090,7 +1091,6
> @@ goto failure5;
>  
>         device_init_wakeup(&pdev->dev, true);
> -       nvt->rdev = rdev;
>         nvt_pr(KERN_NOTICE, "driver has been successfully loaded\n");
>         if (debug) {
>                 cir_dump_regs(nvt);
> 
> 
> I'm still not sure if the rc_register_device shouldn't also be moved up. It
> seems this doesn't trigger a problem right now, but if there is a problem, I
> suspect its trigger window is a lot smaller than with the rdev initialization
> problem...

I'm not sure as well, I'm not very familiar with this code.  However,
it looks like the IRQ request should actually be one of the last
things to do here.

Cheers,
--
Luis
