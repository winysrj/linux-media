Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17960 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1EWLzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:55:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=utf-8
Date: Mon, 23 May 2011 13:55:21 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC] Standardize YUV support in the fbdev API
In-reply-to: <201105180853.33850.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Felipe Contreras' <felipe.contreras@gmail.com>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Message-id: <000601cc1940$4b2e2b20$e18a8160$%szyprowski@samsung.com>
Content-language: pl
References: <201105180007.21173.laurent.pinchart@ideasonboard.com>
 <BANLkTi=mRYkJL-R63K+pvZGvtetJo3oJaQ@mail.gmail.com>
 <201105180853.33850.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, May 18, 2011 8:54 AM Hans Verkuil wrote:

> On Wednesday, May 18, 2011 00:44:26 Felipe Contreras wrote:
> > On Wed, May 18, 2011 at 1:07 AM, Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:
> > > I need to implement support for a YUV frame buffer in an fbdev driver.
> As the
> > > fbdev API doesn't support this out of the box, I've spent a couple of
> days
> > > reading fbdev (and KMS) code and thinking about how we could cleanly
> add YUV
> > > support to the API. I'd like to share my findings and thoughts, and
> hopefully
> > > receive some comments back.
> > >
> > > The terms 'format', 'pixel format', 'frame buffer format' and 'data
> format'
> > > will be used interchangeably in this e-mail. They all refer to the way
> pixels
> > > are stored in memory, including both the representation of a pixel as
> integer
> > > values and the layout of those integer values in memory.
> >
> > This is a great proposal. It was about time!
> >
> > > The third solution has my preference. Comments and feedback will be
> > > appreciated. I will then work on a proof of concept and submit patches.
> >
> > I also would prefer the third solution. I don't think there's much
> > difference from the user-space point of view, and a new ioctl would be
> > cleaner. Also the v4l2 fourcc's should do.
> 
> I agree with this.
> 
> We might want to take the opportunity to fix this section of the V4L2 Spec:
> 
> http://www.xs4all.nl/~hverkuil/spec/media.html#pixfmt-rgb
> 
> There are two tables, 2.6 and 2.7. But 2.6 is almost certainly wrong and
> should be removed.

That's definitely true. I was confused at the beginning when I saw 2
different tables describing the same pixel formats.

 I suspect many if not all V4L2 drivers are badly broken for
> big-endian systems and report the wrong pixel formats.
> 
> Officially the pixel formats reflect the contents of the memory. But
> everything is swapped on a big endian system, so you are supposed to 
> report a different pix format.

I always thought that pix_format describes the layout of video data in
memory on byte level, which is exactly the same on both little- and big-
endian systems. You can notice swapped data only if you access memory
by units larger than byte, like 16bit or 32bit integers. BTW - I would
really like to avoid little- and big- endian flame, but your statement
about 'everything is swapped on a big endian system' is completely
wrong. It is rather the characteristic of little-endian system not big
endian one if you display the content of the same memory first using
byte access and then using word/long access.

> I can't remember seeing any driver do that. Some have built-in swapping,
> though, and turn that on if needed.

The drivers shouldn't do ANY byte swapping at all. Only tools that
extract pixel data with some 'accelerated' methods (like 32bit integer
casting and bit-level shifting) should be aware of endianess.

> I really need to run some tests, but I've been telling myself this for
> years now :-(

I've checked the BTTV board in my PowerMac/G4 and the display was
correct with xawtv. It is just a matter of selecting correct pix format
basing on the information returned by xsever. 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


