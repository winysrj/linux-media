Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39052 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2LHNwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 08:52:31 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so778246eek.19
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2012 05:52:30 -0800 (PST)
Message-ID: <50C34628.5030407@googlemail.com>
Date: Sat, 08 Dec 2012 14:52:40 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net>
In-Reply-To: <50C12302.80603@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.12.2012 23:58, schrieb Matthew Gyurgyik:
> On 12/06/2012 04:49 PM, Frank Schäfer wrote:
>>
>>
>> Did you switch back to
>>
>>      .mpeg_mode      = LGDT3305_MPEG_SERIAL,
>>      .tpclk_edge         = LGDT3305_TPCLK_FALLING_EDGE,
>>
>> in struct lgdt3305_config em2874_lgdt3305_dev (em28xx-dvb.c) before
>> testing this ?
>>
>> You could also play with the other gpio settings.
>>
>> And the last idea (at the moment):
>>
>> +    /* 0db0:8810 MSI DIGIVOX ATSC (HU345-Q)
>> +     * Empia EM2874B + TDA18271HDC2 + LGDT3305 */
>> +    [EM2874_BOARD_MSI_DIGIVOX_ATSC] = {
>> +        .name         = "MSI DIGIVOX ATSC",
>> +        .dvb_gpio     = msi_digivox_atsc,
>> +        .has_dvb      = 1,
>> +        .tuner_type   = TUNER_ABSENT,
>> +        .ir_codes     = RC_MAP_MSI_DIGIVOX_III,        /* just a guess
>> from looking at the picture */
>> +        .xclk         = EM28XX_XCLK_FREQUENCY_12MHZ,    /* TODO */
>> +        .i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
>> +                EM28XX_I2C_CLK_WAIT_ENABLE |
>> +                EM28XX_I2C_FREQ_100_KHZ,
>> +    },
>>
>> => change .xclk to 0x0f.
>> We know that 12MHz is the right xclk setting, which means 0x07. But OTOH
>> the Windows drivers seems to use 0x0f instead and we don't what 0x0f
>> means...
>>
>> Hope this helps,
>> Frank
>>
>
> I lied, it works! I must have forgotten to do run make modules_install
> or something! This patch accurately states my current code changes:
> http://pyther.net/a/digivox_atsc/diff-Dec-06-v1.patch

Great, that's a big one step forward.

Based on this (your) patch, could you please verify that ist was really
the adding of

    {0x0d,            0x42, 0xff,   0},

to struct em28xx_reg_seq msi_digivox_atsc ? The tests before this change
were all made with a wrong combination of configuration values for the
LGDT3305...

Regards,
Frank

