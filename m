Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JVtUf-0000fl-Tz
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 20:05:10 +0100
Message-ID: <47CAFA58.2010608@philpem.me.uk>
Date: Sun, 02 Mar 2008 19:04:56 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Nicolas Will <nico@youplala.net>
References: <47A98F3D.9070306@raceme.org>	
	<1202326173.20362.23.camel@youkaida>	<1202327817.20362.28.camel@youkaida>	
	<1202330097.4825.3.camel@anden.nu> <47AB1FC0.8000707@raceme.org>	
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>	
	<8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>	
	<47C4661C.4030408@philpem.me.uk>	
	<8ad9209c0802261137g1677a745h996583b2facb4ab6@mail.gmail.com>	
	<8ad9209c0802271138o2e0c00d3o36ec16332d691953@mail.gmail.com>	
	<47C7076B.6060903@philpem.me.uk>
	<1204227832.21493.11.camel@youkaida>
In-Reply-To: <1204227832.21493.11.camel@youkaida>
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
> You do know that the cx24123 module has nothing to do with the
> Nova-t-500, don't you?

I know. It's for the HVR-3000's satellite demux.

> Would you have a DVB-S card in the system as well?

See above :)

> Other than this issue, how's the stability of 0.21 in Hardy?
> I'm itching... After al,l I ran Gutsy since alpha 2, for hardware
> support reasons, but I have no real motivation apart from "I want to try
> the latest and greatest" today.

Myth itself is quite stable, but Mythbuntu had some issues with the initial 
8.04a2 release -- mostly with VNC and setting up the Myth transcoding daemon 
('mkdir /var/lib/mythdvd/temp; chmod 777 /var/lib/mythdvd/temp' as root fixed 
it for me). The LIRC config files for the Nova-T500's remote are a bit 
mangled, and some buttons don't work by default.

Other than that, ripping DVDs to MPEG files and playing them back results in 
issues with A/V sync; switching the player to "default player" in File Types 
seems to have cured that.

Stability-wise, it puts MediaPortal to shame. Feature-wise, it's got 
everything I need. Once I get the Nova-T500 to behave itself, and MythTV to 
hibernate (or even shut down completely) and set an ACPI wakeup timer, I'll 
consider the project 'done' :)

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
