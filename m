Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab2EXTMV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 15:12:21 -0400
Message-ID: <4FBE8819.80704@redhat.com>
Date: Thu, 24 May 2012 21:12:25 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: halli manjunatha <hallimanju@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Discussion: How to deal with radio tuners which can tune to multiple
 bands
References: <1337032913-18646-1-git-send-email-manjunatha_halli@ti.com> <CAMT6Pyd6e8zgkLEk_dpGTxiPZDippDe_YgedNRpUkJzA9X5hvw@mail.gmail.com> <4FBD2C80.3060406@redhat.com> <201205241700.36022.hverkuil@xs4all.nl>
In-Reply-To: <201205241700.36022.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/24/2012 05:00 PM, Hans Verkuil wrote:
> On Wed 23 May 2012 20:29:20 Hans de Goede wrote:

<snip>

>> ###
>>
>> So given all of the above I would like to propose the following:
>>
>> 1) Add a "band" field to struct v4l2_tuner, and a capability
>>      indicating if the driver understands / uses this field
>> 2) This field is only valid for radio tuners, for tv tuners it
>> should always be 0 (as it was sofar as it is reserved atm)
>> 3) This field can have a number of fixed values, for now we have:
>>
>> 0 RADIO_BAND_DEFAULT	Entire FM band supported by the tuner, or "default"
>>                           band if different bands require switching the tuner to
>>                           a different mode, or entire AM band supported by the
>> 			tuner for AM only tuners.
>> 1 RADIO_BAND_FM_EUROPE_US Europe or US band(87.5 Mhz - 108 MHz) *
>> 2 RADIO_BAND_FM_JAPAN	Japan band(76 MHz - 90 MHz) *
>> 3 RADIO_BAND_FM_RUSSIAN	OIRT or Russian band(65.8 MHz - 74 MHz) *
>> 4 RADIO_BAND_FM_WEATHER	Weather band(162.4 MHz - 162.55 MHz) *
>>
>> 256 RADIO_BAND_AM_MW	Mid Wave AM band, covered frequencies are tuner dependent
>> 257 RADIO_BAND_AM_LW	Long Wave AM band, covered frequencies are tuner dependent
>> 258 RADIO_BAND_AM_SW	Short Wave AM band, covered frequencies are tuner dependent
>
> I wouldn't add LW and SW as long as we don't have hardware that supports it.

Ok.

>>
>> *) Reported (and available) frequency range might be different based on hardware
>> capabilities
>>
>> Notice how 0, which the current reserved field should be set to for old apps,
>> should always cover as much of FM as possible, or AM for AM only tuners, to
>> preserve functionality for old non band aware v4l2 radio apps.
>>
>> A (radio) tuner should always support RADIO_BAND_DEFAULT
>>
>> 4) Apps can find out which bands are supported by doing a VIDIOC_G_TUNER
>> with band set to the desired value. If the passed band is not available
>> -EINVAL will be returned.
>
> I would propose to add capability flags signaling the presence of each bands.
> There are 24 bits available, and the number of bands is very limited. I see
> no problem here.
>
> This way an application doesn't need to cycle through all possible bands, but
> it can select one immediately.

Ok so that is 2 votes for using capability bits, so lets go with that solution
rather then requiring the app to do a g_tuner with all possible bands to
find out which bands are available.

>> 5) Apps can select the active band by doing a VIDIOC_S_TUNER with the band
>> field set to the desired band.
>
> OK. Note that the current frequency will have to be clamped to the new band.
>
>> 6) Doing a VIDIOC_S_FREQUENCY with a frequency which falls outside of the
>> current band will *not* result in an automatic band switch, instead the
>> passed frequency will be clamped to fit into the current band.
>
> OK.
>
>> 7) Doing a VIDIOC_S_HW_FREQ_SEEK will seek in the currently active band,
>> this matches existing behavior where the seek starts at the currently
>> active frequency.
>
> Sounds good. Then we don't need to add a band field here as was in Halli's
> first proposal.
>
>> I think / hope that covers everything we need. Suggestions ? Comments ?
>
> Modulators. v4l2_modulator needs a band field as well. The capabilities are
> already shared with v4l2_tuner, so that doesn't need to change.

Ah, yes modulators, good one, ack.

Manjunatha, since the final proposal is close to yours, and you already have
a patch for that including all the necessary documentation updates, can I ask
you to update your patch to implement this proposal?

I must admit another reason is that I don't really have a lot of time to work
on this atm, and it would be good to get this finalized soon, so that we will
be ready well in advance of the 3.6 cycle start :)

Thanks & Regards,

Hans
