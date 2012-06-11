Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44649 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2FKHZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 03:25:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/5] usb: gadget/uvc: Add super-speed support to UVC webcam gadget
Date: Mon, 11 Jun 2012 09:25:07 +0200
Message-ID: <1347233.iHu8KtvGD4@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA90D53DF@EAPEX1MAIL1.st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com> <1524353.hc44KZEWdu@avalon> <D5ECB3C7A6F99444980976A8C6D896384FA90D53DF@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

(Dropping Greg from the CC list, I think he gets enough e-mails already 
without our help :-))

On Saturday 09 June 2012 13:39:34 Bhupesh SHARMA wrote:
> Hi Laurent,
> 
> Thanks for your review comments.
> 
> Please find my comments inline:
> > As Felipe has already applied the patch to his public tree, I'll send
> > incremental cleanup patches. Here's my review nonetheless, with a question
> > which I'd like to know your opinion about to write the cleanup patches.
> 
> Not to worry, I can send incremental patches.

I've already prepared incremental patches so I'll send them.

> Anyways I need to ensure 4/5 and 5/5 patches of the series also cleanly
> apply on Felipe's tree as he was facing issues while applying these
> patches.
> 
> Please review 4/5 and 5/5 patches of this patch-set as well and then I can
> re-circulate patches for re-review and incorporation in gadget-next.

I will review 4/5 and 5/5 and ask you to post a new version. I'll send 
incremental patches for 1/5 to 3/5 myself.

> > On Friday 01 June 2012 15:08:56 Bhupesh Sharma wrote:
> > > This patch adds super-speed support to UVC webcam gadget.
> > > 
> > > Also in this patch:
> > >     - We add the configurability to pass bInterval, bMaxBurst, mult
> > >       factors for video streaming endpoint (ISOC IN) through module
> > >       parameters.
> > >     
> > >     - We use config_ep_by_speed helper routine to configure video
> > >       streaming endpoint.
> > > 
> > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>

[snip]

> > > +static unsigned streaming_interval = 1;
> > > +module_param(streaming_interval, uint, S_IRUGO|S_IWUSR);
> > > +MODULE_PARM_DESC(streaming_interval, "1 - 16");
> > > +
> > > +static unsigned streaming_maxpacket = 1024;
> > 
> > unsigned int please.
> 
> Ok.
> 
> > > +module_param(streaming_maxpacket, uint, S_IRUGO|S_IWUSR);
> > > +MODULE_PARM_DESC(streaming_maxpacket, "0 - 1023 (fs), 0 - 1024
> > > (hs/ss)");
> > > +
> > > +static unsigned streaming_mult;
> > > +module_param(streaming_mult, uint, S_IRUGO|S_IWUSR);
> > > +MODULE_PARM_DESC(streaming_mult, "0 - 2 (hs/ss only)");
> > 
> > I'd rather like to integrate this into the streaming_maxpacket parameter,
> > and compute the multiplier at runtime. This shouldn't be difficult for
> > high speed, the multiplier for max packet sizes between 1 and 1024 is 1,
> > between 1025 and 2048 is 2 and between 2049 and 3072 is 3.
> 
> There is a specific purpose for keeping these three module parameters
> separate, with xHCI hosts and USB3 device-side controllers still in
> stabilization phase, it is easy for a person switching from USB2.0 to
> USB3.0 to understand these module parameters as the major difference points
> in respect to ISOC IN endpoints.
> 
> A similar methodology is already used in the reference USB gadget "zero"
> (see here [1]) and I have tried to keep the same methodology here as well.
> 
> [1]
> http://git.kernel.org/?p=linux/kernel/git/balbi/usb.git;a=blob;f=drivers/us
> b/gadget/f_sourcesink.c

Having another driver implementing the same doesn't automatically make it 
right ;-)

I still think the maxpacket and mult values should be combined into a single 
parameter. There's a single way to split a given number of bytes into 
maxpacket and mult values. Felipe (and others), any opinion on this ?

> > > +static unsigned streaming_maxburst;
> > > +module_param(streaming_maxburst, uint, S_IRUGO|S_IWUSR);
> > > +MODULE_PARM_DESC(streaming_maxburst, "0 - 15 (ss only)");
> > 
> > Do you think maxburst could also be integrated into the
> > streaming_maxpacket parameter ? Put it another way, can we computer the
> > multiplier and the burst value from a single maximum number of bytes per
> > service interval, or do they have to be specified independently ? If using
> > more than one burst, the wMaxPacketSize value must be 1024 for HS. Only
> > multiples of 1024 higher than 1024 can thus be achieved through different
> > multipler/burst settings.
> 
> Pls see above..

I'll keep this parameter separate. When maxburst is non-zero the maxpacket 
value must be a multiple of 1024. If the user-specified value is incorrect the 
driver should error out.

I forgot to mention that S_IWUSR looks unsafe to me. If we allow changing the 
mackpacket, mult and maxburst values at runtime, the function could be bound 
after one of the values have been changed but not the others.

[snip]

> > > +
> > > +/* super speed support */
> > > +static struct usb_endpoint_descriptor uvc_ss_control_ep __initdata =
> > {
> > > +   .bLength =              USB_DT_ENDPOINT_SIZE,
> > > +   .bDescriptorType =      USB_DT_ENDPOINT,
> > > +
> > > +   .bEndpointAddress =     USB_DIR_IN,
> > > +   .bmAttributes =         USB_ENDPOINT_XFER_INT,
> > > +   .wMaxPacketSize =       cpu_to_le16(STATUS_BYTECOUNT),
> > > +   .bInterval =            8,
> > > +};
> > 
> > The FS/HS/SS control endpoint descriptors are identical, there's no need
> > to define separate descriptors. You also don't set the SS endpoint number
> > to the FS endpoint number. As you don't call usb_ep_autoconfig() on the SS
> > endpoint, I doubt this will work in SS. Have you tested SS support ?
> 
> Yes. I have tested the SS support. It works fine :)
> usb_ep_autoconfig is usually always called for the lowest speed we support.
> See other gadget drivers for reference:
> 
> [2]
> http://git.kernel.org/?p=linux/kernel/git/balbi/usb.git;a=blob;f=drivers/us
> b/gadget/f_sourcesink.c

Why is that ? It looks like a bug to me.

> > > @@ -498,8 +612,26 @@ uvc_function_bind(struct usb_configuration *c,
> > > struct usb_function *f)
> > > 
> > >     INFO(cdev, "uvc_function_bind\n");
> > > 
> > > +   /* sanity check the streaming endpoint module parameters */
> > > +   if (streaming_interval < 1)
> > > +           streaming_interval = 1;
> > > +   if (streaming_interval > 16)
> > > +           streaming_interval = 16;
> > 
> > You can use clamp() instead (although one might argue that it's less
> > readable).
> 
> Again, I am trying to be as close as possible to "zero" gadget :)

This is the UVC function gadget, it's allowed to be itself.

> > > +   if (streaming_mult > 2)
> > > +           streaming_mult = 2;
> > > +   if (streaming_maxburst > 15)
> > > +           streaming_maxburst = 15;
> > > +
> > > +   /*
> > > +    * fill in the FS video streaming specific descriptors from the
> > > +    * module parameters
> > > +    */
> > > +   uvc_fs_streaming_ep.wMaxPacketSize = streaming_maxpacket > 1023 ?
> > > +                                           1023 : streaming_maxpacket;
> > > +   uvc_fs_streaming_ep.bInterval = streaming_interval;
> > > +
> > > 
> > >     /* Allocate endpoints. */
> > > -   ep = usb_ep_autoconfig(cdev->gadget, &uvc_control_ep);
> > > +   ep = usb_ep_autoconfig(cdev->gadget, &uvc_fs_control_ep);
> > >     if (!ep) {
> > >     
> > >             INFO(cdev, "Unable to allocate control EP\n");
> > >             goto error;
> > > 
> > > @@ -507,7 +639,7 @@ uvc_function_bind(struct usb_configuration *c,
> > > struct usb_function *f)
> > >     uvc->control_ep = ep;
> > > 
> > >     ep->driver_data = uvc;
> > > 
> > > -   ep = usb_ep_autoconfig(cdev->gadget, &uvc_streaming_ep);
> > > +   ep = usb_ep_autoconfig(cdev->gadget, &uvc_fs_streaming_ep);
> > 
> > This will select an endpoint suitable for FS, but there's no guarantee
> > that the endpoint will be suitable for FS and HS maximum packet sizes. I
> > think calling usb_ep_autoconf(_ss) on the endpoint for the highest
> > supported speed should fix the problem.
> 
> Please see explanation of the same given above.

Please see my disagreement to your above explanation :-)

[snip]

> > > diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
> > > index 668fe12..120e134 100644
> > > --- a/drivers/usb/gadget/webcam.c
> > > +++ b/drivers/usb/gadget/webcam.c
> > > @@ -272,7 +272,15 @@ static const struct uvc_color_matching_descriptor
> > > uvc_color_matching = { .bMatrixCoefficients = 4,
> > >  };
> > > 
> > > -static const struct uvc_descriptor_header * const uvc_control_cls[] = {
> > > +static const struct uvc_descriptor_header * const uvc_fs_control_cls[]
> > > = {
> > > +   (const struct uvc_descriptor_header *) &uvc_control_header,
> > > +   (const struct uvc_descriptor_header *) &uvc_camera_terminal,
> > > +   (const struct uvc_descriptor_header *) &uvc_processing,
> > > +   (const struct uvc_descriptor_header *) &uvc_output_terminal,
> > > +   NULL,
> > > +};
> > > +
> > > +static const struct uvc_descriptor_header * const uvc_ss_control_cls[]
> > > = {
> > >     (const struct uvc_descriptor_header *) &uvc_control_header,
> > >     (const struct uvc_descriptor_header *) &uvc_camera_terminal,
> > >     (const struct uvc_descriptor_header *) &uvc_processing,
> > 
> > uvc_fs_control_cls and uvc_ss_controls_cls are identical and const, we
> > don't need two copies.
> 
> Hmm. Actually the UVC specification draft committee has not met since the
> last 5 yrs. The last updated specification is dated July, 2005. I am
> not sure if they will meet again to add some errata for USB3.0 keeping
> in mind the new concept of sequence numbers and burst window added in USB3.0
> I have kept these placeholders only for that purpose.
> 
> If you suggest, I can remove these or better still add a comment here..

We don't need different descriptors now, and there's no clear indication that 
we will need them in the very near future. Let's not add unneeded code to the 
kernel now, we'll split the descriptors later when/if needed.

-- 
Regards,

Laurent Pinchart

