Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab0J0NNT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 09:13:19 -0400
Message-ID: <4CC82658.3040205@redhat.com>
Date: Wed, 27 Oct 2010 15:17:12 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH 3/7] gspca-stv06xx: support bandwidth changing
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>	<1288182926-25400-4-git-send-email-hdegoede@redhat.com> <AANLkTi=tiYJU0fLVqSiN-BRGgMqcf3eF0jFFVDTtr-Lh@mail.gmail.com>
In-Reply-To: <AANLkTi=tiYJU0fLVqSiN-BRGgMqcf3eF0jFFVDTtr-Lh@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 10/27/2010 02:39 PM, Erik Andrén wrote:
> 2010/10/27 Hans de Goede<hdegoede@redhat.com>:
>> stv06xx devices have only one altsetting, but the actual used
>> bandwidth can be programmed through a register. We were already
>> setting this register lower then the max packetsize of the altsetting
>> indicates. This patch makes the gspca-stv06xx update the usb descriptor
>> for the alt setting to reflect the actual packetsize in use, so that
>> the usb subsystem uses the correct information for scheduling usb transfers.
>>
>> This patch also tries to fallback to lower speeds in case a ENOSPC error
>> is received when submitting urbs, but currently this is only supported
>> with stv06xx cams with the pb0100 sensor, as this is the only one for
>> which we know how to change the framerate.
>>
>> This patch is based on an initial incomplete patch by
>> Lee Jones<lee.jones@canonical.com>
>>
>> Signed-off-by: Lee Jones<lee.jones@canonical.com>
>> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
>
> Cool,
> Has this been verified to work with all affected devices?

Yes and no, it has been verified with a camera with a st6422 sensor
and one with a pb0100 sensor. It has not been verified with the others, but
it makes no changes to the others. See min and max bandwidth settings in
the sensor struct in the sensors .h file (and the FIXME comments there).
These result in the STV_ISO_SIZE_L register setting being left untouched
for the untested devices, effectively making this patch a nop for them.
Except that the usb core will be told that some of them do not use the full
bandwidth, which will allow peaceful coexistence with other devices.

AFAIK you have a vv6410 sensor camera, it would be cool if you could:
1) See if you can vary the framerate of it
2) See what the minimum required bandwidth is for each framerate
    (change min and max packet_size to be the same to test).
3) Update max and min packetsize (to reflect the minimum needed
    packetsize at the highest. resp lowest framerate).
4) Update the sensor_start function to program the framerate depending
    on the available bandwidth (see the pb0100 code).

Thanks & Regards,

Hans
