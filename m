Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:33331 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133AbcDHX7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2016 19:59:34 -0400
Received: by mail-lf0-f50.google.com with SMTP id e190so93238918lfe.0
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2016 16:59:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57083b12.ec3ec20a.eed91.1ea1SMTPIN_ADDED_BROKEN@mx.google.com>
References: <57083b12.ec3ec20a.eed91.1ea1SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Sat, 9 Apr 2016 01:59:31 +0200
Message-ID: <CAO8Cc0qC79u_BBV3xaat3Cy6E2XB+GtJfJSf3aCJX==Q++BaXg@mail.gmail.com>
Subject: Re: AVerMedia HD Volar (A867) AF9035 + MXL5007T driver issues
From: Alessandro Radicati <alessandro@radicati.net>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jose, Antti,
The no_probe option or similar is the only fix I could find (in fact i
was going to propose a similar patch to what you have).  I've tried
all combinations of firmware and also tried issuing the read command
to the tuner in different states (e.g. sleep, just after soft/hard
reset) to no avail.  I've modified AverMedia's linux driver to probe
as well, and the same thing happens.  I found the following behavior
in further testing:

- I can arbitrarily read as many bytes as I want from any valid
register and the tuner will continue responding until the af9035
issues the expected NAK to signal the end of the read so that the
mxl5007t can release the bus.  The bus doesn't get released and it
stays stuck either high or low indefinitely so subsequent I2C commands
fail.
- Hard reset of the tuner by cycling af9035 GPIOH12 seems like the
only way to recover.  So mxl5007t is probably at fault.  Perhaps I2C
speed is too fast (SCL cycles at ~100KHz)?  Faulty hardware design of
the usb stick?
- Doesn't seem like the OEM drivers ever issue I2C read commands.
Maybe it's a known issue to them.

I'm pretty much out of ideas to test.  Suggestions are welcome.
Otherwise I'll try to push through a patch for just "no_probe".

Thanks,
Alessandro

On Sat, Apr 9, 2016 at 1:13 AM, Jose Alberto Reguero
<jareguero@telefonica.net> wrote:
> I made a patch long time ago, but it was not accepted.
>
> https://patchwork.linuxtv.org/patch/16242/
>
> Jose Alberto
>
> El 06/04/2016 01:00, Alessandro Radicati <alessandro@radicati.net> escribió:
>>
>> On Wed, Apr 6, 2016 at 12:33 AM, Antti Palosaari <crope@iki.fi> wrote:
>> > I found one stick having AF9035 + MXL5007T. It is HP branded A867, so it
>> > should be similar. It seems to work all three 12.13.15.0 6.20.15.0
>> > firmwares:
>> > http://palosaari.fi/linux/v4l-dvb/firmware/af9035/
>> >
>> > mxl5007t 5-0060: creating new instance
>> > mxl5007t_get_chip_id: unknown rev (3f)
>> > mxl5007t_get_chip_id: MxL5007T detected @ 5-0060
>> >
>> > That is what AF9035 reports (with debug) as a chip version:
>> > dvb_usb_af9035: prechip_version=00 chip_version=03 chip_type=3802
>> >
>> >
>> > Do you have different chip version?
>> >
>>
>> I have a Sky Italy DVB stick with the same chip version.  I see that
>> you get the 0x3f response as well... that should be fixed by the I2C
>> patch I proposed.  However, your stick seems to handle the read
>> properly and process subsequent I2C commands - something that doesn't
>> happen with mine.  The vendor drivers in linux and windows never seem
>> issue the USB I2C commands to read from the tuner.  I'll test with
>> other firmware versions to see if something changes.
>>
>> Regards,
>> Alessandro
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
