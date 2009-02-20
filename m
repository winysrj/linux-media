Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1910 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbZBTSm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 13:42:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Questions about VIDIOC_G_JPEGCOMP / VIDIOC_S_JPEGCOMP
Date: Fri, 20 Feb 2009 19:43:04 +0100
Cc: "Linux Media" <linux-media@vger.kernel.org>
References: <14759.62.70.2.252.1235052151.squirrel@webmail.xs4all.nl> <200902200929.36974.hverkuil@xs4all.nl> <20090220120400.3d797cc4@free.fr>
In-Reply-To: <20090220120400.3d797cc4@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902201943.04525.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 20 February 2009 12:04:00 Jean-Francois Moine wrote:
> On Fri, 20 Feb 2009 09:29:36 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > Support for these ioctls should be added to v4l2-ctl.cpp. It's the
> > > right place for that.
> > >
> > > But more important is to document these ioctls in the v4l2 spec. As
> > > far as I can tell these ioctls came from the zoran driver where
> > > basically a private ioctl was elevated to a public ioctl, but with
> > > little or no review.
> > >
> > > Do you know enough about these ioctls to update the v4l2 spec? That
> > > would be a great help.
> >
> > I'm working on the zoran driver anyway, so I'll document this and add
> > support to v4l2-ctl. I now understand what this is about. The COM and
> > APP markers are either obsolete or are meant as a read-only property.
> > And while it is possible theoretically to set multiple APP segments,
> > it is impossible with the current API to ever read more than one
> > back. Sigh.
>
> Hi Hans,
>
> I see three parts in these ioctls:
> - quality,
> - definition of the APP and COM markers,
> - presence / absence of some JPEG fields (quantization, Huffman..)
>
> Looking at the video tree, the quality is treated by 5 drivers:
> - in cpia2, the quality is not settable and defaults to 80 (%),
> - in zc0301, the quality may be only set to 0,
> - in et61x251 and sn9c102, the quality may be set to 0 or 1,
> - in zoran, the quality may be set from 5% to 100%, but it is used only
>   to compute the max size of the images!
>
> I don't see the usage of APP or COM markers. Such fields may be added
> by the applications. Actually, only the zoran and cpia2 drivers treat
> them.
>
> About the presence / absence of the JPEG fields, it is simpler to have
> all the required fields in the JPEG image. If some field is lacking, it
> should be added at conversion time by the v4l library or added by the
> driver if video output. The fact the ioctl permits the control of these
> fields obliges the drivers (input) or the applications (output) to know
> how to add (or remove) the fields. It seems a complex treatment for a
> small benefit: reduce the size of images by 100 or 200 bytes. Actually,
> only the zoran and cpia2 drivers treat these controls.
>
> So, I propose to remove these ioctls, and to add two controls: one to
> set the JPEG quality (range 15..95 %) and the other to set a webcam
> quality which might be a boolean or any value depending on some
> associated webcam parameter.
>
> What do you think of it?

I have my doubts about actually removing these ioctls. I was thinking more 
along the lines of refining them. The quality field is currently utterly 
useless, so my idea was to make it a value in the range of 0-100, which the 
driver will convert to whatever it supports. And yes, I know 0 and 100 are 
impossible values, but since drivers currently support values in that range 
I think we should keep that.

The jpeg_markers field should probably be obsoleted: i.e. drivers return 0 
and ignore and set values. I agree that there is little point in that 
field.

The APP and COM part, however, probably cannot be removed. I see no reason 
why we should burden apps with hacking the MJPEG stream to add these 
fields. And if the driver doesn't reserve space for them, then that's 
pretty much impossible. Especially the COM part might be useful.

It would be nice to have the driver report whether APPn and COM is 
supported: we might be able to use field_markers for that by creating new 
capability bits for this.

Adding a webcam quality control is fine by me, provided it is mutually 
exclusive with the VIDIOC_S_JPEGCOMP. Otherwise it gets really confusing 
(or more that it already is).

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
