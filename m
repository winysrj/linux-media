Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54652 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GGNG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2012 09:06:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] usb: gadget/uvc: Add support for 'USB_GADGET_DELAYED_STATUS' response for a set_intf(alt-set 1) command
Date: Sat, 07 Jul 2012 15:06:34 +0200
Message-ID: <2053957.fXKIb2sWrZ@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FAA6331E6@EAPEX1MAIL1.st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com> <3733902.ugUPMW9zZI@avalon> <D5ECB3C7A6F99444980976A8C6D896384FAA6331E6@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

On Tuesday 03 July 2012 23:47:14 Bhupesh SHARMA wrote:
> On Wednesday, June 20, 2012 3:19 AM Laurent Pinchart wrote:
> > On Friday 01 June 2012 15:08:58 Bhupesh Sharma wrote:
> > > This patch adds the support in UVC webcam gadget design for providing
> > > USB_GADGET_DELAYED_STATUS in response to a set_interface(alt setting 1)
> > > command issue by the Host.
> > > 
> > > The current UVC webcam gadget design generates a STREAMON event
> > > corresponding to a set_interface(alt setting 1) command from the Host.
> > > This STREAMON event will eventually be routed to a real V4L2 device.
> > > 
> > > To start video streaming, it may be required to perform some register
> > > writes to a camera sensor device over slow external busses like I2C or
> > > SPI. So, it makes sense to ensure that we delay the STATUS stage of the
> > > set_interface(alt setting 1) command.
> > > 
> > > Otherwise, a lot of ISOC IN tokens sent by the Host will be replied to
> > > by zero-length packets by the webcam device. On certain Hosts this may
> > > even> lead to ISOC URBs been cancelled from the Host side.
> > > 
> > > So, as soon as we finish doing all the "streaming" related stuff on the
> > > real V4L2 device, we call a STREAMON ioctl on the UVC side and from here
> > > we call the 'usb_composite_setup_continue' function to complete the
> > > status stage of the set_interface(alt setting 1) command.
> > 
> > That sounds good, thank you for coming up with a solution to this
> > issue.
> > 
> > > Further, we need to ensure that we queue no video buffers on the UVC
> > > webcam gadget, until we de-queue a video buffer from the V4L2 device.
> > > Also, we need to enable UVC video related stuff at the first QBUF ioctl
> > > call itself, as the application will call the STREAMON on UVC side only
> > > when it has dequeued sufficient buffers from the V4L2 side and queued
> > > them to the UVC gadget. So, the UVC video enable stuff cannot be done in
> > > STREAMON ioctl call.
> > 
> > Is that really required ? First of all, the userspace application can
> > queue buffers before it calls VIDIOC_STREAMON. Assuming it doesn't, the
> > gadget driver calls uvc_video_enable() at streamon time, which then calls
> > uvc_video_pump(). As no buffer is queued, the function will return without
> > queuing any USB request, so we shouldn't have any problem.
> 
> I think that while working with a real video device, it will be possible to
> queue a buffer at UVC end only when atleast one buffer has been dequeued
> from the V4L2 device side (and has some real data).
> 
> This is because for a uvc buffer being queued we need to pass the v4l2
> buffer's buffer.start and buffer.length in the qbuf call at UVC side.

I agree with you, queuing a buffer on the UVC gadget side will usually require 
starting capture and waiting for a frame on a V4L2 source device. However, 
unless I'm mistaken, the UVC gadget code already deals with that situation 
correctly. As I explained, when your application calls VIDIOC_STREAMON on the 
UVC gadget, the uvc_video_pump() will not find any V4L2 buffer to be 
transferred, and will return without queuing any URB. It will then be called 
again by VIDIOC_QBUF, and will then start the transfer.

Adding support for USB_GADGET_DELAYED_STATUS is thus a good idea, but the pre-
streaming state is in my opinion not needed. Feel free to prove me wrong 
though :-)

> > > For the same we add two more UVC states:
> > > 	- PRE_STREAMING : not even a single buffer has been queued to UVC
> > > 	- BUF_QUEUED_STREAMING_OFF : one video buffer has been queued to UVC
> > > 			but we have not yet enabled STREAMING on UVC side.
> > > 
> > > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>

-- 
Regards,

Laurent Pinchart

