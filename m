Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2EWTll (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 15:41:41 -0400
Message-ID: <4FBD3D78.5030406@redhat.com>
Date: Wed, 23 May 2012 21:41:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: halli manjunatha <hallimanju@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Discussion: How to deal with radio tuners which can tune to multiple
 bands
References: <1337032913-18646-1-git-send-email-manjunatha_halli@ti.com> <1337032913-18646-3-git-send-email-manjunatha_halli@ti.com> <201205201152.12948.hverkuil@xs4all.nl> <CAMT6Pyd6e8zgkLEk_dpGTxiPZDippDe_YgedNRpUkJzA9X5hvw@mail.gmail.com> <4FBD2C80.3060406@redhat.com> <CAMT6PyeDv3K7hH4wJ_E6jDt-5Vh82FJrrZg-SREnFEmybgnTLA@mail.gmail.com>
In-Reply-To: <CAMT6PyeDv3K7hH4wJ_E6jDt-5Vh82FJrrZg-SREnFEmybgnTLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/23/2012 09:24 PM, halli manjunatha wrote:
> On Wed, May 23, 2012 at 1:29 PM, Hans de Goede<hdegoede@redhat.com>  wrote:

< snip my super long proposal intro :) >

>> ###
>>
>> So given all of the above I would like to propose the following:
>>
>> 1) Add a "band" field to struct v4l2_tuner, and a capability
>>    indicating if the driver understands / uses this field
>> 2) This field is only valid for radio tuners, for tv tuners it
>> should always be 0 (as it was sofar as it is reserved atm)
>> 3) This field can have a number of fixed values, for now we have:
>>
>> 0 RADIO_BAND_DEFAULT    Entire FM band supported by the tuner, or "default"
>>                         band if different bands require switching the tuner
>> to
>>                         a different mode, or entire AM band supported by the
>>                         tuner for AM only tuners.
>> 1 RADIO_BAND_FM_EUROPE_US Europe or US band(87.5 Mhz - 108 MHz) *
>> 2 RADIO_BAND_FM_JAPAN   Japan band(76 MHz - 90 MHz) *
>> 3 RADIO_BAND_FM_RUSSIAN OIRT or Russian band(65.8 MHz - 74 MHz) *
>> 4 RADIO_BAND_FM_WEATHER Weather band(162.4 MHz - 162.55 MHz) *
>>
>> 256 RADIO_BAND_AM_MW    Mid Wave AM band, covered frequencies are tuner
>> dependent
>> 257 RADIO_BAND_AM_LW    Long Wave AM band, covered frequencies are tuner
>> dependent
>> 258 RADIO_BAND_AM_SW    Short Wave AM band, covered frequencies are tuner
>> dependent
>
> First - Here driver will add the list of Band which it supports in the
> VIDEOC_G_TUNER capability flag

We could do that, although then the indexes for the AM bands need to be
lowered. I'm not sure if we should do this though. It will save a number
of ioctl calls, but those are cheap (as long as they don't hit the hardware)
and they are only done during enumeration by the app (iow not repeatedly)

So we've a trade-off here between making it easier for the app (the app
has to do less ioctls and can just test capability bits) and between
being conservative with capability bits.

I've a slight preference for the just let the app call g_tuner a number
of times to find out about supported bands because we don't know what
sort of bands we will add in the future and if we get too many bands
we may run out of capability bits.

With that said I'm not against the capability bits approach, just explaining
my reasoning. If Hans V. says he prefers the capability bits too, I'm fine
with going that way.

>>
>> *) Reported (and available) frequency range might be different based on
>> hardware
>> capabilities
>>
>> Notice how 0, which the current reserved field should be set to for old
>> apps,
>> should always cover as much of FM as possible, or AM for AM only tuners, to
>> preserve functionality for old non band aware v4l2 radio apps.
>>
>> A (radio) tuner should always support RADIO_BAND_DEFAULT
>>
>> 4) Apps can find out which bands are supported by doing a VIDIOC_G_TUNER
>> with band set to the desired value. If the passed band is not available
>> -EINVAL will be returned.
> Second - User Application do VIDEOC_G_TUNER and checks the struct
> v4l2_tuner.capability for the list of bands supported by Driver.

See above :)

>>
>> 5) Apps can select the active band by doing a VIDIOC_S_TUNER with the band
>> field set to the desired band.
> Third - Here App sets the chip  to the required band.

Ack.

>> 6) Doing a VIDIOC_S_FREQUENCY with a frequency which falls outside of the
>> current band will *not* result in an automatic band switch, instead the
>> passed frequency will be clamped to fit into the current band.
> Fourth - As already chip is set to a band set_frequency for frequency
> within the activated band will work.
>
> But I think its better to report 'ERANGE' to the frequencies which are
> out of band limit. So that UI app also knows that set frequency failed
> and it will show the bar to the last frequency.

The spec currently states that the behavior for s_freq is to set the
frequency to the nearest supported frequency, rather then report an error,
so we're stuck with that. Also note that the driver may also change the
frequency even if it is inside the range, because the hardware may not
be able to do the exact requested frequency. So any good written app
should always do a g_freq after a s_freq and show the user what he
actually got.

>>
>> 7) Doing a VIDIOC_S_HW_FREQ_SEEK will seek in the currently active band,
>> this matches existing behavior where the seek starts at the currently
>> active frequency.
> I agree.
>>
>> I think / hope that covers everything we need. Suggestions ? Comments ?
>
> Solution seems fine for me

I'm happy to hear that!

Regards,

Hans
