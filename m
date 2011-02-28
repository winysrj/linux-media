Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46777 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1B1Dw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 22:52:29 -0500
Received: by vxi39 with SMTP id 39so2813479vxi.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 19:52:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298842269.2405.71.camel@localhost>
References: <1298842269.2405.71.camel@localhost>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 27 Feb 2011 19:52:08 -0800
Message-ID: <AANLkTin5rscWm68PYht3R+=LFayxS9Tkf4y9avJgy4vU@mail.gmail.com>
Subject: Re: Mulling over multi-planar formats and videobuf2 for cx18
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andy,

On Sun, Feb 27, 2011 at 13:31, Andy Walls <awalls@md.metrocast.net> wrote:
> Hi all,
>
> So I've been looking into converting cx18 to videobuf2 for about a day.
> Overall I think I can make it work.  I might not be able to take full
> advantage of some things.
>
> I've encountered these design challenges already:
>
> 1. Supporting V4L2_MPEG_STREAM_VBI_FMT_IVTV
>
> http://linuxtv.org/downloads/v4l-dvb-apis/sliced.html#id2811930
>
> is going to be a hassle, if not impossible, in a single-planar format
> without copying buffers and losing the benefit of zero-copy.
>
> 2. A new technique for detecting missed buffer notifications from the
> CX23418 is needed.  The old technique I used won't work, since it relies
> on buffer allocations not being very dynamic at all.
>
> 3. When staring an MPEG capture, the cx18 and ivtv driver can
> automatically start associated metadata or data streams: MPEG Index
> and/or Sliced VBI.  Unfortunately the CX23418 engine generally DMAs
> these buffers at different rates, so they are not in lock-step.  To take
> adavantage of the multiplanar support in vb2 (which is nice, BTW), I can
> only use zero-copy for the primary capture stream.
>
> 4.  When starting up one of the associated data or metadata streams, the
> cx18 driver will likely need to use a vb2 queue internally and not hook
> it to any particular device node in user space.  I still need to
> investigate if this is possible; I think it should be.
>
>
> So I have some questions
>
> 1. Do we have any mulitplanar FourCCs defined yet?
>

Yes, we have 3 of them for, currently used in the s5p-fimc driver:

+/* two non contiguous planes - one Y, one Cr + Cb interleaved  */
+#define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12
Y/CbCr 4:2:0  */
+#define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12
Y/CbCr 4:2:0 64x32 macroblocks */
+
+/* three non contiguous planes - Y, Cb, Cr */
+#define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12
YUV420 planar */
+

> 2. Would an MPEG multiplanar format with these planes be acceptable?
>
>        MPEG
>        MPEG Index
>        MPEG Private packets (holding struct v4l2_mpeg_vbi_fmt_ivtv)
>

Definitely, that's another use for multi-planar formats that Hans
envisioned a year ago, i.e. use planes for not only video data, but
other (meta-)data as well.

> 3. Is a multiplanar format for a particular FourCC envisionsed to always
> have all of its metadata planes present?

This is the next step in the multi-planar extensions: having mandatory
number of planes in each buffer and allowing optional planes to be
passed along with them when needed. The current format could indicate
the obligatory number of planes, while the buffers passed to
qbuf/dqbuf could occasionally have additional planes in them by
increasing buf->length value and adding additional pointers in the
planes array. As long as the driver or an application could identify
those additional planes, they would use them, otherwise they could
safely ignore them.

> For example, what about the above with the "MPEG Index" absent:
>
>        MPEG
>        MPEG Private packets (holding struct v4l2_mpeg_vbi_fmt_ivtv)
>
> or
>
>        MPEG
>        MPEG Index
>        Sliced VBI (struct v4l2_sliced_vbi_data)
>
> or
>
>        MPEG
>        Sliced VBI (struct v4l2_sliced_vbi_data)
>
> Instead of having a separate FourCC for each permutaion, would it make
> sense for a plane format be added to struct v4l2_plane_pix_format?

Definitely. We need to design something that would be universal enough though.

>
> 3.  I have some additional ideas for some multiplanar formats
>
>        HM12
>        Sliced VBI  (struct v4l2_sliced_vbi_data)
>
>        HM12
>        Raw VBI
>
>        UYVY
>        Sliced VBI  (struct v4l2_sliced_vbi_data)
>
>        UYVY
>        Raw VBI
>
> (The CX23418 can actually produce UYVY in hardware, unlike the
> CX23415/6.)
>
> These multiplanar image/data formats can certainly help applications
> keep Video and VBI synchronized.
>
> Would this sort of thing be acceptable?    The same question about
> FourCC's for each permutation applies.
>
> Such multiplanar image/data formats somewhat obviate the need to use the
> seperate V4L2 device node for VBI when capturing video.  [I'd throw a
> PCM audio data plane in there too, if I though I could get away with
> it. ;) ]

Those are all good ideas. It'd be great if we could do some more
brainstorming, gather requirements for different devices and come up
with an universal solution.

-- 
Best regards,
Pawel Osciak
