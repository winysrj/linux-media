Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50495 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab1B0Vav (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 16:30:51 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1RLUnja030044
	for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 21:30:49 GMT
Subject: Mulling over multi-planar formats and videobuf2 for cx18
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 16:31:09 -0500
Message-ID: <1298842269.2405.71.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

So I've been looking into converting cx18 to videobuf2 for about a day.
Overall I think I can make it work.  I might not be able to take full
advantage of some things.  

I've encountered these design challenges already:

1. Supporting V4L2_MPEG_STREAM_VBI_FMT_IVTV 

http://linuxtv.org/downloads/v4l-dvb-apis/sliced.html#id2811930

is going to be a hassle, if not impossible, in a single-planar format
without copying buffers and losing the benefit of zero-copy.

2. A new technique for detecting missed buffer notifications from the
CX23418 is needed.  The old technique I used won't work, since it relies
on buffer allocations not being very dynamic at all.

3. When staring an MPEG capture, the cx18 and ivtv driver can
automatically start associated metadata or data streams: MPEG Index
and/or Sliced VBI.  Unfortunately the CX23418 engine generally DMAs
these buffers at different rates, so they are not in lock-step.  To take
adavantage of the multiplanar support in vb2 (which is nice, BTW), I can
only use zero-copy for the primary capture stream.

4.  When starting up one of the associated data or metadata streams, the
cx18 driver will likely need to use a vb2 queue internally and not hook
it to any particular device node in user space.  I still need to
investigate if this is possible; I think it should be.


So I have some questions

1. Do we have any mulitplanar FourCCs defined yet?

2. Would an MPEG multiplanar format with these planes be acceptable?

	MPEG
	MPEG Index
	MPEG Private packets (holding struct v4l2_mpeg_vbi_fmt_ivtv)

3. Is a multiplanar format for a particular FourCC envisionsed to always
have all of its metadata planes present?  For example, what about the
above with the "MPEG Index" absent:

	MPEG
	MPEG Private packets (holding struct v4l2_mpeg_vbi_fmt_ivtv)

or

	MPEG
	MPEG Index
	Sliced VBI (struct v4l2_sliced_vbi_data)

or

	MPEG
	Sliced VBI (struct v4l2_sliced_vbi_data)

Instead of having a separate FourCC for each permutaion, would it make
sense for a plane format be added to struct v4l2_plane_pix_format?


3.  I have some additional ideas for some multiplanar formats

	HM12
	Sliced VBI  (struct v4l2_sliced_vbi_data)

	HM12
	Raw VBI

	UYVY
	Sliced VBI  (struct v4l2_sliced_vbi_data)
	
	UYVY   
	Raw VBI

(The CX23418 can actually produce UYVY in hardware, unlike the
CX23415/6.)

These multiplanar image/data formats can certainly help applications
keep Video and VBI synchronized.

Would this sort of thing be acceptable?    The same question about
FourCC's for each permutation applies.

Such multiplanar image/data formats somewhat obviate the need to use the
seperate V4L2 device node for VBI when capturing video.  [I'd throw a
PCM audio data plane in there too, if I though I could get away with
it. ;) ]

Regards,
Andy

