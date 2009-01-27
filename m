Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2973 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbZA0NIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 08:08:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Shah, Hardik" <hardik.shah@ti.com>
Subject: Re: [RFC] Adding new ioctl for transparency color keying
Date: Tue, 27 Jan 2009 14:08:29 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EFD9@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EFD9@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271408.29605.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 27 January 2009 13:53:23 Shah, Hardik wrote:
> > -----Original Message-----
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Sent: Tuesday, January 27, 2009 3:21 PM
> > To: Shah, Hardik
> > Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com
> > Subject: Re: [RFC] Adding new ioctl for transparency color keying
> >
> > Hi Hardik,
> >
> > On Thursday 22 January 2009 05:57:18 Shah, Hardik wrote:
> > > Hi,
> > > OMAP class of device supports transparency color keying.  Color
> > > keying can be source color keying or destination color keying.
> >
> > Can it be both as well?
> >
> > > OMAP3 has three pipelines one graphics plane and two video planes. 
> > > Any of these pipelines can go to either the TV or LCD.
> > >
> > > The destination transparency color key value defines the encoded
> > > pixels in the graphics layer to become transparent and display the
> > > underlying video pixels. While the source transparency key value
> > > defines the encoded pixels in the video layer to become transparent
> > > and display the underlying graphics pixels.  This color keying works
> > > only if the video and graphics planes are on the same output like TV
> > > or LCD and images of both the pipelines overlapped.
> > >
> > > I propose to have the one ioctl to set the encoded pixel value and
> > > type of color keying source and destination.  Also we should have the
> > > CID to enable/disable the color keying functionality.
> > >
> > > Please let us know your opinions/comments.
> >
> > Destination color keying is already available through the S_FBUF and
> > S_FMT ioctls. Selecting source color keying can easily be added to
> > S_FBUF, but setting the actual chromakey is harder. The logical place
> > would be the v4l2_pix_format struct, but that is already full. I guess
> > we should make a new control to set the source chromakey. It's not
> > ideal, but it prevents duplicating existing functionality.
>
> [Shah, Hardik] Hi Hans,
> This has nothing to do with the frame buffer.  Transparency key is a
> hardware provided feature.  Driver has just to give the color code and
> whether it wants the source color keying or destination color keying. 
> Hardware will automatically make the color code transparent so that the
> below layer color will be seen. So I don't think so that S_FBUF is
> suitable for this kind of feature. And this will automatically take
> effect if the graphics pipeline is on the same output device as the video
> pipeline.

Why has this nothing to do with the framebuffer? Isn't there a /dev/fbX 
device for the graphics framebuffer? If there is, then it is exactly as I 
described: a video output overlay (aka OSD). Do not confuse this with a 
video overlay which is used to accelerate displaying captured video.

See also:
 
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#OSD

Regards,

      Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
