Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54643 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753213AbeDKMoE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 08:44:04 -0400
Date: Wed, 11 Apr 2018 14:44:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v7 2/2] uvcvideo: handle control pipe protocol STALLs
In-Reply-To: <14935784.6r5jXKdLTR@avalon>
Message-ID: <alpine.DEB.2.20.1804111242260.18053@axis700.grange>
References: <20180323092401.12162-1-laurent.pinchart@ideasonboard.com> <20180323092401.12162-3-laurent.pinchart@ideasonboard.com> <14935784.6r5jXKdLTR@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

First just answers to your questions:

On Sat, 7 Apr 2018, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> On Friday, 23 March 2018 11:24:01 EEST Laurent Pinchart wrote:
> > From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > When a command ends up in a STALL on the control pipe, use the Request
> > Error Code control to provide a more precise error information to the
> > user.
> 
> This is the kind of change that I believe is completely right, but that 
> nonetheless worries me. All the years I've spent working with UVC webcams 
> taught me that lots of cameras have buggy firmware, and that any change in how 
> the host driver issues requests can have dire consequences for users. This is 
> especially true when the host driver issues a request that was never issued 
> before.
> 
> The UVC specification also doesn't clearly tell whether the request error code 
> control is mandatory for a device to implement. My interpretation of the 
> specification is that it is, but it would have been nice for the specification 
> to be explicit on this topic. Have you encountered devices that don't 
> implement this control ?

No, I haven't. But I haven't explicitly tested too many either. This patch 
would only issue that control if a STALL condition is detected, and 
normally that doesn't happen.

> This being said, I don't claim that would be a reason not to use the request 
> error code control as proposed by this patch, but I would feel less worried if 
> I knew whether the Windows driver used that control as well. If it does 
> there's a high chance that cameras will implement it correctly, while if it 
> doesn't we will most certainly hit bugs with several cameras. I was thus 
> wondering if in the course of your UVC developments you would have happened to 
> find out whether this control is used by Windows.

No, sorry, I never tried to analyse the behaviour of the Windows UVC 
driver.

> I would also like to know a bit more about the purpose of this patch. Logging 
> the error code is certainly useful for diagnosis purpose. Have you also found 
> it useful to report different errors back to userspace ? If so, could you 
> explain your use cases ?

Yes, with this patch the user-space can with certainty identify the reason 
of a stall, specifically you would know, when the camera is in a "not 
ready" state. With the previous patch in this series the driver shouldn't 
be sending a second SET_CUR command to the same control, before the first 
one has completed, but on some cameras different controls can also be 
interrelated. In such a case trying to set a different control, while a 
previous one is still being processed, can also cause a STALL with a "Not 
ready" error state.

> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> >  drivers/media/usb/uvc/uvc_video.c | 59 ++++++++++++++++++++++++++++++++----
> >  1 file changed, 53 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c index aa0082fe5833..eb9e04a59427 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -34,15 +34,59 @@ static int __uvc_query_ctrl(struct uvc_device *dev, u8
> > query, u8 unit, u8 intfnum, u8 cs, void *data, u16 size,
> >  			int timeout)
> >  {
> > -	u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
> > +	u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE, tmp, error;
> 
> Would you mind declaring one variable per line to match the style of the rest 
> of the driver ?

In fact I would, but well... ;-)

> >  	unsigned int pipe;
> > +	int ret;
> > 
> >  	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
> >  			      : usb_sndctrlpipe(dev->udev, 0);
> > 
> >  	type |= (query & 0x80) ? USB_DIR_IN : USB_DIR_OUT;
> > 
> > -	return usb_control_msg(dev->udev, pipe, query, type, cs << 8,
> > +	ret = usb_control_msg(dev->udev, pipe, query, type, cs << 8,
> >  			unit << 8 | intfnum, data, size, timeout);
> > +
> 
> Nitpicking, you can remove the blank line here.
> 
> > +	if (ret != -EPIPE)
> > +		return ret;
> > +
> > +	tmp = *(u8 *)data;
> > +
> > +	pipe = usb_rcvctrlpipe(dev->udev, 0);
> > +	type = USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN;
> > +	ret = usb_control_msg(dev->udev, pipe, UVC_GET_CUR, type,
> > +			      UVC_VC_REQUEST_ERROR_CODE_CONTROL << 8,
> > +			      unit << 8 | intfnum, data, 1, timeout);
> 
> Unless I'm mistaken the wIndex value should be "Zero and Interface" according 
> to both the UVC 1.1 and UVC 1.5 specifications. This should thus be
> 
> 	ret = usb_control_msg(dev->udev, pipe, UVC_GET_CUR, type,
> 			      UVC_VC_REQUEST_ERROR_CODE_CONTROL << 8,
> 			      intfnum, data, 1, timeout);

Hm, the 1.5 spec says:

<quote>
This read-only control indicates the status of each host-initiated request 
to a Terminal, Unit, interface or endpoint of the video function.
</quote>

Doesn't that mean, that we also need the "unit" in the high byte?

> UVC_VC_REQUEST_ERROR_CODE_CONTROL is only applicable to requests to the 
> control interface, not to the streaming interfaces, while __uvc_query_ctrl() 
> is used for both.

Hm, that certainly was what I was working with - STALLs, returned in 
response to requests to the control interface. But again referring to the 
above quote it seems to me that the intention is to use it for all 
controls? The next sentence in the spec is:

<quote>
If the device is unable to fulfill the request, it will indicate a stall 
on the control pipe and update this control with the appropriate code to 
indicate the cause.
</quote>

is confusing. Now it says explicitly "on the control pipe," so it seems it 
indeed cannot be used on video interfaces.

> I think the code should thus be moved to uvc_query_ctrl(). 
> This would allow calling __uvc_query_ctrl() for both the original request and 
> the error code control instead of calling usb_control_msg() manually.

Given the above, I think I agree that we can now only limit 
UVC_VC_REQUEST_ERROR_CODE_CONTROL to the control pipe, but I'd like to 
have a confirmation from you regarding the unit field.

> 
> > +	error = *(u8 *)data;
> > +	*(u8 *)data = tmp;
> > +
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (!ret)
> 
> I wonder if this check should be if (ret != 1) as it would be an error if the 
> device returned more than 1 byte. I suppose this can't happen when calling 
> usb_control_msg() with the size set to 1, but I'd find the check easier to 
> understand.
> 
> > +		return -EINVAL;
> 
> Should we return -EPIPE instead ? if ret != 1 we have failed reading the error 
> code, so reporting the STALL to the caller is the best we could do in my 
> opinion. -EINVAL would mean that this function was called with invalid 
> parameters, and we don't know that for sure.
> 
> > +	uvc_trace(UVC_TRACE_CONTROL, "Control error %u\n", error);
> > +
> > +	switch (error) {
> > +	case 0:
> > +		/* Cannot happen - we received a STALL */
> > +		return -EPIPE;
> > +	case 1: /* Not ready */
> > +		return -EAGAIN;
> > +	case 2: /* Wrong state */
> > +		return -EILSEQ;
> > +	case 3: /* Power */
> > +		return -EREMOTE;
> > +	case 4: /* Out of range */
> > +		return -ERANGE;
> > +	case 5: /* Invalid unit */
> > +	case 6: /* Invalid control */
> > +	case 7: /* Invalid Request */
> > +	case 8: /* Invalid value within range */
> 
> I agree that these four should return -EINVAL (I'd do it explicitly here).
> 
> > +	default: /* reserved or unknown */
> 
> But here we don't know what went wrong, so I think returning -EPIPE would be 
> better, as we don't have more information than that the device stalled the 
> original control request.
> 
> > +		break;
> > +	}
> > +
> > +	return -EINVAL;
> >  }
> > 
> >  static const char *uvc_query_name(u8 query)
> > @@ -80,7 +124,7 @@ int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8
> > unit, uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on "
> >  			"unit %u: %d (exp. %u).\n", uvc_query_name(query), cs,
> >  			unit, ret, size);
> > -		return -EIO;
> > +		return ret < 0 ? ret : -EIO;
> >  	}
> > 
> >  	return 0;
> > @@ -203,13 +247,15 @@ static int uvc_get_video_ctrl(struct uvc_streaming
> > *stream, uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF, "UVC non "
> >  			"compliance - GET_DEF(PROBE) not supported. "
> >  			"Enabling workaround.\n");
> > -		ret = -EIO;
> > +		if (ret >= 0)
> > +			ret = -EIO;
> >  		goto out;
> >  	} else if (ret != size) {
> >  		uvc_printk(KERN_ERR, "Failed to query (%u) UVC %s control : "
> >  			"%d (exp. %u).\n", query, probe ? "probe" : "commit",
> >  			ret, size);
> > -		ret = -EIO;
> > +		if (ret >= 0)
> > +			ret = -EIO;
> >  		goto out;
> >  	}
> > 
> > @@ -290,7 +336,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> > *stream, uvc_printk(KERN_ERR, "Failed to set UVC %s control : "
> >  			"%d (exp. %u).\n", probe ? "probe" : "commit",
> >  			ret, size);
> > -		ret = -EIO;
> > +		if (ret >= 0)
> > +			ret = -EIO;
> >  	}
> > 
> >  	kfree(data);
> 
> If you move the request error code handling to uvc_query_ctrl() you won't need 
> these changes.

Thanks
Guennadi

> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 
