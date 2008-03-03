Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JW4kq-0000hF-GN
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 08:06:32 +0100
Received: from [87.194.114.122] (helo=wolf.philpem.me.uk)
	by holly.castlecore.com with esmtp (Exim 4.68)
	(envelope-from <lists@philpem.me.uk>) id 1JW4kl-0000XK-KC
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 07:06:27 +0000
Received: from [10.0.0.8] (cheetah.homenet.philpem.me.uk [10.0.0.8])
	by wolf.philpem.me.uk (Postfix) with ESMTP id B68A51AFD9D5
	for <linux-dvb@linuxtv.org>; Mon,  3 Mar 2008 07:07:15 +0000 (GMT)
Message-ID: <47CBA377.6030304@philpem.me.uk>
Date: Mon, 03 Mar 2008 07:06:31 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47A98F3D.9070306@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
	<47C4661C.4030408@philpem.me.uk>
	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>
	<47C7076B.6060903@philpem.me.uk> <47C879BA.7080002@philpem.me.uk>
	<1204356192.6583.0.camel@youkaida> <47CA609F.3010209@philpem.me.uk>
	<8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>
	<47CAB51F.9030103@philpem.me.uk>
	<1204479088.6236.32.camel@youkaida>
	<47CAEFC3.2020305@philpem.me.uk>
	<gemini.jx4lel00dxyzk03qb.linux@youmustbejoking.demon.co.uk>
In-Reply-To: <gemini.jx4lel00dxyzk03qb.linux@youmustbejoking.demon.co.uk>
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

Darren Salt wrote:
> Which revision?

Huh. Rev 62 UHCI and Rev 65 EHCI. Maybe it's not the USB HA then.

> I have a VIA-based USB card in one computer here; I've had no problems with
> it whatsoever. It shows up as:
> 
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
> 00:10.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)

There's a VIA southbridge in this machine; it actually works quite nicely with 
most things - exceptions being my Icybox IB380 hard drive enclosure and a 
Minolta film scanner.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
