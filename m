Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36980 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZA1Fhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 00:37:35 -0500
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Wed, 28 Jan 2009 11:07:00 +0530
Subject: RE: [RFC] Adding new ioctl for transparency color keying
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02F535F1D3@dbde02.ent.ti.com>
In-Reply-To: <200901271536.32367.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, January 27, 2009 8:07 PM
> To: Shah, Hardik
> Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com
> Subject: Re: [RFC] Adding new ioctl for transparency color keying
> 
> On Tuesday 27 January 2009 15:09:34 Shah, Hardik wrote:
> > > -----Original Message-----
> > > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > > Sent: Tuesday, January 27, 2009 6:38 PM
> > > To: Shah, Hardik
> > > Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com
> > > Subject: Re: [RFC] Adding new ioctl for transparency color keying
> > >
> > > On Tuesday 27 January 2009 13:53:23 Shah, Hardik wrote:
> > > > > -----Original Message-----
> > > > > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > > > > Sent: Tuesday, January 27, 2009 3:21 PM
> > > > > To: Shah, Hardik
> > > > > Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com
> > > > > Subject: Re: [RFC] Adding new ioctl for transparency color keying
> > > > >
> > > > > Hi Hardik,
> > > > >
> > > > > On Thursday 22 January 2009 05:57:18 Shah, Hardik wrote:
> > > > > > Hi,
> > > > > > OMAP class of device supports transparency color keying.  Color
> > > > > > keying can be source color keying or destination color keying.
> > > > >
> > > > > Can it be both as well?
> > > > >
> > > > > > OMAP3 has three pipelines one graphics plane and two video
> > > > > > planes. Any of these pipelines can go to either the TV or LCD.
> > > > > >
> > > > > > The destination transparency color key value defines the encoded
> > > > > > pixels in the graphics layer to become transparent and display
> > > > > > the underlying video pixels. While the source transparency key
> > > > > > value defines the encoded pixels in the video layer to become
> > > > > > transparent and display the underlying graphics pixels.  This
> > > > > > color keying works only if the video and graphics planes are on
> > > > > > the same output like TV or LCD and images of both the pipelines
> > > > > > overlapped.
> > > > > >
> > > > > > I propose to have the one ioctl to set the encoded pixel value
> > > > > > and type of color keying source and destination.  Also we should
> > > > > > have the CID to enable/disable the color keying functionality.
> > > > > >
> > > > > > Please let us know your opinions/comments.
> > > > >
> > > > > Destination color keying is already available through the S_FBUF
> > > > > and S_FMT ioctls. Selecting source color keying can easily be added
> > > > > to S_FBUF, but setting the actual chromakey is harder. The logical
> > > > > place would be the v4l2_pix_format struct, but that is already
> > > > > full. I guess we should make a new control to set the source
> > > > > chromakey. It's not ideal, but it prevents duplicating existing
> > > > > functionality.
> > > >
> > > > [Shah, Hardik] Hi Hans,
> > > > This has nothing to do with the frame buffer.  Transparency key is a
> > > > hardware provided feature.  Driver has just to give the color code
> > > > and whether it wants the source color keying or destination color
> > > > keying. Hardware will automatically make the color code transparent
> > > > so that the below layer color will be seen. So I don't think so that
> > > > S_FBUF is suitable for this kind of feature. And this will
> > > > automatically take effect if the graphics pipeline is on the same
> > > > output device as the video pipeline.
> > >
> > > Why has this nothing to do with the framebuffer? Isn't there a /dev/fbX
> > > device for the graphics framebuffer? If there is, then it is exactly as
> > > I described: a video output overlay (aka OSD). Do not confuse this with
> > > a video overlay which is used to accelerate displaying captured video.
> > >
> > > See also:
> > >
> > > http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-
> > > single/v4l2.html#OSD
> >
> > [Shah, Hardik] Hi Hans,
> > Here the graphics node is created for the graphics pipeline. And graphics
> > pipeline will be controlled by the graphics node /dev/fbx.  Application
> > will set the desired pixel format for the /dev/fbx node and
> > /dev/v4l/videox node.  After that application can select that same output
> > device for both the nodes.  And then user may want to make transparent
> > either the color from the video pipeline of the graphics pipeline.  In
> > any case application will not require frame buffer parameters like base
> > address of the buffer as the blending/transparency processing will not be
> > done in driver.  It will be done by hardware by setting the appropriate
> > register bits.  So do you think that S_FBUF is required?   Please let me
> > know if I am missing something.    If you want I can forward you the link
> > referring to the Technical reference manual explaining the color keying
> > in hardware.
> 
> Yes, this is exactly the same as is implemented for ivtv: ivtvfb is the
> framebuffer driver for the OSD and ivtv implements G/S_FBUF to set the
> framebuffer parameters like chromakeying.
> 
> Note that the fb.h API knows nothing about video, so that cannot be used to
> set chromakeys and such. This has to be done from the V4L2 API. And the
> struct v4l2_framebuffer passed to VIDIOC_G/S_FBUF is how you do it. The
> capability field tells you what the device supports in the way of clipping
> and transparencies. The flags field lets the application select how to do
> e.g. transparency. The base field can be used in the case of OSDs to
> discover with fbX device belongs to the video device. 
[Shah, Hardik] Hi Hans,
I am not well versed with ivtv hardware but looking to the top level implementation of the ivtv driver I think both OMAP DSS and ivtv are not the same.  Let me explain the OMAP DSS in brief -

In OMAP DSS frame buffer node and v4l2 node corresponds to the different devices.  Hence the base addresses of buffers of both nodes will never going to be same.  Following is the high level diagram of the OMAP DSS with some explanation.

/dev/v4l/ video1 plane  --|-----------compositor 0--|---TV encoder|-------TV
/dev/v4l/ video2 plane  --|
/dev/fb/  grahics plane --|-----------compositor 1--|---LCD

- All of the three planes are completely independent.
- Any of the planes can be directed to any of the output devices.
- Compositor will handle the blending/keying between the pipelines and will display the final output on output device from the planes.
- Video1 and Video2 planes are controlled by the V4L2 node to set the different plane parameters like pixel format, height and width of the image and buffer handling.
- Graphics plane is controlled by fbdev node.
- Since the compositor is shared between the planes and are controlled by different nodes, some of the functionalities like the color keying needs to be controlled either by fbdev node or v4l2 node.  But since v4l2 is more suitable of color keying kind of functionality we need to add new ioctl to control this color keying.
- For OMAP, following steps are required in the hardware to accomplish the color keying which is done by compositor.

1.  Divert both video1 and graphics pipeline on the LCD compositor.
2.  Enable the transparency color keying for the LCD output by setting LCD                           	compositor register.
3.  Select either the source color key or destination color key.
4. Then set the transparency color key value in RGB format.

For more details on color keying please refer to the section 1.4.2.4.2 in below mentioned TRM. You can also have a look at the DSS block diagram in section 1.4.2.

http://focus.ti.com/lit/ug/sprufa4a/sprufa4a.pdf


We can discuss this further on irc chat.  I will be online in few minutes.  Just ping me.

Regards,
Hardik Shah





Section 4.4.2 in the
> V4L2 spec shows how to do that. And finally the fmt field will tell you how
> the framebuffer is organized.
> 
> Through VIDIOC_S_FMT and struct v4l2_window you can set the chromakey and
> other clipping/transparency data. So through VIDIOC_S_FBUF you select the
> type of chromakeying and through VIDIOC_S_FMT you actually set the
> chromakey. Except that we currently have no way to set the source
> chromakey, that's missing in the API. Everything else is there already.
> 
> And these ioctls are all for hardware transparency processing, the
> implementation in the driver is always to set the various hardware
> registers according to the arguments.
> 
> Regards,
> 
> 	Hans
> 
> >
> > Regards,
> > Hardik Shah
> >
> > > Regards,
> > >
> > >       Hans
> > >
> > > --
> > > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> 
> 
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

