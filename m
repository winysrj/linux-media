Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:58035 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZDDWJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 18:09:34 -0400
Received: by bwz17 with SMTP id 17so1395583bwz.37
        for <linux-media@vger.kernel.org>; Sat, 04 Apr 2009 15:09:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b02f340d0904031619s747325av93f163498f773186@mail.gmail.com>
References: <b02f340d0904031619s747325av93f163498f773186@mail.gmail.com>
Date: Sun, 5 Apr 2009 01:09:31 +0300
Message-ID: <b02f340d0904041509w5d744aedl9821c2af9bb1a751@mail.gmail.com>
Subject: Driver for STK7700D?
From: ankostis <ankostis@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi (Matthias?),

i have also a STK7700D tv-tuner card.
Can anybody inform me with any updates regarding the letter to
Microtune for Linux support?

(i know that it is 2 years since Matthias sent the letter and probably
he is not on the list any more,
but its never bad to try...)

Has anyone else any infos about this tuner?
Is the driver[1] for MT2266 chip compatible?


Thanks in Advance,
 Kostis


[1] http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/drivers/media/common/tuners/mt2266.c


 > Hello Patrick,

> thank you for your reply. I've send a request for a datasheet to
> Microtune.
>
> I've BCC'ed you, hope you don't mind.
>
> Am Donnerstag, den 11.01.2007, 09:40 +0100 schrieb Patrick Boettcher:
> > Hi Matthias,
> >
> > This is explained very easy.
> >
> > The STK7700D ref design was done with MT2266 from Microtune. As of today,
> > there is no OpenSource driver for this RF tuner.
> >
> > All I can do is, to ask you to contact Microtune and your notebook vendor
> > for that. When there are enough people asking for it, it may change the
> > minds.
> >
> > Patrick.
> >
> > --
> >   Mail: patrick.boettcher at desy.de
> >   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
> >
> > On Thu, 11 Jan 2007, Matthias Hentges wrote:
> >
> > > Hello all,
> > >
> > > I'm trying to get the DVB-T USB device built into my new notebook
> > > working.
> > >
> > > The device uses an STK7700D chip so I hacked dvb-usb-ids.h and added my
> > > vendor:device IDs to fake a Hauppauge Nova-T Stick.
> > >
> > > The following output of dmesg shows the module loading and firmware
> > > insertion:
> > >
> > > dvb-usb: found a 'Hauppauge Nova-T Stick' in cold state, will try to
> > > load a firm
> > > ware
> > > [...]
> > > dvb-usb: downloading firmware from file 'dvb-usb-dib0700-01.fw'
> > > dib0700: firmware started successfully.
> > > dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
> > > **WARNING** I2C adapter driver [Hauppauge Nova-T Stick] forgot to
> > > specify physical device; fix it!
> > > dvb-usb: will pass the complete MPEG2 transport stream to the software
> > > demuxer.
> > > DVB: registering new adapter (Hauppauge Nova-T Stick).
> > > **WARNING** I2C adapter driver [DiBX000 tuner I2C bus] forgot to specify
> > > physical device; fix it!
> > > DVB: registering frontend 0 (DiBcom 7000PC)...
> > > mt2060 I2C read failed
> > > dvb-usb: Hauppauge Nova-T Stick successfully initialized and connected.
> > > usbcore: registered new interface driver dvb_usb_dib0700
> > >
> > > While the firmware is inserted just fine, the **WARNING** messages don't
> > > look good to me. And indeed, tuning does not work:
> > >
> > > scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/de-Koeln-Bonn
> > > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux1'
> > > initial transponder 538000000 0 2 9 1 1 3 0
> > > initial transponder 514000000 0 2 9 1 1 3 0
> > > initial transponder 698000000 0 2 9 1 1 3 0
> > > initial transponder 650000000 0 2 9 1 1 3 0
> > > initial transponder 826000000 0 2 9 1 1 3 0
> > > initial transponder 834000000 0 2 9 1 1 3 0
> > > >>> tune to:
> > > 538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> > > WARNING: >>> tuning failed!!!
> > > >>> tune to:
> > > 538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
> > > WARNING: >>> tuning failed!!!
> > > >>> tune to:
> > > 514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> > > WARNING: >>> tuning failed!!!
> > > [...]
> > > >>> tune to:
> > > 834000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
> > > WARNING: >>> tuning failed!!!
> > > ERROR: initial tuning failed
> > > dumping lists (0 services)
> > > Done.
> > >
> > > A lsusb-vvv dump is attached.
> > >
> > > I would appreciate any pointers in the right direction ;)
> > > I'm using kernel 2.6.4.20-rc4 and latest dvb sources.
> > >
> > > Thanks
> > > Matthias Hentges
> > >
