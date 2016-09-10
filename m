Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35984 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbcIJT6Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 15:58:16 -0400
Date: Sat, 10 Sep 2016 13:58:11 -0600
From: Wade Berrier <wberrier@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: mceusb xhci issue?
Message-ID: <20160910195811.GA4941@berrier.lan>
References: <Pine.LNX.4.44L0.1607121150390.1900-100000@iolanthe.rowland.org>
 <Pine.LNX.4.44L0.1608111617100.1381-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1608111617100.1381-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu Aug 11 16:18, Alan Stern wrote:
> I never received any replies to this message.  Should the patch I 
> suggested be merged?
>

Hello,

I applied this updated patch to the fedora23 4.7.2 kernel and the mceusb
transceiver works as expected.

Thanks,

Wade

> 
> 
> On Tue, 12 Jul 2016, Alan Stern wrote:
> 
> > On Sat, 9 Jul 2016, Mauro Carvalho Chehab wrote:
> > 
> > > C/C linux-usb Mailing list:
> > > 
> > > 
> > > Em Wed, 18 May 2016 08:52:28 -0600
> > > Wade Berrier <wberrier@gmail.com> escreveu:
> > 
> > ...
> > 
> > > > > That message above links to some other threads describing the issue.
> > > > > Here's a post with a patch that supposedly works:
> > > > > 
> > > > > http://www.gossamer-threads.com/lists/mythtv/users/587930
> > > > > 
> > > > > No idea if that's the "correct" way to fix this.
> > > > > 
> > > > > I'll be trying that out and then report back...  
> > > > 
> > > > Indeed, this patch does fix the issue:
> > > > 
> > > > ----------------------
> > > > 
> > > > diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
> > > > index 31ccdcc..03321d4 100644
> > > > --- a/drivers/usb/core/config.c
> > > > +++ b/drivers/usb/core/config.c
> > > > @@ -247,7 +247,7 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
> > > >  			/* For low-speed, 10 ms is the official minimum.
> > > >  			 * But some "overclocked" devices might want faster
> > > >  			 * polling so we'll allow it. */
> > > > -			n = 32;
> > > > +			n = 10;
> > > >  			break;
> > > >  		}
> > > >  	} else if (usb_endpoint_xfer_isoc(d)) {
> > > > 
> > > > 
> > > > ----------------------
> > > > 
> > > > Is this change appropriate to be pushed upstream?  Where to go from
> > > > here?
> > > 
> > > This issue is at the USB core. So, it should be reported to the
> > > linux-usb mailing list. 
> > > 
> > > The people there should help about how to proceed to get this
> > > fixed upstream.
> > 
> > Here's a proper version of that patch.  If this is okay, it can be 
> > merged.
> > 
> > Alan Stern
> > 
> > 
> > 
> > Index: usb-4.x/drivers/usb/core/config.c
> > ===================================================================
> > --- usb-4.x.orig/drivers/usb/core/config.c
> > +++ usb-4.x/drivers/usb/core/config.c
> > @@ -213,8 +213,10 @@ static int usb_parse_endpoint(struct dev
> >  	memcpy(&endpoint->desc, d, n);
> >  	INIT_LIST_HEAD(&endpoint->urb_list);
> >  
> > -	/* Fix up bInterval values outside the legal range. Use 32 ms if no
> > -	 * proper value can be guessed. */
> > +	/*
> > +	 * Fix up bInterval values outside the legal range.
> > +	 * Use 10 or 8 ms if no proper value can be guessed.
> > +	 */
> >  	i = 0;		/* i = min, j = max, n = default */
> >  	j = 255;
> >  	if (usb_endpoint_xfer_int(d)) {
> > @@ -223,13 +225,15 @@ static int usb_parse_endpoint(struct dev
> >  		case USB_SPEED_SUPER_PLUS:
> >  		case USB_SPEED_SUPER:
> >  		case USB_SPEED_HIGH:
> > -			/* Many device manufacturers are using full-speed
> > +			/*
> > +			 * Many device manufacturers are using full-speed
> >  			 * bInterval values in high-speed interrupt endpoint
> >  			 * descriptors. Try to fix those and fall back to a
> > -			 * 32 ms default value otherwise. */
> > +			 * 8 ms default value otherwise.
> > +			 */
> >  			n = fls(d->bInterval*8);
> >  			if (n == 0)
> > -				n = 9;	/* 32 ms = 2^(9-1) uframes */
> > +				n = 7;	/* 8 ms = 2^(7-1) uframes */
> >  			j = 16;
> >  
> >  			/*
> > @@ -247,7 +251,7 @@ static int usb_parse_endpoint(struct dev
> >  			/* For low-speed, 10 ms is the official minimum.
> >  			 * But some "overclocked" devices might want faster
> >  			 * polling so we'll allow it. */
> > -			n = 32;
> > +			n = 10;
> >  			break;
> >  		}
> >  	} else if (usb_endpoint_xfer_isoc(d)) {
> > @@ -255,10 +259,10 @@ static int usb_parse_endpoint(struct dev
> >  		j = 16;
> >  		switch (to_usb_device(ddev)->speed) {
> >  		case USB_SPEED_HIGH:
> > -			n = 9;		/* 32 ms = 2^(9-1) uframes */
> > +			n = 7;		/* 8 ms = 2^(7-1) uframes */
> >  			break;
> >  		default:		/* USB_SPEED_FULL */
> > -			n = 6;		/* 32 ms = 2^(6-1) frames */
> > +			n = 4;		/* 8 ms = 2^(4-1) frames */
> >  			break;
> >  		}
> >  	}
> 
> 
