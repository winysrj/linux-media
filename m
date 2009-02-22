Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp104.rog.mail.re2.yahoo.com ([206.190.36.82]:33876 "HELO
	smtp104.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752112AbZBVTMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 14:12:51 -0500
Message-ID: <49A1A3B2.5090609@rogers.com>
Date: Sun, 22 Feb 2009 14:12:50 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
References: <200902221115.01464.hverkuil@xs4all.nl>
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
>   

Yes


> Optional question:
>
> Why:
>   

Its causing skilled developers to waste time that would be better served
in other areas.  Because of that, these skilled volunteers are becoming
frustrated and losing their interest in pressing forth.  

It causes unnecessary complexity.  The golden rule is to keep things as
simple as possible.

It presents a hurdle to attracting new development talent (both
corporate and individual).

When upstream technical changes (such as i2c subsystem changes) have
made backporting downstream a nightmare, it is time to seriously
evaluate why you are even bothering doing such.  The salient point is
that it is absolutely illogical for volunteers to be catering to narrow
commercial interests. 
- Arguments about appeasing the needs of Enterprise distro's are moot.  
V4L-DVB owes them nothing.  Enterprise distro's are specifically that --
an enterprise's  work; if they crave support, then they can put Hans (or
whomever) on the payroll to backport for their specific needs.
- Arguments about appeasing the needs of embedded distros/platforms are
moot.   V4L-DVB owes them nothing.  Let those groups figure out and/or
support such device needs on their own; else they can put Hans (or
whomever) on the payroll.   Those manufactures releasing products within
this space will adapt to whatever V4L-DVB does.    This space will not
suddenly fall apart because of our decision.   These entrepreneurs have
entered this space specifically to exploit a market opportunity.  If
they exit, someone else will move in.  Its simple free market
dynamics.   (As it is, they are getting a free lunch ... seriously, I
think that when the embedded space looks at how bent over accommodating
we currently are, they must be rubbing their hands together and
gleefully repeating Flounders statement: Oh boy, is this great!
(http://www.acmewebpages.com/midi/great.wav))

The V4L-DVB is lacking in strategic direction.  Yesterday was the time
to adopt one; so lets pick up one today!

I believe the plan to currently backport to 2.6.22 but to bump/narrow
the kernel support window to the ideal/easier_to_maintain 2.6.25, once
express support from the big 3 desktop distos ends, is the most logical
choice and the one which will have the most beneficial impact on the
project's future.



