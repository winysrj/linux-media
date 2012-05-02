Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36060 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2EBLzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 07:55:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: Re: Using UVC webcam gadget with a real v4l2 device
Date: Wed, 02 May 2012 13:55:38 +0200
Message-ID: <1399927.kXqBQq59Zu@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA4446486@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com> <1649797.NTzsYukYS5@avalon> <D5ECB3C7A6F99444980976A8C6D896384FA4446486@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

On Monday 30 April 2012 18:47:24 Bhupesh SHARMA wrote:
> On Monday, April 30, 2012 3:51 PM Laurent Pinchart wrote:
> > On Thursday 26 April 2012 13:23:59 Bhupesh SHARMA wrote:
> > > Hi Laurent,
> > > 
> > > Sorry to jump-in before your reply on my previous mail, but as I was
> > > studying the USERPTR stuff in more detail, I have a few more queries
> > > which I believe you can include in your reply as well..
> > 
> > [snip]
> > 
> > > I am now a bit confused on how the entire system will work now:
> > > - Does USERPTR method needs to be supported both in UVC gadget and
> > > soc-camera side, or one can still support the MMAP method and the other
> > > can now be changed to support USERPTR method and we can achieve a ZERO
> > > buffer copy operation using this method?
> > 
> > You need USERPTR support on one side only. In practice many (all?) soc-
> > camera drivers require physically contiguous memory, so you will need to
> > use MMAP on the soc-camera side and USERPTR on the UVC gadget side.
> > DMABUF, when merged in the kernel, will be a better solution (but will
> > require all drivers to use vb2).
> 
> Perfect. So, I plan now to add vb2 support for uvc-gadget and leave soc-
> camera side to use the mmap stuff.
> 
> Now, waiting for your pointers for managing the race-conditions in the UVC
> gadget and also avoiding the memcpy that is happening in the QBUF call on
> the UVC gadget, before I start the actual work.

The memcpy doesn't happen at QBUF time, but when filling the URBs. Avoiding it 
will be pretty difficult, as the driver needs to add packet headers. I would 
leave that out for now.

Regarding videobuf2 support, the main issue comes from race conditions between 
stream start, buffer queueing and URB completion. Unlike the UVC host driver 
where URBs can be resubmitted immediately, the gadget driver can only resubmit 
URBs (in uvc_video_complete()) when there is data to be sent. Otherwise the 
URB is put on a free URBs list (video->req_free) and enqueued in 
uvc_video_pump() the next time a buffer is queued. This requires taking 
various locks and must thus be considered with care. I'm pretty unhappy with 
calling video->encode with the queue irqlock held, I would like to change 
that, but I don't expect to to be an easy task.

-- 
Regards,

Laurent Pinchart

