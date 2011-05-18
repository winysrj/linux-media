Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3556 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1ERGxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 02:53:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [RFC] Standardize YUV support in the fbdev API
Date: Wed, 18 May 2011 08:53:33 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <201105180007.21173.laurent.pinchart@ideasonboard.com> <BANLkTi=mRYkJL-R63K+pvZGvtetJo3oJaQ@mail.gmail.com>
In-Reply-To: <BANLkTi=mRYkJL-R63K+pvZGvtetJo3oJaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180853.33850.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, May 18, 2011 00:44:26 Felipe Contreras wrote:
> On Wed, May 18, 2011 at 1:07 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > I need to implement support for a YUV frame buffer in an fbdev driver. As the
> > fbdev API doesn't support this out of the box, I've spent a couple of days
> > reading fbdev (and KMS) code and thinking about how we could cleanly add YUV
> > support to the API. I'd like to share my findings and thoughts, and hopefully
> > receive some comments back.
> >
> > The terms 'format', 'pixel format', 'frame buffer format' and 'data format'
> > will be used interchangeably in this e-mail. They all refer to the way pixels
> > are stored in memory, including both the representation of a pixel as integer
> > values and the layout of those integer values in memory.
> 
> This is a great proposal. It was about time!
> 
> > The third solution has my preference. Comments and feedback will be
> > appreciated. I will then work on a proof of concept and submit patches.
> 
> I also would prefer the third solution. I don't think there's much
> difference from the user-space point of view, and a new ioctl would be
> cleaner. Also the v4l2 fourcc's should do.

I agree with this.

We might want to take the opportunity to fix this section of the V4L2 Spec:

http://www.xs4all.nl/~hverkuil/spec/media.html#pixfmt-rgb

There are two tables, 2.6 and 2.7. But 2.6 is almost certainly wrong and should
be removed. I suspect many if not all V4L2 drivers are badly broken for
big-endian systems and report the wrong pixel formats.

Officially the pixel formats reflect the contents of the memory. But everything
is swapped on a big endian system, so you are supposed to report a different
pix format. I can't remember seeing any driver do that. Some have built-in
swapping, though, and turn that on if needed.

I really need to run some tests, but I've been telling myself this for years
now :-(

Regards,

	Hans
