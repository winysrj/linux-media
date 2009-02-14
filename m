Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2841 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZBNJIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 04:08:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: libv4l2 library problem
Date: Sat, 14 Feb 2009 10:08:31 +0100
Cc: linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>
References: <200902131357.46279.hverkuil@xs4all.nl> <20090214065206.1a9494d9@pedra.chehab.org>
In-Reply-To: <20090214065206.1a9494d9@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902141008.31748.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 February 2009 09:52:06 Mauro Carvalho Chehab wrote:
> On Fri, 13 Feb 2009 13:57:45 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Hans,
> >
> > I've developed a converter for the HM12 format (produced by Conexant
> > MPEG encoders as used in the ivtv and cx18 drivers).
> >
> > But libv4l2 has a problem in its implementation of v4l2_read: it
> > assumes that the driver can always do streaming. However, that is not
> > the case for some drivers, including cx18 and ivtv. These drivers only
> > implement read() functionality and no streaming.
> >
> > Can you as a minimum modify libv4l2 so that it will check for this
> > case? The best solution would be that libv4l2 can read HM12 from the
> > driver and convert it on the fly. But currently it tries to convert
> > HM12 by starting to stream, and that produces an error.
> >
> > This bug needs to be fixed first before I can contribute my HM12
> > converter.
>
> Hans Verkuil,
>
> I think it would be valuable if you could convert the drivers to use
> videobuf. There's currently a videobuf variation for devices that don't
> support scatter/gather dma transfers. By using videobuf, the mmap()
> methods (and also overlay, if you want) will be supported.

It's been on my todo list for ages, but I don't see it happening anytime 
soon. It will be difficult to do and the simple fact of the matter is that 
the read() interface is much more suitable for MPEG streams than mmap, and 
almost nobody is using the raw video streams where mmap would make sense.

The only reason for doing this would be to make the driver consistent with 
the other drivers in V4L2. Which is a valid argument, but as long as we 
still have V4L1 drivers to convert I'd argue that this is definitely a low 
prio task.

BTW, it would help if someone would actually document videobuf. 
Documentation should be much more important than it currently is.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
