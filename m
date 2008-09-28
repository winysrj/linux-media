Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8SBXmBf003807
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 07:33:48 -0400
Received: from hermes.gsix.se (hermes.gsix.se [193.11.224.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8SBXWMu002992
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 07:33:33 -0400
Received: from dng-gw.sgsnet.se ([193.11.230.69] helo=[172.16.172.22])
	by hermes.gsix.se with esmtp (Exim 4.63)
	(envelope-from <jonatan@akerlind.nu>) id 1KjuWp-0006Sc-Dc
	for video4linux-list@redhat.com; Sun, 28 Sep 2008 13:33:31 +0200
From: Jonatan =?ISO-8859-1?Q?=C5kerlind?= <jonatan@akerlind.nu>
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="=-N1D3kKT4B/ohvDV+3opL"
Date: Sun, 28 Sep 2008 13:33:28 +0200
Message-Id: <1222601608.22123.18.camel@skoll>
Mime-Version: 1.0
Subject: HVR-1300 unable to change analog tuning while watching mpeg-stream
	(cx88-blackbird) and sound problems with bb mpeg stream
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


--=-N1D3kKT4B/ohvDV+3opL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I have a problem with my HVR-1300 while watching the mpeg stream output
and trying to change analog channel. I'm not using DVB-t at the moment
since I live in sweden and have analog cable tv (actually will not have
this for much longer since I'm moving out of the apartment to my own
house). My problem seems to be the exact same as described in a thread
on this list with subject "Tuning channels not working with
cx88-bb/HVR-1300" dated "Sun, 9 Sep 2007 15:45:45
+0200" (http://lists-archives.org/video4linux/19554-tuning-channels-not-working-with-cx88-bb-hvr-1300.html )

This thread does not however have a solution. The problem is:

Loading all modules seems to be fine, I can use scantv to find channels
and (at least some time ago) I used xawtv with the analog device to tune
to some channels without problems. When using mythtv (and any other
program) to watch the blackbird mpeg-stream I get good picture (crappy
sound, see more later), but when trying to tune to another channel the
picture goes black for about a second and then the some channel I was
watching before returns. Now just exiting mythtv (back to the
mythfrontend menu) and reentering livetv I get the new channel tuned. 

Mythtv is at the moment only configured to know about the cx88-blackbird
mpeg device node (/dev/video1).

v4l-dvb pulled from http://linuxtv.org/hg/v4l-dvb about one hour ago.

It seems like the i2c code cannot access the registers it needs. (see
the 04- file)

-----
The other thing is the sound quality when watching the mpeg stream. It
seems like the audio is chopped every once in a while, I get static for
about 2-300 ms every say 5 seconds or so. The behaviour is not regular
in that the intervals between the static "gaps" is sometimes 2 and other
times 5-10 seconds. I have disabled cpu frequency scaling and stopped
ntpd.
-----

Attached is the dmesg output:
01-dmesg_module_load  -- output from loading the modules
02-dmesg_mythbackend_started  -- output after mythbackend is started
03-dmesg_mythfrontend_started_watching_one_channel  -- output after
    starting to wath livetv
04-dmesg_mythfrontend_tried_changing_channel  -- output after trying to 
    tune to another channel
05-dmesg_mythfrontend_exited_and_reentered_livetv  -- output after 
    exiting livetv and then reentering


module parameters:
tuner debug=2 show_i2c=1
tda9887 debug=1
cx22702 debug=1

loaded modules:
jonatan@brummelina ~ $ lsmod
Module                  Size  Used by
cx88_alsa               9096  0 
cx88_dvb               16388  0 
cx88_vp3054_i2c         2176  1 cx88_dvb
videobuf_dvb            4356  1 cx88_dvb
cx88_blackbird         14212  4 
dvb_core               67968  2 cx88_dvb,videobuf_dvb
cx8802                 12804  2 cx88_dvb,cx88_blackbird
cx2341x                 9732  1 cx88_blackbird
tuner_simple           11664  2 
tuner_types            13824  1 tuner_simple
tda8290                11908  0 
cx8800                 26060  1 cx88_blackbird
cx88xx                 61608  5
cx88_alsa,cx88_dvb,cx88_blackbird,cx8802,cx8800
tuner                  21700  0 
tveeprom               10628  1 cx88xx
videodev               27648  4 cx88_blackbird,cx8800,cx88xx,tuner
v4l1_compat            12036  1 videodev
cx22702                 4996  1 
tda9887                 9092  1 



Any help greatly appreciated.

/Jonatan

--=-N1D3kKT4B/ohvDV+3opL
Content-Disposition: attachment; filename=01-dmesg_module_load
Content-Type: text/plain; name=01-dmesg_module_load; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux video capture interface: v2.00
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:14.0[A] -> GSI 17 (level, low) -> IRQ 17
cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56,autodetected]
cx88[0]: TV tuner type 63, Radio tuner type -1
wm8775' 1-001b: chip found @ 0x36 (cx88[0])
input: i2c IR (CX2388x rem as /class/input/input7
ir-kbd-i2c: i2c IR (CX2388x rem detected at i2c-1/1-0071/ir0 [cx88[0]]
tuner' 1-0043: I2C RECV = f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 
tuner' 1-0043: chip found @ 0x86 (cx88[0])
tda9887 1-0043: creating new instance
tda9887 1-0043: tda988[5/6/7] found
tuner' 1-0043: type set to tda9887
tuner' 1-0043: tv freq set to 0.00
tuner' 1-0043: TV freq (0.00) out of range (44-958)
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0xc0 c=0x00 e=0x00
tuner' 1-0043: cx88[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
tuner' 1-0061: I2C RECV = 70 70 70 70 70 70 70 70 70 70 70 70 70 70 70 70 
tuner' 1-0061: Setting mode_mask to 0x0e
tuner' 1-0061: chip found @ 0xc2 (cx88[0])
tuner' 1-0061: tuner 0x61: Tuner type absent
tuner' 1-0063: I2C RECV = 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00 
tuner' 1-0063: chip found @ 0xc6 (cx88[0])
tuner' 1-0063: tuner 0x63: Tuner type absent
cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner
tveeprom 1-0050: Hauppauge model 96019, rev D6D3, serial# 3218455
tveeprom 1-0050: MAC address is 00-0D-FE-31-1C-17
tveeprom 1-0050: tuner model is Philips FMD1216MEX (idx 133, type 63)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
tveeprom 1-0050: audio processor is CX882 (idx 33)
tveeprom 1-0050: decoder processor is CX882 (idx 25)
tveeprom 1-0050: has radio, has IR receiver, has IR transmitter
cx88[0]: hauppauge eeprom: model=96019
tuner' 1-0043: TUNER_SET_TYPE_ADDR
tuner' 1-0043: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner' 1-0043: set addr discarded for type 74, mask e. Asked to change tuner at addr 0xff, with mask e
tuner' 1-0061: TUNER_SET_TYPE_ADDR
tuner' 1-0061: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner' 1-0061: defining GPIO callback
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
tuner' 1-0061: type set to Philips FMD1216ME MK3 Hybrid Tuner
tuner' 1-0061: tv freq set to 400.00
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0x00 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0061: cx88[0] tuner' I2C addr 0xc2 with type 63 used for 0x0e
tuner' 1-0063: TUNER_SET_TYPE_ADDR
tuner' 1-0063: Calling set_type_addr for type=63, addr=0xff, mode=0x0e, config=0x00
tuner' 1-0063: set addr discarded for type -1, mask 0. Asked to change tuner at addr 0xff, with mask e
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0xc0 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0043: TUNER_SET_STANDBY
tuner' 1-0043: Cmd TUNER_SET_STANDBY accepted for analog TV
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0xe0 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_STANDBY
tuner' 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
tuner' 1-0063: TUNER_SET_STANDBY
cx88[0]/0: found at 0000:00:14.0, rev: 5, irq: 17, latency: 32, mmio: 0xfa000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
tuner' 1-0043: VIDIOC_S_STD
tuner' 1-0043: Cmd VIDIOC_S_STD accepted for analog TV
tuner' 1-0043: switching to v4l2
tuner' 1-0061: VIDIOC_S_STD
tuner' 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
tuner' 1-0061: switching to v4l2
tuner' 1-0061: tv freq set to 400.00
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0x20 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_STD
tuner' 1-0043: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0061: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0063: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0043: TUNER_SET_STANDBY
tuner' 1-0043: Cmd TUNER_SET_STANDBY accepted for analog TV
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0x20 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_STANDBY
tuner' 1-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
tuner' 1-0063: TUNER_SET_STANDBY
tuner' 1-0043: AUDC_SET_RADIO
tuner' 1-0043: Cmd AUDC_SET_RADIO accepted for radio
tuner' 1-0061: AUDC_SET_RADIO
tuner' 1-0061: Cmd AUDC_SET_RADIO accepted for radio
tuner' 1-0061: radio freq set to 87.50
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0xa0 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: AUDC_SET_RADIO
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]/2: cx2388x 8802 Driver Manager
tuner' 1-0043: <6>ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 17 (level, low) -> IRQ 17
cx88[0]/2: found at 0000:00:14.2, rev: 5, irq: 17, latency: 32, mmio: 0xf8000000
TUNER_SET_STANDBY
tuner' 1-0043: Cmd TUNER_SET_STANDBY accepted for radio
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0xa0 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_STANDBY
tuner' 1-0061: Cmd TUNER_SET_STANDBY accepted for radio
tuner' 1-0063: TUNER_SET_STANDBY
cx2388x blackbird driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: blackbird access: shared
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx23416 based mpeg encoder (blackbird reference design)
cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized or corrupted
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx2388x based DVB/ATSC card
cx22702_i2c_gate_ctrl(1)
cx22702_i2c_gate_ctrl(0)
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: TUNER_SET_STANDBY
tuner' 1-0061: TUNER_SET_STANDBY
tuner' 1-0063: TUNER_SET_STANDBY
cx22702_i2c_gate_ctrl(0)
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
cx88[0]/2-bb: Firmware upload successful.
cx88[0]/2-bb: Firmware version is 0x02060039
cx88[0]/2-bb: VIDIOC_TRY_FMT: w: 720, h: 480, f: 4
cx88[0]/2: registered device video1 [mpeg]
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_S_STD
tuner' 1-0043: Cmd VIDIOC_S_STD accepted for analog TV
tuner' 1-0061: VIDIOC_S_STD
tuner' 1-0061: Cmd VIDIOC_S_STD accepted for analog TV
tuner' 1-0061: tv freq set to 400.00
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0x20 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_STD
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0061: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0063: VIDIOC_INT_S_AUDIO_ROUTING
cx22702_i2c_gate_ctrl(0)
cx2388x alsa driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 17 (level, low) -> IRQ 17
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards

--=-N1D3kKT4B/ohvDV+3opL
Content-Disposition: attachment; filename=02-dmesg_mythbackend_started
Content-Type: text/plain; name=02-dmesg_mythbackend_started; charset=UTF-8
Content-Transfer-Encoding: 7bit

cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0061: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0063: VIDIOC_INT_S_AUDIO_ROUTING
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_S_STD
tuner' 1-0061: VIDIOC_S_STD
tuner' 1-0061: tv freq set to 400.00
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0x20 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_STD
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0061: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0063: VIDIOC_INT_S_AUDIO_ROUTING
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_S_STD
tuner' 1-0061: VIDIOC_S_STD
tuner' 1-0061: tv freq set to 400.00
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: Unsupported tvnorm entry - audio muted
tda9887 1-0043: writing: b=0x20 c=0x00 e=0x00
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_STD
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_S_FREQUENCY
tuner' 1-0043: tv freq set to 154.50
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: VIDIOC_S_FREQUENCY
tuner' 1-0061: tv freq set to 154.50
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_FREQUENCY
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_G_FREQUENCY
tuner' 1-0043: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
tuner' 1-0061: VIDIOC_G_FREQUENCY
tuner' 1-0061: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
tuner' 1-0063: VIDIOC_G_FREQUENCY
cx22702_i2c_gate_ctrl(0)

--=-N1D3kKT4B/ohvDV+3opL
Content-Disposition: attachment;
	filename=03-dmesg_mythfrontend_started_watching_one_channel
Content-Type: text/plain;
	name=03-dmesg_mythfrontend_started_watching_one_channel;
	charset=UTF-8
Content-Transfer-Encoding: 7bit

cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0061: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0063: VIDIOC_INT_S_AUDIO_ROUTING
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_S_STD
tuner' 1-0043: tv freq set to 154.50
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: VIDIOC_S_STD
tuner' 1-0061: tv freq set to 154.50
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_STD
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_S_FREQUENCY
tuner' 1-0043: tv freq set to 154.50
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: VIDIOC_S_FREQUENCY
tuner' 1-0061: tv freq set to 154.50
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_FREQUENCY
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_G_FREQUENCY
tuner' 1-0043: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
tuner' 1-0061: VIDIOC_G_FREQUENCY
tuner' 1-0061: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
tuner' 1-0063: VIDIOC_G_FREQUENCY
cx22702_i2c_gate_ctrl(0)
cx88[0]/2-bb: VIDIOC_G_FMT: w: 720, h: 480, f: 4
cx88[0]/2-bb: VIDIOC_S_FMT: w: 480, h: 480, f: 4

--=-N1D3kKT4B/ohvDV+3opL
Content-Disposition: attachment;
	filename=04-dmesg_mythfrontend_tried_changing_channel
Content-Type: text/plain; name=04-dmesg_mythfrontend_tried_changing_channel;
	charset=UTF-8
Content-Transfer-Encoding: 7bit

cx22702_i2c_gate_ctrl(1)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)
tuner' 1-0043: VIDIOC_S_FREQUENCY
tuner' 1-0043: tv freq set to 147.62
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tda9887 1-0043: i2c i/o error: rc == -121 (should be 4)
tuner' 1-0061: VIDIOC_S_FREQUENCY
tuner' 1-0061: tv freq set to 147.62
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tda9887 1-0043: i2c i/o error: rc == -121 (should be 4)
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner-simple 1-0061: i2c i/o error: rc == -121 (should be 4)
tuner' 1-0063: VIDIOC_S_FREQUENCY
cx22702_i2c_gate_ctrl(0)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)
cx22702_i2c_gate_ctrl(1)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)
tuner' 1-0043: VIDIOC_G_FREQUENCY
tuner' 1-0043: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
tuner' 1-0061: VIDIOC_G_FREQUENCY
tuner' 1-0061: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
tuner' 1-0063: VIDIOC_G_FREQUENCY
cx22702_i2c_gate_ctrl(0)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)

--=-N1D3kKT4B/ohvDV+3opL
Content-Disposition: attachment;
	filename=05-dmesg_mythfrontend_exited_and_reentered_livetv
Content-Type: text/plain;
	name=05-dmesg_mythfrontend_exited_and_reentered_livetv;
	charset=UTF-8
Content-Transfer-Encoding: 7bit

cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0061: VIDIOC_INT_S_AUDIO_ROUTING
tuner' 1-0063: VIDIOC_INT_S_AUDIO_ROUTING
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_S_STD
tuner' 1-0043: tv freq set to 147.62
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: VIDIOC_S_STD
tuner' 1-0061: tv freq set to 147.62
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_STD
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_S_FREQUENCY
tuner' 1-0043: tv freq set to 147.62
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: VIDIOC_S_FREQUENCY
tuner' 1-0061: tv freq set to 147.62
tuner' 1-0043: TUNER_SET_CONFIG
tda9887 1-0043: configure for: PAL-BGHN
tda9887 1-0043: writing: b=0x14 c=0x70 e=0x49
tuner' 1-0061: TUNER_SET_CONFIG
tuner' 1-0063: TUNER_SET_CONFIG
tuner' 1-0063: VIDIOC_S_FREQUENCY
cx22702_i2c_gate_ctrl(0)
cx22702_i2c_gate_ctrl(1)
tuner' 1-0043: VIDIOC_G_FREQUENCY
tuner' 1-0043: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
tuner' 1-0061: VIDIOC_G_FREQUENCY
tuner' 1-0061: Cmd VIDIOC_G_FREQUENCY accepted for analog TV
tuner' 1-0063: VIDIOC_G_FREQUENCY
cx22702_i2c_gate_ctrl(0)
cx88[0]/2-bb: VIDIOC_G_FMT: w: 480, h: 480, f: 4
cx88[0]/2-bb: VIDIOC_S_FMT: w: 480, h: 480, f: 4

--=-N1D3kKT4B/ohvDV+3opL
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-N1D3kKT4B/ohvDV+3opL--
