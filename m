Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab2FWGg6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 02:36:58 -0400
Message-ID: <4FE56526.3060501@redhat.com>
Date: Sat, 23 Jun 2012 08:41:42 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 4/6] videodev2.h: add frequency band information.
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl> <4FE07255.6050606@redhat.com> <4FE08942.8020603@redhat.com> <201206221607.10363.hverkuil@xs4all.nl> <4FE49A32.3060307@redhat.com>
In-Reply-To: <4FE49A32.3060307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/22/2012 06:15 PM, Mauro Carvalho Chehab wrote:
> Em 22-06-2012 11:07, Hans Verkuil escreveu:

<snip>

>>> Reusing G_TUNER/S_TUNER or not, the issue is that a bitfield parameter for
>>> frequency range is not actually able to express what are the supported
>>> ranges. As I said before, the tuner ranges can only be properly expressed
>>> by an array with:
>>> 	- range low/high;
>>> 	- modulation (AM, FM, ...);
>>> 	- sub-carriers (mono, stereo, lang1, lang2);
>>> 	- properties (RDS, seek caps, ...).
>>
>> Agreed.
>>
>> So, in my opinion we still need the band field, but instead of this being a
>> fixed band it is an index.
>>
>> In order to enumerate over all bands I propose a new ioctl:
>>
>> VIDIOC_ENUM_TUNER_BAND
>>
>> with struct:
>>
>> struct v4l2_tuner_band {
>> 	__u32 tuner;
>> 	__u32 index;
>> 	char name[32];
>> 	__u32 capability;	/* The same as in v4l2_tuner */
>> 	__u32 rangelow;
>> 	__u32 rangehigh;
>> 	__u32 reserved[7];
>> };
>>
>> It enumerates the supported bands by the tuner, each with a human readable name,
>> frequency range and capabilities.
>>
>> If you change the band using S_TUNER, then G_TUNER will return the frequency range
>> and capabilities from the corresponding v4l2_tuner_band struct.
>>
>> The only capability that needs to be added is one that tells the application that
>> the tuner has the capability to do band enumeration (V4L2_TUNER_CAP_HAS_BANDS or
>> something).
>>
>> I am not 100% certain about the name field: it is very nice for apps, but we do
>> need some guidelines here.
>>
>> A similar struct would be needed for modulators if we ever need to add support for
>> modulators with multiple bands.
>>
>> We could perhaps rename v4l2_tuner_band to just v4l2_band to make it tuner/modulator
>> agnostic.

I've not replied before because I've been thinking about Hans V's proposal for a bit,
I've come to the conclusion that Hans V's proposal is better, because it avoids a
discrepancy in how tuners work between tv and radio, which is something which worried
me about my own proposal. Hans V's proposal also has the benefit that it will work fine
for tv-tuners too, so if we ever need bands for tv tuners we can use the *same* API.

> The above proposal would be great if we were starting to write the radio API today, but
> your proposal is not backward compatible with the status quo.

Huh? Hans V. is proposing adding a band field to the tuner struct (using one of the
reserved fields) and adding a new ioctl to enumerate bands. Old apps will have that field
set to 0 on a S_TUNER, selecting band 0, and G_TUNER will give info on the current band,
where-as S/G_FREQ will be unmodified (they will work on the current band). I don't see how
this breaks current apps...

Anyways both proposals seem workable to me, although I prefer Hans V.'s one. Lets just pick
one and get on with this.

Regards,

Hans




>
> Regards,
> Mauro
>

