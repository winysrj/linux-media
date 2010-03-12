Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46458 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020Ab0CLPVw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 10:21:52 -0500
Received: by bwz1 with SMTP id 1so1126991bwz.21
        for <linux-media@vger.kernel.org>; Fri, 12 Mar 2010 07:21:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201003120827.44814.hverkuil@xs4all.nl>
References: <201003090848.29301.hverkuil@xs4all.nl>
	 <4B98FABB.1040605@gmail.com>
	 <829197381003110631v52410d27m7e13d5438e09cd13@mail.gmail.com>
	 <201003120827.44814.hverkuil@xs4all.nl>
Date: Fri, 12 Mar 2010 10:21:50 -0500
Message-ID: <829197381003120721r2e9250eeu6c981e4b493c8b55@mail.gmail.com>
Subject: Re: v4l-utils: i2c-id.h and alevt
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 12, 2010 at 2:27 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> For unmaintained applications the problem is that even those people that
> have patches for them have no easy way to get them applied, precisely because
> they are unmaintained.
>
> We as v4l-dvb developers don't have the time to make TV apps, but perhaps if
> we 'adopted' one unmaintained application and just update that whenever we
> make new features, then that would be very helpful I think. Or perhaps just
> provide a place for such applications where there is someone who can take
> community supplied patches and review and apply them.

This is the key reason that KernelLabs "adopted" tvtime - the goal being to:

1.  Consolidate all the distro patches floating around
2.  Have a source tree that compiles without patches on modern distributions
3.  Have a channel for people to submit new patches
4.  Make improvements as necessary to make the app "just work" for
most modern tuner cards.

The goal is to get the distros to switch over to treating our tree as
the "official upstream source" so that people will finally have a
lightweight application for analog tv that "just works" and ships with
their Linux distro by default.

> Such an application does not have to be in v4l2-utils, it can have its own
> tree.

If the goal is for the LinuxTV group to adopt some of these
applications, I would definitely recommend it not be in the v4l-utils
tree (for reasons stated in the previous email).  that said, I
certainly have no objection to it in principle.

> Anyway, regarding alevt: I believe that the consensus is that it should be
> moved to v4l2-utils? Or am I wrong?

I haven't looked at the alevt code itself but I believe the answer
should be based on the following questions:

1.  How big is it?  Will distros not want to include the package by
default because along with a few KB of utilities they also end up with
several megabytes of crap that the vast majority of people don't care
about?

2.  What external dependencies does it have?  Right now, v4l-utils is
just a few command line tools with minimal dependencies (meaning it is
trivial to install in pretty much all environments, including those
without X11).  If the result is that you would now have to install
dozens of packages, then that would be a bad thing.

Jamming stuff into v4l-utils should not be seen as some sort of
backdoor way to get Linux distributions to include programs that they
wouldn't have otherwise.  The distributions should see real value in
the additional tool.  If they value the program, they will package the
program if we host it even as a standalone project outside of
v4l-utils.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
