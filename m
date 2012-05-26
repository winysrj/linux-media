Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab2EZSis (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 14:38:48 -0400
Message-ID: <4FC1233C.8000007@redhat.com>
Date: Sat, 26 May 2012 20:38:52 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: halli manjunatha <hallimanju@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Discussion: How to deal with radio tuners which can tune to multiple
 bands
References: <1337032913-18646-1-git-send-email-manjunatha_halli@ti.com> <201205261840.27204.hverkuil@xs4all.nl> <4FC11C71.7090104@redhat.com> <201205262022.57154.hverkuil@xs4all.nl>
In-Reply-To: <201205262022.57154.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/26/2012 08:22 PM, Hans Verkuil wrote:
> On Sat May 26 2012 20:09:53 Hans de Goede wrote:
>> Hi,
>>
>> On 05/26/2012 06:40 PM, Hans Verkuil wrote:
>>> On Sat May 26 2012 18:02:34 Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 05/24/2012 09:12 PM, Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> On 05/24/2012 05:00 PM, Hans Verkuil wrote:
>>>>>>> I think / hope that covers everything we need. Suggestions ? Comments ?
>>>>>>
>>>>>> Modulators. v4l2_modulator needs a band field as well. The capabilities are
>>>>>> already shared with v4l2_tuner, so that doesn't need to change.
>>>>>
>>>>> Ah, yes modulators, good one, ack.
>>>>>
>>>>> Manjunatha, since the final proposal is close to yours, and you already have
>>>>> a patch for that including all the necessary documentation updates, can I ask
>>>>> you to update your patch to implement this proposal?
>>>>>
>>>>
>>>> So I've been working a bit on adding AM support to the tea575x driver using
>>>> the agreed upon API, some observations from this:
>>>>
>>>> 1) There is no way to get which band is currently active
>>>
>>> Huh? Didn't G_TUNER return the current band? That's how I interpreted the
>>> proposal. G_TUNER returns the available bands in capabilities and the current
>>> band and its frequency range. You want to find the frequency range of another
>>> band you call have to call S_TUNER first to select that other band, and then
>>> G_TUNER to discover its range.
>>
>> Ah, we misunderstood each other there, I thought G_TUNER would honor the band
>> passed in and return info on that band.
>>
>>> That also solves case 2. No need for an extra band in v4l2_frequency.
>>
>> Right, the downside to this is that there is no way to just enumerate things
>> without actually changing anything. It would be nice if for example v4l2-ctl
>> could lists all bands including ranges as a 100% read-only operation.
>>
>> Note I'm ok with the way you propose to handle things, just pointing out
>> one (obvious) shortcoming of doing things this way. I think it is a short coming
>> we can live with, but we should be aware of it.
>
> Well, the important thing is that you know what bands are supported, and you
> know because of the capabilities.

I agree.

> I don't really think you have to query the
> exact range of other than the current band: the band's name is already a good
> indication of what the range will be, you just don't know the exact boundaries
> until you switch to that band. Which I believe is perfectly reasonable.

I agree, so lets go with your proposal / my original proposal as interpreted by
you :)

Regards,

Hans
