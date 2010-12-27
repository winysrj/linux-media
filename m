Return-path: <mchehab@gaivota>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4780 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab0L0Mpb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 07:45:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/6] V4L1 cleanups and videodev.h removal
Date: Mon, 27 Dec 2010 13:45:15 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20101227093848.324b6abd@gaivota> <201012271321.08128.hverkuil@xs4all.nl> <4D1887B0.8070709@redhat.com>
In-Reply-To: <4D1887B0.8070709@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012271345.16124.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, December 27, 2010 13:33:52 Mauro Carvalho Chehab wrote:
> Em 27-12-2010 10:21, Hans Verkuil escreveu:
> > On Monday, December 27, 2010 12:38:48 Mauro Carvalho Chehab wrote:
> >> Now that all hard work to remove V4L1 happened, it doesn't make
> >> sense on keeping videodev.h just because of two obsoleted drivers.
> > 
> > Perhaps it is also time to mark the videodev2.h _OLD ioctls for removal in
> > 2.6.39?
> > 
> > If we are getting rid of old stuff anyway, then this will also be a nice
> > cleanup.
> > 
> > Perhaps we can even delete it without marking it for removal. After all,
> > removing it will only affect binaries compiled against a *really* old kernel
> > (I suspect 2.5.something). Anything that has been recompiled will automatically
> > use the correct ioctls.
> 
> We can't just remove the _OLD, as they're used internally, in order to handle
> those old binaries. I think that not all come from 2.5 times. So, the better is to
> mark them to be removed for .39.

I double checked and they were introduced in 2.6.2 except for CROPCAP_OLD which
was introduced in 2.6.6.

Do you want me to mark them for removal or will you?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
