Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm26.bullet.mail.sp2.yahoo.com ([98.139.91.96]:25042 "HELO
	nm26.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750743Ab1K0Iyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 03:54:45 -0500
Message-ID: <1322384084.24357.YahooMailNeo@web112419.mail.gq1.yahoo.com>
Date: Sun, 27 Nov 2011 00:54:44 -0800 (PST)
From: music man <music_man1352000@yahoo.com.au>
Reply-To: music man <music_man1352000@yahoo.com.au>
Subject: saa7162 support status
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone

I apologise in advance if this is the wrong place to ask these questions.

I'm hoping somebody here could be so kind as to help me to understand what is happening with support for the NXP saa716x (saa7160, 7162) chipset - I'm totally confused...

1. Until 24 hours ago I was only aware of Manu Abraham's work (http://www.jusst.de/hg/saa716x/). I've been following his work for several years but his progress seems to have been quite slow. Given that there have been no updates for about a year I've been wondering whether he considers the driver complete, whether he doesn't have time to work on it at the moment, or whether the project is completely abandoned (?).

2. My [Windows] HTPC died so I figured it would be a good opportunity to try Ubuntu [again]. I discovered that Manu's driver won't compile with the new 3.x kernel in Ubuntu 11.10. I did some searching and found what seems to be a new and quite active repository that Andreas Regel is working on (http://powarman.dyndns.org/hg/v4l-dvb-saa716x/). Unfortunately that work is being done on the backported branch (so again, only compatible with kernel 2.6.x). What is the purpose of the backport branch and why is the saa716x development work being done on that branch?

3. Is there any way to test the latest saa716x code on Ubuntu 11.10? Alternatively when will the saa716x code be updated to support the 3.x kernel?

Thank you in advance for any comments!
mm
