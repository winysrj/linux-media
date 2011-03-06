Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43756 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1CFEA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 23:00:27 -0500
Received: by qyk7 with SMTP id 7so1193366qyk.19
        for <linux-media@vger.kernel.org>; Sat, 05 Mar 2011 20:00:26 -0800 (PST)
Subject: Re: [PATCH 0/13] lirc_zilog: Ref-counting and locking cleanup
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1297991502.9399.16.camel@localhost>
Date: Sat, 5 Mar 2011 23:00:22 -0500
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4BC877EC-56F4-4ED6-8410-183712C8FAF8@wilsonet.com>
References: <1297991502.9399.16.camel@localhost>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 17, 2011, at 8:11 PM, Andy Walls wrote:

> The following 13 patches are a substantial rework of lirc_zilog
> reference counting, object allocation and deallocation, and object
> locking.
> 
> With these changes, devices can now disappear out from under lircd +
> lirc_dev + lirc_zilog with no adverse effects.  I tested this with irw +
> lircd + lirc_dev + lirc_zilog + cx18 + HVR-1600.  I could unload the
> cx18 driver without any oops or application crashes.  When I reloaded
> the cx18 driver, irw started receiving RX button presses again, and
> irsend worked without a problem (and I didn't even need to restart
> lircd!).
> 
> The ref counting fixes aren't finished as lirc_zilog itself can still be
> unloaded by the user when it shouldn't be, but a hot unplug of an
> HD-PVR, PVR-USB2, or HVR-1950 isn't going to trigger that.
> 
> These changes are base off of Jarod Wilson's git repo
> 
> 	http://git.linuxtv.org/jarod/linux-2.6-ir.git for-2.6.38 (IIRC)

As discussed on irc Friday, after figuring out an issue with trying to
test these using media_build against a 2.6.32 kernel, both the hdpvr
and hvr-1950 still function with these patches, and now you can even
hot-unplug them with lirc_zilog loaded and the system doesn't blow up.

Also gave a cursory read over all the code changes, didn't see anything
jump out that looked out of sorts, aside from the few minor fixlets we
also discussed. I'll just fix those locally in what I merge into the
tree I'm prepping with a variety of IR-related fixes for 2.6.39 to have
Mauro pull.

So for the set:

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@wilsonet.com



