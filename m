Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steele.brian@gmail.com>) id 1KQWxe-0000cC-Rm
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2008 02:33:09 +0200
Received: by yw-out-2324.google.com with SMTP id 3so1332805ywj.41
	for <linux-dvb@linuxtv.org>; Tue, 05 Aug 2008 17:33:01 -0700 (PDT)
Message-ID: <5f8558830808051733w5960fb03p169ae2aa6d893ce8@mail.gmail.com>
Date: Tue, 5 Aug 2008 17:33:01 -0700
From: "Brian Steele" <steele.brian@gmail.com>
To: "Andy Walls" <awalls@radix.net>
In-Reply-To: <1217814427.23133.24.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
	<5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
	<1217791214.2690.31.camel@morgan.walls.org>
	<5f8558830808031428u3c9a8191tcd1705b27087f992@mail.gmail.com>
	<1217814427.23133.24.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 - No audio
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

On Sun, Aug 3, 2008 at 6:47 PM, Andy Walls <awalls@radix.net> wrote:
> Well, let's collect some debug data about how the tuner is getting set
> up and what happens on channel change.  (Because it's either tuner
> commands not working, or cx18-av setup or register changes not working.)
>
> Add lines like these to /etc/modprobe.conf
>
> options tuner show_i2c=1 debug=2
> options tuner-simple debug=1
> options tda8290 debug=1
> options tda9887 debug=2
>
>   (and/or debug options for whatever other tuner modules your
>    system loads for the cx18)
>
> Then do
>
> # modprobe -r cx18 tda9887 tda8290 tuner-simple tuner
> # modprobe cx18 debug=83      (<---- warn, info, i2c, ioctl)
>
> I'd be interested in all the messages when the cx18 module initializes
> (not just the ones prefixed with "cx18") and the messages that occur
> when you change channels.

Andy,

I pulled the latest from Hg, recompiled, executed the commands above,
then did ivtv-tune -c <channel> twice.  Here is the output in dmesg:
Linux video capture interface: v2.00
cx18:  Start initialization, version 1.0.0
cx18-0: Initializing card #0
cx18-0: Autodetected Hauppauge card
cx18-0 info: base addr: 0xe8000000
cx18-0 info: Enabling pci device
ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [APC2] -> GSI 17 (level,
low) -> IRQ 22
cx18-0 info: cx23418 (rev 0) at 01:09.0, irq: 22, latency: 64, memory:
0xe8000000
cx18-0 info: attempting ioremap at 0xe8000000 len 0x04000000
cx18-0: cx23418 revision 01010000 (B)
cx18-0 info: GPIO initial dir: 0000cffe/0000ffff out: 00003001/00000000
cx18-0 info: activating i2c...
cx18-0 i2c: i2c init
cx18-0 info: Active card count: 1.
tveeprom 0-0050: Hauppauge model 74021, rev C1B2, serial# 1441469
tveeprom 0-0050: MAC address is 00-0D-FE-15-FE-BD
tveeprom 0-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 0-0050: audio processor is CX23418 (idx 38)
tveeprom 0-0050: decoder processor is CX23418 (idx 31)
tveeprom 0-0050: has no radio, has IR receiver, has IR transmitter
cx18-0: Autodetected Hauppauge HVR-1600
cx18-0 info: NTSC tuner detected
cx18-0: VBI is not yet supported
cx18-0 info: Loaded module tuner
cx18-0 info: Loaded module cs5345
cx18-0 i2c: i2c client register
tuner 1-0061: I2C RECV = 79 79 79 79 79 79 79 79 79 79 79 79 79 79 79 79
tuner 1-0061: Setting mode_mask to 0x0e
tuner 1-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
tuner 1-0061: tuner 0x61: Tuner type absent
cx18-0 i2c: i2c client register
cs5345 0-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
tuner 1-0061: TUNER_SET_TYPE_ADDR
tuner 1-0061: Calling set_type_addr for type=50, addr=0xff, mode=0x04,
config=0x32
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 50 (TCL 2002N)
tuner-simple 1-0061: tuner 0 atv rf input will be autoselected
tuner-simple 1-0061: tuner 0 dtv rf input will be autoselected
tuner 1-0061: type set to TCL 2002N
tuner 1-0061: tv freq set to 400.00
tuner-simple 1-0061: desired params (pal) undefined for tuner 50
tuner-simple 1-0061: using tuner params #0 (ntsc)
tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x02
tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 1-0061: tv 0x1b 0x6f 0x8e 0x02
tuner 1-0061: cx18 i2c driver #0-1 tuner I2C addr 0xc2 with type 50
used for 0x0e
cx18-0 info: Allocate encoder MPEG stream: 63 x 32768 buffers (2016kB total)
cx18-0 info: Allocate TS stream: 32 x 32768 buffers (1024kB total)
cx18-0 info: Allocate encoder YUV stream: 16 x 131072 buffers (2048kB total)
cx18-0 info: Allocate encoder PCM audio stream: 63 x 16384 buffers
(1008kB total)
cx18-0: Disabled encoder IDX device
cx18-0: Registered device video0 for encoder MPEG (2 MB)
DVB: registering new adapter (cx18)
MXL5005S: Attached at address 0x63
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx18-0: DVB Frontend registered
cx18-0: Registered device video32 for encoder YUV (2 MB)
cx18-0: Registered device video24 for encoder PCM audio (1 MB)
cx18-0: Initialized card #0: Hauppauge HVR-1600
cx18:  End initialization
cx18-0 info: load segment a00000-a07fff
cx18-0 info: load segment ae0000-ae00ff
cx18-0 info: load segment b00000-b1a65f
cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
cx18-0 info: 1 MiniMe Encoder Firmware 0.0.74.0 (Release 2007/03/12)
cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
cx18-0 info: load segment a00000-a07fff
cx18-0 info: load segment ae0000-ae00ff
cx18-0 info: load segment b00000-b1a65f
cx18-0 info: 1 MiniMe Encoder Firmware 0.0.74.0 (Release 2007/03/12)
cx18-0 info: Changing input from 1 to 0
cx18-0 info: Mute
cx18-0 info: cmd 4008646f triggered fw load
cx18-0: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
cx18-0 info: decoder set video input 7, audio input 8
cx18-0 i2c: call_i2c_client addr=4c
cx18-0 info: decoder set video input 7, audio input 8
cx18-0 info: Unmute
cx18-0 info: Switching standard to 1000.
cx18-0 info: changing video std to fmt 1
cx18-0 info: PLL regs = int: 15, frac: 2876158, post: 4
cx18-0 info: PLL = 0.000011 MHz
cx18-0 info: PLL/8 = 0.000001 MHz
cx18-0 info: ADC Sampling freq = 0.000001 MHz
cx18-0 info: Chroma sub-carrier freq = 0.000000 MHz
cx18-0 info: hblank 122, hactive 720, vblank 26 , vactive 487,
vblank656 26, src_dec 543,burst 0x5b, luma_lpf 1, uv_lpf 1, comb 0x66,
sc 0x087c1f
tuner 1-0061: VIDIOC_S_STD
tuner 1-0061: switching to v4l2
tuner 1-0061: tv freq set to 400.00
tuner-simple 1-0061: using tuner params #0 (ntsc)
tuner-simple 1-0061: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x02
tuner-simple 1-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=7132
tuner-simple 1-0061: tv 0x1b 0xdc 0x8e 0x02
cx18-0 info: Mute
cx18-0 info: v4l2 ioctl: set frequency 1076
tuner 1-0061: VIDIOC_S_FREQUENCY
tuner 1-0061: tv freq set to 67.25
tuner-simple 1-0061: using tuner params #0 (ntsc)
tuner-simple 1-0061: freq = 67.25 (1076), range = 0, config = 0x8e, cb = 0x01
tuner-simple 1-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
tuner-simple 1-0061: tv 0x8e 0x01 0x07 0x10
cx18-0 info: Unmute
cx18-0: VIDIOC_S_FREQUENCY tuner=0, type=2, frequency=2612
cx18-0 info: Mute
cx18-0 info: v4l2 ioctl: set frequency 2612
tuner 1-0061: VIDIOC_S_FREQUENCY
tuner 1-0061: tv freq set to 163.25
tuner-simple 1-0061: using tuner params #0 (ntsc)
tuner-simple 1-0061: freq = 163.25 (2612), range = 0, config = 0x8e, cb = 0x01
tuner-simple 1-0061: Freq= 163.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=3344
tuner-simple 1-0061: tv 0x0d 0x10 0x8e 0x01
cx18-0 info: Unmute
tuner 1-0061: VIDIOC_G_TUNER
tuner 1-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
cx18-0: VIDIOC_G_TUNER index=0, name=cx18 TV Tuner, type=2,
capability=0x72, rangelow=704, rangehigh=15328, signal=0, afc=0,
rxsubchans=0x1, audmode=3
cx18-0 ioctl: close() of encoder MPEG
cx18-0: VIDIOC_S_FREQUENCY tuner=0, type=2, frequency=8180
cx18-0 info: Mute
cx18-0 info: v4l2 ioctl: set frequency 8180
tuner 1-0061: VIDIOC_S_FREQUENCY
tuner 1-0061: tv freq set to 511.25
tuner-simple 1-0061: using tuner params #0 (ntsc)
tuner-simple 1-0061: freq = 511.25 (8180), range = 2, config = 0x8e, cb = 0x08
tuner-simple 1-0061: Freq= 511.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8912
tuner-simple 1-0061: tv 0x22 0xd0 0x8e 0x08
cx18-0 info: Unmute
tuner 1-0061: VIDIOC_G_TUNER
tuner 1-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
cx18-0: VIDIOC_G_TUNER index=0, name=cx18 TV Tuner, type=2,
capability=0x72, rangelow=704, rangehigh=15328, signal=65535, afc=0,
rxsubchans=0x1, audmode=3
cx18-0 ioctl: close() of encoder MPEG

Thanks for all your help so far.
Brian

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
