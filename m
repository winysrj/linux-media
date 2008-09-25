Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-37.mail.demon.net ([194.217.242.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1Kiz2F-0001cx-Np
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 00:10:08 +0200
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-37.mail.demon.net with esmtp (Exim 4.69)
	id 1Kiz2B-00015F-P1
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 22:10:03 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1Kiz0b-0005Sm-4k
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 23:08:30 +0100
Date: Thu, 25 Sep 2008 23:04:16 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <4FE9FBE3F0%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <607427.44664.qm@web52906.mail.re2.yahoo.com>
References: <607427.44664.qm@web52906.mail.re2.yahoo.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Hauppauge DVB USB2 Nova-TD stick has a new remote
	control.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I demand that Chris Rankin may or may not have written...

> The WinTV Nova-TD is shipping with a new credit card sized remote control
> that has 35 buttons. The key-codes for these buttons are as follows:
> 
>         { 0x1d, 0x00, KEY_0 },
>         { 0x1d, 0x01, KEY_1 },
[snip]
>         { 0x1d, 0x3d, KEY_POWER },

i.e. the same as for the 0x1E and 0x1F blocks used by older
Hauppauge-supplied remote controls.

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Output *more* particulate pollutants.      BUFFER AGAINST GLOBAL WARMING.

Be alert. The world needs more lerts.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
