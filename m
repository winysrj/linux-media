Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc3-s26.bay0.hotmail.com ([65.54.246.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aegyssus@hotmail.com>) id 1Kfy6f-0003AS-05
	for linux-dvb@linuxtv.org; Wed, 17 Sep 2008 16:34:13 +0200
Message-ID: <BLU134-DAV80904DC18112615D393CBD34C0@phx.gbl>
From: "Virgil Mocanu" <aegyssus@hotmail.com>
To: <linux-dvb@linuxtv.org>
References: <20080916042956.711261CE825@ws1-6.us4.outblaze.com>
Date: Wed, 17 Sep 2008 10:33:30 -0400
MIME-Version: 1.0
Cc: stev391@email.com
Subject: Re: [linux-dvb] LeadTek PxPVR2200 drivers
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

Hi Steven,
Many thanks for your answer.
The card is analog only. So no DVB of any kind is supported.
I tried several <card> options including the Leadtek one that you suggested. 
I got not luck so far... The typical behaviour is that the cx23885 driver 
loads, but fails to initialize the frontend. It generates the following log 
messages and then crashes the kernel when rmmod.
===
cx23885 driver version 0.0.1 loaded
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 18 (level, low) -> IRQ 18
CORE cx23885[0]: subsystem: 107d:6f21, board: Leadtek Winfast PxDVR3200 H 
[card=12,insmod option]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
cx23885[0]: cx23885 based dvb card
cx23885[0]: frontend initialization failed
cx23885_dvb_register() dvb_register failed err = -1
cx23885_dev_setup() Failed to register dvb on VID_C
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:07:00.0, rev: 2, irq: 18, latency: 0, mmio: 
0xfe800000
PCI: Setting latency timer of device 0000:07:00.0 to 64
===
I started an Wiki page for this card:
http://www.linuxtv.org/wiki/index.php/Leadtek_Winfast_PxPVR_2200

Regards,
aegyssus

----- Original Message ----- 
From: <>
To: <aegyssus@hotmail.com>
Cc: <linux-dvb@linuxtv.org>
Sent: Tuesday, September 16, 2008 12:29 AM
Subject: Re: [linux-dvb] LeadTek PxPVR2200 drivers


> Hi,
> I am just wondering if anybody succeeded to make a LeadTek PxPVR2200 
> work...
> It's using Conexant CX23885+CX23417 + Xceive silicon tuner.
> The card is mostly sold in Eastern Europe but it is only coming with 
> Windows
> drivers and v4l does not recognize it:
> ========================
> cx23885 driver version 0.0.1 loaded
> ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 18 (level, low) -> IRQ 18
> cx23885[0]: Your board isn't known (yet) to the driver.  You can
> cx23885[0]: try to pick one of the existing card configs via
> cx23885[0]: card=<n> insmod option.  Updating to the latest
> cx23885[0]: version might help as well.
> cx23885[0]: Here is a list of valid choices for the card=<n> insmod 
> option:
> cx23885[0]:    card=0 -> UNKNOWN/GENERIC
> cx23885[0]:    card=1 -> Hauppauge WinTV-HVR1800lp
> cx23885[0]:    card=2 -> Hauppauge WinTV-HVR1800
> cx23885[0]:    card=3 -> Hauppauge WinTV-HVR1250
> cx23885[0]:    card=4 -> DViCO FusionHDTV5 Express
> cx23885[0]:    card=5 -> Hauppauge WinTV-HVR1500Q
> cx23885[0]:    card=6 -> Hauppauge WinTV-HVR1500
> cx23885[0]:    card=7 -> Hauppauge WinTV-HVR1200
> cx23885[0]:    card=8 -> Hauppauge WinTV-HVR1700
> cx23885[0]:    card=9 -> Hauppauge WinTV-HVR1400
> cx23885[0]:    card=10 -> DViCO FusionHDTV7 Dual Express
> cx23885[0]:    card=11 -> DViCO FusionHDTV DVB-T Dual Express
> cx23885[0]:    card=12 -> Leadtek Winfast PxDVR3200 H
> CORE cx23885[0]: subsystem: 107d:6f21, board: UNKNOWN/GENERIC
> [card=0,autodetected]
> cx23885[0]: i2c bus 0 registered
> tuner' 2-0061: chip found @ 0xc2 (cx23885[0])
> cx23885[0]: i2c bus 1 registered
> tvaudio' 3-004c: tea6420 found @ 0x98 (cx23885[0])
> cx23885[0]: i2c bus 2 registered
> cx23885_dev_checkrevision() Hardware revision = 0xb0
> cx23885[0]/0: found at 0000:07:00.0, rev: 2, irq: 18, latency: 0, mmio:
> 0xfe800000
> PCI: Setting latency timer of device 0000:07:00.0 to 64
> ========================
>
> No video device is created for this card therefore it's totally unusable
> under Linux.
> I played with the card by changing <card> option but none of them worked. 
> I
> used the latest mercurial drivers but it did not help.
>
> lspci -vvv returns this:
---Snip---
> ========================
>
> Many thanks for any suggestion,
> aegyssus
>


Aegyssus,
Does this card handle DVB? If so try loading the cx23885 with the option 
card=12.

If it doesn't you will have to wait a little longer for linux support or try 
writing your own driver.

If you have some spare time, please create a wiki page for this card similar 
to this one:
http://linuxtv.org/wiki/index.php/Leadtek_Winfast_PxDVR_3200_H

and also update:
http://linuxtv.org/wiki/index.php/Leadtek

The driver's currently for the cx23885 chipset aren't stable enough to 
reliably run the analog (well in my personal experience, and analog is not a 
high priority for me).
However there is some patches floating around that add support for other 
similar cards, that have managed to get the analog working near or 
perfectly.

If you want to attempt to write your own driver look in the source files 
under
linux/drivers/media/video/cx23885/
and try to understand how they work.

If you want to wait to I or someone else has some spare time, then please at 
least create the wiki page with:
* High resolution photo of board.
* Photo of the major chips.
* output of lspci -vvn
* A Dscaler Regspy output (see this message to get the right version: 
http://www.spinics.net/lists/linux-dvb/msg28077.html)
* i2cdetect -l and also the i2cdetect output for each of the 3 buses on this 
card.

Thanks, for bringing this to list.

Regards,
Stephen.


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
