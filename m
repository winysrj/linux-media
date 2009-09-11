Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33947 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZIKW7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 18:59:09 -0400
Subject: Re: Media controller: sysfs vs ioctl
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200909120021.48353.hverkuil@xs4all.nl>
References: <200909120021.48353.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 19:01:50 -0400
Message-Id: <1252710110.4826.64.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-09-12 at 00:21 +0200, Hans Verkuil wrote:
> Hi all,
> 
> I've started this as a new thread to prevent polluting the discussions of the
> media controller as a concept.
> 
> First of all, I have no doubt that everything that you can do with an ioctl,
> you can also do with sysfs and vice versa. That's not the problem here.
> 
> The problem is deciding which approach is the best.

I've wanted to reply earlier but I cannot collect enough time to do
proper research, but since you asked this particular question, I happen
to have something which may help.

I would suggest evaluating a representative proposals by applying
Baldwin and Clark's Net Options Value (NOV) metric to a simple system
representation.  The system to which to apply the metric would comprise:

	- a representative user space app
	- a representative v4l-dvb driver
	- an API concept/suggestion/proposal

I think this metric is appropriate to apply, because the NOV is a way to
assign value to implementing options (i.e. options in modular systems).
An API itself is not a modular system and hard to evaluate in isolation,
so it needs to be evaluated in the context of the options it provies to
the system designers and maintainers.

The NOV boils to simple concepts:

1. a system design has a total value that is its present value plus the
value of it's options that can be exploited in the future.

2. an option represents a potential value that may provide a return in
the future

3. an option has only a potential value (in the present)

4. an option only yields a return if that option may be exploited in the
future.  The probability that the option may be exploited needs to be
taken into account.

5. an option has costs associated with exploiting it (in the future)

I'm not advocating a rigorous computation of the metric for the
proposals, but more a qualitative look at the proposals but still using
the precise definition of the metric (sorry I don't have a URL
handy...).


I will note that I think am in agreement with Hans on sysfs.  I think
the cost of trying to exploit any option provided through sysfs in a
userspace apppllication will nullify any technical benefit of said
option to the application.

Lets say we want to convert an existing app to a "Media Controller
aware" version of that app.  There is a cost to do that.  Will the API
proposal make exploting some options have a large cost?  Do some of the
options of the API have a low probability of being exploited?  Do some
of the options of the API provide very low technical benefit?  What does
the API proposal do to the total value of the system (e.g. an API with
no flexibility fixes the total value close to the present value and
there is no value to be realized from exploiting options in the future).


OK, I hope I've communicated what I mean.  I feel like that all may be
less than clear.


These ideas have come from a confluence of research I've been doing at
work, and V4L-DVB work (thinking about Multiproto vs. DVB v5, and the
v4l2_subdev IR ops, etc.).


Regards,
Andy

