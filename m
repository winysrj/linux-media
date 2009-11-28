Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:60666 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbZK1S5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 13:57:49 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 7136C818167
	for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 19:57:50 +0100 (CET)
Received: from tele (qrm29-1-82-245-201-222.fbx.proxad.net [82.245.201.222])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 5BB038180EA
	for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 19:57:48 +0100 (CET)
Date: Sat, 28 Nov 2009 19:57:54 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca: add input support for interrupt endpoints
Message-ID: <20091128195754.74503736@tele>
In-Reply-To: <4B10CDF1.9030204@freemail.hu>
References: <4B095EDE.4090409@freemail.hu>
	<4B10CDF1.9030204@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Nov 2009 08:14:57 +0100
Németh Márton <nm127@freemail.hu> wrote:

> what do you think about the latest version of this patchset?

Hello Márton,

I wonder why you did not include the input functions directly in the
file gspca.c instead of adding new files and changing the Makefile.

Below are more remarks.

Regards.

	[snip]
> > diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/gspca.c
> > --- a/linux/drivers/media/video/gspca/gspca.c	Sat Nov 21
> > 12:01:36 2009 +0100 +++
> > b/linux/drivers/media/video/gspca/gspca.c	Sun Nov 22
	[snip]
> > @@ -499,11 +502,13 @@
> >  			i, ep->desc.bEndpointAddress);
> >  	gspca_dev->alt = i;		/* memorize the current
> > alt setting */ if (gspca_dev->nbalt > 1) {
> > +		gspca_input_destroy_urb(gspca_dev);
> >  		ret = usb_set_interface(gspca_dev->dev,
> > gspca_dev->iface, i); if (ret < 0) {
> >  			err("set alt %d err %d", i, ret);
> > -			return NULL;
> > +			ep = NULL;
> >  		}
> > +		gspca_input_create_urb(gspca_dev);
> >  	}
> >  	return ep;
> >  }

If the interface cannot be set, I wonder if creating the input URB is
useful.

> > @@ -707,7 +712,9 @@
> >  		if (gspca_dev->sd_desc->stopN)
> >  			gspca_dev->sd_desc->stopN(gspca_dev);
> >  		destroy_urbs(gspca_dev);
> > +		gspca_input_destroy_urb(gspca_dev);
> >  		gspca_set_alt0(gspca_dev);
> > +		gspca_input_create_urb(gspca_dev);
> >  	}

Instead of destroying and recreating the input URB at each interface
change, it might be simpler to have a global function set_alt() and to
do the input job inside this one.

[snip]
> > diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/input.c
> > --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> > +++ b/linux/drivers/media/video/gspca/input.c	Sun Nov 22
> > 16:40:34 2009 +0100 @@ -0,0 +1,184 @@
	[snip]
> > +EXPORT_SYMBOL(gspca_input_connect);

Don't do that: this function is not used by any other module.

> > +
> > +static int alloc_and_submit_int_urb(struct gspca_dev *gspca_dev,
> > +			  struct usb_endpoint_descriptor *ep)
> > +{
> > +	unsigned int buffer_len;
> > +	int interval;
> > +	struct urb *urb;
> > +	struct usb_device *dev;
> > +	void *buffer = NULL;
> > +	int ret = -EINVAL;
> > +
> > +	buffer_len = ep->wMaxPacketSize;
> > +	interval = ep->bInterval;
> > +	PDEBUG(D_PROBE, "found int in endpoint: 0x%x, "
> > +		"buffer_len=%u, interval=%u",
> > +		ep->bEndpointAddress, buffer_len, interval);
> > +
> > +	dev = gspca_dev->dev;
> > +	gspca_dev->int_urb = NULL;

Not useful: the descriptor is already set to zero.

> > +
> > +	urb = usb_alloc_urb(0, GFP_KERNEL);
> > +	if (!urb) {
> > +		ret = -ENOMEM;
> > +		goto error;
> > +	}
> > +
> > +	buffer = usb_buffer_alloc(dev, ep->wMaxPacketSize,
> > +				GFP_KERNEL, &urb->transfer_dma);
> > +	if (!buffer) {
> > +		ret = -ENOMEM;
> > +		goto error_buffer;
> > +	}
> > +	usb_fill_int_urb(urb, dev,
> > +		usb_rcvintpipe(dev, ep->bEndpointAddress),
> > +		buffer, buffer_len,
> > +		int_irq, (void *)gspca_dev, interval);
> > +	gspca_dev->int_urb = urb;

This instruction should go just before the normal return.

> > +	ret = usb_submit_urb(urb, GFP_KERNEL);
> > +	if (ret < 0) {
> > +		PDEBUG(D_ERR, "submit URB failed with error %i",
> > ret);
> > +		goto error_submit;
> > +	}
> > +	return ret;
> > +
> > +error_submit:
> > +	usb_buffer_free(dev,
> > +			urb->transfer_buffer_length,
> > +			urb->transfer_buffer,
> > +			urb->transfer_dma);
> > +error_buffer:
> > +	usb_free_urb(urb);
> > +error:
> > +	return ret;
> > +}
	[snip]
> > diff -r bc16afd1e7a4 linux/drivers/media/video/gspca/input.h
> > --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> > +++ b/linux/drivers/media/video/gspca/input.h	Sun Nov 22
> > 16:40:34 2009 +0100 @@ -0,0 +1,36 @@
	[snip]
> > +#ifdef CONFIG_INPUT
> > +int gspca_input_connect(struct gspca_dev *gspca_dev);
> > +int gspca_input_create_urb(struct gspca_dev *gspca_dev);
> > +void gspca_input_destroy_urb(struct gspca_dev *gspca_dev);
> > +#else
> > +#define gspca_input_connect(gspca_dev)		0
> > +#define gspca_input_create_urb(gspca_dev)	0
> > +#define gspca_input_destroy_urb(gspca_dev)

I better like empty functions, but this will be natural with the input
functions in the file gspca.c...

> > +#endif
> > +
> > +#endif

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
