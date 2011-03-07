Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33924 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1CGS1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 13:27:01 -0500
Received: by wyg36 with SMTP id 36so4428612wyg.19
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 10:27:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimWRDk+iGPzuXarmpr0w9W4aS4Be=xpBPkMipdC@mail.gmail.com>
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>
	<4D7163FD.9030604@iki.fi>
	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>
	<4D716ECA.4060900@iki.fi>
	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>
	<AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>
	<AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com>
	<AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>
	<AANLkTimDSwR06nRxNv9x11_dDdaSBzD-En4N8ameDe1Y@mail.gmail.com>
	<AANLkTimWRDk+iGPzuXarmpr0w9W4aS4Be=xpBPkMipdC@mail.gmail.com>
Date: Mon, 7 Mar 2011 18:26:59 +0000
Message-ID: <AANLkTimUAKjx81Z1GF=ceG33zHhLX1r-HfykWWyNpay-@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: adq <adq@lidskialf.net>
To: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/3/6 adq <adq@lidskialf.net>:
> 2011/3/5 adq <adq@lidskialf.net>:
>> 2011/3/5 Juan Jesús García de Soria Lucena <skandalfo@gmail.com>:
>>> Hi, Andrew.
>>>
>>> This is what happens to me with both the KWorld dual tuner (when using only
>>> one tuner) and the Avermedia Volar Black (single tuner), both based on
>>> AF9015.
>>>
>>> I also got corrupted streams with the KWorld when capturing via both tuners
>>> (the video our the audio would show artifacts in mythtv each several
>>> seconds).
>>>
>>> As far as the loss of tuning ability goes, I think it's a problem related to
>>> tuning itself, since it wouldn't happen when you just left a channel tuned
>>> and streaming in a simple client, but would trigger after a random time when
>>> you left mythtv scanning the channels for EIT data.
>>>
>>> I don't think it's a problem with a specific HW implementation, since I got
>>> it with both AF9015-based cards. It could be either a chipset quirk our a
>>> bug in the driver.
>>>
>>> My informal and quick tests with Windows Media Center and these cards did
>>> not reproduce the problem, when trying to change channels as quickly as
>>> possible, admittedly for not so long a time.
>>
>> Correct. I have two af9015 cards from different manufacturers as well,
>> and they both exhibit the same problem.
>>
>> However, on a hunch last night, I went back to my original (-v1) patch
>> with the total i2c bus lock and left it running with my tuning scripts
>> for 10 hours. Both tuners are still working fine. That isn't
>> conclusive, but it is encouraging.
>>
>> I'm just swapping back to a completely unpatched state to see how long
>> it takes to break and to check if its easily reproducible (on my live
>> system, it usually does it within a few hours of normal usage).
>>
>
> Hi, right, I can reproduce it when completely unpatched, but it takes
> a while. I left HTS "tvheadend" running at the same time as "dvbsnoop"
> monitoring each frontend's status (so I had lots of i2c traffic going
> on), and it happened sometime overnight. I turned on all the idle
> scanning and frontend monitoring features tvheadend has.
>
> Now trying running the same with the -v1 patch.
>

Hi, its been running for well over 24 hours now, and its still tuning fine.

I'm obviously I'm going to leave it testing for more days, but I'm
daring it to suddenly break as soon as I send this mail :)

As you will recall, v3 implemented a lock around the i2cgate so that
only one frontend could open it and therefore only one could access a
tuner at a time. Since this didn't fix the issue, it implies that if
the gate is open *any* other i2c access (e.g. just reading the
ucblocks) can somehow "crash" the tuner in such a way that it needs a
hardware reset. This means you'd need a complete lock around
*anything*  which can cause i2c traffic as v1 implements (assuming v1
does fix it that is).

Anyway, I'm keeping it running for the moment. It'd be good if someone
else who experiences this problem could try out v1 too though.

Oh, I see these every now and then:
af9015: recv bulk message failed:-71
af9015: af9015_rc_query: failed:-1
dvb-usb: error -1 while querying for an remote control event.

They don't seem to cause a problem, but seems odd they should occur at
all. Disabling rc polling "fixes" it as docced elsewhere, but why do
they occur in the first place I wonder?
