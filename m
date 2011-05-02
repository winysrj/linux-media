Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41728 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1EBT3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 15:29:46 -0400
Received: by ewy4 with SMTP id 4so1850909ewy.19
        for <linux-media@vger.kernel.org>; Mon, 02 May 2011 12:29:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105022111.40604.hverkuil@xs4all.nl>
References: <E1QGwlS-0006ys-15@www.linuxtv.org>
	<201105022111.40604.hverkuil@xs4all.nl>
Date: Mon, 2 May 2011 15:21:52 -0400
Message-ID: <BANLkTi=3n++7w-UOE6HZ8p6P9S6Oa9y9kQ@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw
 YUV video capture
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, May 2, 2011 at 3:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> NACK.
>
> For two reasons: first of all it is not signed off by Andy Walls, the cx18
> maintainer. I know he has had other things on his plate recently which is
> probably why he hasn't had the chance to review this.
>
> Secondly, while doing a quick scan myself I noticed that this code does a
> conversion from UYVY format to YUYV *in the driver*. Format conversion is
> not allowed in the kernel, we have libv4lconvert for that. So at the minimum
> this conversion code must be removed first.

Hi Hans,

Cutting the code that does UYVY to YUYV shouldn't be a problem, since
there are other devices which only support UYVY and thus applications
do support the format (the HVR-950q for one).  Should just need to
remove the offending code block and adjust the advertised formats
list.

That said, Andy hasn't provided any feedback onlist at all, which is a
bit disconcerting (and probably calls for "why won't Andy comment?"
instead of an arbitrary NACK).

I did speak to Andy about this patch series several months ago, and he
was generally not in favor of it because he was planning on converting
to videobuf2.  While I agree this would be good in the long term, this
patch provides a great deal of value in the meantime, and I've always
been a fan of the notion that "perfect is the enemy of good".  Who
knows when we'll actually see a videobuf2 conversion, and this patch
doesn't really prevent any of that from happening.

I would hate to see yet another situation where a solution stays
out-of-tree for years because of some totally awesome better approach
which might possibly get integrated at some unknown point in the
future.

In other words, let's get this merged in (sans the UYVY/YUYV
conversion), and if/when Andy eventually does a videobuf2 conversion,
then we will all rejoice.  Actually, nobody except us driver
developers will rejoice since it's an internal architecture change
which provides no user-visible value.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
