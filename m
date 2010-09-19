Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab0ISAmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 20:42:13 -0400
Received: by ewy23 with SMTP id 23so1324485ewy.19
        for <linux-media@vger.kernel.org>; Sat, 18 Sep 2010 17:42:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284812434.2053.28.camel@morgan.silverblock.net>
References: <AANLkTimt5bs1fNp=+36VLaTy0Kwi1rDPcpUTeN4z+c35@mail.gmail.com>
	<1284677325.2056.17.camel@morgan.silverblock.net>
	<AANLkTinddFfzQtaW_gUqi18OSPn437JTFiRa1HKM8Nva@mail.gmail.com>
	<1284812434.2053.28.camel@morgan.silverblock.net>
Date: Sat, 18 Sep 2010 20:42:11 -0400
Message-ID: <AANLkTi=HzqGW6qLxhTXprNW03LsnGjZ4Cg_PC=Wspv1A@mail.gmail.com>
Subject: Re: HVR 1600 Distortion
From: Josh Borke <joshborke@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Sep 18, 2010 at 8:20 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Fri, 2010-09-17 at 18:23 -0400, Josh Borke wrote:
>> Thanks for the response!  Replies are in line.
>>
>> On Thu, Sep 16, 2010 at 6:48 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> > On Wed, 2010-09-15 at 22:54 -0400, Josh Borke wrote:
>> >> I've recently noticed some distortion coming from my hvr1600 when
>> >> viewing analog channels.  It happens to all analog channels with some
>> >> slightly better than others.  I am running Fedora 12 linux with kernel
>> >> version 2.6.32.21-166.
>> >
>> >
>> >> I know I need to include more information but I'm not sure what to
>> >> include.  Any help would be appreciated.
>> >
>> > 1. Would you say the distortion is something you would possibly
>> > encounter on an analog television set, or does it look "uniquely
>> > digital"?  On systems with a long uptime and lots of usage, MPEG encoder
>> > firmware could wind up in a screwed up state giving weird output image.
>> > Simple solution in this case is to reboot.
>>
>> I'm not sure if I would classify it as "uniquely digital".  The
>> distortion happens across most of the screen with it being
>> concentrated in the top third.  Additionally shows that include black
>> bars the top black bar is seemingly stretched and the image seems like
>> the colors are over-saturated where they colors are brighter.
>> Rebooting had no effect :(
>
> OK.
>
>> > 2. Have you ensured your cable plant isn't affecting signal integrity?
>> > http://ivtvdriver.org/index.php/Howto:Improve_signal_quality
>>
>> The cable plant hasn't changed the signal strength or integrity as far
>> as I know.
>
> OK.  Keep it in the back of your mind though.
>
>> > 3. Does this happen with only the RF tuner or only CVBS or only SVideo
>> > or more than one of them?  If the problem is only with RF, then it could
>> > be an incoming signal distortion problem.  Do you have cable or an over
>> > the air antenna for analog RF?
>>
>> I only have input for the RF tuner.  I have cable for analog RF.
>
> Please try and test the output of a VCR or DVD play plugged into the
> HVR-1600.  (We don't need sound, just the video.)
>
> This will tell us if the problem happens before the CX23418 chip's
> analog front end (i.e. in the RF and analog tuner) or not.
>
>
> $ v4l2-ctl -d /dev/video0 -n
> (List of possible inputs displayed)
>
> $ v4l2-ctl -d /dev/video0 -i 2
> Video input set to 2 (Composite 1)
>
> # v4l2-ctl -d /dev/video0 -s ntsc-m
> Standard set to 00001000
>
> $ cat /dev/video0 > foo.mpg
> ^C
>

I only have S-Video but doing this produced a perfect picture.

>
>> > 4. What does v4l2-ctl --log-status show as your analog tuner?
>>
>> Not sure what you mean so I've included the full output:
>> # v4l2-ctl -d /dev/hvr1600 --log-status
>>
>> Status Log:
>>
>>    cx18-0: =================  START STATUS CARD #0  =================
>>    cx18-0: Version: 1.2.0  Card: Hauppauge HVR-1600
>>    tveeprom 3-0050: Hauppauge model 74041, rev C6B2, serial# 898361
>>    tveeprom 3-0050: MAC address is 00-0D-FE-0D-B5-39
>>    tveeprom 3-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
>                                     ^^^^^^^^^^^^^^
> OK.  You have a board with the same tuner as I have.
>
> All I have for an analog RF source is a DTV STB, so a very clean channel
> 3 is all I have to try and duplicate the problem.
>
>
>>    tveeprom 3-0050: TV standards NTSC(M) (eeprom 0x08)
>>    tveeprom 3-0050: audio processor is CX23418 (idx 38)
>>    tveeprom 3-0050: decoder processor is CX23418 (idx 31)
>>    tveeprom 3-0050: has no radio, has IR receiver, has IR transmitter
>>    cx18-0 843: Video signal:              present
>>    cx18-0 843: Detected format:           NTSC-M
>>    cx18-0 843: Specified standard:        NTSC-M
>>    cx18-0 843: Specified video input:     Composite 7
>>    cx18-0 843: Specified audioclock freq: 48000 Hz
>>    cx18-0 843: Detected audio mode:       mono
>>    cx18-0 843: Detected audio standard:   BTSC
>>    cx18-0 843: Audio muted:               no
>>    cx18-0 843: Audio microcontroller:     running
>>    cx18-0 843: Configured audio standard: automatic detection
>>    cx18-0 843: Configured audio system:   BTSC
>>    cx18-0 843: Specified audio input:     Tuner (In8)
>>    cx18-0 843: Preferred audio mode:      stereo
>>    cx18-0 gpio-reset-ctrl: GPIO:  direction 0x00003001, value 0x00003001
>>    tuner 4-0061: Tuner mode:      analog TV
>>    tuner 4-0061: Frequency:       175.25 MHz
>                                    ^^^^^^
> This is the freq for both US Broadcast and US Cable channel 7 BTW.
>
>
>>    tuner 4-0061: Standard:        0x0000b000
>>    cs5345 3-004c: Input:  1
>>    cs5345 3-004c: Volume: 0 dB
>>    cx18-0: Video Input: Tuner 1
>>    cx18-0: Audio Input: Tuner 1
>>    cx18-0: GPIO:  direction 0x00003001, value 0x00003001
>>    cx18-0: Tuner: TV
>>    cx18-0: Stream: MPEG-2 Program Stream
>>    cx18-0: VBI Format: Private packet, IVTV format
>>    cx18-0: Video:  720x480, 30 fps
>>    cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 6600000, Peak 6600000
>>    cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure
>>    cx18-0: Audio:  48 kHz, MPEG-1/2 Layer II, 384 kbps, Stereo, No
>> Emphasis, No CRC
>>    cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
>>    cx18-0: Temporal Filter: Manual, 8
>>    cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]
>>    cx18-0: Status flags: 0x00200001
>>    cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2048 KiB (64
>> buffers) in use
>>    cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use
>>    cx18-0: Stream encoder VBI: status 0x0000, 0% of 1015 KiB (20 buffers) in use
>>    cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1024 KiB
>> (256 buffers) in use
>>    cx18-0: Read MPEG/VBI: 3507263488/15001920 bytes
>>    cx18-0: ==================  END STATUS CARD #0  ==================
>>
>>
>> > 5. Do you have a kernel with the new concurrency managed workqueues?
>> > On these kernels 'ps axf' will *not* show kernel threads with names like
>> > [cx18-0-in], [cx18-0-out/0], [cx18-0-out/1].  This is a major kernel
>> > change which could cause some MPEG buffers to be lost or reordered, if
>> > the new workqueue implementation has bugs.
>> >
>> ps axf shows [cx18-0-in], [cx18-0-out/0], [cx18-0-out/1],
>> [cx18-0-out/2], [cx18-0-out/3]
>
> OK.  That eliminates that potential source of problems.
>
>
>> > 6. Have you recently installed new hardware in the subject computer?  Of
>> > most interest are adapter cards with cables coming off of them and cards
>> > very close to the HVR-1600.  EMI can be picked up by the HVR-1600's
>> > board traces that are not shielded.
>> >
>>
>> Haven't changed any of the hardware in the system.
>
> OK.
>
>> > 7. Does the distortion look like loss of horizontal line sync and happen
>> > only near very bright parts of the image on the left edge?  If it does,
>> > the baseband video signal level is too high.
>>
>> It does seem to be worse in brighter areas of the screen.  Inserting
>> additional splitters (to reduce the signal strength) has no affect.
>
> OK.  The problem I mentioned is usually for when you have a very good
> picture otherwise.  If the entire image is poor, then this likely isn't
> the cause.
>
>> > 8. Care to post a short image in a paste bin or email a small MPEG to
>> > me?
>>
>> I've tried using $ ivtv-tune -c 71 -d /dev/hvr1600 followed by $ cat
>> /dev/hvr1600 > /tmp/test.mpg then ctrl+c'ing that after a few seconds
>> but it results in garbage.  Do you have a better method?
>
> So try this:
>
> 1. Configure your system so they MythTV backend, or any other
> application that messes with the video card, won't start up on reboot.
>
> 2. Shutdown the machine & power-off & power back on.
>
> 3. Do these for steps for US Cable
>
> $ v4l2-ctl -d /dev/video0 -i 0
> Video input set to 0 (Tuner 1)
>
> $ ivtv-tune -d /dev/video0 -t us-cable -c 7
> /dev/video0: 175.250 MHz
>
> $ cat /dev/video0 > foo.mpg
>
>
> Note that v4l2-ctl and ivtv-tune default to "/dev/video0", but I see you
> have a "/dev/hvr1600"(?).  In all my examples, I explicitly call out the
> device node as "/dev/video0".  Please replace "/dev/video0" with the
> appropriate device node name on your system.
>
>

I've mapped mine to hvr1600 so that it always gets the same device name.
>
>
>>   I'll email
>> you that file so you can see it anyway.  Most of my recordings are
>> from using mythtv and the results are at least watchable.
>> > Regards,
>> > Andy
>> >
>
> Received it.  It looks really, really bad: like an untuned channel.
> Please try again with the steps I provided explicitly calling out the
> device node.
>
> Thanks,
> Andy
>
>
>

Thanks for your help!
-josh
