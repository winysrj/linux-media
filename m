Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:51417 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbcGSU4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 16:56:22 -0400
Date: Tue, 19 Jul 2016 15:56:00 -0500
From: Bin Liu <b-liu@ti.com>
To: <matwey@sai.msu.ru>
CC: <hdegoede@redhat.com>, <linux-media@vger.kernel.org>,
	<linux-usb@vger.kernel.org>
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
Message-ID: <20160719205600.GA14569@uda0271908>
References: <1468959677-1768-1-git-send-email-matwey@sai.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1468959677-1768-1-git-send-email-matwey@sai.msu.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Jul 19, 2016 at 11:21:17PM +0300, matwey@sai.msu.ru wrote:
> Hello,
> 
> I have Philips SPC 900 camera (0471:0329) connected to my AM335x based BeagleBoneBlack SBC.
> I am sure that both of them are fine and work properly.
> I am running Linux 4.6.4 (my kernel config is available at https://clck.ru/A2kQs ) and I've just discovered, that there is an issue with frame transfer when high resolution formats are used.
> 
> The issue is the following. I use simple v4l2 example tool (taken from API docs), which source code is available at http://pastebin.com/grcNXxfe
> 
> When I use (see line 488) 640x480 frames
> 
>                 fmt.fmt.pix.width       = 640;
>                 fmt.fmt.pix.height      = 480;
> 
> then I get "select timeout" and don't get any frames.
> 
> When I use 320x240 frames
>                 
>                 fmt.fmt.pix.width       = 320;
>                 fmt.fmt.pix.height      = 240;
> 
> then about 60% frames are missed. An example outpout of ./a.out -f is available at https://yadi.sk/d/aRka8xWPtSc4y
> It looks like there are pauses between bulks of frames (frame counter and timestamp as returned from v4l2 API):
> 
> 3 3705.142553
> 8 3705.342533
> 13 3705.542517
> 110 3708.776208
> 115 3708.976190
> 120 3709.176169
> 125 3709.376152
> 130 3709.576144
> 226 3712.807848
> 
> When I use tiny 160x120 frames
>                 
>                 fmt.fmt.pix.width       = 160;
>                 fmt.fmt.pix.height      = 120;
> 
> then more frames are received. See output example at https://yadi.sk/d/DedBmH6ftSc9t
> That is why I thought that everything was fine in May when used tiny xawtv window to check kernel OOPS presence (see http://www.spinics.net/lists/linux-usb/msg141188.html for reference)
> 
> Even more. When I introduce USB hub between the host and the webcam, I can not receive even any 320x240 frames.
> 
> I've managed to use ftrace to see what is going on when no frames are received.
> I've found that pwc_isoc_handler is called frequently as the following:
> 
>  0)               |  pwc_isoc_handler [pwc]() {
>  0)               |    usb_submit_urb [usbcore]() {
>  0)               |      usb_submit_urb.part.3 [usbcore]() {
>  0)               |        usb_hcd_submit_urb [usbcore]() {
>  0)   0.834 us    |          usb_get_urb [usbcore]();
>  0)               |          musb_map_urb_for_dma [musb_hdrc]() {
>  0)   0.792 us    |            usb_hcd_map_urb_for_dma [usbcore]();
>  0)   5.750 us    |          }
>  0)               |          musb_urb_enqueue [musb_hdrc]() {
>  0)   0.750 us    |            _raw_spin_lock_irqsave();
>  0)               |            usb_hcd_link_urb_to_ep [usbcore]() {
>  0)   0.792 us    |              _raw_spin_lock();
>  0)   0.791 us    |              _raw_spin_unlock();
>  0) + 10.500 us   |            }
>  0)   0.791 us    |            _raw_spin_unlock_irqrestore();
>  0) + 25.375 us   |          }
>  0) + 45.208 us   |        }
>  0) + 51.042 us   |      }
>  0) + 56.084 us   |    }
>  0) + 61.292 us   |  }
> 
> However, pwc_isoc_handler never calls vb2_buffer_done() that is why I get "select timeout" in userspace.
> Unfortunately, my kernel is not compiled with CONFIG_USB_PWC_DEBUG=y but I can recompile it, if you think that it could provide more information. I am also ready to perform additional tests (use usbmon maybe?).
> 
> How could this issue be resolved?
> 
> Thank you.

Do you have CPPI DMA enabled? If so I think you might hit on a known
issue in CPPI Isoch transfer, in which the MUSB controller only sends IN
tokens in every other SOF, so only half of the bus bandwidth is
utilized, which causes video frame drops in higher resolution.

To confirm this, use a bus analyzer to capture a bus trace, you would
see no IN tokens in every other SOF while transfering Isoch packets.

Regards,
-Bin.
