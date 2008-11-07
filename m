Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd16712.kasserver.com ([85.13.137.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdr@helmutauer.de>) id 1Kya2g-0000iv-HL
	for linux-dvb@linuxtv.org; Fri, 07 Nov 2008 23:43:03 +0100
Received: from [192.168.178.120] (p50812E25.dip0.t-ipconnect.de [80.129.46.37])
	by dd16712.kasserver.com (Postfix) with ESMTP id F1219180BC519
	for <linux-dvb@linuxtv.org>; Fri,  7 Nov 2008 23:43:04 +0100 (CET)
Message-ID: <4914C482.8010306@helmutauer.de>
Date: Fri, 07 Nov 2008 23:43:14 +0100
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] tbs 8920 / cx24116 not working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello List,

I just tried to get my tbs 8920 running with current S2API and VDR and =

also with the multiproto drivers and a patch for this card.
Both versions are failing, with this error:

Nov  7 23:39:26 [kernel] LNB Voltage SEC_VOLTAGE_18
Nov  7 23:39:26 [vdr] [23138] ERROR (dvbdevice.c,282): Die Operation =

wird nicht unterst=FCtzt
Nov  7 23:39:35 [vdr] [23138] frontend 0 timed out while tuning to =

channel 3, tp 112187
Nov  7 23:39:35 [vdr] [23138] ERROR (dvbdevice.c,282): Die Operation =

wird nicht unterst=FCtzt
Nov  7 23:39:35 [kernel] LNB Voltage SEC_VOLTAGE_18
Nov  7 23:39:44 [vdr] [23138] ERROR (dvbdevice.c,282): Die Operation =

wird nicht unterst=FCtzt
Nov  7 23:39:44 [kernel] LNB Voltage SEC_VOLTAGE_18

dmesg shows:

LNB Voltage SEC_VOLTAGE_off
ACPI: PCI interrupt for device 0000:01:09.0 disabled
cx88/2: unregistering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=3D71]
ACPI: PCI interrupt for device 0000:01:09.2 disabled
Linux video capture interface: v2.00
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [LNKC] -> GSI 11 (level, =

low) -> IRQ 11
cx88[0]: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 =

[card=3D72,autodetected], frontend(s): 1
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88[0]/0: found at 0000:01:09.0, rev: 5, irq: 11, latency: 165, mmio: =

0xfc000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:01:09.2[A] -> Link [LNKC] -> GSI 11 (level, =

low) -> IRQ 11
cx88[0]/2: found at 0000:01:09.2, rev: 5, irq: 11, latency: 64, mmio: =

0xfd000000
cx8802_probe() allocating 1 frontend(s)
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=3D72]
cx88[0]/2: cx2388x based DVB/ATSC card
DVB: registering new adapter (cx88[0])
DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
cx24116_firmware_ondemand: Waiting for firmware upload =

(dvb-fe-cx24116.fw)...
cx24116_firmware_ondemand: Waiting for firmware upload(2)...
cx24116_load_firmware: FW version 1.22.82.0
cx24116_firmware_ondemand: Firmware upload complete
LNB Voltage SEC_VOLTAGE_13
LNB Voltage SEC_VOLTAGE_18

I also tested this patch:
http://hg.kewl.org/v4l-dvb/raw-rev/8d6d8974b33d

but without any change.

Any hints whats going wrong here ?

-- =

Helmut Auer, helmut@helmutauer.de =



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
