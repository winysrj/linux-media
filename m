Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab2FSTOd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 15:14:33 -0400
Message-ID: <4FE0D0AF.40801@redhat.com>
Date: Tue, 19 Jun 2012 21:19:11 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: halli manjunatha <hallimanju@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 4/6] videodev2.h: add frequency band information.
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl> <005651489cd5c9f832df2d5d90e19e2eee07c9b9.1338201853.git.hans.verkuil@cisco.com> <4FDFCC0F.9000208@redhat.com> <4FE037FE.7030804@redhat.com> <4FE05DF4.7030905@redhat.com> <4FE07255.6050606@redhat.com> <4FE08942.8020603@redhat.com> <4FE0AD29.4070300@redhat.com> <4FE0B802.3080703@redhat.com> <CAMT6PycQvuGxVC=ThLRYc5zDXitxy4QG2=jpO2qfagRhDFsdaQ@mail.gmail.com>
In-Reply-To: <CAMT6PycQvuGxVC=ThLRYc5zDXitxy4QG2=jpO2qfagRhDFsdaQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/19/2012 07:43 PM, halli manjunatha wrote:
> On Tue, Jun 19, 2012 at 12:33 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hi,
>>
>>
>> On 06/19/2012 06:47 PM, Hans de Goede wrote:
>>>
>>> Hi,
>>>
>>> <snip long discussion about having a fixed set of bands versus
>>> a way to enumerate bands, including their rangelow, rangehigh
>>> and capabilities>
>>>
>>> Ok, you've convinced me. I agree that having a way to actually
>>> enumerate ranges, rather then having a fixed set of ranges, is
>>> better.
>>>
>>> Which brings us back many weeks to the proposal for making
>>> it possible to enumerate bands on radio devices. Rather
>>> then digging up the old mails lets start anew, I propose
>>> the following API for this:
>>>
>>> 1. A radio device can have multiple tuners, but only 1 can
>>> be active (streaming audio to the associated audio input)
>>> at the same time.
>>>
>>> 2. Radio device tuners are enumerated by calling G_TUNER
>>> with an increasing index until EINVAL gets returned
>>>
>>> 3. G_FREQUENCY will always return the frequency and index
>>> of the currently active tuner
>>>
>>> 4. When calling S_TUNER on a radio device, the active
>>> tuner will be set to the v4l2_tuner index field
>>>
>>> 5. When calling S_FREQUENCY on a radio device, the active
>>> tuner will be set to the v4l2_frequency tuner field
>>>
>>> 6. On a G_TUNER call on a radio device the rxsubchans,
>>> audmode, signal and afc v4l2_tuner fields are only
>>> filled on for the active tuner (as returned by
>>> G_FREQUENCY) for inactive tuners these fields are reported
>>> as 0.
>>
>>
>> p.s.
>>
>> I forgot:
>>
>> 7. When calling VIDIOC_S_HW_FREQ_SEEK on a radio device, the active
>> tuner will be set to the v4l2_hw_freq_seek tuner field
>>
>> 8. When changing the active tuner with S_TUNER or S_HW_FREQ_SEEK,
>> the current frequency may be changed to fit in the range of the
>> new active tuner
>>
>> 9. For backwards compatibility reasons tuner 0 should be the tuner
>> with the broadest possible FM range
>
> So with this approach every time during S_FREQ/S_HW_SEEK/S_TUNER
> driver will check which tuner mode it is set to and change the tuner
> mode (or band) according to tuner field.
>
> So in my case I will have to support 5 tuner modes (EUROPE, JAPAN,
> RUSSIAN, WEATHER and DEFAULT) just like bands.

Correct.

Regards,

Hans
