Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58508 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbcGARcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 13:32:55 -0400
Subject: Re: [PATCH] [media] cec: add missing inline stubs
To: Arnd Bergmann <arnd@arndb.de>
References: <20160701112027.102024-1-arnd@arndb.de>
 <6419506.V8JtZUoqT3@wuerfel> <975908ec-c95c-170d-e7b7-31a810ad82ba@xs4all.nl>
 <6460555.uRUCQj0uFx@wuerfel>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <889f267e-b4ef-a26a-a55d-af400bd5dd49@xs4all.nl>
Date: Fri, 1 Jul 2016 19:30:11 +0200
MIME-Version: 1.0
In-Reply-To: <6460555.uRUCQj0uFx@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2016 05:37 PM, Arnd Bergmann wrote:
> On Friday, July 1, 2016 5:22:32 PM CEST Hans Verkuil wrote:
>>> diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
>>> index 8e6918c5c87c..8e31146d079a 100644
>>> --- a/drivers/media/platform/vivid/Kconfig
>>> +++ b/drivers/media/platform/vivid/Kconfig
>>> @@ -26,6 +26,7 @@ config VIDEO_VIVID
>>>  config VIDEO_VIVID_CEC
>>>       bool "Enable CEC emulation support"
>>>       depends on VIDEO_VIVID && MEDIA_CEC
>>> +     depends on VIDEO_VIVID=m || MEDIA_CEC=y
>>>       ---help---
>>>         When selected the vivid module will emulate the optional
>>>         HDMI CEC feature.
>>>
>>> which is still not overly nice, but it manages to avoid the
>>> IS_REACHABLE() check and it lets MEDIA_CEC be a module.
>>
>> The only IS_REACHABLE is for the RC_CORE check, and that should remain.
> 
> I believe that is already taken care of by my earlier "[media] cec: add
> RC_CORE dependency" patch, https://patchwork.linuxtv.org/patch/34892/
> which seems to handle the dependency more gracefully (preventing nonsense
> configurations rather than just not using RC_CORE).
> 
>> With my patch MEDIA_CEC can remain a module provided MEDIA_SUPPORT is also
>> a module. All drivers depending on MEDIA_CEC also depend on MEDIA_SUPPORT,
>> so that works.
> 
> To clarify, the problem with the option above is that VIDEO_VIVID_CEC
> is a 'bool' option, and Kconfig lets that be turned on if both
> VIDEO_VIVID and MEDIA_CEC are enabled, including the case where MEDIA_CEC
> is a module and VIDEO_VIVID is not.
> 
> Your patch avoids that problem by making MEDIA_CEC a 'bool', my patch
> above is an alternative by ensuring that VIDEO_VIVID_CEC cannot be
> enabled if MEDIA_CEC is a module and VIDEO_VIVID is not.

The problem I have with both your suggestions is that options disappear just
because one dependency is a module. Very unexpected and hard to figure out.

I am not enthusiastic about the IS_REACHABLE(RC_CORE) solution either, but it
will do for now while it is in staging. I still think it is better then making
MEDIA_CEC depend on whether RC_CORE is a module or not. The RC support is an
optional extension and CEC still works fine without it.

Regards,

	Hans
