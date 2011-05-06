Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1EFPaf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 11:30:35 -0400
Message-ID: <4DC41409.4000705@redhat.com>
Date: Fri, 06 May 2011 12:30:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] Sony CXD2820R DVB-T/T2/C demodulator
 driver
References: <20110506125542.ADA1D162E7@stevekerrison.com>
In-Reply-To: <20110506125542.ADA1D162E7@stevekerrison.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-05-2011 09:55, Steve Kerrison escreveu:
> If antti doesn't do this before me, I will look at this over the weekend and generate a patch against antti's current code... if that's appropriate of course (I'm new at this ;))

Feel free to do it. I suspect that Antti won't work on it during this weekend. From
what I understood, he's travelling in vacations.

It helps if you could also add the bits into the frontend API DocBook:
	Documentation/DocBook/dvb/dvbproperty.xml  

The chapter that describes DVBv5 extensions is at:
	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_PROPERTY.html

As you may realize, this chapter were originally written with a description
of the ISDB-T extensions. I've imported it from a .txt file, and did just
some small adjustments to glue it into the specs, but I didn't have time to
make it generic enough.

So, the descriptions there for FE_[GET|SET]_PROPERTY are focused on ISDB-T.
Yet, it shouldn't be hard to make it generic.

I'm sending right now a patch I just made that will better document those two
calls. I'm not adding the other non-documented properties. So, there are still
lots of other DVBv5 property types not documented there (feel free to send us 
patches if you have time for that), and there are other missing changes
from DVB APIv3 time, but at least we reduce a little bit the differences between
the code and the spec [1].

In the past, the specs were shipped on a separate tree, using LaTex format,
and outside the kernel. So, they weren't changed when new code were added.

Now that we have it together with the kernel, we should only extend the API 
together with API specs, to avoid increasing the specs gap.

With the specs at the kernel, all that needs to do to re-generate is to change
the xml files and run:
	$ make htmldocs

Then look at the specs using your favourite browser with an URL like:

file:///home/myhome/media-tree/Documentation/DocBook/media/FE_GET_SET_PROPERTY.html

[1] From DVB API v3 to v5, the differences are at the FE_[GET/SET]_PROPERTY ioctls.

Thanks!
Mauro.

> 
> Regards,
> Steve Kerrison.
> 
> ----- Reply message -----
> From: "Andreas Oberritter" <obi@linuxtv.org>
> Date: Fri, May 6, 2011 13:36
> Subject: [git:v4l-dvb/for_v2.6.40] [media] Sony CXD2820R DVB-T/T2/C demodulator driver
> To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
> Cc: "Steve Kerrison" <steve@stevekerrison.com>, <linux-media@vger.kernel.org>, "Antti Palosaari" <crope@iki.fi>
> 
> 
> On 05/06/2011 02:23 PM, Mauro Carvalho Chehab wrote:
>> Em 06-05-2011 07:42, Steve Kerrison escreveu:
>>> Hi Andreas,
>>>
>>> From cxd2820r_priv.h:
>>>
>>>> +/*
>>>> + * FIXME: These are totally wrong and must be added properly to the API.
>>>> + * Only temporary solution in order to get driver compile.
>>>> + */
>>>> +#define SYS_DVBT2             SYS_DAB
>>>> +#define TRANSMISSION_MODE_1K  0
>>>> +#define TRANSMISSION_MODE_16K 0
>>>> +#define TRANSMISSION_MODE_32K 0
>>>> +#define GUARD_INTERVAL_1_128  0
>>>> +#define GUARD_INTERVAL_19_128 0
>>>> +#define GUARD_INTERVAL_19_256 0
>>>
>>>
>>> I believe Antti didn't want to make frontent.h changes until a consensus
>>> was reached on how to develop the API for T2 support.
>>
>> Yeah.
>>
>> Andreas/Antti,
>>
>> It seems more appropriate to remove the above hack and add Andreas patch.
>> I've reviewed it and it seemed ok on my eyes, provided that we also update
>> DVB specs to reflect the changes.
>>
>> In special, the new DVB command should be documented:
>> +#define DTV_DVBT2_PLP_ID 43
> 
> In addition to the patch, the PLP ID needs to be stored in struct
> dtv_frontend_properties and used by property cache functions in
> dvb_frontend.c.
> 
> Antti, could you please complete the patch and test it with your device?
> This patch was adapted from an older kernel and only compile-tested few
> weeks ago.
> 
> Regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

