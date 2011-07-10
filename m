Return-path: <mchehab@localhost>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51650 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab1GJThT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 15:37:19 -0400
Received: by bwd5 with SMTP id 5so2780795bwd.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 12:37:17 -0700 (PDT)
Date: Sun, 10 Jul 2011 21:37:14 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-media@vger.kernel.org
Subject: Re: [Patch] dvb-apps: add test tool for DMX_OUT_TSDEMUX_TAP
Message-ID: <20110710213714.5b60a7c7@susi.home.s3e.de>
In-Reply-To: <201107101645.47915.remi@remlab.net>
References: <20110710124303.26655303@susi.home.s3e.de>
	<201107101645.47915.remi@remlab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Am Sun, 10 Jul 2011 16:45:46 +0300
schrieb "Rémi Denis-Courmont" <remi@remlab.net>:

> Le dimanche 10 juillet 2011 13:43:03 Stefan Seyfried, vous avez écrit :
> > Hi all,
> > 
> > I patched test_dvr to use DMX_OUT_TSDEMUX_TAP and named it test_tapdmx.
> > Might be useful for others, too :-)
> > This is my first experience with mercurial, so bear with me if it's
> > totally wrong.
> 
> Did it work for you? We at VideoLAN.org could not get DMX_OUT_TSDEMUX_TAP to 
> work with any of three distinct device/drivers (on two different delivery 
> systems). We do get TS packets, but they seem to be partly corrupt.

Yes, worked today on plain openSUSE Factory, kernel 3.0.0-rc5-1-desktop

I did read your post to the list and actually looked up on how to use the
interface in the vlc code you linked ;-).

My device is a TeVii S660 USB DVB-S2

usb 2-1: New USB device found, idVendor=9022, idProduct=d660
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: DVBS2BOX
usb 2-1: Manufacturer: TBS-Tech
dvb-usb: found a 'TeVii S660 USB' in cold state, will try to load a firmware

I successfully recorded an audio and a video PID from Astra 19.2E
transponder 11836 MHz horizontal

Trying to record the complete TS (pid 0x2000) did produce dropouts, but
that might be due to insufficient buffer size or something like that.

In general the DMX_OUT_TSDEMUX_TAP interface worked well.

Just try it with my test_tapdmx :-)
-- 
Stefan Seyfried

"Dispatch war rocket Ajax to bring back his body!"
