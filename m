Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JVo7S-00029g-Vr
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 14:20:47 +0100
Message-ID: <47CAA9A9.5040608@philpem.me.uk>
Date: Sun, 02 Mar 2008 13:20:41 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Patrik Hansson <patrik@wintergatan.com>
References: <47A98F3D.9070306@raceme.org>	<1202403104.5780.42.camel@eddie.sth.aptilo.com>	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>	<47C4661C.4030408@philpem.me.uk>	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>	<47C7076B.6060903@philpem.me.uk>
	<47C879BA.7080002@philpem.me.uk>	<1204356192.6583.0.camel@youkaida>
	<47CA609F.3010209@philpem.me.uk>
	<8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>
In-Reply-To: <8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>
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

Patrik Hansson wrote:
> When i started using options usbcore autosuspend=-1 i deactivated debug=15
> Will reactivate it again and reset my clock also.

Just had a USB disconnect..

Switched MythTV to BBC HD, CPU load hit 100% and video jittered like mad. 
Switched back to Freeview via the Nova, both tuners down. USB disconnect and 
I2C errors in dmesg. Killed off mythbackend and the T500 re-attached, but 
wouldn't work (continuous disconnects whenever I loaded mythbackend) until I 
killed mythbackend, rmmod'ed dvb-usb-dib0700, then modprobed dvb-usb-dib0700 
and restarted mythbackend.

I've disabled EIT scanning on all but one of the Nova-T500 tuners, and set 
"open on demand" for both Nova-T500 tuners and both HVR-3000 tuners.

If Myth isn't holding the tuner open, maybe it'll be a little more tolerant of 
this kind of glitch.. but it doesn't seem to switch to another tuner on the 
same source if one is dead, it just keeps hammering the same tuner over and 
over until it gives up... Urgh.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
