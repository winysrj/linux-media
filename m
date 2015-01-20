Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57375 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbbATM7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 07:59:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Florian Echtler <floe@butterbrot.org>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
Date: Tue, 20 Jan 2015 14:59:49 +0200
Message-ID: <64652239.MTTlcOgNK2@avalon>
In-Reply-To: <54BE201F.4060209@xs4all.nl>
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <54BE1EBC.2090001@butterbrot.org> <54BE201F.4060209@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 20 January 2015 10:30:07 Hans Verkuil wrote:
> On 01/20/15 10:24, Florian Echtler wrote:
> > On 19.01.2015 11:38, Hans Verkuil wrote:
> >> Sorry for the delay.
> > 
> > No problem, thanks for your feedback.
> > 
> >>> Note: I'm intentionally using dma-contig instead of vmalloc, as the USB
> >>> core apparently _will_ try to use DMA for larger bulk transfers.
> >> 
> >> As far as I can tell from looking through the usb core code it supports
> >> scatter-gather DMA, so you should at least use dma-sg rather than
> >> dma-contig. Physically contiguous memory should always be avoided.
> > 
> > OK, will this work transparently (i.e. just switch from *-contig-* to
> > *-sg-*)? If not, can you suggest an example driver to use as template?
> 
> Yes, that should pretty much be seamless. BTW, the more I think about it,
> the more I am convinced that DMA will also be used by the USB core when
> you use videobuf2-vmalloc.
> 
> I've CC-ed Laurent, I think he knows a lot more about this than I do.
> 
> Laurent, when does the USB core use DMA? What do you need to do on the
> driver side to have USB use DMA when doing bulk transfers?

How USB HCD drivers map buffers for DMA is HCD-specific, but all drivers 
exepct ehci-tegra, max3421-hcd and musb use the default implementation 
usb_hcd_map_urb_for_dma() (in drivers/usb/core/hcd.c).

Unless the buffer has already been mapped by the USB driver (in which case the 
driver will have set the URB_NO_TRANSFER_DMA_MAP flag in urb->transfer_flags 
and initialized the urb->transfer_dma field), the function will use 
dma_map_sg(), dma_map_page() or dma_map_single() depending on the buffer type 
(controlled through urb->sg and urb->num_sgs). DMA will thus always be used 
*expect* if the platform uses bounce buffers when the buffer can't be mapped 
directly for DMA.

> >> I'm also missing a patch for the Kconfig that adds a dependency on
> >> MEDIA_USB_SUPPORT and that selects VIDEOBUF2_DMA_SG.
> > 
> > Good point, will add that.
> > 
> >>> +err_unreg_video:
> >>> +	video_unregister_device(&sur40->vdev);
> >>> +err_unreg_v4l2:
> >>> +	v4l2_device_unregister(&sur40->v4l2);
> >>> 
> >>>  err_free_buffer:
> >>>  	kfree(sur40->bulk_in_buffer);
> >>>  
> >>>  err_free_polldev:
> >>> @@ -436,6 +604,10 @@ static void sur40_disconnect(struct usb_interface
> >>> *interface)>> 
> >> Is this a hardwired device or hotpluggable? If it is hardwired, then this
> >> code is OK, but if it is hotpluggable, then this isn't good enough.
> > 
> > It's hardwired. Out of curiosity, what would I have to change for a
> > hotpluggable one?
> 
> In that case you can't clean everything up since some application might
> still have a filehandle open. You have to wait until the very last
> filehandle is closed.
> 
> >>> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> >>> +	i->std = V4L2_STD_UNKNOWN;
> >>> +	strlcpy(i->name, "In-Cell Sensor", sizeof(i->name));
> >> 
> >> Perhaps just say "Sensor" here? I'm not sure what "In-Cell" means.
> > 
> > In-cell is referring to the concept of integrating sensor pixels
> > directly with LCD pixels, I think it's what Samsung calls it.

-- 
Regards,

Laurent Pinchart

