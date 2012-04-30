Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:54304 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348Ab2D3KtZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 06:49:25 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Date: Mon, 30 Apr 2012 18:47:24 +0800
Subject: RE: Using UVC webcam gadget with a real v4l2 device
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA4446486@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com>
 <4085740.9DbpdWgfF6@avalon>
 <D5ECB3C7A6F99444980976A8C6D896384FA4445DA8@EAPEX1MAIL1.st.com>
 <1649797.NTzsYukYS5@avalon>
In-Reply-To: <1649797.NTzsYukYS5@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Monday, April 30, 2012 3:51 PM
> To: Bhupesh SHARMA
> Cc: linux-usb@vger.kernel.org; linux-media@vger.kernel.org;
> balbi@ti.com; g.liakhovetski@gmx.de
> Subject: Re: Using UVC webcam gadget with a real v4l2 device
> 
> Hi Bhupesh,
> 
> On Thursday 26 April 2012 13:23:59 Bhupesh SHARMA wrote:
> > Hi Laurent,
> >
> > Sorry to jump-in before your reply on my previous mail,
> > but as I was studying the USERPTR stuff in more detail, I have a few
> more
> > queries which I believe you can include in your reply as well..
> 
> [snip]
> 
> > I am now a bit confused on how the entire system will work now:
> > 	- Does USERPTR method needs to be supported both in UVC gadget
> and
> > soc-camera side, or one can still support the MMAP method and the
> other can
> > now be changed to support USERPTR method and we can achieve a ZERO
> buffer
> > copy operation using this method?
> 
> You need USERPTR support on one side only. In practice many (all?) soc-
> camera
> drivers require physically contiguous memory, so you will need to use
> MMAP on
> the soc-camera side and USERPTR on the UVC gadget side. DMABUF, when
> merged in
> the kernel, will be a better solution (but will require all drivers to
> use
> vb2).

Perfect. So, I plan now to add vb2 support for uvc-gadget and leave soc-camera
side to use the mmap stuff.

Now, waiting for your pointers for managing the race-conditions in the UVC gadget
and also avoiding the memcpy that is happening in the QBUF call on the UVC gadget,
before I start the actual work.

Thanks for your help.

Regards,
Bhupesh

> > 	- More specifically, I would like to keep the soc-camera still
> using MMAP
> > (and hence still using video-buf) and make changes at the UVC gadget
> side
> > to support USERPTR and videobuf2. Will this work?
> 
> Please see above :-)
> 
> > 	- At the application side how should we design the flow in case
> both
> > support USERPTR, i.e. the buffer needs to be protected from
> simultaneous
> > access from the UVC gadget driver and soc-camera driver (to ensure
> that a
> > single buffer can be shared across them). Also in case we keep soc-
> camera
> > still using MMAP and UVC gadget side supporting USERPTR, how can we
> share a
> > common buffer across the UVC gadget and soc-camera driver.
> 
> That's easy. Request the same number of buffers on both sides with
> REQBUFS,
> mmap() them to userspace on the soc-camera side, and then use the user
> pointer
> to queue them with QBUF on the UVC side. You just need to ensure that a
> buffer
> is never enqueued to two drivers at the same time. Wait for buffers to
> be
> ready on both sides with select(), and when a buffer is ready dequeue
> it and
> requeue it on the other side.
> 
> > 	- In case of USERPTR method the camera capture hardware should be
> able to
> > DMA the received data to the user space buffers. Are there any
> specific
> > requirements on the DMA capability of these use-space buffers
> > (scatter-gather or contiguous?).
> 
> DMA to userspace is quite hackish. You should use the MMAP method on
> the soc-
> camera side.
> 
> --
> Regards,
> 
> Laurent Pinchart

