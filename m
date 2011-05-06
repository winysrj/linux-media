Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:57728 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1EFOf3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 10:35:29 -0400
Message-ID: <28ca5dfb5d4613fd74f7d7bf2f8c2660.squirrel@webmail.kapsi.fi>
In-Reply-To: <4DC3EB32.7010202@linuxtv.org>
References: <E1QHwSm-0006hA-A9@www.linuxtv.org>
    <4DC3C6FA.8070505@linuxtv.org> <1304678539.8670.29.camel@ares>
    <4DC3E82A.7040202@redhat.com> <4DC3EB32.7010202@linuxtv.org>
Date: Fri, 6 May 2011 17:35:26 +0300
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] Sony CXD2820R DVB-T/T2/C
 demodulator driver
From: "Antti Palosaari" <crope@iki.fi>
To: "Andreas Oberritter" <obi@linuxtv.org>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	"Steve Kerrison" <steve@stevekerrison.com>,
	linux-media@vger.kernel.org, "Antti Palosaari" <crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

pe 6.5.2011 15:36 Andreas Oberritter kirjoitti:
> On 05/06/2011 02:23 PM, Mauro Carvalho Chehab wrote:
>> Em 06-05-2011 07:42, Steve Kerrison escreveu:
>>> Hi Andreas,
>>>
>>> From cxd2820r_priv.h:
>>>
>>>> +/*
>>>> + * FIXME: These are totally wrong and must be added properly to the
>>>> API.
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
>>> I believe Antti didn't want to make frontent.h changes until a
>>> consensus
>>> was reached on how to develop the API for T2 support.
>>
>> Yeah.
>>
>> Andreas/Antti,
>>
>> It seems more appropriate to remove the above hack and add Andreas
>> patch.
>> I've reviewed it and it seemed ok on my eyes, provided that we also
>> update
>> DVB specs to reflect the changes.
>>
>> In special, the new DVB command should be documented:
>> 	+#define DTV_DVBT2_PLP_ID	43
>
> In addition to the patch, the PLP ID needs to be stored in struct
> dtv_frontend_properties and used by property cache functions in
> dvb_frontend.c.
>
> Antti, could you please complete the patch and test it with your device?
> This patch was adapted from an older kernel and only compile-tested few
> weeks ago.

I can test it next week.

I added also those first to the frontend.h but rebased that patch out
before PULL request just since I didn't have enough time to make proper
API for 2.6.40 schedule. It can be already found from my old GIT tree.

As I looked DVB-T2 specs it was rather complex and large to learn. For
example how to handle multiple PLPs (driver does not handle it currently).
Maybe PLP_ID is enough for that.

Antti

