Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45089 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3KIDZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Nov 2013 22:25:21 -0500
Received: by mail-lb0-f178.google.com with SMTP id l4so1987972lbv.9
        for <linux-media@vger.kernel.org>; Fri, 08 Nov 2013 19:25:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <527DA266.2030903@iki.fi>
References: <1383760655-11388-1-git-send-email-crope@iki.fi>
	<1383760655-11388-4-git-send-email-crope@iki.fi>
	<CAHFNz9KKajctZphw5bNCoYAyG15Bo+SDWNY=TXR0o337dXyzKA@mail.gmail.com>
	<527DA266.2030903@iki.fi>
Date: Sat, 9 Nov 2013 08:55:19 +0530
Message-ID: <CAHFNz9Lm+NUBe-o4MNZFXPdkjVOWdD-6z6pJ7JEE7a-LWi7e0w@mail.gmail.com>
Subject: Re: [PATCH 3/8] Montage M88DS3103 DVB-S/S2 demodulator driver
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 9, 2013 at 8:18 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 09.11.2013 04:35, Manu Abraham wrote:
>>
>> On Wed, Nov 6, 2013 at 11:27 PM, Antti Palosaari <crope@iki.fi> wrote:
>
>
>
>>> +/*
>>> + * Driver implements own I2C-adapter for tuner I2C access. That's since
>>> chip
>>> + * has I2C-gate control which closes gate automatically after I2C
>>> transfer.
>>> + * Using own I2C adapter we can workaround that.
>>> + */
>>
>>
>>
>> Why should the demodulator implement it's own adapter for tuner access ?
>
>
> In order to implement it properly.
>
>
>
>> DS3103 is identical to DS3002, DS3000 which is similar to all other
>> dvb demodulators. Comparing datsheets of these demodulators
>> with others, I can't see any difference in the repeater setup, except
>> for an additional bit field to control the repeater block itself.
>>
>> Also, from what I see, the vendor; Montage has a driver, which appears
>> to be more code complete looking at this url. http://goo.gl/biaPYu
>>
>> Do you still think the DS3103 is much different in comparison ?
>

DS3000 demodulator datasheet states:

To avoid unwanted noise disturbing the tuner performance, the
M88DS3000 offers a 2-wire bus repeater dedicated for tuner
control. The tuner is connected to the M88DS3000 through the
SCLT and SDAT pins. See Figure 11. Every time the 2-wire bus
master wants to access the tuner registers, it must enable the
repeater first. When the repeater is enabled, the SDAT and SCLT
pins are active. The messages on the SDA and SCL pins is
repeated on the SDAT and SCLT pins. The repeater will be
automatically disabled once the access times to the tuner
reaches the configured value. When disabled, the SCLT and
SDAT pins are completely isolated from the 2-wire bus and
become inactive (HIGH).

DS3002 demodulator datasheet states:

To avoid unwanted noise disturbing the tuner performance, the
M88DS3002B offers a 2-wire bus repeater dedicated for tuner
control. The tuner is connected to the M88DS3002B through
the SCLT and SDAT pins. See Figure 12. Every time the 2-wire
bus master wants to access the tuner registers, it must enable
the repeater first by configuring bit 2_WIRE_REP_EN (03H).
When the repeater is enabled, the SDAT and SCLT pins are
active. The messages on the SDA and SCL pins is repeated
on the SDAT and SCLT pins. The repeater will be automatically
disabled once the access times to the tuner reaches the
configured value set in bits 2_WIRE_REP_TM[2:0] (03H).
When disabled, the SCLT and SDAT pins are completely
isolated from the 2-wire bus and become inactive (HIGH).

DS3013 demodulator datasheet states:

To avoid unwanted noise disturbing the tuner performance, the
M88DS3103 offers a 2-wire bus repeater dedicated for tuner
control. The tuner is connected to the M88DS3103 through the
SCLT and SDAT pins. See Figure 12. Every time the 2-wire bus
master wants to access the tuner registers, it must enable the
repeater first by configuring bit 2_WIRE_REP_EN (03H). When
the repeater is enabled, the SDAT and SCLT pins are active.
The messages on the SDA and SCL pins is repeated on the
SDAT and SCLT pins. The repeater will be automatically
disabled once the access times to the tuner reaches the
configured value set in bits 2_WIRE_REP_TM[2:0] (03H).
When disabled, the SCLT and SDAT pins are completely
isolated from the 2-wire bus and become inactive (HIGH).

When you compare this with *almost* any other demodulator
that exists; This behaviour is much consistent with that which
exists in the mainline kernel source.


If you look at most DVB-S/S2 demodulator drivers almost all
of them do have an I2C repeater, which in some cases are
configurable for a) auto-manual close, b) auto close,
c) manual close. The majority of them do auto close,
unless bugs on the hardware implementation do exist.

What I don't understand why you need an I2C adapter to handle
the I2C repeater. All demodulator drivers use i2c_gate_ctl
to enable/disable the repeater.

ie, how is your i2c_adapter implementation for the ds3103
demodulator going to make things better than:

static int ds3103_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
{
        struct ds3103_state *state = fe->demodulator_priv;

        if (enable)
                ds3103_writereg(state, 0x03, 0x12);
        else
                ds3103_writereg(state, 0x03, 0x02);

        return 0;
}

which is more common to all other DVB demodulator drivers.
Please don't make weird implementations for straight forward
stuff.

>
> There was even some patches, maybe 2 years, ago in order to mainline that
> but it never happened.

??

>
> More complete is here 53 vs. 86 register writes, so yes it is more ~40 more
> complete if you like to compare it like that.

What I would stress more, is that the driver at this URL

http://goo.gl/biaPYu

is from Montage themselves rather than a reverse engineered one;
rather than the number of lines of code, or number of registers.
