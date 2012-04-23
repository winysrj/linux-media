Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49191 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2DWOQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 10:16:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: Re: Using UVC webcam gadget with a real v4l2 device
Date: Mon, 23 Apr 2012 16:17:15 +0200
Message-ID: <111268324.hD9BSZaXPY@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

On Monday 23 April 2012 02:24:53 Bhupesh SHARMA wrote:
> Hi Laurent,
> 
> I have been doing some experimentation with the UVC webcam gadget along with
> the UVC user-space application which you have written.
> 
> The UVC webcam gadget works fine with the user space application handling
> the CONTROL events and providing DATA events. Now, I wish to interface a
> real v4l2 device, for e.g. VIVI or more particularly a soc_camera based
> host and subdev pair.
> 
> Now, I see that I can achieve this by opening the UVC and V4L2 devices and
> doing MMAP -> REQBUF -> QBUF -> DQBUF calls on both the devices per the UVC
> control event received. But this will involve copying the video buffer in
> the user-space application from v4l2 (_CAPTURE) to uvc (_OUTPUT) domains,
> which will significantly reduce the video capture performance.
> 
> Is there a better solution to this issue? Maybe doing something like a RNDIS
> gadget does with the help of u_ether.c like helper routines. But if I
> remember well it also requires the BRCTL (Bridge Control Utility) in
> userspace to route data arriving on usb0 to eth0 and vice-versa. Not sure
> though, if it does copying of a skb buffer from ethernet to usb domain and
> vice-versa.

To avoid copying data between the two devices you should use USERPTR instead 
of MMAP on at least one of the two V4L2 devices. The UVC gadget driver doesn't 
support USERPTR yet though. This shouldn't be too difficult to fix, we need to 
replace the custom buffers queue implementation with videobuf2, as has been 
done in the uvcvideo driver.

I'll try to implement this. Would you then be able to test patches ?

-- 
Regards,

Laurent Pinchart

