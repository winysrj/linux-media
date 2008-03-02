Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JVsmz-0004jf-Ts
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 19:19:58 +0100
Message-ID: <47CAEFC3.2020305@philpem.me.uk>
Date: Sun, 02 Mar 2008 18:19:47 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Nicolas Will <nico@youplala.net>
References: <47A98F3D.9070306@raceme.org>	
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>	
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>	
	<47C4661C.4030408@philpem.me.uk>	
	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>	
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>	
	<47C7076B.6060903@philpem.me.uk> <47C879BA.7080002@philpem.me.uk>	
	<1204356192.6583.0.camel@youkaida>
	<47CA609F.3010209@philpem.me.uk>	
	<8ad9209c0803020419s49e9f9f0i883f48cf857fb20c@mail.gmail.com>	
	<47CAB51F.9030103@philpem.me.uk>
	<1204479088.6236.32.camel@youkaida>
In-Reply-To: <1204479088.6236.32.camel@youkaida>
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
> I am shocked by all your problems.

I'm not.
The blasted thing has a VIA USB controller on board - from experience it seems 
VIA are one of the few companies that still haven't managed to come up with a 
USB2 host-controller design that works properly without a filter driver 
sitting between the USB stack and the chip...

I've got an uptime of 1 hour with the tuners idling (EIT scan on one of the 
tuners, other idle), but as soon as I start channel-hopping, the stupid thing 
falls over.

So for what it's worth, here's the spec of my machine:
   - Biostar TA690G mainboard; AMD 690G chipset. Onboard VGA disabled.
   - AMD Athlon64 X2 4000+ AM2 CPU
   - 2GB RAM, dual channel mode
   - WD Caviar-GP (WD5000AACS) 500GB Quiet Drive
   - LiteOn LH-20A1P DVD writer
   - Hauppauge HVR-3000 DVB-S/T hybrid tuner
   - Hauppauge Nova-T 500 dual DVB-T

And the OS:
   - Mythbuntu 8.04 alpha2 (Ubuntu Hardy) with latest updates
   - Kernel 2.6.24-11-generic
   - MythTV 0.21.0~fixes16259-0ubuntu1

I know a few folks are using 2.6.22 kernels.. just out of curiosity, has 
anyone got a Nova-T 500 working on 2.6.24? I'm just about to dig into the 
kernel changelog to see if anything's been changed relating to USB (especially 
anything to do with handling of VIA USB chipsets), though I doubt this is a 
kernel issue.

IIRC there was something related to USB bandwidth handling that went into the 
kernel not long ago... hmm, I wonder...

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
