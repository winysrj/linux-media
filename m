Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:60721 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbbIRJns (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 05:43:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 7/9] [media] v4l2: introduce v4l2_timeval
Date: Fri, 18 Sep 2015 11:43:24 +0200
Message-ID: <9019880.VVdOR6WRt1@wuerfel>
In-Reply-To: <55FBD90C.3020301@xs4all.nl>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de> <8200227.6XAMdOOJfW@wuerfel> <55FBD90C.3020301@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 18 September 2015 11:27:40 Hans Verkuil wrote:
> Ah, OK. Got it.
> 
> I think this is dependent on the upcoming media workshop next month. If we
> decide to redesign v4l2_buffer anyway, then we can avoid timeval completely.
> And the only place where we would need to convert it in the compat code
> hidden in the v4l2 core (likely v4l2-ioctl.c).

Ah, I think I understood the idea now, I missed that earlier when you mention
the idea.

So what you are saying here is that you could come up with a new unambiguous
(using only __u32 and __u64 types and no pointers) format that gets exposed
to a new set of ioctls, and then change the handling of the existing three
formats (native 64-bit, traditional 32-bit, and 32-bit with 64-bit time_t)
so they get converted into the new format by the common ioctl handling code?

> I am not really keen on having v4l2_timeval in all these drivers. I would
> have to check them anyway since I suspect that in several drivers the local
> timeval variable can be avoided by rewriting that part of the driver.

I've tried to do that for all the drivers where I could find an easy solution
in patch 6/9, but I'm sure you can do it for a couple more.

We could also do a lightweight redesign and use 'timespec64' internally
in all the drivers and then convert that to 'timeval' or the 64-bit
format of that in the ioctl handler. This is also something I tried at
some point but then found it a bit more intuitive to leave the normal ioctl
path alone and have an explicit type.

> Personally I am in favor of a redesigned v4l2_buffer: it's awkward to use
> with multiplanar formats, there is cruft in there that can be removed (timecode),
> and there is little space for additions (HW-specific timecodes, more buffer
> meta data, etc).
> 
> We'll see.

Ok.

	Arnd
