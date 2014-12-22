Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58259 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbaLVOCB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 09:02:01 -0500
Message-ID: <54982454.6040306@iki.fi>
Date: Mon, 22 Dec 2014 16:01:56 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org>	<54972866.3030101@gentoo.org> <20141222112550.5f5e80c7@concha.lan.sisa.samsung.com> <54981E79.5090601@gentoo.org>
In-Reply-To: <54981E79.5090601@gentoo.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/22/2014 03:36 PM, Matthias Schwarzott wrote:
> On 22.12.2014 14:25, Mauro Carvalho Chehab wrote:
>> Em Sun, 21 Dec 2014 21:07:02 +0100
>> Matthias Schwarzott <zzam@gentoo.org> escreveu:
>>
>>> Hi!
>>>
>>> Should the commit message directly point to the breaking commit
>>> 36efec48e2e6016e05364906720a0ec350a5d768?
>>
>> Yes, if this fixes an issue that happened on a previous commit, then
>> you should add the original commit there.
>>
>> That likely means that this is a regression fix, right? So, you should
>> c/c the patch to stable, adding a comment msg telling to what Kernel
>> version it applies (assuming that the patch was merged on 3.18).
>> Also, please add "PATCH FIX" to the subject, as this patch should be
>> sent to 3.19 as well.
>>
>>>
>>> This commit hopefully reverts the problematic attach for the Starburst
>>> card. I kept the GPIO-part in common, but I can split this also if
>>> necessary.
>>
>> Keep the GPIO part in common is better, if the GPIOs are the same.
>
> Hi!
>
> The GPIO-Pins that are used are the same on both cards. And I assume the
> ones that control Si2165 on HVR-5500 are just unused on Starburst, so
> setting them does not hurt (and Antti confirmed that the patch works).

It registers all the chips correctly, I didn't test it actually anymore 
:] I don't even have live signal, just generator, satellite finder to 
test voltage/tone and one 4-port DiSEqC switch.

> The cards have more in common, but I could not find a clean way to share
> attaching and TS-config of the DVB-S2 frontend.

In my understanding Starburst is HVR-4400, but only satellite tuner is 
installed to PCB - whilst terrestrial/cable is left out.

I think the root of mistake was done years ago when all these HVR-4400 
revisions were put to same profile. Matthias didn't realized there is 
device missing totally another tuner when he added later support for 
these full-featured models.

> So I will change the commit message, prefix subject with PATCH fix, and
> resend the patch here and c/c to stable.

It is not so simple as there is multiple new devices added to that 
driver after that. You will need to make stable patch against older 
kernel version.

regards
Antti
-- 
http://palosaari.fi/
