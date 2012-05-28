Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45370 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2E1MR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 08:17:59 -0400
Date: Mon, 28 May 2012 14:17:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC PATCH 0/3] Improve Kconfig selection for media devices
Message-ID: <20120528141752.7e4c530e@stein>
In-Reply-To: <4FC363A5.1010802@redhat.com>
References: <4FC24E34.3000406@redhat.com>
	<1338137803-12231-1-git-send-email-mchehab@redhat.com>
	<20120528114803.0d1a4881@stein>
	<4FC363A5.1010802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On May 28 Mauro Carvalho Chehab wrote:
> Em 28-05-2012 06:48, Stefan Richter escreveu:
> > c) The RC_CORE_SUPP help text gives the impression that RC core is
> > always needed if there is hardware with an IR feature.  But the firedtv
> > driver is a case where the driver directly works on top of the input
> > subsystem rather than on RC core.  Maybe there are more such cases.
> 
> All other drivers use RC_CORE, as we've replaced the existing implementations
> to use it, removing bad/inconsistent IR code implementations everywhere.
> The only driver left is firedtv.
[...]
> The right thing to do is to convert drivers/media/dvb/firewire/firedtv-rc.c
> to use rc-core. There are several issues with the current implementation:
> 
> 	- IR keycode tables are hardcoded;
> 	- There is a "magic" to convert a 16 bits scancode (NEC protocol?)
> 	  into a key;
> 	- There's no way to replace the existing table to an user-provided
> 	  one;

There are two tables:  An old mapping and a new mapping.  The new mapping
is copied into a newly allocated writable array.  It should be possible to
overwrite this array by means of EVIOCSKEYCODE ioctls.

If I remember correctly, the firedtv driver sources came only with the old
mapping table when they were submitted for upstream merge.  When I helped
to clean up the driver, I noticed that the two FireDTV C/CI and T/CI (which
I newly purchased at the time as test devices) emitted entirely different
scan codes than what the sources suggested.  I suppose the original driver
sources were written against older firmware or maybe older hardware
revisions, possibly even prototype hardware.  We would have to get hold of
the original authors if we wanted to find out.

Anyway, I implemented the new scancode->keycode mapping in a way that
followed Dimitry's (?) review advice at that time, but left the old
immutable mapping in there as fallback if an old scancode was received.

If it is a burden, we could rip out the old table and see if anybody
complains.

> 	- The IR userspace tools won't work, as it doesn't export the
> 	  needed sysfs nodes to report an IR.

But at least keypad/ keyboard related userspace should work.

> If you want, I can write a patch doing that, but I can't test it here, as
> I don't have a firedtv device.

I can test such a patch as spare time permits if you point me to particular
tools that I should test.
-- 
Stefan Richter
-=====-===-- -=-= ===--
http://arcgraph.de/sr/
