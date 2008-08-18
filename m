Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KV3w6-0007mQ-Ug
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 14:34:16 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out2.iol.cz (Postfix) with ESMTP id 3EB649C092
	for <linux-dvb@linuxtv.org>; Mon, 18 Aug 2008 14:27:39 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Mon, 18 Aug 2008 14:27:36 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808181427.36988.ajurik@quick.cz>
Subject: [linux-dvb] HVR-4000 driver problems - i2c error
Reply-To: ajurik@quick.cz
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I've got a HVR-4000, but I have now some very strange problems.
I have Debian Leeny with 2.6.25-2 kernel and multiproto from Igor Lipianin =
hg =

running at Athlon64 X2 2700+ and Asus M2N-DVI mobo. =

Whole multiproto tree compiled without any problem.

- when starting system I got this message:

[ =A0 24.658572] tda9887 0-0043: i2c i/o error: rc =3D=3D -121 (should be 4)
[ =A0 24.659047] tuner-simple 0-0061: i2c i/o error: rc =3D=3D -121 (should=
 be 4)
[ =A0 23.609971] tda9887 0-0043: i2c i/o error: rc =3D=3D -121 (should be 4)

- the firmware is loaded into the card at first time the card is opened - i=
t =

is okay?

[ =A0917.660620] cx24116_firmware_ondemand: Waiting for firmware upload =

(dvb-fe-cx24116.fw)...
[ =A0917.703010] cx24116_firmware_ondemand: Waiting for firmware upload(2).=
..
[ =A0922.703870] cx24116_load_firmware: FW version 1.22.82.0
[ =A0922.703889] cx24116_firmware_ondemand: Firmware upload complete

The result is that only for some channels it is possible to get lock with =

szap2. VDR is hanging (or starting) when trying to tune to initial channel, =

even when this channel is set to channel at which is szap2 successfull. I'm =

not able to say criteria which channels are possible to lock.

Any hints are appreciated.

BR,

Ales

[ =A0 =A09.343037] Linux video capture interface: v2.00
...
[ =A0 =A09.465617] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loa=
ded
[ =A0 =A09.466569] cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HV=
R4000 =

DVB-S/S2/T/Hybrid [card=3D68,autodetected]
[ =A0 =A09.466622] cx88[0]: TV tuner type 63, Radio tuner type -1
...
[ =A0 =A09.497778] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[ =A0 =A09.539221] cx2388x alsa driver version 0.0.6 loaded
[ =A0 =A09.596629] cx88[0]: i2c init: enabling analog demod on HVR1300/3000=
/4000 =

tuner
[ =A0 =A09.672364] tuner' 0-0043: chip found @ 0x86 (cx88[0])
[ =A0 =A09.701019] tda9887 0-0043: creating new instance
[ =A0 =A09.701019] tda9887 0-0043: tda988[5/6/7] found
[ =A0 =A09.704336] tuner' 0-0061: chip found @ 0xc2 (cx88[0])
[ =A0 =A09.705311] tuner' 0-0063: chip found @ 0xc6 (cx88[0])
[ =A0 =A09.750913] tveeprom 0-0050: Hauppauge model 69009, rev B2D3, serial=
# =

3326338
[ =A0 =A09.750954] tveeprom 0-0050: MAC address is 00-0D-FE-32-C1-82
[ =A0 =A09.750991] tveeprom 0-0050: tuner model is Philips FMD1216MEX (idx =
133, =

type 63)
[ =A0 =A09.751041] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L'=
) =

PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[ =A0 =A09.751093] tveeprom 0-0050: audio processor is CX882 (idx 33)
[ =A0 =A09.751131] tveeprom 0-0050: decoder processor is CX882 (idx 25)
[ =A0 =A09.751169] tveeprom 0-0050: has radio, has IR receiver, has no IR =

transmitter
[ =A0 =A09.751218] cx88[0]: hauppauge eeprom: model=3D69009
[ =A0 =A09.802610] tuner-simple 0-0061: creating new instance
[ =A0 =A09.802610] tuner-simple 0-0061: type set to 63 (Philips FMD1216ME M=
K3 =

Hybrid Tuner)
[ =A0 =A09.805659] input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/i=
nput6
[ =A0 =A09.850619] cx88[0]/2: cx2388x 8802 Driver Manager
[ =A0 =A09.850619] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
[ =A0 =A09.850619] ACPI: PCI Interrupt 0000:01:06.2[A] -> Link [LNKA] -> GS=
I 19 =

(level, low) -> IRQ 19
[ =A0 =A09.850619] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 19, laten=
cy: 64, =

mmio: 0xfb000000
[ =A0 =A09.849788] ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 18
[ =A0 =A09.849840] ACPI: PCI Interrupt 0000:04:00.0[A] -> <6>ACPI: PCI Inte=
rrupt =

0000:01:06.1[A] -> Link [LNKA] -> GSI 19 (level, low) -> IRQ 19
[ =A0 =A09.850619] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[ =A0 =A09.849841] Link [LNEA] -> GSI 18 (level, low) -> IRQ 18
...
[ =A0 =A09.901424] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[ =A0 =A09.901465] cx88/2: registering cx8802 driver, type: dvb access: sha=
red
[ =A0 =A09.901505] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-=
HVR4000 =

DVB-S/S2/T/Hybrid [card=3D68]
[ =A0 =A09.901557] cx88[0]/2: cx2388x based DVB/ATSC card
...
[ =A0 =A09.976606] DVB: registering new adapter (cx88[0])
[ =A0 =A09.976648] DVB: registering frontend 0 (Conexant CX24116/CX24118)...
[ =A0 10.053023] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKA] -> GSI =
19 =

(level, low) -> IRQ 19
[ =A0 10.053123] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 19, latency=
: 64, =

mmio: 0xfd000000
[ =A0 10.053216] cx88[0]/0: registered device video0 [v4l2]
[ =A0 10.053270] cx88[0]/0: registered device vbi0
[ =A0 10.053321] cx88[0]/0: registered device radio0
...
[ =A0 24.658572] tda9887 0-0043: i2c i/o error: rc =3D=3D -121 (should be 4)
[ =A0 24.659047] tuner-simple 0-0061: i2c i/o error: rc =3D=3D -121 (should=
 be 4)
[ =A0 23.609971] tda9887 0-0043: i2c i/o error: rc =3D=3D -121 (should be 4)
...
[ =A0917.660620] cx24116_firmware_ondemand: Waiting for firmware upload =

(dvb-fe-cx24116.fw)...
[ =A0917.703010] cx24116_firmware_ondemand: Waiting for firmware upload(2).=
..
[ =A0922.703870] cx24116_load_firmware: FW version 1.22.82.0
[ =A0922.703889] cx24116_firmware_ondemand: Firmware upload complete

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
