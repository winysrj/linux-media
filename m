Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:28438 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab0IJNu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:50:26 -0400
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	t.fujak@samsung.com
In-Reply-To: <201009101022.22832.hverkuil@xs4all.nl>
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
	 <4C89B3AD.1010404@redhat.com> <4C89E084.6090203@samsung.com>
	 <201009101022.22832.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 09:50:06 -0400
Message-ID: <1284126606.2123.98.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, 2010-09-10 at 10:22 +0200, Hans Verkuil wrote:
> On Friday, September 10, 2010 09:38:44 Marek Szyprowski wrote:
> > Hello,
> > 
> > On 2010-09-10 13:27, Mauro Carvalho Chehab wrote:
> > 
> > >>> 1) it lacks implementation of read() method. This means that vivi driver
> > >>> has a regression, as it currently supports it.
> > >>
> > >> Yes, read() is not yet implemented. I guess it is not a feature that would
> > >> be deprecated, right?
> > >
> > > Yes, there are no plans to deprecate it. Also, some devices like cx88 and bttv
> > > allows receiving simultaneous streams, one via mmap, and another via read().
> > > This is used by some applications to allow recording video via ffmpeg/mencoder
> > > using read(), while the main application is displaying video using mmap.
> > 
> > Well, in my opinion such devices should provide two separate /dev/videoX 
> > nodes rather than hacking with mmap and read access types.
> 
> 1) It is in use so you can't just drop it.
> 2) The read() API is actually very useful for video devices that deal with
>    compressed video streams. E.g. you can do things like 'cat /dev/video0 >foo.mpg'
> 
> It's been a long standing wish to convert the ivtv and cx18 drivers to videobuf,
> but it's always been too complex. With a new vb2 implementation it may become
> actually possible.

Steven has mmap() mostly done for the cx18 YUV stream:

http://www.kernellabs.com/hg/~stoth/cx18-videobuf/

I provided him a slew of comments on the patchset,  The comments were
mostly just grunt work to move things around and clean it up than any
major flaws.  I only saw one problem that must be fixed before it is
usable for the masses, IIRC.

Maybe if there's a test case for trying out videobuf2, it's the cx18
driver where we want to use mmap() for YUV and read() for MPEG.  Note
Steven's changes allow one to tell the CX23418 to send YUV data in YUYV
format vs. HM12.

Regards,
Andy



