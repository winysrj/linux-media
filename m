Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:40053 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107Ab2D3DgJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 23:36:09 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Date: Mon, 30 Apr 2012 11:34:09 +0800
Subject: RE: Using UVC webcam gadget with a real v4l2 device
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA44462B0@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com>
 <111268324.hD9BSZaXPY@avalon>
 <D5ECB3C7A6F99444980976A8C6D896384FA44457A9@EAPEX1MAIL1.st.com>
 <4085740.9DbpdWgfF6@avalon>  
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Bhupesh SHARMA
> Sent: Thursday, April 26, 2012 10:54 AM
> To: 'Laurent Pinchart'
> Cc: 'linux-usb@vger.kernel.org'; 'linux-media@vger.kernel.org';
> 'balbi@ti.com'; 'g.liakhovetski@gmx.de'
> Subject: RE: Using UVC webcam gadget with a real v4l2 device
> 
> Hi Laurent,
> 
> Sorry to jump-in before your reply on my previous mail,
> but as I was studying the USERPTR stuff in more detail, I have a few
> more
> queries which I believe you can include in your reply as well..
> 
> > -----Original Message-----
> > From: Bhupesh SHARMA
> > Sent: Wednesday, April 25, 2012 8:37 PM
> > To: 'Laurent Pinchart'
> > Cc: linux-usb@vger.kernel.org; linux-media@vger.kernel.org;
> > balbi@ti.com; g.liakhovetski@gmx.de
> > Subject: RE: Using UVC webcam gadget with a real v4l2 device
> >
> > Hi Laurent,
> >
> > > -----Original Message-----
> > > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > > Sent: Tuesday, April 24, 2012 2:26 AM
> > > To: Bhupesh SHARMA
> > > Cc: linux-usb@vger.kernel.org; linux-media@vger.kernel.org;
> > > balbi@ti.com; g.liakhovetski@gmx.de
> > > Subject: Re: Using UVC webcam gadget with a real v4l2 device
> > >
> > > Hi Bhupesh,
> > >
> > > On Tuesday 24 April 2012 02:46:22 Bhupesh SHARMA wrote:
> > > > On Monday, April 23, 2012 7:47 PM Laurent Pinchart wrote:
> > > > > On Monday 23 April 2012 02:24:53 Bhupesh SHARMA wrote:
> > > > > > Hi Laurent,
> > > > > >
> > > > > > I have been doing some experimentation with the UVC webcam
> > gadget
> > > along
> > > > > > with the UVC user-space application which you have written.
> > > > > >
> > > > > > The UVC webcam gadget works fine with the user space
> > application
> > > > > > handling the CONTROL events and providing DATA events. Now, I
> > > wish to
> > > > > > interface a real v4l2 device, for e.g. VIVI or more
> > particularly
> > > a
> > > > > > soc_camera based host and subdev pair.
> > > > > >
> > > > > > Now, I see that I can achieve this by opening the UVC and
> V4L2
> > > devices
> > > > > > and doing MMAP -> REQBUF -> QBUF -> DQBUF calls on both the
> > > devices per
> > > > > > the UVC control event received. But this will involve copying
> > the
> > > video
> > > > > > buffer in the user-space application from v4l2 (_CAPTURE) to
> > uvc
> > > > > > (_OUTPUT) domains, which will significantly reduce the video
> > > capture
> > > > > > performance.
> > > > > >
> > > > > > Is there a better solution to this issue? Maybe doing
> something
> > > like a
> > > > > > RNDIS gadget does with the help of u_ether.c like helper
> > > routines. But
> > > > > > if I remember well it also requires the BRCTL (Bridge Control
> > > Utility)
> > > > > > in userspace to route data arriving on usb0 to eth0 and vice-
> > > versa. Not
> > > > > > sure though, if it does copying of a skb buffer from ethernet
> > to
> > > usb
> > > > > > domain and vice-versa.
> > > > >
> > > > > To avoid copying data between the two devices you should use
> > > USERPTR
> > > > > instead of MMAP on at least one of the two V4L2 devices. The
> UVC
> > > gadget
> > > > > driver doesn't support USERPTR yet though. This shouldn't be
> too
> > > difficult
> > > > > to fix, we need toreplace the custom buffers queue
> implementation
> > > with
> > > > > videobuf2, as has been done in the uvcvideo driver.
> > > >
> > > > I was thinking of using the USERPTR method too, but I realized
> that
> > > > currently neither UVC webcam gadget nor soc-camera subsystem
> > supports
> > > this
> > > > IO method. They support only MMAP IO as of now :(
> > >
> > > Both soc-camera and the UVC gadget driver should be ported to
> > videobuf2
> > > to fix
> > > the problem.
> 
> I am now a bit confused on how the entire system will work now:
> 	- Does USERPTR method needs to be supported both in UVC gadget
> and soc-camera side,
> 	  or one can still support the MMAP method and the other can now
> be changed to support USERPTR method
> 	  and we can achieve a ZERO buffer copy operation using this
> method?
> 
> 	- More specifically, I would like to keep the soc-camera still
> using MMAP (and hence still using video-buf)
> 	  and make changes at the UVC gadget side to support USERPTR and
> videobuf2. Will this work?
> 
> 	- At the application side how should we design the flow in case
> both support USERPTR, i.e. the buffer needs
> 	  to be protected from simultaneous access from the UVC gadget
> driver and soc-camera driver (to ensure that
> 	  a single buffer can be shared across them). Also in case we
> keep soc-camera still using MMAP and UVC gadget
> 	  side supporting USERPTR, how can we share a common buffer
> across the UVC gadget and soc-camera driver.
> 
> 	- In case of USERPTR method the camera capture hardware should be
> able to DMA the received data to the user
> 	  space buffers. Are there any specific requirements on the DMA
> capability of these use-space buffers
> 	  (scatter-gather or contiguous?).


Can you help me with these queries.

Thanks,
Bhupesh
 
> Regards,
> Bhupesh
> 
> > > > > I'll try to implement this. Would you then be able to test
> > patches
> > > ?
> > > >
> > > > For sure, I can test your patches on my setup.
> > >
> > > I had a quick look, but there's a bit more work than expected. The
> > UVC
> > > gadget
> > > driver locking scheme needs to be revisited. I unfortunately won't
> > have
> > > time
> > > to work on that in the next couple of weeks, and very probably not
> > > before end
> > > of June. Sorry.
> >
> > > If you want to give it a try, I can provide you with some pointers.
> >
> > It's  a pity. You are the best person to do it as you have in-depth
> > know
> > -how of both v4l2 and UVC webcam gadget. But I can give it a try if
> you
> > can provide me some pointers..
> >
> >
> > > > BTW, I was exploring GSTREAMER to use the data arriving from soc-
> > > camera
> > > > (v4l2) capture device '/dev/video1' via 'v4l2src' plugin and
> > routing
> > > the
> > > > same to the UVC gadget '/dev/video0' via the 'v4l2sink' plugin.
> > > >
> > > > Don't know if this can work cleanly in my setup and whether
> > GSTREAMER
> > > > actually performs a buffer copy internally. But I will at-least
> > give
> > > it a
> > > > try :)
> > >
> > > There will definitely be a buffer copy (and actually two copies, as
> > the
> > > UVC
> > > gadget driver performs a second copy internally) if you don't use
> > > USERPTR.
> >
> > That's what I was afraid of. But can you let me know where the gadget
> > driver
> > performs a second copy internally, so that I can also start exploring
> > the
> > USERPTR method using the pointers provided by you..
> >
> > Regards,
> > Bhupesh
