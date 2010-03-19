Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751421Ab0CSOZg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 10:25:36 -0400
Subject: Re: cx23885: Hauppauge WinTV HVR-1400 firmware loading problem
From: Alina Friedrichsen <x-alina@gmx.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1268788483.1536.24.camel@destiny>
References: <1268788483.1536.24.camel@destiny>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 15:25:33 +0100
Message-ID: <1269008733.1645.8.camel@destiny>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No one has got this card and can say if this is normal (on a stable
kernel) or my hardware is broken?

Regards
Alina

Am Mittwoch, den 17.03.2010, 02:14 +0100 schrieb Alina Friedrichsen:
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


