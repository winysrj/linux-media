Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8O0xNUf028270
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 20:59:23 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8O0xBVx004343
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 20:59:11 -0400
From: Andy Walls <awalls@radix.net>
To: Dale Pontius <DEPontius@edgehp.net>
In-Reply-To: <48D6FAA1.8080303@edgehp.net>
References: <48D4D5FE.60507@edgehp.net>
	<1221961427.6151.43.camel@palomino.walls.org>
	<48D6FAA1.8080303@edgehp.net>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 20:57:55 -0400
Message-Id: <1222217875.2652.73.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: HVR-1600 - unable to find tuner
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

On Sun, 2008-09-21 at 21:53 -0400, Dale Pontius wrote:
> Andy Walls wrote:
> > On Sat, 2008-09-20 at 06:52 -0400, Dale Pontius wrote:
> > 
> >> A week back I posted a "newby question," and eventually it became
> >> apparent that I can't find my tuner.
> > 
> >>  I loaded the module with:
> >> "modprobe cx18 mmio_ndelay=61"
> > 
> > You can always try higher numbers to see if things get better at some
> > higher value.  Use multiples of 30.3.
> > 
> 
> Things look a litte different with "modprobe cx18 mmio_ndelay=182 debug=67",
> and I've also added the other debug parameters you suggest later.  With that,
> here's my dmesg:
> ---------------------------------------------------------------------------
> cx18-0: Autodetected Hauppauge HVR-1600
> cx18-0 info: NTSC tuner detected

This message means the driver has likely parsed the EEPROM properly and
thinks you have an NTSC tuner (which you should).

> cx18-0: VBI is not yet supported
> cx18-0 info: Loaded module tuner
> cx18-0 info: Loaded module cs5345
> cx18-0 i2c: i2c client register

That was the analog tuner I2C device registration message.  You should
have seen:

"tuner n-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)"

if the tuner driver had found an analog tuner (mixer/oscillator chip)
responding on the proper I2C bus on this card.

This likely means the very last call to 

	i2c_new_probed_device() 

at the bottom of 

	cx18-i2c.c:cx18_i2c_register() 

is failing to return a successful probe of the tuner device.


> cx18-0 i2c: i2c client register
> cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> cx18-0 info: Allocate encoder MPEG stream: 63 x 32768 buffers (2016kB
> total)

[snip]

> tuner' 2-0061: tv freq set to 463.25
> tuner-simple 2-0061: using tuner params #0 (ntsc)
> tuner-simple 2-0061: freq = 463.25 (7412), range = 2, config = 0x8e, cb = 0x08
> tuner-simple 2-0061: Freq= 463.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8144
> tuner-simple 2-0061: tv 0x1f 0xd0 0x8e 0x08

[snip]

I'm not sure what to make of these repeated tunes to US cable channel
64.  I wouldn't expect it to happen on cx18 driver initialization.

[snip]
> cx18-0 info: Switching standard to 1000.
> cx18-0 info: changing video std to fmt 1
> cx18-0 info: PLL regs = int: 15, frac: 2876158, post: 4
> cx18-0 info: PLL = 0.000011 MHz
> cx18-0 info: PLL/8 = 0.000001 MHz
> cx18-0 info: ADC Sampling freq = 0.000001 MHz
> cx18-0 info: Chroma sub-carrier freq = 0.000000 MHz
> cx18-0 info: hblank 122, hactive 720, vblank 26 , vactive 487, vblank656 26, src_dec 543,burst 0x5b, luma_lpf 1, uv_lpf 1, comb 0x66, sc 0x087c1f
> cx18-0 info: Mute
> cx18-0 info: v4l2 ioctl: set frequency 1076

This is an attempt to tune to US broadcast and cable channel 4.  The
driver tries to do this at the end of initialization.  If the command
actually went to a tuner driver, and the tuner and tuner-simple modules
had debugging set, you should have seen more messages like the previous
tunes but to 67.25 MHz.




For reference, here is the full log from my non-MCE HVR-1600 being
initialized with the following set in /etc/modprobe.conf:

   options tuner show_i2c=1 debug=1
   options tuner-simple debug=1

and doing

   # modprobe cx18 debug=67

(with some minor changes in my stuff to do with video buffers)

cx18:  Start initialization, version 1.0.0
cx18-0: Initializing card #0
cx18-0: Autodetected Hauppauge card
cx18-0 info: base addr: 0xf8000000
cx18-0 info: Enabling pci device
ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 21 (level, low) -> IRQ 21
cx18-0 info: cx23418 (rev 0) at 03:03.0, irq: 21, latency: 64, memory: 0xf8000000
cx18-0 info: attempting ioremap at 0xf8000000 len 0x04000000
cx18-0: cx23418 revision 01010000 (B)
cx18-0 info: GPIO initial dir: 0000cffe/0000ffff out: 00003001/00000000
cx18-0 info: activating i2c...
cx18-0 i2c: i2c init
cx18-0 info: Active card count: 1.
tveeprom 0-0050: Hauppauge model 74041, rev C5B2, serial# 891351
tveeprom 0-0050: MAC address is 00-0D-FE-0D-99-D7
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
tuner 2-0061: I2C RECV = 79 79 79 79 79 79 79 79 79 79 79 79 79 79 79 79 
tuner 2-0061: Setting mode_mask to 0x0e
tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
tuner 2-0061: tuner 0x61: Tuner type absent
cx18-0 i2c: i2c client register
cs5345 0-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
tuner 2-0061: Calling set_type_addr for type=50, addr=0xff, mode=0x04, config=0x32
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 50 (TCL 2002N)
tuner-simple 2-0061: tuner 0 atv rf input will be autoselected
tuner-simple 2-0061: tuner 0 dtv rf input will be autoselected
tuner 2-0061: type set to TCL 2002N
tuner 2-0061: tv freq set to 400.00
tuner-simple 2-0061: desired params (pal) undefined for tuner 50
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x02
tuner-simple 2-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
tuner-simple 2-0061: tv 0x1b 0x6f 0x8e 0x02
tuner 2-0061: cx18 i2c driver #0-1 tuner I2C addr 0xc2 with type 50 used for 0x0e
cx18-0 info: Allocate encoder MPEG stream: 63 x 8192 buffers (504kB total)
cx18-0 info: Allocate TS stream: 63 x 8192 buffers (504kB total)
cx18-0 info: Allocate encoder YUV stream: 8 x 131072 buffers (1024kB total)
cx18-0 info: Allocate encoder PCM audio stream: 63 x 6144 buffers (378kB total)
cx18-0: Disabled encoder IDX device
cx18-0: Registered device video0 for encoder MPEG (63 x 8 kiB)
DVB: registering new adapter (cx18)
cx18-0 info: load segment a00000-a07fff
cx18-0 info: load segment ae0000-ae00ff
cx18-0 info: load segment b00000-b1a65f
cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
MXL5005S: Attached at address 0x63
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx18-0: Registered DVB adapter0 for TS (63 x 8 kiB)
cx18-0: Registered device video32 for encoder YUV (8 x 128 kiB)
cx18-0: Registered device video24 for encoder PCM audio (63 x 6 kiB)
cx18-0: Initialized card #0: Hauppauge HVR-1600
cx18:  End initialization
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
cx18-0 info: hblank 122, hactive 720, vblank 26 , vactive 487, vblank656 26, src_dec 543,burst 0x5b, luma_lpf 1, uv_lpf 1, comb 0x66, sc 0x087c1f
tuner 2-0061: switching to v4l2
tuner 2-0061: tv freq set to 400.00
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 400.00 (6400), range = 1, config = 0x8e, cb = 0x02
tuner-simple 2-0061: Freq= 400.00 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=7132
tuner-simple 2-0061: tv 0x1b 0xdc 0x8e 0x02
cx18-0 info: Mute
cx18-0 info: v4l2 ioctl: set frequency 1076
tuner 2-0061: tv freq set to 67.25
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 67.25 (1076), range = 0, config = 0x8e, cb = 0x01
tuner-simple 2-0061: Freq= 67.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=1808
tuner-simple 2-0061: tv 0x8e 0x01 0x07 0x10
cx18-0 info: Unmute



> I'm getting some noise about a tuner, but apparently not enough.  My bttv
> card attaches its tuner before (I've got the cx18 blacklisted, so it won't
> autoload.) this, and it gives more informative messages about the tuner, more
> similar to what you show.  There appears to be info here about what the tuner
> is doing, but nothing about the tuner, itself.

For testing, I'd try blacklisting the bttv driver too.  That way you can
try to modprobe the cx18 driver before any other driver has tried to
load the tuner modules.

I'm kind of in the dark about why 




> As for your later suggestions, I've set msecs_asserted=100, msecs_recovery=200,
> and mdelay(100), and the dmesg shows no significant difference.  All subsequent
> stuff is with the tweaked driver.

OK.  That should have really ensured hardware on the I2C buses was
reset.


> Incidentally, "v4l2-ctl -d /dev/video1 --log-status" gives:
> ---------------------------------------------------------------------------
> Status Log:
> 

[snip]

Your log info showed no tuner status lines.  This is a further
indication that the driver doesn't have a tuner device of it's own
registered properly.


>   I notice that the format is "NTSC-M" instead of "NTSC",
> but am not sure if that's significant.

That just means the driver read that you have an NTSC-M system tuner via
the EEPROM chip.  The standard M system is appropriate for almost all
NTSC broadcasts except in Japan and South Korea (IIRC).





> Lastly, I'm not sure how much sense this makes, "i2cdetect -y 7" :
> ---------------------------------------------------------------------------
>       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 70: -- -- -- -- -- -- -- --
> ---------------------------------------------------------------------------
> Rather indicates that nothing is there, but I suspect I did something wrong.
> It did seem to detect a tuner, and besides the tuner the other messages
> appeared to be OK.  Incidentally, this was done with the tweaked values in
> the source code.

Well there should be only one tuner (mixer/oscillator) chip on that 2nd
i2c bus on the HVR-1600 bus.  The output of i2cdetect, assuming you
queried the correct bus, says that no chip is responding anywhere on
that bus, nor has any address on that bus been claimed by a driver.

This could be because the tuner's actually bad, or simply not responding
for some reason (i.e. the reset sequence with mdelay()'s at the end of
cx18-i2c.c didn't work), or the CX23418 chip is not responding properly
on the PCI bus when querying it's I2C control registers for the second
I2C bus (weird since everything else looks to be working).


For reference, here's output from my working HVR-1600

# modprobe i2c-dev
# i2cdetect -l
i2c-1	smbus     	SMBus PIIX4 adapter at 0b00     	SMBus adapter
i2c-0	i2c       	cx18 i2c driver #0-0            	I2C adapter
i2c-2	i2c       	cx18 i2c driver #0-1            	I2C adapter

# i2cdetect -y 0
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- 19 -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- UU -- -- -- 
50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- 63 -- -- -- -- -- -- -- -- -- -- -- -- 
70: 70 71 72 73 -- -- -- --                        

(IIRC
 19 = cx25447
 4c = cs5345
 UU = device has been claimed by a driver
 50 = ATMEL eeprom
 63 = mxl5005s
 70-73 = Z8F0811 IR microcontroller)

# i2cdetect -y 2
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- UU -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --             

61 = simple tuner mixer/oscillator chip
UU = device has been claimed by a driver


> I'm wondering if either my bttv card is interfering somehow,

If you got all '--' on the i2cdetect of the correct i2c bus on the
HVR-1600, then it really can't be the bttv driver, AFAICT.

For testing, I'm going to try to implement another, agressive PCI bus
access algorithm for accessing the CX23418 instead of using simple
delays with mmio_ndelay.  I don't have a definite schedule on this yet.
I'm not hopeful that it will help though, seeing as your CX23418 seems
to behaving well otherwise (no -121 errors, can always read the eeprom,
always loads the firmware, always can init the ATSC side of the card,
etc.).


>  or if this card
> needs to be RMA'ed. 

Try it in a Windows installation first.


>  I have another identical card in an unopened box, if it's
> time to try that.

I suspect it may behave differently (manufacturing variations).  If your
second card works, it doesn't mean your first card is broken though.  It
may mean the cx18 driver needs to do something differently.  Make sure
the first card doesn't work in Windows as well before returning (if
possible).


> Thanks,
> Dale Pontius

Regards,
Andy


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
