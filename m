Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44713 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbZGSOG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 10:06:26 -0400
MIME-Version: 1.0
In-Reply-To: <4A631C8F.7000002@rtr.ca>
References: <4A631C8F.7000002@rtr.ca>
Date: Sun, 19 Jul 2009 10:06:25 -0400
Message-ID: <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
	branch
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 19, 2009 at 9:15 AM, Mark Lord<lkml@rtr.ca> wrote:
> Devin,
>
> Thanks for your good efforts and updates on the xc5000 driver.
> But the version in 2.6.31 no longer works with mythfrontend
> from the 0.21-fixes branch of MythTV.
>
> The mythbackend (recording) program tunes/records fine with it,
> but any attempt to watch "Live TV" via mythfrontend just locks
> up the UI for 30 seconds or so, and then it reverts to the menus.
>
> I find that rather odd, as mythfrontend normally has very little
> interaction with the tuner devices.  But it does try to read the
> signal strength and quality from the tuner, so perhaps this is a
> clue as to what has gone wrong?
>
> I also took just the xc5000.[ch] files from 2.6.31 and tried them
> with 2.6.30, to help isolate things.  Exactly the same behaviour
> was observed there, too.  The mythbackend could tune/record,
> but the mythfrontend would lock up.
>
> ???
>

Hello Mark,

Thank you for the bug report.

Michael Krufky and I tested the tuner changes with what I thought were
all the tuners that used the xc5000 (yes, between the two of us we
have quite a collection).  Perhaps we missed one though.

Replacing xc5000.[ch] would normally be a good idea from a testing
standpoint.  However, in this case it isn't very conclusive since the
xc5000 performance and power management improvements exposed numerous
bugs in various demods, bridges, and even one in dvb core (all of
which I had to fix before the xc5000 work could be submitted
upstream).

Could you please provide the following:

1.  Exactly which product you are using (including the USB/PCI id)
2.  dmesg output from the time the card is inserted (or booted up if
PCI) to the time *after* you attempted to use the frontend with
mythtv.
3.  Whether you are using the device for digital, analog, or both, and
which the mythtv attempted to use when running the mythfrontend.

Also, Could you please install the latest v4l-dvb code using the
directions at http://linuxtv.org/repo and see if the problem still
occurs.  This will tell us if the problem is some patch that didn't
make it upstream, and will make it easier for me to give you patches
that provide more debug info.

I will be afk until tonight, but will check my email as soon as I get home.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
