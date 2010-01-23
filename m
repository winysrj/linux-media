Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52115 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0AWTqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 14:46:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYlvm-0007O0-QT
	for linux-media@vger.kernel.org; Sat, 23 Jan 2010 20:46:02 +0100
Received: from upc.si.94.140.72.111.dc.cable.static.telemach.net ([94.140.72.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 23 Jan 2010 20:46:02 +0100
Received: from prusnik by upc.si.94.140.72.111.dc.cable.static.telemach.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 23 Jan 2010 20:46:02 +0100
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alja=C5=BE?= Prusnik <prusnik@gmail.com>
Subject: Re: technisat cablestar hd2, 2.6.33-rc5, no remote (VP2040)
Date: Sat, 23 Jan 2010 20:45:45 +0100
Message-ID: <1264275944.21574.103.camel@slash.doma>
References: <1264193852.21574.84.camel@slash.doma>
Reply-To: Manu Abraham <abraham.manu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1264193852.21574.84.camel@slash.doma>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu,

I'm sorry to bother you with this one, but I'd really like to know if
there's something I'm doing wrong or is there something more I can
provide on this one. Below are some results from the newest kernel RC,
while sometime back I also posted some more debug info. 

I just noticed that someone else also reported the same problem:
http://www.spinics.net/lists/linux-media/msg14332.html


Thanks in advance for any info.

Regards,
Aljaz



On pet, 2010-01-22 at 21:57 +0100, Aljaž Prusnik wrote:
> Hi!
> 
> I tried 2.6.33-rc5 kernel hoping to get the remote working, but it's the
> same behaviour as in my previous posts. TV reception works, however
> there's no VP2040 to be noticed anywhere in the logs.
> 
> The device used to be detected like this:
> 
> I: Bus=0001 Vendor=0000 Product=0000 Version=0001
> N: Name="Mantis VP-2040 IR Receiver"
> P: Phys=pci-0000:03:06.0/ir0
> S: Sysfs=/devices/virtual/input/input5
> U: Uniq=
> H: Handlers=kbd event5
> B: EV=100003
> B: KEY=108fc330 284204100000000 0 2000000018000 218040000801
> 9e96c000000000 ffc
> 
> 
> but now, this does not happen anymore. Any ideas?
> 
> Below are some outputs of the current situation:
> 
> mantis modules:
> 
> $ lsmod | grep mantis
> mantis                 14728  0 
> mantis_core            23909  18 mantis
> ir_common              26893  1 mantis_core
> ir_core                 3906  2 mantis_core,ir_common
> mb86a16                16598  1 mantis
> tda10021                4822  1 mantis
> tda10023                5823  1 mantis
> zl10353                 5893  1 mantis
> stv0299                 7860  1 mantis
> dvb_core               77233  2 mantis_core,stv0299
> 
> 
> devices (no mantis 2040 anywhere):
> 
> $ cat /proc/bus/input/devices
> I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
> N: Name="AT Translated Set 2 keyboard"
> P: Phys=isa0060/serio0/input0
> S: Sysfs=/devices/platform/i8042/serio0/input/input0
> U: Uniq=
> H: Handlers=kbd event0 
> B: EV=120013
> B: KEY=402000000 3803078f800d001 feffffdfffefffff fffffffffffffffe
> B: MSC=10
> B: LED=7
> 
> I: Bus=0019 Vendor=0000 Product=0001 Version=0000
> N: Name="Power Button"
> P: Phys=PNP0C0C/button/input0
> S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
> U: Uniq=
> H: Handlers=kbd event1 
> B: EV=3
> B: KEY=10000000000000 0
> 
> I: Bus=0019 Vendor=0000 Product=0001 Version=0000
> N: Name="Power Button"
> P: Phys=LNXPWRBN/button/input0
> S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> U: Uniq=
> H: Handlers=kbd event2 
> B: EV=3
> B: KEY=10000000000000 0
> 
> I: Bus=0010 Vendor=001f Product=0001 Version=0100
> N: Name="PC Speaker"
> P: Phys=isa0061/input0
> S: Sysfs=/devices/platform/pcspkr/input/input3
> U: Uniq=
> H: Handlers=kbd event3 
> B: EV=40001
> B: SND=6
> 
> I: Bus=0003 Vendor=03f0 Product=041d Version=0110
> N: Name="Hewlett-Packard HP USB Travel Mouse"
> P: Phys=usb-0000:00:12.1-1/input0
> S: Sysfs=/devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.0/input/input4
> U: Uniq=
> H: Handlers=mouse0 event4 
> B: EV=17
> B: KEY=70000 0 0 0 0
> B: REL=103
> B: MSC=10
> 
> I: Bus=0001 Vendor=10ec Product=0887 Version=0001
> N: Name="HDA Digital PCBeep"
> P: Phys=card0/codec#0/beep0
> S: Sysfs=/devices/pci0000:00/0000:00:14.2/input/input5
> U: Uniq=
> H: Handlers=kbd event5 
> B: EV=40001
> B: SND=6
> 
> 
> Regards,
> Aljaz Prusnik



