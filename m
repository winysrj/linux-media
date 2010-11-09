Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:49631 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753864Ab0KITtH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 14:49:07 -0500
Content-Type: text/plain; charset="utf-8"
Date: Tue, 09 Nov 2010 20:49:04 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1268788483.1536.24.camel@destiny>
Message-ID: <20101109194904.107230@gmx.net>
MIME-Version: 1.0
References: <1268788483.1536.24.camel@destiny>
Subject: Re: Hauppauge WinTV HVR-1400 (XC3028L) firmware loading problem
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

beginning with kernel 2.6.34.? the HVR-1400 stops working completely.
If I run the scan utility, only the fist tuning works and after that it fails always. On the next run of the utility it says "Device or resource busy". Watching TV with vlc works never.

This bug persist up to the current developer kernel 2.6.37-rc1-git7.

Any ideas? Maybe it's a PCIe/ExpressCard related problem? Some more
popular USB sticks use the same chipset.

Regards,
Alina

-------- Original-Nachricht --------
> Datum: Wed, 17 Mar 2010 02:14:43 +0100
> Von: Alina Friedrichsen <x-alina@gmx.net>
> An: linux-media@vger.kernel.org
> Betreff: Hauppauge WinTV HVR-1400 firmware loading problem

> My kernel is 2.6.33.
> When I want to watch DVB-T with VLC, loading the firmwares stops after
> the following and don't see any pictures:
> 
> cx23885 0000:03:00.0: firmware: requesting xc3028L-v36.fw
> xc2028 3-0064: Loading 81 firmware images from xc3028L-v36.fw, type:
> xc2028 firmware, ver 3.6
> xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> 
> And hangs forever. Any retries has the same effect.
> 
> But if I start "scan /usr/share/dvb/dvb-t/de-Berlin" the tuning fails
> two times, then all firmwares load correctly and scanning works.
> 
> xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0064: Loading firmware for type=D2633 DTV78 (110), id
> 0000000000000000.
> xc2028 3-0064: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE
> HAS_IF_5200 (61000300), id 0000000000000000.
> 
> After that all other firmware loadings works fine and I can watch TV.
> 
> Any idea whats goes wrong? Is this a problem of the driver, or is my
> express card broken? I unfortunately has no other card to test.
> 
> Thanks!
> Alina
> 
> 
> 
