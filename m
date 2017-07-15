Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34206 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdGOMyq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 08:54:46 -0400
Received: by mail-wm0-f65.google.com with SMTP id p204so15222210wmg.1
        for <linux-media@vger.kernel.org>; Sat, 15 Jul 2017 05:54:45 -0700 (PDT)
Message-ID: <1500123283.25393.1.camel@gmail.com>
Subject: Re: [PATCH 1/3] [media] uvcvideo: variable size controls
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Sat, 15 Jul 2017 14:54:43 +0200
In-Reply-To: <4593253.3XROVtGbEB@avalon>
References: <20170714201424.23592-1-philipp.zabel@gmail.com>
         <4593253.3XROVtGbEB@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Samstag, den 15.07.2017, 12:49 +0300 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.

Thank you for the review.

> On Friday 14 Jul 2017 22:14:22 Philipp Zabel wrote:
> > Some USB webcam controllers have extension unit controls that report
> > different lengths via GET_LEN, depending on internal state.
> 
> If I ever need to hire a hardware designer, I'll make sure to reject any 
> candidate who thinks that creativity is an asset :-(

:)

> If the size changes, could the flags change as well ? Should you issue a 
> GET_INFO too ?

The size-changing eSP770U control always reports the same INFO.
Could this be added as a separate flag in the future if needed, when
the next webcam controller designer feels creative?

> > Add a flag to mark these controls as variable length and issue GET_LEN
> > before GET/SET_CUR transfers to verify the current length.
> 
> What happens if the internal state changes between the GET_LEN and the 
> GET/SET_CUR ?

At least for the Oculus Sensor, as far as I can tell, the length only
changes in reaction to a SET_CUR on another control:
Control 11 is written to set up an SPI transfer, apparently. That 16-
byte control contains a length field in byte 9. The length written to
that field becomes the LEN of control 12, which can then be used to
read or write data.

> > Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> > ---
> >  drivers/media/usb/uvc/uvc_ctrl.c | 26 +++++++++++++++++++++++++-
> >  include/uapi/linux/uvcvideo.h    |  2 ++
> >  2 files changed, 27 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > b/drivers/media/usb/uvc/uvc_ctrl.c index c2ee6e39fd0c..ce69e2c6937d 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -1597,7 +1597,7 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device
> > *dev, struct usb_device_id id;
> > > >  		u8 entity;
> > > >  		u8 selector;
> > > > -		u8 flags;
> > > > +		u16 flags;
> > > >  	};
> > 
> > > >  	static const struct uvc_ctrl_fixup fixups[] = {
> > @@ -1799,6 +1799,30 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
> > > >  		goto done;
> > > >  	}
> > 
> > > > +	if ((ctrl->info.flags & UVC_CTRL_FLAG_VARIABLE_LEN) && reqflags) {
> > > > +		data = kmalloc(2, GFP_KERNEL);
> > > > +		/* Check if the control length has changed */
> > > > +		ret = uvc_query_ctrl(chain->dev, UVC_GET_LEN, xqry->unit,
> > +				     chain->dev->intfnum, xqry->selector, 
> 
> data,
> > > > +				     2);
> > > > +		size = le16_to_cpup((__le16 *)data);
> > +		kfree(data);
> 
> Now data is not NULL.
> 
> > > > +		if (ret < 0) {
> > > > +			uvc_trace(UVC_TRACE_CONTROL,
> > > > +				  "GET_LEN failed on control %pUl/%u (%d).\n",
> > > > +				  entity->extension.guidExtensionCode,
> > > > +				  xqry->selector, ret);
> > +			goto done;
> 
> And the kfree(data) at the done label will cause a double free.

Thanks, will fix that.

> > +		}
> > > > +		if (ctrl->info.size != size) {
> > > > +			uvc_trace(UVC_TRACE_CONTROL,
> > +				  "XU control %pUl/%u queried: len %u -> 
> 
> %u\n",
> > > > +				  entity->extension.guidExtensionCode,
> > > > +				  xqry->selector, ctrl->info.size, size);
> > > > +			ctrl->info.size = size;
> > > > +		}
> > +	}
> 
> How about moving this code (or part of it at least) to a function that could 
> be shared with uvc_ctrl_fill_xu_info() ?

I'll try. This will come at the cost of a bit more boilerplate.

regards
Philipp
