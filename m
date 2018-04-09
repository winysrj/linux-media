Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeDIJOr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 05:14:47 -0400
Date: Mon, 9 Apr 2018 11:14:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Nibble Max <nibble.max@gmail.com>,
        linux-media <linux-media@vger.kernel.org>, mchehab@kernel.org,
        wsa@the-dreams.de
Subject: Re: Regression: DVBSky S960 USB tuner doesn't work in 4.10 or newer
Message-ID: <20180409091441.GX4043@hirez.programming.kicks-ass.net>
References: <CAAZRmGz8iTDSZ6S=05V0JKDXBnS47e43MBBSvnGtrVv-QioirA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAZRmGz8iTDSZ6S=05V0JKDXBnS47e43MBBSvnGtrVv-QioirA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 04, 2018 at 02:41:51PM +0300, Olli Salonen wrote:
> Hello Peter and Max,
> 
> I noticed that when using kernel 4.10 or newer my DVBSky S960 and
> S960CI satellite USB TV tuners stopped working properly. Basically,
> they will fail at one point when tuning to a channel. This typically
> takes less than 100 tuning attempts. For perspective, when performing
> a full channel scan on my system, the tuner tunes at least 500 times.
> After the tuner fails, I need to reboot the PC (probably unloading the
> driver and loading it again would do).
> 
> 2018-04-04 10:17:36.756 [   INFO] mpegts: 12149H in 4.8E - tuning on
> Montage Technology M88DS3103 : DVB-S #0
> 2018-04-04 10:17:37.159 [  ERROR] diseqc: failed to send diseqc cmd
> (e=Connection timed out)
> 2018-04-04 10:17:37.160 [   INFO] mpegts: 12265H in 4.8E - tuning on
> Montage Technology M88DS3103 : DVB-S #0
> 2018-04-04 10:17:37.535 [  ERROR] diseqc: failed to send diseqc cmd
> (e=Connection timed out)
> 
> I did a kernel bisect between 4.9 and 4.10. It seems the commit that
> breaks my tuner is the following one:
> 
> 9d659ae14b545c4296e812c70493bfdc999b5c1c is the first bad commit
> commit 9d659ae14b545c4296e812c70493bfdc999b5c1c
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Tue Aug 23 14:40:16 2016 +0200
> 
>     locking/mutex: Add lock handoff to avoid starvation
> 
> I couldn't easily revert that commit only. I can see that the
> drivers/media/usb/dvb-usb-v2/dvbsky.c driver does use mutex_lock() and
> mutex_lock_interruptible() in a few places.
> 
> Do you guys see anything that's obviously wrong in the way the mutexes
> are used in dvbsky.c or anything in that particular patch that could
> cause this issue?

Nothing, sorry.. really weird. That driver looks fairly straight forward
with respect to mutex usage (although obviously I have less than 0 clue
on the whole usb media thing).

That it breaks that driver would suggest something funny with it though;
because the kernel has loads and loads of mutexes in and they all appear
to work well with that patch -- in fact, it fixed a reported starvation
case.

The only way for that patch to affect things is if there is contention
on the mutex though; so who or what is also trying to acquire the mutex?

The reported error is a timeout, suggesting that whoever is contending
on the lock is keeping it held too long? I do notice that
dvbsky_stream_ctrl() has an msleep() while holding a mutex.

Do you have any idea which of the 3 (afaict) mutexes in that driver is
failing? Going by the fact that it's failing to send, I'd hazard a guess
it's the i2c mutex, but again, I have less than 0 clues about i2c.
