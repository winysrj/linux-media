Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JVjG2-0007tE-1s
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 09:09:18 +0100
Message-ID: <47CA609F.3010209@philpem.me.uk>
Date: Sun, 02 Mar 2008 08:09:03 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Nicolas Will <nico@youplala.net>
References: <47A98F3D.9070306@raceme.org>	
	<1202326173.20362.23.camel@youkaida>	<1202327817.20362.28.camel@youkaida>	
	<1202330097.4825.3.camel@anden.nu>	<47AB1FC0.8000707@raceme.org>	
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>	
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>	
	<47C4661C.4030408@philpem.me.uk>	
	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>	
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>	
	<47C7076B.6060903@philpem.me.uk> <47C879BA.7080002@philpem.me.uk>
	<1204356192.6583.0.camel@youkaida>
In-Reply-To: <1204356192.6583.0.camel@youkaida>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

Nicolas Will wrote:
> You should really stick to the 1.10 firmware. 03-pre1 was an earlier
> test and has more issues.

Well, I've figured out what was going on.
Seems if you run 'make' against the source tree with one kernel, it will 
always build modules for said kernel until you run 'make distclean'. I started 
by building for 2.6.24-8-generic, then upgraded to -10-generic, then to 
-11-generic, and only did a 'make clean; make; sudo make install' when I 
rebuilt v4l-dvb, as this worked for Madwifi.

So to summarise, if you're going to reuse the same source tree for multiple 
kernels, make distclean before making the drivers, or it'll build for the last 
kernel you built for... Not sure if it installs to the running kernel, but it 
certainly doesn't use the headers for the running kernel...

But at least the card seems to be behaving now. Up 10 hours with:

options dvb-usb-dib0700 debug=15 force_lna_activation=1
options dvb_usb disable_rc_polling=1
options usbcore autosuspend=-1

I've also blacklisted dvb-usb-dib0700 and modprobe'd it in an rc-script, so my 
HVR-3000 ends up as device 0 and the two T-500 tuners end up as devices 1 and 
2; said shell script also sets up symlinks for the 1st and 2nd front-ends on 
the HVR to devices 10 and 11, because MythTV doesn't like the idea of a card 
having multiple front-ends...

The clock is once again running...

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
