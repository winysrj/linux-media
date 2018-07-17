Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58118 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbeGQXv4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 19:51:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v8 3/3] uvcvideo: handle control pipe protocol STALLs
Date: Wed, 18 Jul 2018 02:17:29 +0300
Message-ID: <15478343.qxZ17KchLc@avalon>
In-Reply-To: <7129850.vz39VDuykc@avalon>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com> <1525792064-30836-4-git-send-email-guennadi.liakhovetski@intel.com> <7129850.vz39VDuykc@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday, 17 July 2018 23:58:03 EEST Laurent Pinchart wrote:
> On Tuesday, 8 May 2018 18:07:44 EEST Guennadi Liakhovetski wrote:
> > When a command ends up in a STALL on the control pipe, use the Request
> > Error Code control to provide a more precise error information to the
> > user. For example, if a camera is still busy processing a control,
> > when the same or an interrelated control set request arrives, the
> > camera can react with a STALL and then return the "Not ready" status
> > in response to a UVC_VC_REQUEST_ERROR_CODE_CONTROL command. With this
> > patch the user would then get an EBUSY error code instead of a
> > generic EPIPE.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Can I push this patch already before 2/3 is ready ?

> > ---
> > 
> > v8:
> > 
> > * restrict UVC_VC_REQUEST_ERROR_CODE_CONTROL to the control interface
> > * fix the wIndex value
> > * improve error codes
> > * cosmetic changes
> > 
> >  drivers/media/usb/uvc/uvc_video.c | 52 +++++++++++++++++++++++++++++-----
> >  1 file changed, 46 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c index aa0082f..ce65cd6 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -73,17 +73,57 @@ int uvc_query_ctrl(struct uvc_device *dev, u8 query,
> > u8
> > unit, u8 intfnum, u8 cs, void *data, u16 size)
> > 
> >  {
> >  
> >  	int ret;
> > 
> > +	u8 error;
> > +	u8 tmp;
> > 
> >  	ret = __uvc_query_ctrl(dev, query, unit, intfnum, cs, data, size,
> >  	
> >  				UVC_CTRL_CONTROL_TIMEOUT);
> > 
> > -	if (ret != size) {
> > -		uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on "
> > -			"unit %u: %d (exp. %u).\n", uvc_query_name(query), cs,
> > -			unit, ret, size);
> > -		return -EIO;
> > +	if (likely(ret == size))
> > +		return 0;
> > +
> > +	uvc_printk(KERN_ERR,
> > +		   "Failed to query (%s) UVC control %u on unit %u: %d (exp. %u).
\n",
> > +		   uvc_query_name(query), cs, unit, ret, size);
> > +
> > +	if (ret != -EPIPE)
> > +		return ret;
> > +
> > +	tmp = *(u8 *)data;
> > +
> > +	ret = __uvc_query_ctrl(dev, UVC_GET_CUR, 0, intfnum,
> > +			       UVC_VC_REQUEST_ERROR_CODE_CONTROL, data, 1,
> > +			       UVC_CTRL_CONTROL_TIMEOUT);
> > +
> > +	error = *(u8 *)data;
> > +	*(u8 *)data = tmp;
> > +
> > +	if (ret != 1)
> > +		return ret < 0 ? ret : -EPIPE;
> > +
> > +	uvc_trace(UVC_TRACE_CONTROL, "Control error %u\n", error);
> > +
> > +	switch (error) {
> > +	case 0:
> > +		/* Cannot happen - we received a STALL */
> > +		return -EPIPE;
> > +	case 1: /* Not ready */
> > +		return -EBUSY;
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
> > +		return -EINVAL;
> > +	default: /* reserved or unknown */
> > +		break;
> > 
> >  	}
> > 
> > -	return 0;
> > +	return -EPIPE;
> > 
> >  }
> >  
> >  static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,


-- 
Regards,

Laurent Pinchart
