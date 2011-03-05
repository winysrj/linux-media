Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:38656 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1CELzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 06:55:11 -0500
Received: by wwe15 with SMTP id 15so1067426wwe.1
        for <linux-media@vger.kernel.org>; Sat, 05 Mar 2011 03:55:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>
	<4D7163FD.9030604@iki.fi>
	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>
	<4D716ECA.4060900@iki.fi>
	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>
	<AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>
	<AANLkTi=e-cAzMWZSHvKR8Yx+0MqcY_Ewf4z1gDyZfCeo@mail.gmail.com>
	<AANLkTi=YMtTbgwxNA1O6zp03OoeGKJvn8oYDB9kHjti1@mail.gmail.com>
Date: Sat, 5 Mar 2011 11:55:10 +0000
Message-ID: <AANLkTimDSwR06nRxNv9x11_dDdaSBzD-En4N8ameDe1Y@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: adq <adq@lidskialf.net>
To: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/3/5 Juan Jes�s Garc�a de Soria Lucena <skandalfo@gmail.com>:
> Hi, Andrew.
>
> This is what happens to me with both the KWorld dual tuner (when using only
> one tuner) and the Avermedia Volar Black (single tuner), both based on
> AF9015.
>
> I also got corrupted streams with the KWorld when capturing via both tuners
> (the video our the audio would show artifacts in mythtv each several
> seconds).
>
> As far as the loss of tuning ability goes, I think it's a problem related to
> tuning itself, since it wouldn't happen when you just left a channel tuned
> and streaming in a simple client, but would trigger after a random time when
> you left mythtv scanning the channels for EIT data.
>
> I don't think it's a problem with a specific HW implementation, since I got
> it with both AF9015-based cards. It could be either a chipset quirk our a
> bug in the driver.
>
> My informal and quick tests with Windows Media Center and these cards did
> not reproduce the problem, when trying to change channels as quickly as
> possible, admittedly for not so long a time.

Correct. I have two af9015 cards from different manufacturers as well,
and they both exhibit the same problem.

However, on a hunch last night, I went back to my original (-v1) patch
with the total i2c bus lock and left it running with my tuning scripts
for 10 hours. Both tuners are still working fine. That isn't
conclusive, but it is encouraging.

I'm just swapping back to a completely unpatched state to see how long
it takes to break and to check if its easily reproducible (on my live
system, it usually does it within a few hours of normal usage).
