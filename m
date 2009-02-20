Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:55097 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZBTLHv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 06:07:51 -0500
Date: Fri, 20 Feb 2009 12:04:00 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Linux Media" <linux-media@vger.kernel.org>
Subject: Re: Questions about VIDIOC_G_JPEGCOMP / VIDIOC_S_JPEGCOMP
Message-ID: <20090220120400.3d797cc4@free.fr>
In-Reply-To: <200902200929.36974.hverkuil@xs4all.nl>
References: <14759.62.70.2.252.1235052151.squirrel@webmail.xs4all.nl>
	<200902200929.36974.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Feb 2009 09:29:36 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > Support for these ioctls should be added to v4l2-ctl.cpp. It's the
> > right place for that.
> >
> > But more important is to document these ioctls in the v4l2 spec. As
> > far as I can tell these ioctls came from the zoran driver where
> > basically a private ioctl was elevated to a public ioctl, but with
> > little or no review.
> >
> > Do you know enough about these ioctls to update the v4l2 spec? That
> > would be a great help. 
> 
> I'm working on the zoran driver anyway, so I'll document this and add 
> support to v4l2-ctl. I now understand what this is about. The COM and
> APP markers are either obsolete or are meant as a read-only property.
> And while it is possible theoretically to set multiple APP segments,
> it is impossible with the current API to ever read more than one
> back. Sigh.

Hi Hans,

I see three parts in these ioctls:
- quality,
- definition of the APP and COM markers,
- presence / absence of some JPEG fields (quantization, Huffman..)

Looking at the video tree, the quality is treated by 5 drivers:
- in cpia2, the quality is not settable and defaults to 80 (%),
- in zc0301, the quality may be only set to 0,
- in et61x251 and sn9c102, the quality may be set to 0 or 1,
- in zoran, the quality may be set from 5% to 100%, but it is used only
  to compute the max size of the images!

I don't see the usage of APP or COM markers. Such fields may be added
by the applications. Actually, only the zoran and cpia2 drivers treat
them.

About the presence / absence of the JPEG fields, it is simpler to have
all the required fields in the JPEG image. If some field is lacking, it
should be added at conversion time by the v4l library or added by the
driver if video output. The fact the ioctl permits the control of these
fields obliges the drivers (input) or the applications (output) to know
how to add (or remove) the fields. It seems a complex treatment for a
small benefit: reduce the size of images by 100 or 200 bytes. Actually,
only the zoran and cpia2 drivers treat these controls.

So, I propose to remove these ioctls, and to add two controls: one to
set the JPEG quality (range 15..95 %) and the other to set a webcam
quality which might be a boolean or any value depending on some
associated webcam parameter.

What do you think of it?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
