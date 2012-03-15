Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36390 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030342Ab2COB0d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 21:26:33 -0400
Subject: Re: Hauppauge HVR-1600 potential bug or model issue
From: Andy Walls <awalls@md.metrocast.net>
To: Matt Berglund <bmwebinfo@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Wed, 14 Mar 2012 21:26:27 -0400
In-Reply-To: <CALUGRoAhxsZ2u8sGOEG3--cMPozobq-qReH6dD1dhYFA9Y_zAQ@mail.gmail.com>
References: <CALUGRoAhxsZ2u8sGOEG3--cMPozobq-qReH6dD1dhYFA9Y_zAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1331774789.2737.49.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

On Sun, 2012-03-11 at 13:45 -0400, Matt Berglund wrote:
> Hello all,
> 
> I'm having trouble with my 1600 listed as: Hauppauge model 74541, rev C6A3
> The firmware is installed. Both using yum and manually.
> Based on the LTV wiki, it seems this is less well tested model. If
> this is so,

This model should work with the stock kernel cx18 driver and supporting
modules, in any kernel from the past few years.

(Although I must admit, I have not tested if kernel-churn outside of the
cx18 driver in very recent 3.x kernels broke anything.)

>  I'll be happy to do what I can to test it.
> 
> Subsystem: Hauppauge computer works Inc. WinTV HVR-1600 [0070:7444]
> 
> Running Fedora 16 with 3.2.9-1.fc16.x86_64 on an MSI 790FX-GD70 with
> an AMD 5770 and 6770 board running crossfirex/catalyst  (I realize
> this is potentially problematic but I don't think it is the cause of
> this issue)
> 
> I have used both the built-in drivers and now have compiled what I
> believe are the latest linuxtv drivers, per the wiki there.
> 
> With the following results:
> [  762.974890] Linux media interface: v0.10
> [  762.979795] Linux video capture interface: v2.00
> [  762.979804] WARNING: You are using an experimental version of the
> media stack.
> [  762.979808]  As the driver is backported to an older kernel, it doesn't offer
> [  762.979811]  enough quality for its usage in production.
> [  762.979813]  Use it with care.

[snip]

> [  762.986723] cx18:  Start initialization, version 1.5.1
> [  762.987457] cx18-0: Initializing card 0
> [  762.987460] cx18-0: Autodetected Hauppauge card
> [  762.993040] cx18-0: cx23418 revision 01010000 (B)
> [  763.227077] tveeprom 0-0050: Hauppauge model 74541, rev C6A3, serial#
> [  763.227080] tveeprom 0-0050: MAC address
> [  763.227082] tveeprom 0-0050: tuner model is TCL MFNM05-4 (idx 103, type 43)
> [  763.227084] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
> [  763.227086] tveeprom 0-0050: audio processor is CX23418 (idx 38)
> [  763.227088] tveeprom 0-0050: decoder processor is CX23418 (idx 31)
> [  763.227089] tveeprom 0-0050: has radio
> [  763.227090] cx18-0: Autodetected Hauppauge HVR-1600
> [  763.227092] cx18-0: Simultaneous Digital and Analog TV capture supported
> [  763.340073] cx18-0: Registered device video0 for encoder MPEG (64 x 32.00 kB)
> [  763.340076] DVB: registering new adapter (cx18)
> [  763.341895] s5h1409_readreg: readreg error (ret == -6)

I2C bus communications between the CX23418 and CX24227(aka S5H1409)
ATSC/QAM demodulator chip aren't working.  The cx18 driver bailed out
because of this.



> [  763.341903] cx18-0: frontend initialization failed
> [  763.342126] cx18-0: DVB failed to register
> [  763.342235] cx18-0: Registered device video32 for encoder YUV (20 x
> 101.25 kB)
> [  763.342301] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
> [  763.342369] cx18-0: Registered device video24 for encoder PCM audio
> (256 x 4.00 kB)
> [  763.342433] cx18-0: Registered device radio0 for encoder radio
> [  763.342552] cx18-0: unregister DVB
> [  763.343628] cx18-0: Error -1 registering devices
> [  763.346390] cx18-0: Error -1 on initialization
> [  763.346406] cx18: probe of 0000:07:07.0 failed with error -1
> [  763.346427] cx18:  End initialization
> 
> This will be used to capture signals from a cable feed, both free HD
> and SD, if possible.

Yes it should be fine, but for DTV you will only be able to receive the
unencrypted channels.


> This happens regardless of how the drivers are installed.
> 
> I noticed this:
> [  763.341895] s5h1409_readreg: readreg error (ret == -6)
> And was wondering if this is related to the card appearing to be less
> well known?

Nope.  It is likely related to your specific system hardware and/or the
way the linux kernel sets up your motherboard's PCI chipset.

Some things to do:

1. The card looks like an older model, so I'm assuming you got it used.
Go test the card in a Windows machine and verify the digital TV side of
the card works under that OS.


2. As I mentioned on IRC, the legacy conventional PCI bus is sesnitive
to accumulations of dust.  Pull *all* your PCI cards, blow the dust out
of all the slots, reseat your cards, and test again.

3. The cx18 driver bit-bangs every bit on the I2C bus on the HVR-1600
with per I2C-bit PCI transactions over the PCI bus.  Some PCI bridges
may not handle this well under certain circumstances and will return
error words on the PCI bus (0xffffffff) instead of actual data.  You may
wish to try this card in a different Linux box, with a different
motherboard and see if the error follows the HVR-1600 or not.  You could
throw in some debug statements in cx18-io.[ch] and/or cx18-i2c.c to
perhaps gain some insight into what is going on with your hardware.


I am looking into converting the cx18 driver to use the CX23418 hardware
I2C master, instead of bit-banging.  That might alleviate some problems
with PCI bridges which might behave badly with many back-to-back PCI
accesses.  The CX23418 hardware I2C master isn't very intelligent, but
it would improve things some.  My problem is that the datasheet which I
have is poorly written in explaining how the hardware I2C master is to
be driven, so it will take some time and experimentation.


4. The other I2C bus operations on the HVR-1600 (BTW, the CX23418 and
HVR-1600 have 2 I2C buses) don't seem to have any problems: i.e. the
EEPROM and analog tuner.  It could be the CX24227 is somehow stuck in
reset or just plain stuck.  I have no GPIO pin to twiddle to reset the
CX24227 chip.  You may have some luck with ensuring there is ample power
to power the HVR-1600 board and no ground loops.  You may wish to try
temporarily pulling all unneeded PCI/PCIe cards and drives from your
machine, and unhook all your TV cables from the machine, and see if
things get better.

> I will enable debug and poke around a bit more, but I'm far from a
> driver writer.
> 
> Thanks,
> Matt

Regards,
Andy W.

