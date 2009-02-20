Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1071 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbZBTI33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 03:29:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: Questions about VIDIOC_G_JPEGCOMP / VIDIOC_S_JPEGCOMP
Date: Fri, 20 Feb 2009 09:29:36 +0100
Cc: "Linux Media" <linux-media@vger.kernel.org>
References: <14759.62.70.2.252.1235052151.squirrel@webmail.xs4all.nl>
In-Reply-To: <14759.62.70.2.252.1235052151.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902200929.36974.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 19 February 2009 15:02:31 Hans Verkuil wrote:
> > Hi,
> >
> > The VIDIOC_G_JPEGCOMP / VIDIOC_S_JPEGCOMP v4l2 ioctls seem not to be
> > used by many drivers / applications. They should!
>
> Unfortunately, these ioctls are completely undocumented. Which might be
> the reason why they aren't used :-)
>
> > In some ms-win traces, there are automatic and dynamic adjustments of
> > the JPEG quality according to... who knows?
> >
> > Also, most webcams do not include the quantization tables in the
> > images. Then, (in gspca), these tables are added by the subdrivers with
> > a quality defined by the testers and according to their taste.
> >
> > As I understand, the JPEGCOMP ioctls permit to set the JPEG quality and
> > to define the content of the JPEG frames.
> >
> > If I implement these controls in gspca:
> >
> > - by default, I could not add the quantization and Huffman tables in
> > the image frames,
> >
> > - the quality could be set dynamically, this value being used to load
> >   the quantization tables in the webcam and also to convert the images.
> >
> > The questions are:
> >
> > 1) May the driver refuse to set some values on VIDIOC_S_JPEGCOMP?
> >    For example, if it cannot add the Huffman table in the frames.
>
> You will have to check what the existing practice is. How to other
> drivers handle this?
>
> > 2) Will the VIDIOC_G_JPEGCOMP ioctl be used by the v4l library (for
> >    conversion purpose)?
> >
> > 3) Does anybody know a command line or X application which may get/set
> >    these JPEG parameters?
>
> Support for these ioctls should be added to v4l2-ctl.cpp. It's the right
> place for that.
>
> But more important is to document these ioctls in the v4l2 spec. As far
> as I can tell these ioctls came from the zoran driver where basically a
> private ioctl was elevated to a public ioctl, but with little or no
> review.
>
> Do you know enough about these ioctls to update the v4l2 spec? That would
> be a great help.
>
> Regards,
>
>         Hans

I'm working on the zoran driver anyway, so I'll document this and add 
support to v4l2-ctl. I now understand what this is about. The COM and APP 
markers are either obsolete or are meant as a read-only property. And while 
it is possible theoretically to set multiple APP segments, it is impossible 
with the current API to ever read more than one back. Sigh.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
