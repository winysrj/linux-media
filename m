Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:62883 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612AbbKEJZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2015 04:25:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: y2038@lists.linaro.org, Junghak Sung <jh1009.sung@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Y2038] Which type to use for timestamps: u64 or s64?
Date: Thu, 05 Nov 2015 10:25:36 +0100
Message-ID: <3967137.8jj5KpGqKx@wuerfel>
In-Reply-To: <563B1BE8.8090007@xs4all.nl>
References: <563B0817.2060508@xs4all.nl> <10717379.s8aWAKUxAs@wuerfel> <563B1BE8.8090007@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 November 2015 10:05:44 Hans Verkuil wrote:
> On 11/05/15 09:36, Arnd Bergmann wrote:
> > On Thursday 05 November 2015 08:41:11 Hans Verkuil wrote:
> >> Hi Arnd,
> >>
> >> We're redesigning the timestamp handling in the video4linux subsystem moving away
> >> from struct timeval to a single timestamp in ns (what ktime_get_ns() gives us).
> >> But I was wondering: ktime_get_ns() gives a s64, so should we use s64 as well as
> >> the timestamp type we'll eventually be returning to the user, or should we use u64?
> >>
> >> The current patch series we made uses a u64, but I am now beginning to doubt that
> >> decision.
> > 
> > I would lean towards u64, but I don't think it really matters either way,
> > especially since all the drivers should be using monotonic timestamps now.
> 
> One thing that might be easier if it is a s64 is when adding/subtracting offsets
> from the timestamp. And the other reason is that a u64 gives a false view of the
> underlying type. With a s64 it is clear that a timestamp will wrap around after
> 292 years instead of double that. Admittedly, not our problem, but if we ever send
> a space probe to Alpha Centauri, then it might be nice to know as application
> developer that you need to take special measures if the mission takes longer than
> 292 years 

There is another problem here if you are worried about the overflow: Unsigned
overflow is well-defined in C, i.e. (U64_MAX + 1) is known to be 0. However,
signed overflow is not defined in C for historic reasons, so taking the
result of (S64_MAX + 1) can have arbitrary results [1], including a kernel
oops, or random other things not related to the variable that carries the
result, if gcc decides that 'this cannot happen'.

	Arnd

[1] http://stackoverflow.com/questions/3948479/integer-overflow-and-undefined-behavior
