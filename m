Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KXcz1-00062T-J9
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 16:23:52 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K65000GNUMQ32X0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 25 Aug 2008 10:23:16 -0400 (EDT)
Date: Mon, 25 Aug 2008 10:23:14 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48B285BA.2090101@singlespoon.org.au>
To: Paul Chubb <paulc@singlespoon.org.au>
Message-id: <48B2C052.5030905@linuxtv.org>
MIME-version: 1.0
References: <48B285BA.2090101@singlespoon.org.au>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] leadtek dtv1800 h support
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

Paul Chubb wrote:
> Hi,
>     a few months ago Miroslav Sustek created a patch for this card 
> against Markus Rechberger's v4l repository. This patch is attached as 
> dtv1800.patch. A patched and compiled set of drivers fails on ubuntu 
> hardy heron 8.04 with lots of symbol errors. Hardy is running 2.6.24.19. 
> I have attempted to backport this patch to the current v4l tree with 
> limited success. The driver loads however fails to do anything useful. 
> My patch is attached as dtv1800h-v4l.patch.
> 
> I *think* the issue is with loading firmware. The tuner-xc2028.c 
> function check_firmware is passed a frontend without the firmware name - 
> producing the error shown in the dmesg listing below. If I hack the 
> function and hardcode the firmware file name, it attempts to load the 
> firmware but fails when it tries to read back.
> 
> Now that I am totally out of my depth I am not sure what to try next. 
> Any help will be gratefully received.

Don't call cx_write() inside the gpio card setup, you're potentially 
destroying the other bits, it's risky.

+	case CX88_BOARD_WINFAST_DTV1800H:
+		cx_write(MO_GP1_IO, 0x101010);  //gpio 12 = 1: powerup XC3028
+		mdelay(250);
+		cx_write(MO_GP1_IO, 0x101000);  //gpio 12 = 0: powerdown XC3028
+		mdelay(250);
+		cx_write(MO_GP1_IO, 0x101010);  //gpio 12 = 1: powerup XC3028
+		mdelay(250);
+		break;


Call cx_clear() and cx_set() instead, for the specific gpio bit (12) 
that you need.

- Steve





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
