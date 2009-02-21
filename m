Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:30175 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZBUJc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 04:32:28 -0500
Date: Sat, 21 Feb 2009 10:32:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090221103209.7f4fa1d0@hyperion.delvare>
In-Reply-To: <20090220212327.410a298b@pedra.chehab.org>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<20090218071041.63c09ba3@pedra.chehab.org>
	<20090218140105.17c86bcb@hyperion.delvare>
	<20090220212327.410a298b@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Only answering points Hans didn't already answered (and I agree with
him):

On Fri, 20 Feb 2009 21:23:27 -0300, Mauro Carvalho Chehab wrote:
> On Wed, 18 Feb 2009 14:01:05 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> > Not necessarily something to be proud about. This only shows how slowly
> > v4l has evolved in the past few years. Big changes that should have
> > happen have been constantly postponed in the name of compatibility.
> 
> No change I'm aware of were postponed due to previous kernel compatibility.

I2C bus multiplexing support, including transparent support for I2C
gates, is waiting to be implemented since kernel 2.6.27. Unfortunately
it is fundamentally incompatible with the legacy i2c binding model, so
we have to clean this up first. As it happens, this will not happen
before 2.6.30 at best. That's a 6 month delay, which is essentially due
to the fact that the conversion of v4l drivers is lagging behind. While
I was able to convert all hwmon drivers quickly, and rtc drivers were
converted by other developers quickly as well, v4l drivers I couldn't
convert myself because of the backwards compatibility requirements.

As a matter of fact, I sent a patch converting the zoran driver to the
new i2c binding model in September 2008. It was working perfectly fine
for me. But it was breaking backwards compatibility, so Hans told me to
hold off and he would take care of the conversion the right way. He
just did last week... 5 months after my own code was ready.

What you see here is a delay of several months in getting a task done,
plus me wasting my time on code that was then thrown away because Hans
had to do it all over again in a different way. When things get to the
point where patches written for the upstream kernel have to be
discarded and rewritten from scratch for the external repository, I say
that things have become too complex. This is the point at which you
start losing contributions.

> (...)
> No. I'm saying that we should not exclude an user just because it uses a RHEL
> kernel (btw, there are some versions at RHEL aimed for desktop and notebooks
> also using 2.6.18).

And I claim, once again, that we should exclude such users, because you
can count them on the fingers of one hand worldwide. It's really not a
matter of desktop vs. server distribution. It is a matter of
Enterprise-grade distribution vs. home user distribution, and the
requirements and expectations attached to them. A home user running
RHEL on a recent desktop machine on which he/she intends to watch TV is
simply using the wrong tool for the job.

> > (...)
> > As a side note, I doubt that the v4l-dvb repository would always work
> > that well for enterprise distribution kernels anyway. All the tests are
> > based on the kernel version, but the enterprise kernels diverge a lot
> > over time from the upstream version they were originally based on, so I
> > wouldn't be surprised if things broke from times to times.
> 
> True, but, when something breaks, people complain and the support is added. The
> better way of adding a backport is by adding a small search string at
> v4l/scripts/make_config_compat.pl and adding the backport code at compat. This
> solves the issues with the distro kernels much better than just checking for a
> specific kernel version.

Ah, I didn't know about that script. The good news is that it means the
system is more robust than I thought. The bad news is that it is even
more complex than I thought...

Anyway, please don't keep track of my original request. All I was
really saying is that supporting both the legacy and the new i2c
binding models is next to impossible, because of the huge conceptual
difference between them, and for this reason we have to drop support
for kernels older than 2.6.22. Now you say that maybe we need to
rethink the v4l-dvb development model from the ground up. Maybe we do,
but that's a totally different issue.

Thanks,
-- 
Jean Delvare
