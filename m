Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:36408 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1HUBvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 21:51:12 -0400
Received: by iye16 with SMTP id 16so8028685iye.1
        for <linux-media@vger.kernel.org>; Sat, 20 Aug 2011 18:51:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAATJ+fu5JqVmyY=zJn_CM_Eusst_YWKG2B2MAuu5fqELYYsYqA@mail.gmail.com>
References: <CAATJ+fu5JqVmyY=zJn_CM_Eusst_YWKG2B2MAuu5fqELYYsYqA@mail.gmail.com>
Date: Sun, 21 Aug 2011 11:51:11 +1000
Message-ID: <CAATJ+ft9HNqLA62ZZkkEP6EswXC1Jhq=FBcXU+OHCkXTKpqeUA@mail.gmail.com>
Subject: Re: Afatech AF9013
From: Jason Hecker <jwhecker@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a problem that may be related to the issues on this thread and
it's driving me nuts.

I have two dual tuner Afatech based cards, they are both Leadtek
2000DS cards, one made by Leadtek and the other branded as KWorld but
they are otherwise identical in spite of different VID:PID.

On each card tuner A is an AF9015 and tuner B is an AF9013.  The
KWorld card worked just fine for about 18 months in Mythbuntu 10.04
with the rebuilt and patched modules as described in the Wiki entry on
the 2000DS.  A few weeks ago tuner A started giving errors making the
viewing unwatchable so figuring the card had died I bought the
Leadtek.  To my surprise it gave the same problem as the KWorld when
using tuner A.  It seems Tuner A is OK until Tuner B is used and then
Tuner A gets a lot of errors.  Tuner B never has errors.  I did try
using the latest "media_build" from V4L but that didn't help.

So, I installed Mythbuntu 11.04 and with both cards I
still get the same problem.  Watching live TV with MythTV or with
mplayer on tuner A gives errors and tuner B is always flawless even
with "media_build" updates.

I honestly can't recall if when the failure first occurred if I had
done a routine kernel update at that time - though it would have just
been the usual 2.6.32 update that is in line with 10.04 maintenance.

I have tried everything imaginable to nail down the problem but can't
seem to fix it.  Even "options dvb-usb force_pid_filter_usage=1" seems
to improve the problem somewhat but the errors are still there.  I
have tried every firmware from 4.65 to 5.10, adjusting the PCI latency
from 32 to 96, fed each card directly from the antenna (taking the
splitter out of the loop), one card fitted, both cards fitted, kernel
and system upgrades (Mythbuntu 10.04 to 11.04), mplayer vs MythTV but
the results are always the same.  Tuner B is perfect, tuner A
corrupts when Tuner B is used.  There are no errors or warnings in
syslog or dmesg to
suggest anything has failed.

I'd appreciate any suggestions at this point as I am pretty unhappy
with the situation considering it *used* to work.
