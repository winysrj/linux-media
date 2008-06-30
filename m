Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sccmmhc91.asp.att.net ([204.127.203.211])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hwertz@avalon.net>) id 1KDBwB-0000oW-W3
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 07:28:28 +0200
Received: from voltron.homelinux.org (voltron.homelinux.org [192.168.0.1])
	by voltron.homelinux.org (8.14.2/8.14.2) with ESMTP id m5U5RdOs022939
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 00:27:39 -0500
Date: Mon, 30 Jun 2008 00:27:39 -0500 (CDT)
From: hwertz@avalon.net
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.64.0806300012100.22453@voltron.homelinux.org>
MIME-Version: 1.0
Subject: [linux-dvb] Pinnacle PCTV 801e SE?
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

      So, I got one of these Pinnacle PCTV 801e SE sticks.  This is USB, 
receives NTSC+ATSC+QAM.
      First, two questions:
      1)I want to know, is anyone working on a driver for  this?  I don't 
want to start if someone is like 99% finished.
      2)Anyone working on a DVB-driver-friendly XC5000 code?

      Per a post from months ago (and I confirmed this by cracking mine 
open) it uses a DiB0700 USB bridge chip, XC5000 tuner, S5H1411 8VSB/QAM 
demodulator,  CX25843 NTSC decoder, and Cirrus Logic 5340CZZ chip for 
something (original post speculated FM).

      Also, I've seen Jernej Tonejc's posts from May 3 where he's found i2c 
items at 0x19, 0x1a, 0x44 and 0x50.  I know not to mess with 0x50, that's 
the EEPROM (based both on later post on that thread, and on looking 
through source and seeing 0x50 is pretty common for the ROM.)

      So, there's a DVB driver for DiB0700-based sticks.  I see there's 
quite new code for S5H1411.  I don't see XC5000 support for DVB drivers, 
but cx88 driver has XC5000 support and XC3028 support (and, the cx88 and 
DVB drivers both look pretty clean!)  I was going to use DiB0700+XC3028 as 
a template to basically see what functions go where from the cx88 way of 
doing things, and then move XC5000 support straight over based on that. 
The CX2584x code I see in-tree looks like a mess so that'll wait for later 
(to be clear, I'm not disrespecting the CX2584x driver's code quality, the 
chip just appears to be one of those ones that needs quite a bit of 
hand-holding and general kicking to get things done... which I don't feel 
like unravelling and moving to DVB framework at the moment 8-)


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
