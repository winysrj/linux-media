Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZHPX3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Aug 2009 19:29:54 -0400
Date: Sun, 16 Aug 2009 20:29:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Document libv4l at V4L2 API specs
Message-ID: <20090816202949.436c49ca@caramujo.chehab.org>
In-Reply-To: <200908160942.20256.hverkuil@xs4all.nl>
References: <20090815163726.5f4bae41@caramujo.chehab.org>
	<200908160942.20256.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Sun, 16 Aug 2009 09:42:20 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> I've done a quick review of the text. See comments below.

Thank you for the review! I've addressed your points. I'll commit it. Later, it
can improved as needed.

> > +		<para>libv4lconvert/processing offers the actual video
> > +processing functionality.</para>
> 
> I hope that Hans or someone else can document the v4lconvert functions in
> detail in the future.

Yes, that would be great.

> > +<link linkend='VIDIOC-ENUM-FMT'><constant>VIDIOC_ENUM_FMT</constant></link> keep
> > +enumerating the hardware supported formats.
> 
> "keeps".
> 
> Actually, you might want to rewrite this ENUM_FMT description, since I'm not
> quite sure what you want to say here. I think what you mean is something like
> this:
>
> "VIDIOC_ENUM_FMT still enumerates the hardware supported formats, but the
> emulated formats are added at the end."

Ok, I changed it to:

VIDIOC_ENUM_FMT keeps enumerating the hardware supported formats, plus the
emulated formats offered by libv4l at the end.

> The description of v4l2_fd_open is missing.

Added, together with the get/set control functions.

> > +counterparts, by using LD_PRELOAD=/usr/lib/v4l1compat.so.</para>
> > +		<para>It allows usage of binary legacy applications that
> > +still don't use libv4l.</para>
> 
> Is this description really correct? Based on the name of the wrapper I would
> say that this is a library has something to do with V4L1 compatibility, yet
> the description makes no mention of that.

It also emulates V4L1 calls. Changed it to:

This library intercepts calls to 
open/close/ioctl/mmap/mmunmap operations and redirects them to the libv4l
counterparts, by using LD_PRELOAD=/usr/lib/v4l1compat.so. It also
emulates V4L1 calls via V4L2 API.



Cheers,
Mauro
