Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34227 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1AOMzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 07:55:32 -0500
Received: by iyj18 with SMTP id 18so3293398iyj.19
        for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 04:55:32 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 15 Jan 2011 13:55:32 +0100
Message-ID: <AANLkTi=8aJ=C76+55DY7XOeinW9DWB01gRppH6gb391r@mail.gmail.com>
Subject: Technotrend C-2300, LOCK but no data on encrypted channels
From: Magion <magion@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi!

I have a Technotrend C-2300 which have been working great with MythTV
on Mythbuntu 8.10 for both FTA and encrypted channels.
About two weeks ago I decided to reinstall my HTPC and install Gentoo
instead, as that is the distro I usually prefer...
but whatever I tried, I just couldn't get the C-2300 to work with
encrypted channels.
I tried kernel 2.6.32, 2.6.34 and 2.6.36, and I always get a lock on
the encrypted channels, but there seems like I get no data.
So I then tried installing Mythbuntu again, but now I can't get it to
work with that either, it's the same error.
I have every Mythbuntu version from 8.04 to 10.10, and whatever I do I
just get the same result.
So then I tried to put in my old Technotrend C-1500 instead, and with
that I get LOCK and picture/audio, but, for some reason
that card only get about 55% signal, whereas the C-2300 always get
atleast 80%... so some channels are unwatchable with the C-1500.

Can someone please give me some more advice on what I can try to get
the C-2300 to get data on encrypted channels again?
(btw, I've tried every firmware I could find for it, all with the same results)
I'm starting to think that the card somehow is broken... which would
be odd, as all I did was reinstall, and it works perfectly for FTA
channels.
Mplayer says it gets a TS stream, but on encrypted channels it just
hangs there, whereas on FTA channels it finds video and audio and then
plays the stream.
Oh, I've also tried with both CI and softcam, and it says it gets the
correct key and LOCK, but still no data.
I'm out of ideas!

If you need some logs or some other info or anything, I'll be happy to post it.

/Mattias
