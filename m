Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2902 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZBNT6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 14:58:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: libv4l2 library problem
Date: Sat, 14 Feb 2009 20:57:57 +0100
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Hans de Goede <j.w.r.degoede@hhs.nl>
References: <200902131357.46279.hverkuil@xs4all.nl> <200902141511.13334.hverkuil@xs4all.nl> <20090214165808.2a54e048@pedra.chehab.org>
In-Reply-To: <20090214165808.2a54e048@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142057.57622.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 February 2009 19:58:08 Mauro Carvalho Chehab wrote:
>
> Hans and Andy,
>
> I understand that this have low priority. The only practical usage is if
> someone wants to do a better encoding for some video above the limits
> that cx2341x provides (for example, encoding with the same rate, but with
> MPEG 4, to have a higher quality).
>
> What I'm trying to say is that I don't see much value to change libv4l2
> to support read() method and HM12, since using read() method for a stream
> without a metadata doesn't work very well (sync issues, etc), but this is
> just my 2 cents.

The core issue is that libv4l2 shouldn't attempt to use mmap() with read() 
if the driver doesn't support mmap(). If that's fixed, then I'm happy. I 
think it's a simple thing for Hans to fix. If he doesn't have the time for 
that, then I can take a look as well since I'd like to get the HM12 
converter merged. It's handy for testing with qv4l2.

> With respect with ivtv-alsa and cx18-alsa, I think that, once having the
> driver ported to videobuf, it shouldn't be hard to use cx88-alsa as a
> reference for writing those drivers.
>
> About the efforts to port it, only you can evaluate it. In the case of
> em28xx, once having a videobuf driver for usb, it weren't hard to port it
> to videobuf (almost all troubles we had were related to the usage of a
> new videobuf module - videobuf-vmalloc). The resulting code worked a way
> better than the original driver and it is now easier to understand what
> it is doing at the videobuffers than what it used to be.

Just to be clear, if I would start out now creating the driver I would base 
it around videobuf. Or if we had problems with the DMA and buffering, I 
would probably choose to move to videobuf as well. But we have two stable 
drivers and no user demand to implement videobuf/alsa. Everyone uses the 
MPEG stream, and using streaming I/O to get the MPEG stream just makes no 
sense. The read() call is the natural way to access MPEG data.

Given a choice between working on the v4l2_device/v4l2_subdev conversion and 
upgrading V4L1 drivers to V4L2, or implementing videobuf/alsa in cx18/ivtv, 
then it is clear that the first is a much more important use of my time.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
