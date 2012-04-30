Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46804 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab2D3KUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 06:20:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: Re: Using UVC webcam gadget with a real v4l2 device
Date: Mon, 30 Apr 2012 12:20:47 +0200
Message-ID: <1649797.NTzsYukYS5@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA4445DA8@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com> <4085740.9DbpdWgfF6@avalon> <D5ECB3C7A6F99444980976A8C6D896384FA4445DA8@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

On Thursday 26 April 2012 13:23:59 Bhupesh SHARMA wrote:
> Hi Laurent,
> 
> Sorry to jump-in before your reply on my previous mail,
> but as I was studying the USERPTR stuff in more detail, I have a few more
> queries which I believe you can include in your reply as well..

[snip]

> I am now a bit confused on how the entire system will work now:
> 	- Does USERPTR method needs to be supported both in UVC gadget and
> soc-camera side, or one can still support the MMAP method and the other can
> now be changed to support USERPTR method and we can achieve a ZERO buffer
> copy operation using this method?

You need USERPTR support on one side only. In practice many (all?) soc-camera 
drivers require physically contiguous memory, so you will need to use MMAP on 
the soc-camera side and USERPTR on the UVC gadget side. DMABUF, when merged in 
the kernel, will be a better solution (but will require all drivers to use 
vb2).

> 	- More specifically, I would like to keep the soc-camera still using MMAP
> (and hence still using video-buf) and make changes at the UVC gadget side
> to support USERPTR and videobuf2. Will this work?

Please see above :-)

> 	- At the application side how should we design the flow in case both
> support USERPTR, i.e. the buffer needs to be protected from simultaneous
> access from the UVC gadget driver and soc-camera driver (to ensure that a
> single buffer can be shared across them). Also in case we keep soc-camera
> still using MMAP and UVC gadget side supporting USERPTR, how can we share a
> common buffer across the UVC gadget and soc-camera driver.

That's easy. Request the same number of buffers on both sides with REQBUFS, 
mmap() them to userspace on the soc-camera side, and then use the user pointer 
to queue them with QBUF on the UVC side. You just need to ensure that a buffer 
is never enqueued to two drivers at the same time. Wait for buffers to be 
ready on both sides with select(), and when a buffer is ready dequeue it and 
requeue it on the other side.

> 	- In case of USERPTR method the camera capture hardware should be able to
> DMA the received data to the user space buffers. Are there any specific
> requirements on the DMA capability of these use-space buffers
> (scatter-gather or contiguous?).

DMA to userspace is quite hackish. You should use the MMAP method on the soc-
camera side.

-- 
Regards,

Laurent Pinchart

