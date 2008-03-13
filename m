Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1JZbFt-0001Hd-1S
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 01:25:09 +0100
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JZbFm-0007ND-Om
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 00:25:02 +0000
Received: from c83-254-20-12.bredband.comhem.se ([83.254.20.12])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 13 Mar 2008 00:25:02 +0000
Received: from elupus by c83-254-20-12.bredband.comhem.se with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 13 Mar 2008 00:25:02 +0000
To: linux-dvb@linuxtv.org
From: elupus <elupus@ecce.se>
Date: Thu, 13 Mar 2008 01:14:39 +0100
Message-ID: <timjkg4t68k0.u9vss0x6vh17$.dlg@40tude.net>
Mime-Version: 1.0
Subject: [linux-dvb] STK7700-PH ( dib7700 + ConexantCX25842 + Xceive XC3028 )
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

Hi, i'm trying to get a AOPEN mc770a up and running. 

>From what i can find it should be the same as a DIBCOM 7700-PH. This should
contain dib7700 + ConexantCX25842 + Xceive XC3028 according to their own
docs.

After following this thread with some minor alterations to match my card's
usbid parameters.
http://thread.gmane.org/gmane.linux.drivers.dvb/39269/focus=39298

I've manged to get the card detected and it loads the driver accordings to
dmesg log. (will post a full log later, currently that machine isn't
running).

No errors show up untill i try to tune, then i get this logged in log.

dib0700: stk7700ph_xc3028_callback: XC2028_TUNER_RESET 0
xc2028 1-0061: i2c output error: rc = -5 (should be 64)
xc2028 1-0061: -5 returned from send
xc2028 1-0061: Error -22 while loading base firmware

I traced it down to where it tries to write to the i2c address 0x61 which
was setup for the XC3028. Is there any posibility that this address should
be something else?

If anybody has some experience with this types of card and can give me
hand, let me know.

Regards
Joakim


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
