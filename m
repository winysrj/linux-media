Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50605 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaCGRBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 12:01:24 -0500
Date: Fri, 7 Mar 2014 20:01:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] [patch] [media] em28xx-cards: remove a wrong indent
 level
Message-ID: <20140307170110.GP4774@mwanda>
References: <20140305110937.GC16926@elgon.mountain>
 <5319F7E4.1000303@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5319F7E4.1000303@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 07, 2014 at 05:46:28PM +0100, Frank Schäfer wrote:
> 
> Am 05.03.2014 12:09, schrieb Dan Carpenter:
> > This code is correct but the indenting is wrong and triggers a static
> > checker warning "add curly braces?".
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: in v1 I added curly braces.
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> > index 4d97a76cc3b0..33f06ffec4b2 100644
> > --- a/drivers/media/usb/em28xx/em28xx-cards.c
> > +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> > @@ -3331,8 +3331,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	if (has_video) {
> >  	    if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
> >  		dev->analog_xfer_bulk = 1;
> > -		em28xx_info("analog set to %s mode.\n",
> > -			    dev->analog_xfer_bulk ? "bulk" : "isoc");
> > +	    em28xx_info("analog set to %s mode.\n",
> > +			dev->analog_xfer_bulk ? "bulk" : "isoc");
> 
> Instead of moving em28xx_info(...) to the left the if section needs to
> be moved to the right:
> 
> - 	    if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
> - 		dev->analog_xfer_bulk = 1;
> + 		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
> + 			dev->analog_xfer_bulk = 1;

Yes.  I'd happy to.

> 
> While you are at it, could you also do fix the indention in the next
> paragraph ?

The next paragraph is almost identical but my static checker was
ignoring the curly braces because of the blank line.  I'll modify to
complain about that as well.

I'll resend.  Thanks for the review.

regards,
dan carpenter

