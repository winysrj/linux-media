Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab1KNUqu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 15:46:50 -0500
Message-ID: <4EC17E31.5010407@redhat.com>
Date: Mon, 14 Nov 2011 18:46:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: PATCH v3: Query DVB frontend delivery capabilities (was: Re:
 PATCH: Query DVB frontend capabilities)
References: <CAHFNz9JW-CyOsFutMNkfVZ-KuJX2FE1DZ_AQ5TZne4CCypLYng@mail.gmail.com>
In-Reply-To: <CAHFNz9JW-CyOsFutMNkfVZ-KuJX2FE1DZ_AQ5TZne4CCypLYng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-11-2011 17:39, Manu Abraham escreveu:
> On 11/12/11, Andreas Oberritter <obi@linuxtv.org> wrote:
>> On 11.11.2011 23:38, Mauro Carvalho Chehab wrote:
>>> Em 11-11-2011 20:07, Manu Abraham escreveu:
>>>> On Fri, Nov 11, 2011 at 3:42 PM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com> wrote:
>>>>> Em 11-11-2011 04:26, Manu Abraham escreveu:
>>>>>> On Fri, Nov 11, 2011 at 2:50 AM, Mauro Carvalho Chehab
>>>>>> <mchehab@redhat.com> wrote:
>>>>>>> Em 10-11-2011 13:30, Manu Abraham escreveu:
>>>>>> The purpose of the patch is to
>>>>>> query DVB delivery system capabilities alone, rather than DVB frontend
>>>>>> info/capability.
>>>>>>
>>>>>> Attached is a revised version 2 of the patch, which addresses the
>>>>>> issues that were raised.
>>>>>
>>>>> It looks good for me. I would just rename it to DTV_SUPPORTED_DELIVERY.
>>>>> Please, when submitting upstream, don't forget to increment DVB version
>>>>> and
>>>>> add touch at DocBook, in order to not increase the gap between API specs
>>>>> and the
>>>>> implementation.
>>>>
>>>> Ok, thanks for the feedback, will do that.
>>>>
>>>> The naming issue is trivial. I would like to have a shorter name
>>>> rather that SUPPORTED. CAPS would have been ideal, since it refers to
>>>> device capability.
>>>
>>> CAPS is not a good name, as there are those two CAPABILITIES calls there
>>> (well, currently not implemented). So, it can lead in to some confusion.
>>>
>>> DTV_ENUM_DELIVERY could be an alternative for a short name to be used
>>> there.
>>
>> I like "enum", because it suggests that it's a read-only property.
>>
>> DVB calls them "delivery systems", so maybe DTV_ENUM_DELSYS may be an
>> alternative.
> 
> This is a bit more sensible and meaningful than the others. I like
> this one better than the others.
> 
> Attached is a version 3 patch which addresses all the issues that were raised

Ok from my side. A minor issue is that we've renamed the cmd, but the
internal function name was the same:

dtv_set_default_delivery_caps()

Anyway, ACK from my side.

I'll merge it upstream when you submit the DocBook patches (or send me a git
pull request with both things - whatever work better for you).

Regards,
Mauro
