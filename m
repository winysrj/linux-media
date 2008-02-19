Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fides.aptilo.com ([62.181.224.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1JRaEB-00026O-9T
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 22:42:15 +0100
From: Jonas Anden <jonas@anden.nu>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
Date: Tue, 19 Feb 2008 22:41:04 +0100
Message-Id: <1203457264.8019.6.camel@anden.nu>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
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

> In any case, especially to that problem with "unknown key code" I think it 
> is time to change the IR-behavior of the DVB-USB.
> 
> My problem is, I don't know how.
> 
> My naive idea would be, that the IR-code is reporting each key (as raw as 
> possible) without mapping it to an event to the event interface and then 
> someone, somewhere is interpreting it. Also forward any repeat-attribute.

I would suggest creating a netlink device which lircd (or similar) can
read from. I haven't really looked further into it since I never really
intended on having the IR support from the DVB devices; my brewing
mythtv frontend system is both diskless and tunerless so I have a USB
MCE IR dongle instead.

  // J


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
