Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab1K3VWW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 16:22:22 -0500
Message-ID: <4ED69E88.6020302@redhat.com>
Date: Wed, 30 Nov 2011 19:22:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: linux-media@vger.kernel.org, Jens.Erdmann@web.de
Subject: Re: [PATCH] em28xx: Add Terratec Cinergy HTC Stick
References: <11607963.5467764.1322494881126.JavaMail.fmail@mwmweb051> <0MQf77-1RNtkl3pe9-00U2UK@smtp.web.de> <4ED4D683.40508@linuxtv.org> <201111302039.48970.Jens.Erdmann@web.de> <4ED694E3.6080500@linuxtv.org>
In-Reply-To: <4ED694E3.6080500@linuxtv.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30-11-2011 18:41, Andreas Oberritter wrote:
> On 30.11.2011 20:39, Jens Erdmann wrote:
>> Dear Andreas,
>>
>> On Tuesday, November 29, 2011 01:56:35 PM you wrote:
>> <snip>
>>>
>>>>>> 2. I stumbled over http://linux.terratec.de/tv_en.html where they list
>>>>>> a NXP TDA18271
>>>>>>
>>>>>>      as used tuner for H5 and HTC Stick devices. I dont have any
>>>>>>      experience in this kind of stuff but i am just asking.
>>>>>
>>>>> That's right.
>>>>
>>>> So this should be made like the other devices which are using the
>>>> TDA18271? Or is there no driver for this tuner yet?
>>>
>>> I don't understand your question. Both TERRATEC H5 and Cinergy HTC Stick
>>> are already supported by Linux (at least for digital signals, the latter
>>> since the patch you're referring to), so a driver for every relevant
>>> chip, including TDA18271, is already involved.
>>>
>>
>> If i remember correctly there was used another tuner driver in the out
>> commended code. Is this just a coyp paste leftover?
>
> Hm. When Mauro committed the patch, the description got lost:
>
>> - Can receive DVB-C and DVB-T. No analogue television or radio yet.
>> - For now it's a copy of the Terratec H5 code with a different name.

Gah! sorry for that. Not sure what happened there. I'll try to remember
about it when sending upstream, in order to recover the original comment.

Feel free to ping me closer to the next merge window, in order to remind
me.

>
> So, to answer your question: The disabled code was copied from the H5
> right above the new code, in the hope that if someone is going to fix
> analogue TV for the H5, he or she might just fix it for the HTC Stick as
> well, assuming that there's only little or no difference.

Support for analog is not trivial, as it requires writing a driver for
tvf4910b. Not sure if is there any publicly released driver with some
code for it. Maybe this could be done via sniffing the USB traffic, but, if
this device is as complicated as DRX, then I doubt people would try to
do it.

> HTH,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

