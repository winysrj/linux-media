Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:37121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1ACNQy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 08:16:54 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p03DGrtY008737
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 08:16:53 -0500
Message-ID: <4D21CC3F.5060105@redhat.com>
Date: Mon, 03 Jan 2011 11:16:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Philips SPC315NC is vertically flipped
References: <4D21AA15.6080703@redhat.com> <4D21C928.2000306@redhat.com>
In-Reply-To: <4D21C928.2000306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 03-01-2011 11:03, Hans de Goede escreveu:
> Hi,
> 
> On 01/03/2011 11:51 AM, Mauro Carvalho Chehab wrote:
>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>
>> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
>> index f32ef7b..a182efe 100644
>> --- a/lib/libv4lconvert/control/libv4lcontrol.c
>> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
>> @@ -46,6 +46,8 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
>>       { 0x0471, 0x0326, 0, NULL, NULL, V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
>>       /* Philips SPC210NC */
>>       { 0x0471, 0x032d, 0, NULL, NULL, V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
>> +    /* Philips SPC315NC */
>> +    { 0x0471, 0x032e, 0, NULL, NULL, V4LCONTROL_VFLIPPED },
>>       /* Genius E-M 112 (also want whitebalance by default) */
>>       { 0x093a, 0x2476, 0, NULL, NULL,
>>           V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED | V4LCONTROL_WANTS_WB, 1500 },
> 
> Are you sure it is only vertically flipped ? I've have the Philips SPC 200NC (0471:0325)
> myself and it simply has the sensor upside down (so both h and v flipped).

Yes, I'm sure about that. Only vertical is flipped on this webcam.

> Did you happen to use skype to test this? Skype is known to decide to mirror the image
> before showing it in some cases (I don't know when / why skype does this).

My previous test were with qv4l2. With skype, plus the above patch, the webcam is also
working properly.
> 
> Regards,
> 
> Hans

