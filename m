Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45138 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755105AbcIVNdb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 09:33:31 -0400
Date: Thu, 22 Sep 2016 08:33:27 -0500
From: Bin Liu <b-liu@ti.com>
To: Felipe Balbi <felipe.balbi@linux.intel.com>
CC: <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: g_webcam Isoch high bandwidth transfer
Message-ID: <20160922133327.GA31827@uda0271908>
References: <20160920170441.GA10705@uda0271908>
 <871t0d4r72.fsf@linux.intel.com>
 <20160921132702.GA18578@uda0271908>
 <87oa3go065.fsf@linux.intel.com>
 <87lgyknyp7.fsf@linux.intel.com>
 <87d1jw6yfd.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87d1jw6yfd.fsf@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 22, 2016 at 01:06:46PM +0300, Felipe Balbi wrote:
> 
> Hi,
> 
> Felipe Balbi <felipe.balbi@linux.intel.com> writes:
> > Felipe Balbi <felipe.balbi@linux.intel.com> writes:
> >> Bin Liu <b-liu@ti.com> writes:
> >>> On Wed, Sep 21, 2016 at 11:01:21AM +0300, Felipe Balbi wrote:
> >>>> 
> >>>> Hi,
> >>>> 
> >>>> Bin Liu <b-liu@ti.com> writes:
> >>>> > Hi,
> >>>> >
> >>>> > I am trying to check Isoch high bandwidth transfer with g_webcam.ko in
> >>>> >  high-speed connection.
> >>>> >
> >>>> > First I hacked webcam.c as follows to enable 640x480@30fps mode.
> >>>> >
> >>>> > diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/legacy/webcam.c
> >>>> > index 72c976b..9eb315f 100644
> >>>> > --- a/drivers/usb/gadget/legacy/webcam.c
> >>>> > +++ b/drivers/usb/gadget/legacy/webcam.c
> >>>> > @@ -191,15 +191,15 @@ static const struct UVC_FRAME_UNCOMPRESSED(3) uvc_frame_yuv_360p = {
> >>>> >         .bFrameIndex            = 1,
> >>>> >         .bmCapabilities         = 0,
> >>>> >         .wWidth                 = cpu_to_le16(640),
> >>>> > -       .wHeight                = cpu_to_le16(360),
> >>>> > +       .wHeight                = cpu_to_le16(480),
> >>>> >         .dwMinBitRate           = cpu_to_le32(18432000),
> >>>> >         .dwMaxBitRate           = cpu_to_le32(55296000),
> >>>> > -       .dwMaxVideoFrameBufferSize      = cpu_to_le32(460800),
> >>>> > -       .dwDefaultFrameInterval = cpu_to_le32(666666),
> >>>> > +       .dwMaxVideoFrameBufferSize      = cpu_to_le32(614400),
> >>>> > +       .dwDefaultFrameInterval = cpu_to_le32(333333),
> >>>> >         .bFrameIntervalType     = 3,
> >>>> > -       .dwFrameInterval[0]     = cpu_to_le32(666666),
> >>>> > -       .dwFrameInterval[1]     = cpu_to_le32(1000000),
> >>>> > -       .dwFrameInterval[2]     = cpu_to_le32(5000000),
> >>>> > +       .dwFrameInterval[0]     = cpu_to_le32(333333),
> >>>> > +       .dwFrameInterval[1]     = cpu_to_le32(666666),
> >>>> > +       .dwFrameInterval[2]     = cpu_to_le32(1000000),
> >>>> >  };
> >>>> >
> >>>> > then loaded g_webcam.ko as
> >>>> >
> >>>> > # modprobe g_webcam streaming_maxpacket=3072
> >>>> >
> >>>> > The endpoint descriptor showing on the host is
> >>>> >
> >>>> >       Endpoint Descriptor:
> >>>> >         bLength                 7
> >>>> >         bDescriptorType         5
> >>>> >         bEndpointAddress     0x8d  EP 13 IN
> >>>> >         bmAttributes            5
> >>>> >           Transfer Type            Isochronous
> >>>> >           Synch Type               Asynchronous
> >>>> >           Usage Type               Data
> >>>> >         wMaxPacketSize     0x1400  3x 1024 bytes
> >>>> >         bInterval               1
> >>>> >
> >>>> > However the usb bus trace shows only one transaction with 1024-bytes packet in
> >>>> > every SOF. The host only sends one IN packet in every SOF, I am expecting 2~3
> >>>> > 1024-bytes transactions, since this would be required to transfer 640x480@30fps
> >>>> > YUV frames in high-speed.
> >>>> >
> >>>> > DId I miss anything in the setup?
> >>>> 
> >>>> MUSB or DWC3? This looks like a UDC bug to me. Can you show a screenshot
> >>>
> >>> Happened on both MUSB and DWC3.
> >>>
> >>>> of your bus analyzer? When host sends IN token, are you replying with
> >>>
> >>> The trace screenshot on DWC3 is attached.
> >>>
> >>>> DATA0, DATA1 or DATA2?
> >>>
> >>> Good hint! It is DATA0!
> >>
> >> yeah, should've been DATA2. I'll check if we're missing anything for
> >> High Bandwidth Iso on DWC3. Can you confirm if it works of tails on
> >> DWC3? On your follow-up mail you mentioned it's a bug in MUSB. What
> >> about DWC3?
> >
> > I'm assuming DWC3 really breaks. Here's a patch for that:
> >
> > 8<---------------------------------- cut here ----------------------------------
> > From 62807011c00055785575bb39d92bfe8836817e2f Mon Sep 17 00:00:00 2001
> > From: Felipe Balbi <felipe.balbi@linux.intel.com>
> > Date: Thu, 22 Sep 2016 11:01:01 +0300
> > Subject: [PATCH] usb: dwc3: gadget: set PCM1 field of isochronous-first TRBs
> >
> > In case of High-Speed, High-Bandwidth endpoints, we
> > need to tell DWC3 that we have more than one packet
> > per interval. We do that by setting PCM1 field of
> > Isochronous-First TRB.
> >
> > Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> > ---
> >  drivers/usb/dwc3/gadget.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 602f12254161..106623faf060 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -787,6 +787,9 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
> >  		unsigned length, unsigned chain, unsigned node)
> >  {
> >  	struct dwc3_trb		*trb;
> > +	struct dwc3		*dwc = dep->dwc;
> > +	struct usb_gadget	*gadget = &dwc->gadget;
> > +	enum usb_device_speed	speed = speed;
> 
> and of course I sent the wrong version :-)
> 
> Here's one that actually compiles, sorry about that.

No worries, I was sleeping ;-)

I will test it out early next week. Thanks.

Regards,
-Bin.

> 
> 8<---------------------------------- cut here ----------------------------------
> From 44282f6c664b17e6b9dffbc31e72258be84823a4 Mon Sep 17 00:00:00 2001
> From: Felipe Balbi <felipe.balbi@linux.intel.com>
> Date: Thu, 22 Sep 2016 11:01:01 +0300
> Subject: [PATCH] usb: dwc3: gadget: set PCM1 field of isochronous-first TRBs
> 
> In case of High-Speed, High-Bandwidth endpoints, we
> need to tell DWC3 that we have more than one packet
> per interval. We do that by setting PCM1 field of
> Isochronous-First TRB.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---
>  drivers/usb/dwc3/gadget.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 602f12254161..34a7b1bf0522 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -787,6 +787,9 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
>  		unsigned length, unsigned chain, unsigned node)
>  {
>  	struct dwc3_trb		*trb;
> +	struct dwc3		*dwc = dep->dwc;
> +	struct usb_gadget	*gadget = &dwc->gadget;
> +	enum usb_device_speed	speed = gadget->speed;
>  
>  	dwc3_trace(trace_dwc3_gadget, "%s: req %p dma %08llx length %d%s",
>  			dep->name, req, (unsigned long long) dma,
> @@ -813,10 +816,17 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
>  		break;
>  
>  	case USB_ENDPOINT_XFER_ISOC:
> -		if (!node)
> +		if (!node) {
>  			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS_FIRST;
> -		else
> +
> +			if (speed == USB_SPEED_HIGH) {
> +				struct usb_ep *ep = &dep->endpoint;
> +				u8 pkts = DIV_ROUND_UP(ep->maxpacket, 1024);
> +				trb->size |= DWC3_TRB_SIZE_PCM1(pkts - 1);
> +			}
> +		} else {
>  			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
> +		}
>  
>  		/* always enable Interrupt on Missed ISOC */
>  		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
> -- 
> 2.10.0
> 
> 
> 
> -- 
> balbi


