Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:56142 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716Ab2DWSsR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 14:48:17 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Date: Tue, 24 Apr 2012 02:46:22 +0800
Subject: RE: Using UVC webcam gadget with a real v4l2 device
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA44457A9@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com>
 <111268324.hD9BSZaXPY@avalon>
In-Reply-To: <111268324.hD9BSZaXPY@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Monday, April 23, 2012 7:47 PM
> To: Bhupesh SHARMA
> Cc: linux-usb@vger.kernel.org; linux-media@vger.kernel.org;
> balbi@ti.com; g.liakhovetski@gmx.de
> Subject: Re: Using UVC webcam gadget with a real v4l2 device
> 
> Hi Bhupesh,
> 
> On Monday 23 April 2012 02:24:53 Bhupesh SHARMA wrote:
> > Hi Laurent,
> >
> > I have been doing some experimentation with the UVC webcam gadget
> along with
> > the UVC user-space application which you have written.
> >
> > The UVC webcam gadget works fine with the user space application
> handling
> > the CONTROL events and providing DATA events. Now, I wish to
> interface a
> > real v4l2 device, for e.g. VIVI or more particularly a soc_camera
> based
> > host and subdev pair.
> >
> > Now, I see that I can achieve this by opening the UVC and V4L2
> devices and
> > doing MMAP -> REQBUF -> QBUF -> DQBUF calls on both the devices per
> the UVC
> > control event received. But this will involve copying the video
> buffer in
> > the user-space application from v4l2 (_CAPTURE) to uvc (_OUTPUT)
> domains,
> > which will significantly reduce the video capture performance.
> >
> > Is there a better solution to this issue? Maybe doing something like
> a RNDIS
> > gadget does with the help of u_ether.c like helper routines. But if I
> > remember well it also requires the BRCTL (Bridge Control Utility) in
> > userspace to route data arriving on usb0 to eth0 and vice-versa. Not
> sure
> > though, if it does copying of a skb buffer from ethernet to usb
> domain and
> > vice-versa.
> 
> To avoid copying data between the two devices you should use USERPTR
> instead
> of MMAP on at least one of the two V4L2 devices. The UVC gadget driver
> doesn't
> support USERPTR yet though. This shouldn't be too difficult to fix, we
> need to
> replace the custom buffers queue implementation with videobuf2, as has
> been
> done in the uvcvideo driver.

I was thinking of using the USERPTR method too, but I realized that currently
neither UVC webcam gadget nor soc-camera subsystem supports this IO method.
They support only MMAP IO as of now :(

> 
> I'll try to implement this. Would you then be able to test patches ?

For sure, I can test your patches on my setup.

BTW, I was exploring GSTREAMER to use the data arriving from soc-camera (v4l2)
capture device '/dev/video1' via 'v4l2src' plugin and routing the same to
the UVC gadget '/dev/video0' via the 'v4l2sink' plugin.

Don't know if this can work cleanly in my setup and whether GSTREAMER actually
performs a buffer copy internally. But I will at-least give it a try :)

Regards,
Bhupesh
