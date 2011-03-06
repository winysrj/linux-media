Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60787 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1CFNI0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 08:08:26 -0500
Received: by wwb22 with SMTP id 22so4246564wwb.1
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2011 05:08:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D738664.1020200@iki.fi>
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
	<AANLkTi=7NupG4-X=iFM25pJHwzfkp3ZvEvxJUBexYtsd@mail.gmail.com>
	<4D738664.1020200@iki.fi>
Date: Sun, 6 Mar 2011 13:08:25 +0000
Message-ID: <AANLkTi=1Rn86nifhDfonQUBou+sfh4RrgRxcfCMeU59e@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: adq <adq@lidskialf.net>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/3/6 Antti Palosaari <crope@iki.fi>:
> On 03/06/2011 02:24 PM, adq wrote:
>>
>> Another issue I've noticed just now: The UCBLOCKS measure isn't reset:
>> it seems to be an accumulative counter, which isn't correct from the
>> DVB API (if I remember correctly).
>>
>> This explains why tvheadend's "quallity" measure gradually tends to 0,
>> since it is assuming UCBLOCKS is non-accumulative.
>
> 2.2.7 FE READ UNCORRECTED BLOCKS DESCRIPTION
> This ioctl call returns the number of uncorrected blocks detected by the
> device driver during its lifetime. For meaningful measurements, the
> incrementin block count during a specific time interval should be
> calculated. For this command, read-only access to the device is sufficient.
> Note that the counter will wrap to zero after its maximum count has been
> reached.

(this time to the list as well)

Hah! Sorry, its been a while :)

In that case, I need to look at the tvheadend source.
