Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3HTOoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 10:44:30 -0400
Date: Tue, 20 Aug 2013 16:44:29 +0200 (CEST)
From: remi <remi@remis.cc>
Reply-To: remi <remi@remis.cc>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Message-ID: <1970131979.98476.1377009869066.open-xchange@email.1and1.fr>
In-Reply-To: <408826654.91086.1376994751713.open-xchange@email.1and1.fr>
References: <641271032.80124.1376921926586.open-xchange@email.1and1.fr> <52123758.4090007@iki.fi> <408826654.91086.1376994751713.open-xchange@email.1and1.fr>
Subject: Re: avermedia A306 / PCIe-minicard (laptop)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

FYI

I digged into the firmware problem a little,


xc3028L-v36.fw  gets loaded by default , and the errors are as you saw earlier


forcing the /lib/firmware/xc3028-v27.fw : 

[ 3569.941404] xc2028 2-0061: Could not load firmware
/lib/firmware/xc3028-v27.fw


So i searched the original dell/windows driver :


I have these files in there :

root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070# ls -lR
.:
total 5468
drwxr-xr-x 2 gpunk gpunk    4096 août  20 13:24 Driver_X86
-rwxr-xr-x 1 gpunk gpunk 5589827 sept. 12  2007 Setup.exe
-rw-r--r-- 1 gpunk gpunk     197 oct.   9  2007 setup.iss

./Driver_X86:
total 1448
-rw-r--r-- 1 gpunk gpunk 114338 sept.  7  2007 A885VCap_ASUS_DELL_2.inf
-rw-r--r-- 1 gpunk gpunk  15850 sept. 11  2007 a885vcap.cat
-rw-r--r-- 1 gpunk gpunk 733824 sept.  7  2007 A885VCap.sys
-rw-r--r-- 1 gpunk gpunk 147870 avril 20  2007 cpnotify.ax
-rw-r--r-- 1 gpunk gpunk 376836 avril 20  2007 cx416enc.rom
-rw-r--r-- 1 gpunk gpunk  65536 avril 20  2007 cxtvrate.dll
-rw-r--r-- 1 gpunk gpunk  16382 avril 20  2007 merlinC.rom
root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070#

root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86# grep
firmware *
Fichier binaire A885VCap.sys concordant
root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86#



I'll try to find a way to extract "maybe" the right firmware for what this card
,

I'd love some help :)

Good news there are ALOT of infos on how to initialize the card in the .INF , so

many problems, i think, are partially solved (I need to implement them )

I'll send a copy of theses to anyone who wishes,

Or see
http://www.dell.com/support/drivers/us/en/04/DriverDetails?driverId=R169070     
 :)

Regards

Rémi





> Le 20 août 2013 à 12:32, remi <remi@remis.cc> a écrit :
>
>
> Hello
>
> I have just putdown my screwdrivers :)
>
>
> Yes it was three ICs
>
>
> on the bottom-side , no heatsinks (digital reception, that's why i guess) , is
> an AF9013-N1
>
> on the top-side, with a heatsink : CX23885-13Z , PCIe A/V controler
>
> on the top-side, with heat-sink + "radio-isolation" (aluminum box) XC3028ACQ ,
> so the analog reception .
>
>  
> Its all on a PCIe bus, the reason why i baught it ... :)
>
>
>
> To resume :
>
>
> AF9013-N1
>
> CX23885-13Z
>
> XC3028ACQ
>
>
> the drivers while scanning
>
>
> gpunk@medeb:~/Bureau$ dmesg |grep i2c
> [    2.363784] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
> [    2.384721] cx23885[0]: i2c scan: found device @ 0xc2 
> [tuner/mt2131/tda8275/xc5000/xc3028]
> [    2.391502] cx23885[0]: i2c scan: found device @ 0x66  [???]
> [    2.392339] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
> [    2.392831] cx23885[0]: i2c scan: found device @ 0x98  [flatiron]
> [    5.306751] i2c /dev entries driver
> gpunk@medeb:~/Bureau$
>
>
>  4.560428] xc2028 2-0061: xc2028_get_reg 0008 called
> [    4.560989] xc2028 2-0061: Device is Xceive 0 version 0.0, firmware version
> 0.0
> [    4.560990] xc2028 2-0061: Incorrect readback of firmware version.
> [ *    4.561184] xc2028 2-0061: Read invalid device hardware information -
> tuner
> hung?
> [ *    4.561386] xc2028 2-0061: 0.0      0.0
> [ *    4.674072] xc2028 2-0061: divisor= 00 00 64 00 (freq=400.000)
> [    4.697830] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [    4.698029] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 18, latency:
> 0,
> mmio: 0xd3000000
>
> * --> I bypassed the "goto fail" to start debugging a little bit the
> tuner-xc2028.c/ko ... lines 869
> ...
>
>
>
> The firmware doesnt get all loaded .
> gpunk@medeb:~/Bureau$  uname -a
> Linux medeb 3.11.0-rc6remi #1 SMP PREEMPT Mon Aug 19 13:30:04 CEST 2013 i686
> GNU/Linux
> gpunk@medeb:~/Bureau$
>
>
> With yesterday's tarball from linuxtv.org / media-build git .
>
>
>
> Best regards
>
> Rémi
>
>
>
>
> > Le 19 août 2013 à 17:18, Antti Palosaari <crope@iki.fi> a écrit :
> >
> >
> > On 08/19/2013 05:18 PM, remi wrote:
> > > Hello
> > >
> > > I have this card since months,
> > >
> > > http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=376&SI=true
> > >
> > > I have finally retested it with the cx23885 driver : card=39
> > >
> > >
> > >
> > > If I could do anything to identify : [    2.414734] cx23885[0]: i2c scan:
> > > found
> > > device @ 0x66  [???]
> > >
> > > Or "hookup" the xc5000 etc
> > >
> > > I'll be more than glad .
> > >
> >
> >
> > >
> > > ps: i opened it up a while ago,i saw an af9013 chip ? dvb-tuner looks like
> > > maybe the "device @ 0x66 i2c"
> > >
> > > I will double check , and re-write-down all the chips , i think 3 .
> >
> > You have to identify all the chips, for DVB-T there is tuner missing.
> >
> > USB-interface: cx23885
> > DVB-T demodulator: AF9013
> > RF-tuner: ?
> >
> > If there is existing driver for used RF-tuner it comes nice hacking
> > project for some newcomer.
> >
> > It is just tweaking and hacking to find out all settings. AF9013 driver
> > also needs likely some changes, currently it is used only for devices
> > having AF9015 with integrated AF9013, or AF9015 dual devices having
> > AF9015 + external AF9013 providing second tuner.
> >
> > I have bought quite similar AverMedia A301 ages back as I was looking
> > for that AF9013 model, but maybe I have bought just wrong one... :)
> >
> >
> > regards
> > Antti
> >
> >
> > --
> > http://palosaari.fi/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
