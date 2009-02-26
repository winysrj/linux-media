Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:58161 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbZBZF0X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 00:26:23 -0500
Date: Wed, 25 Feb 2009 23:26:20 -0600 (CST)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0902252313130.29891@cnc.isely.net>
References: <200902221115.01464.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 22 Feb 2009, Hans Verkuil wrote:

> Hi all,
> 
> There are lot's of discussions, but it can be hard sometimes to actually 
> determine someone's opinion.
> 
> So here is a quick poll, please reply either to the list or directly to me 
> with your yes/no answer and (optional but welcome) a short explanation to 
> your standpoint. It doesn't matter if you are a user or developer, I'd like 
> to see your opinion regardless.
> 
> Please DO NOT reply to the replies, I'll summarize the results in a week's 
> time and then we can discuss it further.
> 
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
> 
> _: Yes
> _: No

Yes (see below)


> 
> Optional question:
> 
> Why:
> 

I'm always for backwards compatibility in general.  I have an 
out-of-tree "standalone" pvrusb2 driver which includes extra stuff that 
at least compiles correctly all the way back to 2.6.12 (extra - but old 
- i2c modules are also included with the driver for kernels of that 
vintage).

However, that's just my one driver and I think trying to maintain that 
sort of (in)sanity over the entire v4l-dvb tree is going to be a major 
morale-sucking headache.

I'm working right now on v4l2-subdev support and it's my intention that 
I will be ripping out all the old I2C adaptation stuff as part of this 
effort.  (I am actually going to at least try to make the old stuff 
still work as a compile-time switch in the standalone pvrusb2 driver but 
I don't realistically expect that to remain practical with the driver as 
it currently resides in v4l-dvb.)

So even if the decision is made to keep v4l-dvb as a whole compatible 
all the way back to 2.6.16, the pvrusb2 driver will still in the end 
have to be excluded in v4l-dvb builds for anything older than 2.6.22.  
I really can't vote "no" above with a straight face while doing this 
v4l2-subdev related work in the driver.

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
