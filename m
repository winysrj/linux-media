Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40873 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab2KWTYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 14:24:23 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3557659eek.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 11:24:20 -0800 (PST)
Message-ID: <50AFCD65.90200@googlemail.com>
Date: Fri, 23 Nov 2012 20:24:21 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: Mysterious USB device ID change on Hauppauge HVR-900 (em28xx)
References: <50AFABDA.9050309@googlemail.com> <50AFB05B.6020209@iki.fi>
In-Reply-To: <50AFB05B.6020209@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.11.2012 18:20, schrieb Antti Palosaari:
> On 11/23/2012 07:01 PM, Frank Schäfer wrote:
>> Hi,
>>
>> I've got a Hauppauge HVR-900 (65008/A1C0) today. First,  the device
>> showed up as USB device 7640:edc1 (even after several unplug - replug
>> cycles), so I decided to add this VID:PID to the em28xx driver to see
>> what happens.
>> That worked fine, em2882/em2883, tuner xc2028/3028 etc. were detected
>> properly.
>> Later I noticed, that the device now shows up as 2040:6500, which is the
>> expected ID for this device.
>> Since then, the device maintains this ID. I also checked if Windows is
>> involved, but it shows up with the same ID there.
>>
>> Does anyone have an idea what could have happened ???
>> I wonder if we should add this ID to the em28xx driver...
>
> em28xx chip reads USB ID from the external eeprom using I2C just after
> it was powered. After USB ID is got it connects to the USB bus using
> that ID. If there is no external eeprom it uses chipset default USB
> ID, which is 0xeb1a as vendor ID and some other number defined for
> chip model as device ID. In that case those wrong IDs seems to be
> total garbage, which indicates there is some hardware problems when
> communicating towards eeprom.
>
Yeah, hardware problems, sure... but I wonder why the USB ID was/is
persistent ? Communication problems caused by circuit defect should lead
to a rather random behavior...
On power loss, the everything except (ee)prom(s) contents should be
reset to a default state.
And if the eeprom was corrupted, how could it magically recover ?
Also: the USB id is read from the eeprom even without a OS driver beeing
involved, but the first usage of the driver seems to have "fixed" the ID...

Regards,
Frank

> That method is not only Empia USB interface chips but almost all
> chipset uses just similar method.
>
>
> regard
> Antti
>

