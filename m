Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:43501 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1K3UlL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 15:41:11 -0500
Message-ID: <4ED694E3.6080500@linuxtv.org>
Date: Wed, 30 Nov 2011 21:41:07 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Jens Erdmann <Jens.Erdmann@web.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: Add Terratec Cinergy HTC Stick
References: <11607963.5467764.1322494881126.JavaMail.fmail@mwmweb051> <0MQf77-1RNtkl3pe9-00U2UK@smtp.web.de> <4ED4D683.40508@linuxtv.org> <201111302039.48970.Jens.Erdmann@web.de>
In-Reply-To: <201111302039.48970.Jens.Erdmann@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30.11.2011 20:39, Jens Erdmann wrote:
> Dear Andreas,
> 
> On Tuesday, November 29, 2011 01:56:35 PM you wrote:
> <snip>
>>
>>>>> 2. I stumbled over http://linux.terratec.de/tv_en.html where they list
>>>>> a NXP TDA18271
>>>>>
>>>>>     as used tuner for H5 and HTC Stick devices. I dont have any
>>>>>     experience in this kind of stuff but i am just asking.
>>>>
>>>> That's right.
>>>
>>> So this should be made like the other devices which are using the
>>> TDA18271? Or is there no driver for this tuner yet?
>>
>> I don't understand your question. Both TERRATEC H5 and Cinergy HTC Stick
>> are already supported by Linux (at least for digital signals, the latter
>> since the patch you're referring to), so a driver for every relevant
>> chip, including TDA18271, is already involved.
>>
> 
> If i remember correctly there was used another tuner driver in the out 
> commended code. Is this just a coyp paste leftover?

Hm. When Mauro committed the patch, the description got lost:

> - Can receive DVB-C and DVB-T. No analogue television or radio yet.
> - For now it's a copy of the Terratec H5 code with a different name.

So, to answer your question: The disabled code was copied from the H5
right above the new code, in the hope that if someone is going to fix
analogue TV for the H5, he or she might just fix it for the HTC Stick as
well, assuming that there's only little or no difference.

HTH,
Andreas
