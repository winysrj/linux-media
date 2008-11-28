Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay14.mail.uk.clara.net ([80.168.70.194])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <news@onastick.clara.co.uk>) id 1L64sq-00018g-RJ
	for linux-dvb@linuxtv.org; Fri, 28 Nov 2008 16:03:55 +0100
Received: from [79.123.71.101] (port=10177 helo=mail.onasticksoftware.net)
	by relay14.mail.uk.clara.net with esmtp (Exim 4.69)
	(envelope-from <news@onastick.clara.co.uk>) id 1L64sl-0006B1-H1
	for linux-dvb@linuxtv.org; Fri, 28 Nov 2008 15:03:48 +0000
Received: from onasticksoftware.net (lapdog.onasticksoftware.net [192.168.0.3])
	by mail.onasticksoftware.net (Postfix) with ESMTP id 9584C8C8A4
	for <linux-dvb@linuxtv.org>; Fri, 28 Nov 2008 15:03:50 +0000 (GMT)
Message-ID: <XE4pEqAEgAMJFw9N@onasticksoftware.net>
Date: Fri, 28 Nov 2008 15:02:28 +0000
To: linux-dvb@linuxtv.org
From: jon bird <news@onastick.clara.co.uk>
References: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>
	<492A8A43.4060001@rusch.name> <u0lnYVBoGwKJFwJg@onasticksoftware.net>
	<1227556939.16187.0.camel@youkaida>
	<100c0ba70811241329s594e3112h467e1deff9d3c1ac@mail.gmail.com>
	<1227644366.6949.18.camel@watkins-desktop>
	<412bdbff0811251229m7e36ed33jade32457a4c37185@mail.gmail.com>
	<492E5EC9.30308@rusch.name> <1227819747.7014.58.camel@watkins-desktop>
In-Reply-To: <1227819747.7014.58.camel@watkins-desktop>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Nova/dib0700/i2C write failed
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

In article <1227819747.7014.58.camel@watkins-desktop>, Robert Watkins 
<robert@watkin5.net> writes
>On Thu, 2008-11-27 at 09:48 +0100, Holger Rusch wrote:
>  As written before.
>  I got an MB with SB700 USB Chipset and it seems to have the same
>  problems as the SB600 with the USB ports (disconnects here and
>  then).
>  The SB400 seems to have them also?
>
[...]

>My Hauppauge Nova-T 500 Dual DVB-T is a PCI card with built in VIA USB
>controller.
>
>watkins@watkins-desktop:~$ lspci -vv | grep -i usb
>00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host
>Controller (rev 80) (prog-if 10 [OHCI])
>00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host
>Controller (rev 80) (prog-if 10 [OHCI])
>00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host
>Controller (rev 80) (prog-if 20 [EHCI])
>02:01.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
>Controller (rev 62) (prog-if 00 [UHCI])
> Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>02:01.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
>Controller (rev 62) (prog-if 00 [UHCI])
> Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>02:01.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
>(prog-if 20 [EHCI])
> Subsystem: VIA Technologies, Inc. USB 2.0
>
Here's mine:

/usr/local/sbin/lspci -v | grep -i usb
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80) (prog-if 00 [UHCI])
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80) (prog-if 00 [UHCI])
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80) (prog-if 00 [UHCI])
00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82) (prog-if 
20 [EHCI])

so could be the same chipset as on your PCI card but it's not an SBxxx 
chipset. If it *is* the controller mind you would expect it to be 
susceptible to all sorts of USB devices not just this one.

-- 
== jon bird - software engineer
== <reply to address _may_ be invalid, real mail below>
== <reduce rsi, stop using the shift key>
== posted as: news 'at' onastick 'dot' clara.co.uk


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
