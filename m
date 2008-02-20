Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-30.mail.demon.net ([194.217.242.88])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JReMN-000581-Kq
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 03:06:59 +0100
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-30.mail.demon.net with esmtp (Exim 4.67)
	id 1JReMJ-000AbK-2i
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 02:06:56 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JReMF-0005aX-37
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 02:06:55 +0000
Date: Wed, 20 Feb 2008 02:05:29 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <4F7949E774%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
MIME-Version: 1.0
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
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

I demand that Patrick Boettcher may or may not have written...

> That indeed looks OK to my eyes. I have to admit that I never took a look 
> into the IR-code from DiBcom...

> In any case, especially to that problem with "unknown key code" I think it 
> is time to change the IR-behavior of the DVB-USB.

> My problem is, I don't know how.

However it's done, it should involve ir-common.

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Lobby friends, family, business, government.    WE'RE KILLING THE PLANET.

Try `stty 0' - it works much better.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
