Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35827 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2DWUzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 16:55:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: Re: Using UVC webcam gadget with a real v4l2 device
Date: Mon, 23 Apr 2012 22:55:57 +0200
Message-ID: <4085740.9DbpdWgfF6@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA44457A9@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com> <111268324.hD9BSZaXPY@avalon> <D5ECB3C7A6F99444980976A8C6D896384FA44457A9@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

On Tuesday 24 April 2012 02:46:22 Bhupesh SHARMA wrote:
> On Monday, April 23, 2012 7:47 PM Laurent Pinchart wrote:
> > On Monday 23 April 2012 02:24:53 Bhupesh SHARMA wrote:
> > > Hi Laurent,
> > > 
> > > I have been doing some experimentation with the UVC webcam gadget along
> > > with the UVC user-space application which you have written.
> > > 
> > > The UVC webcam gadget works fine with the user space application
> > > handling the CONTROL events and providing DATA events. Now, I wish to
> > > interface a real v4l2 device, for e.g. VIVI or more particularly a
> > > soc_camera based host and subdev pair.
> > > 
> > > Now, I see that I can achieve this by opening the UVC and V4L2 devices
> > > and doing MMAP -> REQBUF -> QBUF -> DQBUF calls on both the devices per
> > > the UVC control event received. But this will involve copying the video
> > > buffer in the user-space application from v4l2 (_CAPTURE) to uvc
> > > (_OUTPUT) domains, which will significantly reduce the video capture
> > > performance.
> > > 
> > > Is there a better solution to this issue? Maybe doing something like a
> > > RNDIS gadget does with the help of u_ether.c like helper routines. But
> > > if I remember well it also requires the BRCTL (Bridge Control Utility)
> > > in userspace to route data arriving on usb0 to eth0 and vice-versa. Not
> > > sure though, if it does copying of a skb buffer from ethernet to usb
> > > domain and vice-versa.
> > 
> > To avoid copying data between the two devices you should use USERPTR
> > instead of MMAP on at least one of the two V4L2 devices. The UVC gadget
> > driver doesn't support USERPTR yet though. This shouldn't be too difficult
> > to fix, we need toreplace the custom buffers queue implementation with
> > videobuf2, as has been done in the uvcvideo driver.
> 
> I was thinking of using the USERPTR method too, but I realized that
> currently neither UVC webcam gadget nor soc-camera subsystem supports this
> IO method. They support only MMAP IO as of now :(

Both soc-camera and the UVC gadget driver should be ported to videobuf2 to fix 
the problem.

> > I'll try to implement this. Would you then be able to test patches ?
> 
> For sure, I can test your patches on my setup.

I had a quick look, but there's a bit more work than expected. The UVC gadget 
driver locking scheme needs to be revisited. I unfortunately won't have time 
to work on that in the next couple of weeks, and very probably not before end 
of June. Sorry.

If you want to give it a try, I can provide you with some pointers.

> BTW, I was exploring GSTREAMER to use the data arriving from soc-camera
> (v4l2) capture device '/dev/video1' via 'v4l2src' plugin and routing the
> same to the UVC gadget '/dev/video0' via the 'v4l2sink' plugin.
> 
> Don't know if this can work cleanly in my setup and whether GSTREAMER
> actually performs a buffer copy internally. But I will at-least give it a
> try :)

There will definitely be a buffer copy (and actually two copies, as the UVC 
gadget driver performs a second copy internally) if you don't use USERPTR.

-- 
Regards,

Laurent Pinchart

