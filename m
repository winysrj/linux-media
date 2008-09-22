Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8M1srxZ016965
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 21:54:53 -0400
Received: from mho-02-bos.mailhop.org (mho-02-bos.mailhop.org [63.208.196.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8M1rVqb030120
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 21:53:32 -0400
Message-ID: <48D6FAA1.8080303@edgehp.net>
Date: Sun, 21 Sep 2008 21:53:37 -0400
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <48D4D5FE.60507@edgehp.net>
	<1221961427.6151.43.camel@palomino.walls.org>
In-Reply-To: <1221961427.6151.43.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Andy Walls wrote:
> On Sat, 2008-09-20 at 06:52 -0400, Dale Pontius wrote:
> 
>> A week back I posted a "newby question," and eventually it became
>> apparent that I can't find my tuner.
> 
>>  I loaded the module with:
>> "modprobe cx18 mmio_ndelay=61"
> 
> You can always try higher numbers to see if things get better at some
> higher value.  Use multiples of 30.3.
> 

Things look a litte different with "modprobe cx18 mmio_ndelay=182 debug=67",
and I've also added the other debug parameters you suggest later.  With that,
here's my dmesg:
---------------------------------------------------------------------------
cx18-0: Autodetected Hauppauge HVR-1600
cx18-0 info: NTSC tuner detected
cx18-0: VBI is not yet supported
cx18-0 info: Loaded module tuner
cx18-0 info: Loaded module cs5345
cx18-0 i2c: i2c client register
cx18-0 i2c: i2c client register
cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
cx18-0 info: Allocate encoder MPEG stream: 63 x 32768 buffers (2016kB total)
cx18-0 info: Allocate TS stream: 32 x 32768 buffers (1024kB total)
cx18-0 info: Allocate encoder YUV stream: 16 x 131072 buffers (2048kB total)
cx18-0 info: Allocate encoder PCM audio stream: 63 x 16384 buffers (1008kB total)
cx18-0: Disabled encoder IDX device
cx18-0: Registered device video1 for encoder MPEG (2 MB)
DVB: registering new adapter (cx18)
MXL5005S: Attached at address 0x63
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx18-0: DVB Frontend registered
cx18-0: Registered device video32 for encoder YUV (2 MB)
cx18-0: Registered device video24 for encoder PCM audio (1 MB)
cx18-0: Initialized card #0: Hauppauge HVR-1600
cx18:  End initialization
tuner' 2-0061: tv freq set to 463.25
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 463.25 (7412), range = 2, config = 0x8e, cb = 0x08
tuner-simple 2-0061: Freq= 463.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8144
tuner-simple 2-0061: tv 0x1f 0xd0 0x8e 0x08
tuner' 2-0061: tv freq set to 463.25
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 463.25 (7412), range = 2, config = 0x8e, cb = 0x08
tuner-simple 2-0061: Freq= 463.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8144
tuner-simple 2-0061: tv 0x1f 0xd0 0x8e 0x08
tuner' 2-0061: tv freq set to 463.25
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 463.25 (7412), range = 2, config = 0x8e, cb = 0x08
tuner-simple 2-0061: Freq= 463.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8144
tuner-simple 2-0061: tv 0x1f 0xd0 0x8e 0x08
tuner' 2-0061: tv freq set to 463.25
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 463.25 (7412), range = 2, config = 0x8e, cb = 0x08
tuner-simple 2-0061: Freq= 463.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8144
tuner-simple 2-0061: tv 0x1f 0xd0 0x8e 0x08
tuner' 2-0061: tv freq set to 463.25
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 463.25 (7412), range = 2, config = 0x8e, cb = 0x08
tuner-simple 2-0061: Freq= 463.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8144
tuner-simple 2-0061: tv 0x1f 0xd0 0x8e 0x08
tuner' 2-0061: tv freq set to 463.25
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 463.25 (7412), range = 2, config = 0x8e, cb = 0x08
tuner-simple 2-0061: Freq= 463.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8144
tuner-simple 2-0061: tv 0x1f 0xd0 0x8e 0x08
tuner' 2-0061: tv freq set to 463.25
tuner-simple 2-0061: using tuner params #0 (ntsc)
tuner-simple 2-0061: freq = 463.25 (7412), range = 2, config = 0x8e, cb = 0x08
tuner-simple 2-0061: Freq= 463.25 MHz, V_IF=45.75 MHz, Offset=0.00 MHz, div=8144
tuner-simple 2-0061: tv 0x1f 0xd0 0x8e 0x08
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
cx18-0 info: hblank 122, hactive 720, vblank 26 , vactive 487, vblank656 26, src_dec 543,burst 0x5b, luma_lpf 1, uv_lpf 1, comb 0x66, sc 0x087c1f
cx18-0 info: Mute
cx18-0 info: v4l2 ioctl: set frequency 1076
cx18-0 info: Unmute
---------------------------------------------------------------------------
I'm getting some noise about a tuner, but apparently not enough.  My bttv
card attaches its tuner before (I've got the cx18 blacklisted, so it won't
autoload.) this, and it gives more informative messages about the tuner, more
similar to what you show.  There appears to be info here about what the tuner
is doing, but nothing about the tuner, itself.

As for your later suggestions, I've set msecs_asserted=100, msecs_recovery=200,
and mdelay(100), and the dmesg shows no significant difference.  All subsequent
stuff is with the tweaked driver.

Incidentally, "v4l2-ctl -d /dev/video1 --log-status" gives:
---------------------------------------------------------------------------
Status Log:

    cx18-0: =================  START STATUS CARD #0  =================
    tveeprom 6-0050: Hauppauge model 74041, rev C6B2, serial# 3334244
    tveeprom 6-0050: MAC address is 00-0D-FE-32-E0-64
    tveeprom 6-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
    tveeprom 6-0050: TV standards NTSC(M) (eeprom 0x08)
    tveeprom 6-0050: audio processor is CX23418 (idx 38)
    tveeprom 6-0050: decoder processor is CX23418 (idx 31)
    tveeprom 6-0050: has no radio, has IR receiver, has IR transmitter
    cx18-0: Video signal:              not present
    cx18-0: Detected format:           NTSC-M
    cx18-0: Specified standard:        NTSC-M
    cx18-0: Specified video input:     Composite 7
    cx18-0: Specified audioclock freq: 32000 Hz
    cx18-0: Detected audio mode:       mono
    cx18-0: Detected audio standard:   no detected audio standard
    cx18-0: Audio muted:               yes
    cx18-0: Audio microcontroller:     running
    cx18-0: Configured audio standard: automatic detection
    cx18-0: Configured audio system:   BTSC
    cx18-0: Specified audio input:     Tuner (In8)
    cx18-0: Preferred audio mode:      stereo
    cs5345 6-004c: Input:  1
    cs5345 6-004c: Volume: 0 dB
    cx18-0: Video Input: Tuner 1
    cx18-0: Audio Input: Tuner 1
    cx18-0: GPIO:  direction 0x00003001, value 0x00003001
    cx18-0: Tuner: TV
    cx18-0: Stream: MPEG-2 Program Stream
    cx18-0: VBI Format: No VBI
    cx18-0: Video:  480x480, 30 fps
    cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 4500000, Peak 6000000
    cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
    cx18-0: Audio:  32 kHz, MPEG-1/2 Layer II, 384 kbps, Stereo, No Emphasis, No CRC
    cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
    cx18-0: Temporal Filter: Manual, 0
    cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
    cx18-0: Status flags: 0x00200001
    cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2016 KiB (63 buffers) in use
    cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use
    cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1008 KiB (63 buffers) in use
    cx18-0: Read MPEG/VBI: 23478272/0 bytes
    cx18-0: ==================  END STATUS CARD #0  ==================
---------------------------------------------------------------------------
Still "Video signal: not present".  The resolution is odd, but that's because
MythTV has touched it.  I notice that the format is "NTSC-M" instead of "NTSC",
but am not sure if that's significant.

Lastly, I'm not sure how much sense this makes, "i2cdetect -y 7" :
---------------------------------------------------------------------------
      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
---------------------------------------------------------------------------
Rather indicates that nothing is there, but I suspect I did something wrong.
It did seem to detect a tuner, and besides the tuner the other messages
appeared to be OK.  Incidentally, this was done with the tweaked values in
the source code.

I'm wondering if either my bttv card is interfering somehow, or if this card
needs to be RMA'ed.  I have another identical card in an unopened box, if it's
time to try that.  I'll have to check the doc to see if Win98SE is supported,
but I don't have a handy WinXP machine to try this in.  My cunning plan was
to move to the dual Hauppauge cards because I figured I couldn't do software
encoding with 2 simple cards in one box.  The HVR-1600 left me ready for the
cutover, and MythTV with a "strategy" for sticking with my old TVs.

Thanks,
Dale Pontius

>>  or suggest a next step in finding my tuner?
> 
> 1. Make sure you have tuner modules installed somewhere
> under /lib/modules (i.e. tuner.ko, tuner-simple.ko, etc.)
> 
> 2. Turn on some debugging in /etc/modprobe.conf:
> 
> 	options tuner debug=1 show_i2c=1
> 	options tuner-simple debug=1
> 	options cx18 debug=67
> 	
> and see, if on module load, something obviously looks wrong.
> 
> 3. You can increase the msecs_asserted and msecs_recovery in
> linux/drivers/media/video/cx18/cx18-cards.c and the mdelays() in
> linux/drivers/media/video/cx18/cx18-i2c.c to some ridiculously high
> numbers (e.g. 100 msec) to make sure everything connected to the I2C
> buses gets reset.  (Obviously rebuild and reinstall the cx18.ko module.)
> 
> 4. As I mentioned before, you may just need to set the mmio_ndelay
> number higher.  From my observations, the CX23418 appears to have a
> problem when accessing one set of its registers and then jumping to
> access registers in a different part of its register address space with
> no "dead time" in between.  The control registers for the first and
> second I2C bus masters are about 64k apart, and, of course, accessed
> almost back to back during module initialization.  The mmio_ndelay
> parameter adds in the "dead time" the CX23418 occasionally seems to
> need.
> 
> 
> Good luck.
> 
> Andy
> 
>> Thanks,
>> Dale Pontius
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
