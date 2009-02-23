Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:44992 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZBWNtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 08:49:32 -0500
Date: Mon, 23 Feb 2009 14:49:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
Message-ID: <20090223144917.257a8f65@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

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

X: Yes

> _: No
> 
> Optional question:
> 
> Why:

The cost to preserve backwards compatibility for these old kernels is
much too high compared to the remaining user-base. I can only repeat
the points I have made in the past week:
* Maintained distributions aimed at home users (Fedora, openSUSE) run
  kernels >= 2.6.22 by now.
* Enterprise-class distributions (RHEL, SLED) are not the right target
  for the v4l-dvb repository, so we don't care which kernels these are
  running.
* Engineering time which is put into backwards compatibility would be
  better spent on improving the drivers upstream and adding support
  for new hardware faster.
* v4l-dvb depends on subsystems which do evolve, and when these changes
  are too important (e.g. new i2c device driver binding model)
  backwards compatibility comes are an unbearable complexity and cost.
  That kind of cost sucks the time of current developers, might turn
  them into ex-developers when they realize they lost all the fun, and
  prevents new developers from joining the project because of the
  complexity of the compatibility layer.

So let's just drop support for kernels < 2.6.22 and focus on better
supporting upstream and recent kernels.

Thanks,
-- 
Jean Delvare
