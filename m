Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58206 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3I0Als convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Sep 2013 20:41:48 -0400
Date: Fri, 27 Sep 2013 02:41:45 +0200 (CEST)
From: remi <remi@remis.cc>
Reply-To: remi <remi@remis.cc>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-media@vger.kernel.org
Message-ID: <763113790.297312.1380242505378.open-xchange@email.1and1.fr>
In-Reply-To: <CAJL_dMtRmbfbXYSwgonHyEuYoHPMa2ZQVpmGOC1mV8EN_zk=2g@mail.gmail.com>
References: <641271032.80124.1376921926586.open-xchange@email.1and1.fr> <52123758.4090007@iki.fi> <408826654.91086.1376994751713.open-xchange@email.1and1.fr> <1970131979.98476.1377009869066.open-xchange@email.1and1.fr> <CAJL_dMtRmbfbXYSwgonHyEuYoHPMa2ZQVpmGOC1mV8EN_zk=2g@mail.gmail.com>
Subject: Re: avermedia A306 / PCIe-minicard (laptop)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello


The firmware got fixed, the module option, needs a file-name only, no path , lol
for once


Well, the driver says Firmware OK ,


I have seen the message of Mauro, he must be right a hundred percent,

'cause we seem to have the initialisations ok, but , for me at lease no data
coming out from the tuner ...

and it has GPIOs , that have to be used accordinly ...

No data meaning no reaction, and no tuning .

Otherwise I think we have video from the tuner ( snow ! )  and composite (
parasites )



I will as soon as i can, take macro photos heads/tails , and draw a schematic


With the datasheets i have (all ;) ) I will find out the GPIOs where they are
going ... :)


will keep you all informed of course .



Best regards



Rémi


###

               cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382
bytes)
[    4.392762] tuner 1-0061: Tuner -1 found with type(s) Radio TV.
[    4.395040] xc2028 1-0061: creating new instance
[    4.395043] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[    4.395214] cx23885[0]: registered device video1 [v4l2]
[    4.395333] cx23885[0]: registered device vbi0
[    4.395519] cx23885[0]: registered ALSA audio device
[    4.395870] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
type: xc2028 firmware, ver 2.7
[    4.598038] xc2028 1-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[    5.762199] xc2028 1-0061: Loading firmware for type=(0), id
000000000000b700.
[    5.777471] SCODE (20000000), id 000000000000b700:
[    5.777474] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
(60008000), id 0000000000008000.
[    5.923492] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    5.923499] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 18, latency: 0,
mmio: 0xd3000000


####



> Le 18 septembre 2013 à 16:44, Anca Emanuel <anca.emanuel@gmail.com> a écrit :
> 
> 
> On Tue, Aug 20, 2013 at 5:44 PM, remi <remi@remis.cc> wrote:
> > Hello
> >
> > FYI
> >
> > I digged into the firmware problem a little,
> >
> >
> > xc3028L-v36.fw  gets loaded by default , and the errors are as you saw earlier
> >
> >
> > forcing the /lib/firmware/xc3028-v27.fw :
> >
> > [ 3569.941404] xc2028 2-0061: Could not load firmware
> > /lib/firmware/xc3028-v27.fw
> >
> >
> > So i searched the original dell/windows driver :
> >
> >
> > I have these files in there :
> >
> > root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070# ls -lR
> > .:
> > total 5468
> > drwxr-xr-x 2 gpunk gpunk    4096 août  20 13:24 Driver_X86
> > -rwxr-xr-x 1 gpunk gpunk 5589827 sept. 12  2007 Setup.exe
> > -rw-r--r-- 1 gpunk gpunk     197 oct.   9  2007 setup.iss
> >
> > ./Driver_X86:
> > total 1448
> > -rw-r--r-- 1 gpunk gpunk 114338 sept.  7  2007 A885VCap_ASUS_DELL_2.inf
> > -rw-r--r-- 1 gpunk gpunk  15850 sept. 11  2007 a885vcap.cat
> > -rw-r--r-- 1 gpunk gpunk 733824 sept.  7  2007 A885VCap.sys
> > -rw-r--r-- 1 gpunk gpunk 147870 avril 20  2007 cpnotify.ax
> > -rw-r--r-- 1 gpunk gpunk 376836 avril 20  2007 cx416enc.rom
> > -rw-r--r-- 1 gpunk gpunk  65536 avril 20  2007 cxtvrate.dll
> > -rw-r--r-- 1 gpunk gpunk  16382 avril 20  2007 merlinC.rom
> 
> I think merlinC.rom is your xc3028-v27.fw
> 
> Compare it to http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028
> the file extracted there.
> 
> > root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070#
> >
> > root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86# grep
> > firmware *
> > Fichier binaire A885VCap.sys concordant
> > root@medeb:/home/gpunk/.wine/drive_c/dell/drivers/R169070/Driver_X86#
> >
> >
> >
> > I'll try to find a way to extract "maybe" the right firmware for what this card
> > ,
> >
> > I'd love some help :)
> 
> Mauro replied this
> http://www.spinics.net/lists/linux-media/msg25746.html to me in 2010.
> 
> Then I removed the card from my PC.
> 
> Some years later I tried again. This time I found this patch to give
> me some hints: http://www.spinics.net/lists/linux-media/msg43069.html
> After compiling several versions of the patch for the upstream kernel
> (try and hope type) I posted what works for me.
> 
> Tutorial to make kernel patches: http://www.youtube.com/watch?v=LLBrBBImJt4
> Tutorial to set git send-email correctly for git: https://coderwall.com/p/dp-gka
> Tip for first kernel patch: send to your address first to spot any errors.
> Tip for linux-media patchwork to automatically get yours: use labels
> (search for discussion about this).
> 
> I hope this helps.
