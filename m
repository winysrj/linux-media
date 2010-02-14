Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f216.google.com ([209.85.218.216]:34986 "EHLO
	mail-bw0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0BNCES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 21:04:18 -0500
Received: by bwz8 with SMTP id 8so1945751bwz.38
        for <linux-media@vger.kernel.org>; Sat, 13 Feb 2010 18:04:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B775931.8020208@yahoo.it>
References: <4B775931.8020208@yahoo.it>
Date: Sat, 13 Feb 2010 21:04:16 -0500
Message-ID: <829197381002131804p184ad1b6ndf11e1d713e9f335@mail.gmail.com>
Subject: Re: Possible em28xx regression for Pinnacle Dazzle Tv Hybrid Stick
	320E
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: SebaX75 <sebax75@yahoo.it>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 13, 2010 at 9:00 PM, SebaX75 <sebax75@yahoo.it> wrote:
> Hi,
> I've already wrote on the problem that I'll go to explain and that was
> already solved by Devin. It was solved and a call for tester was done, and
> all was working (em28xx DVB modeswitching change); logically I've used
> actual tree (updated with hg today).
> Now the problem: with scandvb, during a scan for channels, the adapter is
> able to recognize and tune only the first mux found in the list, for all the
> other mux the output is "tuning failed"; I can change the mux order, but
> always only first mux is tuned and channel recognized.

I would have to fall on my sword with this one - the modeswitching
changes weren't committed because of Mauro's concerns about power
management (and while I think he is incorrect in this regard, I never
took the time to prove it).  And I failed to check in the one line
change which was strobing the reset when the dvb gpio get called
(which was what was causing the zl10353 driver state to get out of
sync with the chip).

In other words, neither fix ever actually made it into the mainline
v4l-dvb tree.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
