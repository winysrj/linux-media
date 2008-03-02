Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from anchor-post-32.mail.demon.net ([194.217.242.90])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JVxHm-0003Cd-Ux
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 00:08:03 +0100
Received: from youmustbejoking.demon.co.uk ([80.176.152.238]
	helo=pentagram.youmustbejoking.demon.co.uk)
	by anchor-post-32.mail.demon.net with esmtp (Exim 4.67)
	id 1JVxHj-000Blt-7z
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:07:59 +0000
Received: from [192.168.0.5] (helo=flibble.youmustbejoking.demon.co.uk)
	by pentagram.youmustbejoking.demon.co.uk with esmtp (Exim 4.63)
	(envelope-from <linux@youmustbejoking.demon.co.uk>)
	id 1JVxHc-0007Uk-2F
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:07:56 +0000
Date: Sun, 2 Mar 2008 23:03:57 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-dvb@linuxtv.org
Message-ID: <gemini.jx4lel00dxyzk03qb.linux@youmustbejoking.demon.co.uk>
In-Reply-To: <47CAEFC3.2020305@philpem.me.uk>
References: <47A98F3D.9070306@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
	<47C7076B.6060903@philpem.me.uk> <47C879BA.7080002@philpem.me.uk>
	<1204356192.6583.0.camel@youkaida> <47CA609F.3010209@philpem.me.uk>
	<8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>
	<47CAB51F.9030103@philpem.me.uk> <1204479088.6236.32.camel@youkaida>
	<47CAEFC3.2020305@philpem.me.uk>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

I demand that Philip Pemberton may or may not have written...

[snip]
> The blasted thing has a VIA USB controller on board - from experience it
> seems VIA are one of the few companies that still haven't managed to come
> up with a USB2 host-controller design that works properly without a filter
> driver sitting between the USB stack and the chip...

Which revision?

I have a VIA-based USB card in one computer here; I've had no problems with
it whatsoever. It shows up as:

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
00:10.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Output less CO2 => avoid massive flooding.    TIME IS RUNNING OUT *FAST*.

I am what I am and that's all that I am.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
