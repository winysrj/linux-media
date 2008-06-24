Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OAQFgv011069
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 06:26:15 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OAQ1Hc026456
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 06:26:01 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: video4linux-list@redhat.com
Date: Tue, 24 Jun 2008 12:25:50 +0200
References: <200806191008.05063.zzam@gentoo.org>
	<200806231614.45264.zzam@gentoo.org>
In-Reply-To: <200806231614.45264.zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241225.51725.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: [PATCH] cx88-dvb: Fix Oops in case no i2c bus is available
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

So trying some stuff:
Having in /etc/modprobe.d/dvb:
options i2c-algo-bit bit_test=1


Now rebooting and running
# modprobe cx88-dvb
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]: quirk: PCIPCI_NATOMA -- set TBFX
cx88[0]: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S 
[card=37,autodetected]
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88[0]: SDA stuck high!
cx88[0]: i2c register FAILED
input: cx88 IR (Hauppauge Nova-S-Plus  as /class/input/input5
cx88[0]/2: cx2388x 8802 Driver Manager
PCI: Enabling device 0000:00:10.2 (0154 -> 0156)
ACPI: PCI Interrupt 0000:00:10.2[A] -> Link [LNKD] -> GSI 9 (level, low) -> 
IRQ 9
cx88[0]/2: found at 0000:00:10.2, rev: 5, irq: 9, latency: 64, mmio: 
0xfb000000
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S [card=37]
cx88[0]/2: cx2388x based DVB/ATSC card
cx88[0]/2: no i2c-bus available, cannot attach dvb drivers
cx88[0]/2: dvb_register failed (err = -22)
cx88[0]/2: cx8802 probe failed, err = -22
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S [card=37]
cx88[0]/2: cx2388x based DVB/ATSC card
cx88[0]/2: no i2c-bus available, cannot attach dvb drivers
cx88[0]/2: dvb_register failed (err = -22)
cx88[0]/2: cx8802 probe failed, err = -22


So my patch at least stopped the Oops from appearing.
Btw. Why do I get the output of cx88[0]/2 twice?


Now trying a different module load order after another reboot as suggested 
from the referenced bug (http://bugzilla.kernel.org/show_bug.cgi?id=9455)

# modprobe cx8800
# modprobe cx8802

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
PCI: Enabling device 0000:00:10.0 (0154 -> 0156)
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKD] -> GSI 9 (level, low) -> 
IRQ 9
cx88[0]: quirk: PCIPCI_NATOMA -- set TBFX
cx88[0]: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S 
[card=37,autodetected]
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88[0]: Test OK
cx88[0]: eeprom i2c attach [addr=0x50,client=eeprom]
cx88[0]: eeprom i2c attach [addr=0x55,client=eeprom]
cx88[0]: i2c register ok
cx88[0]: i2c scan: found device @ 0x10  [???]
cx88[0]: i2c scan: found device @ 0xa0  [eeprom]
cx88[0]: i2c scan: found device @ 0xaa  [???]
tveeprom 5-0050: Hauppauge model 92001, rev B2B1, serial# 761920
tveeprom 5-0050: MAC address is 00-0D-FE-0B-A0-40
tveeprom 5-0050: tuner model is Conexant_CX24109 (idx 111, type 4)
tveeprom 5-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 5-0050: audio processor is CX883 (idx 32)
tveeprom 5-0050: decoder processor is CX883 (idx 22)
tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=92001
input: cx88 IR (Hauppauge Nova-S-Plus  as /class/input/input5
cx88[0]/0: found at 0000:00:10.0, rev: 5, irq: 9, latency: 165, mmio: 
0xfd000000
cx88[0]/0: registered device video1 [v4l2]
cx88[0]/0: registered device vbi1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]/2: cx2388x 8802 Driver Manager
PCI: Enabling device 0000:00:10.2 (0154 -> 0156)
ACPI: PCI Interrupt 0000:00:10.2[A] -> Link [LNKD] -> GSI 9 (level, low) -> 
IRQ 9
cx88[0]/2: found at 0000:00:10.2, rev: 5, irq: 9, latency: 64, mmio: 
0xfb000000
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova-S-Plus DVB-S [card=37]
cx88[0]/2: cx2388x based DVB/ATSC card
CX24123: detected CX24123
i2c-adapter i2c-6: SMBus Quick command not supported, can't probe for chips
DVB: registering new adapter (cx88[0])
DVB: registering frontend 2 (Conexant CX24123/CX24109)...


This way it works.
So it seems I do need to load cx8800 before anything mpeg/dvb related on my 
cx88 card.

Regards
Matthias

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
