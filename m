Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1130 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0IJIWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 04:22:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
Date: Fri, 10 Sep 2010 10:22:22 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	t.fujak@samsung.com
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com> <4C89B3AD.1010404@redhat.com> <4C89E084.6090203@samsung.com>
In-Reply-To: <4C89E084.6090203@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009101022.22832.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Friday, September 10, 2010 09:38:44 Marek Szyprowski wrote:
> Hello,
> 
> On 2010-09-10 13:27, Mauro Carvalho Chehab wrote:
> 
> >>> 1) it lacks implementation of read() method. This means that vivi driver
> >>> has a regression, as it currently supports it.
> >>
> >> Yes, read() is not yet implemented. I guess it is not a feature that would
> >> be deprecated, right?
> >
> > Yes, there are no plans to deprecate it. Also, some devices like cx88 and bttv
> > allows receiving simultaneous streams, one via mmap, and another via read().
> > This is used by some applications to allow recording video via ffmpeg/mencoder
> > using read(), while the main application is displaying video using mmap.
> 
> Well, in my opinion such devices should provide two separate /dev/videoX 
> nodes rather than hacking with mmap and read access types.

1) It is in use so you can't just drop it.
2) The read() API is actually very useful for video devices that deal with
   compressed video streams. E.g. you can do things like 'cat /dev/video0 >foo.mpg'

It's been a long standing wish to convert the ivtv and cx18 drivers to videobuf,
but it's always been too complex. With a new vb2 implementation it may become
actually possible.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
