Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:49287 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab0AaQc7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 11:32:59 -0500
Subject: Re: CAM appears to introduce packet loss
From: Abylai Ospan <aospan@netup.ru>
To: Marc Schmitt <marc.schmitt@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <b36f333c1001310825n6ae6e5dbg45a0cf135d2e89e@mail.gmail.com>
References: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
	 <1264941827.28401.3.camel@alkaloid.netup.ru>
	 <b36f333c1001310707w3397a5a6i758031262d8591a7@mail.gmail.com>
	 <b36f333c1001310723p561d7a69x955b2d4a6d9b4e1@mail.gmail.com>
	 <1264951975.28401.8.camel@alkaloid.netup.ru>
	 <b36f333c1001310825n6ae6e5dbg45a0cf135d2e89e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 19:31:23 +0300
Message-ID: <1264955483.28401.32.camel@alkaloid.netup.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-01-31 at 17:25 +0100, Marc Schmitt wrote:
> Compiling from source made me stumble across
> http://www.mail-archive.com/ubuntu-devel-discuss@lists.ubuntu.com/msg09422.html
> I just left out the firedtv driver as recommended.
> 
> I'm getting the following kernel output after enabling dvb_demux_speedcheck:
> [  330.366115] TS speed 40350 Kbits/sec
> [  332.197693] TS speed 40085 Kbits/sec
> [  334.011856] TS speed 40528 Kbits/sec
> [  335.843466] TS speed 40107 Kbits/sec
> [  337.665411] TS speed 40261 Kbits/sec
> [  339.496959] TS speed 40107 Kbits/sec
> [  341.318289] TS speed 40350 Kbits/sec
> 
> Do you think the CI/CAM can not handle that?
40 Mbit/sec is high bitrate for some CAM's. 

You can:
1. Try to contact with CAM vendor and check maximum bitrate which can be
passed throught this CAM
2. Try to find reception card with hardware PID filtering and pass only
interesting PID's throught CAM. Bitrate should be equal to bitrate of
one channel - aprox. 4-5 mbit/sec ( not 40 mbit/sec).
3.may be some fixes can be made on TS output from demod. Demod's usually
has tunable TS output timings/forms. You should check TS clock by
oscilloscope and then try to change TS timings/forms in demod.

-- 
Abylai Ospan <aospan@netup.ru>
NetUP Inc.

