Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50364 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1K0JEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 04:04:08 -0500
Received: by wwp14 with SMTP id 14so6759717wwp.1
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2011 01:04:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322384084.24357.YahooMailNeo@web112419.mail.gq1.yahoo.com>
References: <1322384084.24357.YahooMailNeo@web112419.mail.gq1.yahoo.com>
Date: Sun, 27 Nov 2011 14:34:05 +0530
Message-ID: <CAHFNz9LPbWGYXFpiA=2EFiOruPqcJgbaRLobRJCyredv_tzz+Q@mail.gmail.com>
Subject: Re: saa7162 support status
From: Manu Abraham <abraham.manu@gmail.com>
To: music man <music_man1352000@yahoo.com.au>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 27, 2011 at 2:24 PM, music man
<music_man1352000@yahoo.com.au> wrote:
> Hello everyone
>
> I apologise in advance if this is the wrong place to ask these questions.
>
> I'm hoping somebody here could be so kind as to help me to understand what is happening with support for the NXP saa716x (saa7160, 7162) chipset - I'm totally confused...
>
> 1. Until 24 hours ago I was only aware of Manu Abraham's work (http://www.jusst.de/hg/saa716x/). I've been following his work for several years but his progress seems to have been quite slow. Given that there have been no updates for about a year I've been wondering whether he considers the driver complete, whether he doesn't have time to work on it at the moment, or whether the project is completely abandoned (?).


It's not abandoned. Quite active development on that front, just
that the public repository is not updated. It is supposed to be merged
sometime soon.


>
> 2. My [Windows] HTPC died so I figured it would be a good opportunity to try Ubuntu [again]. I discovered that Manu's driver won't compile with the new 3.x kernel in Ubuntu 11.10. I did some searching and found what seems to be a new and quite active repository that Andreas Regel is working on (http://powarman.dyndns.org/hg/v4l-dvb-saa716x/). Unfortunately that work is being done on the backported branch (so again, only compatible with kernel 2.6.x). What is the purpose of the backport branch and why is the saa716x development work being done on that branch?


The development tools, hardware debugger and software associated
have been really tied to some kernel versions, ie some tools require
specific versions and hence for development reasons, the kernel version
hasn't moved on ahead.


>
> 3. Is there any way to test the latest saa716x code on Ubuntu 11.10? Alternatively when will the saa716x code be updated to support the 3.x kernel?


Sometime very soon, as far as I can say.

Regards,
Manu
