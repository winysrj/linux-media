Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54323 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbZBNU0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 15:26:32 -0500
Subject: Re: libv4l2 library problem
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>
In-Reply-To: <200902141511.13334.hverkuil@xs4all.nl>
References: <200902131357.46279.hverkuil@xs4all.nl>
	 <200902141206.28036.hverkuil@xs4all.nl>
	 <1234620314.3073.28.camel@palomino.walls.org>
	 <200902141511.13334.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 15:26:28 -0500
Message-Id: <1234643188.12473.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-02-14 at 15:11 +0100, Hans Verkuil wrote:
> On Saturday 14 February 2009 15:05:14 Andy Walls wrote:
> > On Sat, 2009-02-14 at 12:06 +0100, Hans Verkuil wrote:
> > > On Saturday 14 February 2009 11:32:06 Mauro Carvalho Chehab wrote:
> > > > On Sat, 14 Feb 2009 10:08:31 +0100
> > > >
> > > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > > On Saturday 14 February 2009 09:52:06 Mauro Carvalho Chehab wrote:

> 
> It's a macroblock format where all Y and UV bytes are organized in 8x8 
> blocks. I believe it is a by-product of the MPEG encoding process that is 
> made available by the firmware as a bonus feature. It is clearly meant as 
> the source format for the actual MPEG encoder. Pretty much specific to the 
> cx2341x devices.

That's interesting.  I guess,it's a useful thing to have, if I were
working on a software implementation of an MPEG (not MPEG-2) or MJPEG
encoder, or something else that did DCT or Wavelet Transforms on
macroblocks.

I was also musing that the "raw VBI" capture of the chip's API could be
abused to extract the entire active raster of UYVY samples for each
frame (first field followed by second field).  It even sends a per frame
PTS with this raw raster data.  But there's lot of pain with that:
wasted bus bandwidth, stripping out all the SAV sequences, and, not
surprisingly, the cx18 driver is not structured top provide a video
capture stream via the VBI streams. ;)

Regards,
Andy

> Regards,
> 
> 	Hans


