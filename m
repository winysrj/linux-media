Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail18.syd.optusnet.com.au ([211.29.132.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <russell@kliese.wattle.id.au>) id 1JN6rx-0000Wf-69
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 14:32:49 +0100
Received: from [192.168.0.4] (c220-239-70-96.rochd3.qld.optusnet.com.au
	[220.239.70.96]) (authenticated sender russell.kliese)
	by mail18.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m17DWgGE023897
	for <linux-dvb@linuxtv.org>; Fri, 8 Feb 2008 00:32:43 +1100
Message-ID: <47AB0A20.2020000@kliese.wattle.id.au>
Date: Thu, 07 Feb 2008 23:39:44 +1000
From: Russell Kliese <russell@kliese.wattle.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] MSI TV@nywhere A/D v1.1 mostly working
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I just wanted to report on my progress with the MSI TV@nywhere A/D card
v1.1 in case anyone has some ideas that might help getting this card
working 100%.

I've posted a picture of my card at the following URL:
http://ringo.com/photos/photo.html?photoId=253664472 . The chipset
includes: Philips TDA10046A digital decder, Philips SAA7131E analog
decoder and a 8275AC1 tuner.

I am able to get most functions working using the latest drivers (as of
today - hg clone http://linuxtv.org/hg/v4l-dvb). I'm running Mythbuntu
with the 2.6.22-14-generic kernel. I followed the instructions from
http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers#Case_2:_Installation_of_LinuxTV_Drivers_Required 

.

As this card isn't currently recognized (1131:7133), I used the
following to load the driver: modprobe saa7134 card=109. I choose
card=109 because this is for a reference design and there are other
cards with the same combination of chips as the MSI card that work using
this. Note that firmware must be obtained using the latest
get_dvb_firmware script (also included with the latest drivers).
Firmware obtained with an earlier version of this script didn't work.

Analog TV worked without a problem (even with the older drivers).

There is still a problem with the digital decoder. Sometimes it works
fine (I can scan for channels and can run tzap to view a channel using
mplayer). However, sometimes these commands don't work. I've noticed the
following when running dmesg:


[ 6318.055521] tda1004x: found firmware revision 20 -- ok
[ 6322.661170] tda1004x: setting up plls for 48MHz sampling clock
[ 6322.856931] tda1004x: found firmware revision 20 -- ok
[ 6410.414553] tda1004x: setting up plls for 48MHz sampling clock
[ 6410.610246] tda1004x: found firmware revision 20 -- ok
[ 6629.945993] tda1004x: setting up plls for 48MHz sampling clock
[ 6630.173438] tda1004x: found firmware revision 0 -- invalid
[ 6630.173451] tda1004x: trying to boot from eeprom
[ 6630.541243] tda1004x: found firmware revision 20 -- ok
[ 6658.598487] tda1004x: setting up plls for 48MHz sampling clock
[ 6658.834190] tda1004x: found firmware revision 0 -- invalid
[ 6658.834202] tda1004x: trying to boot from eeprom
[ 6659.201994] tda1004x: found firmware revision 0 -- invalid
[ 6659.202007] tda1004x: waiting for firmware upload...
[ 6671.615390] tda1004x: found firmware revision 0 -- invalid
[ 6671.615403] tda1004x: firmware upload failed
[ 6700.212279] tda1004x: setting up plls for 48MHz sampling clock
[ 6700.448050] tda1004x: found firmware revision 0 -- invalid
[ 6700.448060] tda1004x: trying to boot from eeprom
[ 6700.815855] tda1004x: found firmware revision 0 -- invalid
[ 6700.815868] tda1004x: waiting for firmware upload...
[ 6715.188208] tda1004x: timeout waiting for DSP ready
[ 6715.228185] tda1004x: found firmware revision 0 -- invalid
[ 6715.228192] tda1004x: firmware upload failed

I suspect that the card is failing to work because the firmware
sometimes isn't being uploaded for some reason. Does anybody have any
ideas why or what I could do to try and fix this?

Hopefully this problem can be sorted out and another card can be added
to the list of supported DVB-T cards. Yay!

Cheers,

Russell


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
