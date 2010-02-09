Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:64928 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab0BIPZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 10:25:37 -0500
Received: by bwz23 with SMTP id 23so265266bwz.1
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2010 07:25:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <47786.707.qm@web33501.mail.mud.yahoo.com>
References: <47786.707.qm@web33501.mail.mud.yahoo.com>
Date: Tue, 9 Feb 2010 10:25:34 -0500
Message-ID: <829197381002090725m2ec3c6c3r346c32f965a5a198@mail.gmail.com>
Subject: Re: Leadtek WinFast DVR3100 H zl10353_read_register: readreg error
	(reg=127, ret==-6)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Patrick Cairns <patrick_cairns@yahoo.com>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 9, 2010 at 10:19 AM, Patrick Cairns
<patrick_cairns@yahoo.com> wrote:
> Hi Andy
>
> Andy Walls wrote:
>
>>
>> Hi Patrick,
>>
>> On Tue, 2010-02-09 at 03:35 -0800, Patrick Cairns wrote:
>> > Hello
>> >
>> > I'm testing use of multiple Leadtek WinFast DVR3100 H cards for a
>> > project.  I've had large numbers of them working well in the same
>> > machine as encoders (haven't been using the DVB-T capabilities).
>> >
>> > However if I use more than a few of these cards in the same machine
>> > then upon startup there are always one or two cards where Zarlink
>> > zl10353 reading errors are reported preventing their use:-
>> >
>> > options: enc_yuv_buffers=0 enc_pcm_buffers=0 enc_vbi_buffers=0 radio=0
>> enc_idx_buffers=0 enc_mpg_bufsize=64
>> >
>> > cx18-10: Initializing card 10
>> > cx18-10: Autodetected Leadtek WinFast DVR3100 H card
>> > cx18 0000:05:09.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>> > cx18-10: Unreasonably low latency timer, setting to 64 (was 32)
>> > cx18-10: cx23418 revision 01010000 (B)
>> > cx18-10: Simultaneous DVB-T and Analog capture supported,
>> >        except when capturing Analog from the antenna input.
>> > IRQ 18/cx18-10: IRQF_DISABLED is not guaranteed on shared IRQs
>> > cx18-10: Disabled encoder YUV device
>> > cx18-10: Disabled encoder VBI device
>> > cx18-10: Disabled encoder PCM audio device
>> > cx18-10: Disabled encoder IDX device
>> > cx18-10: Registered device video10 for encoder MPEG (32 x 64 kB)
>> > DVB: registering new adapter (cx18)
>> > zl10353_read_register: readreg error (reg=127, ret==-6)
>>
>> Register 127 is the CHIP_ID register of the Zarlink ZL10353, it is the
>> first register the zl10353 driver tries to read.  It is returning with
>> an error obviously.
>>
>> > cx18-10: frontend initialization failed
>> > cx18-10: DVB failed to register
>> > cx18-10: Registered device radio10 for encoder radio
>>
>> Hmmm. I have to look into why the radio=0 option isn't honored.
>
> yeah, doesn't appear to disable.
>
>>
>> > cx18-10: Error -1 registering devices
>> > cx18-10: Error -1 on initialization
>> > cx18: probe of 0000:05:09.0 failed with error -1
>> >
>> > Looking/flailing around for more diagnostic information and related
>> > posts I tried a few things and found that if I enabled the bit_test in
>> > i2c-algo-bit, the second test failed with the offending cards whereas
>> > it normally succeeds.  I'm not certain this is relevant but it might
>> > indicate an underlying fault in card<->driver communication:-
>> >
>> > cx18-10: Initializing card 10
>> > cx18-10: Autodetected Leadtek WinFast DVR3100 H card
>> > cx18-10: cx23418 revision 01010000 (B)
>> > cx18-10:  i2c: i2c init
>> > cx18 i2c driver #10-0: Test OK
>> > cx18 i2c driver #10-1: bus seems to be busy
>> > cx18-10: Could not initialize i2c
>> > cx18-10: Error -19 on initialization
>>
>> This was an excellent test to perform.  IIRC, only the ZL10353 and
>> XC3028 are on the second I2C bus (#10-1 in this case), which likely
>> means one of those two chips is hung.
>>
>> In the cx18 driver, I have a way of explicitly resetting the XC3028, and
>> the driver does reset it.  So either the XC3028 may not be all the way
>> out of reset yet or the ZL10353 is hung.
>>
>>
>> > Can anyone advise how to debug this further or know any fixes to try?
>> > I'm not quite sure what's going on under the hood.
>>
>>
>> In cx18-gpio.c:resetctrl_reset(), find
>>
>>        case CX18_GPIO_RESET_XC2028:
>>                if (cx->card->tuners[0].tuner == TUNER_XC2028)
>>                        gpio_reset_seq(cx, (1 << cx->card->xceive_pin), 0,
>>                                        1, 1);
>>
>> and change the "1, 1);" from 1 msec assert and recovery delays to
>> something like 30 msec for each.  Most likely the recovery delay (the
>> second one) will be the one that matters.  We want to make sure the
>> XC3028 is out of reset before talking on the I2C bus to the ZL10353.
>>
>
>
> I gave that a whirl.  That CX18_GPIO_RESET_XC2028 call only seems to get called later along with the firmware being loaded at the point where the device is accessing using my v4l application and if I try modifying the times to 30 msec instead of 1 it doesn't prevent or fix future occurrences of the error (eg if I reboot/remodprobe the cx18 driver).
>>
>> I'll have to look at what can be done to reset the ZL10353. I don't know
>> if the board has a separate hardware line to the ZL10353, so this may
>> not be possible.
>>
>
>>
>> (I should really also implement hardware master I2C in the cx18 driver
>> instead of bit-banging I2C, but I suspect it would be unlikely to have
>> an effect on this particular problem.)
>>
>> > More information:-
>> >
>> > Tested against Kernel 2.6.32 (our own custom config including
>> > increased max dvb adapter count) with or without latest v4l staging
>> > development repository overlayed (the above dmesg output is from the
>> > default 2.6.32 v4l).
>> >
>> > The problem almost always persists across soft reboots affecting the
>> > same one or two cards each time.  A full power cycle however often
>> > results in different cards being affected.  Reordering cards, varying
>> > bus positions/locations (there are 3 buses on my main test system) has
>> > no apparent effect on the problem.  So there is apparent randomness.
>> > Problem has occurred with as few as 4 cards (not sure about 2/3 yet).
>> > Sometimes, after a power cycle, no cards are affected, but within a
>> > few soft cycles, one or 2 cards become afflicted and the problem
>> > remains until power cycled.
>>  ^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> Sounds like the ZL10353 getting hung.
>>
>> So do you need the DVB side at all, or would you be OK with a patch to
>> have the card working with only analog baseband (the tuner is on the
>> problem I2C bus), if DVB initialization fails?
>>
>
> Interesting, yeah although I'll want use of the v4l analogue tuning and perhaps the DVB frontend for DVB-T later, a patch to bypass this failure and work without these could be really very useful to me in the short term.
>
> I've learned a little more about how this hangs together from your email, thanks!
>
>> > I'm now testing a couple of alternative systems to see if the same
>> > behaviour occurs there but thought it best at this stage to post for
>> > suggestions.
>> >
>> > Regards
>> >
>> > Patrick Cairns
>>
>> Regards,
>> Andy

Are we sure the zl10353 is being reset at all?  I've seen cases before
where the zl10353 can hang the entire i2c bus ( in particular with the
i2c_gate_ctrl issue), and the only path to recovery is strobing the
chip reset.  It's possible that the GPIO for resetting the zl10353 is
just *wrong* because somebody copied it from some other board profile,
and the chip is never being reset.

Oh, on an unrelated note, I believe the required xc3028 reset strobe
time is supposed to be 10ms, but I would have to double check the docs
to confirm.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
