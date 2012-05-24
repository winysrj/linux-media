Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:19755 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab2EXPBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:01:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Discussion: How to deal with radio tuners which can tune to multiple bands
Date: Thu, 24 May 2012 17:00:35 +0200
Cc: halli manjunatha <hallimanju@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1337032913-18646-1-git-send-email-manjunatha_halli@ti.com> <CAMT6Pyd6e8zgkLEk_dpGTxiPZDippDe_YgedNRpUkJzA9X5hvw@mail.gmail.com> <4FBD2C80.3060406@redhat.com>
In-Reply-To: <4FBD2C80.3060406@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205241700.36022.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 23 May 2012 20:29:20 Hans de Goede wrote:
> Hi,
> 
> As discussed before 2 different use-cases have come up where we want some
> knowledge of there being different radio bands added to the v4l2 API.
> 
> In Manjunatha Halli's case, if I understand things correctly, he wants
> to limit hw_freq_seek to a certain band, rather then the receiver happily
> trying to seek to frequencies which are not relevant for the use case in
> question. To that purpose his patch proposes adding a band field to the
> v4l2_hw_freq_seek struct, which can have one of the following values:
> 
> FM_BAND_TYPE_ALL	All Bands from 65.8 MHz till 108 Mhz or 162.55 MHz if weather band

I suggested that this be renamed to FM_BAND_DEFAULT (and that the _TYPE part
of the names will be removed). The default band is usually the widest band
(often 76-108) that the hardware can handle.

> FM_BAND_TYPE_EUROPE_US	Europe or US band(87.5 Mhz - 108 MHz)
> FM_BAND_TYPE_JAPAN	Japan band(76 MHz - 90 MHz)
> FM_BAND_TYPE_RUSSIAN	OIRT or Russian band(65.8 MHz - 74 MHz)
> FM_BAND_TYPE_WEATHER	Weather band(162.4 MHz - 162.55 MHz)
> 
> In my case the problem is that the TEA5757 tuner can tune both AM
> and FM (but note at the same time, it is a single tuner):
> AM  530   - 1710 kHz
> FM   87.5 -  108 MHz
> 
> In my case part of the problem is that the userspace UI for the tuner
> cannot simply depict the frequency range as one large slider.
> 
> For FM devices having a slider going from 65.8 - 162.55 MHz is
> far from ideal, esp. as there is a large whole of nothing in the
> 108-162 Mhz making the non functional area of the sliders range
> larger then the functional area.
> 
> For AM and FM capable devices representing the entire range
> (530 Khz - 162.55 Mhz) is not just not ideal it is simply unworkable!
> 
> So we don't just want to limit the range a VIDIOC_S_HW_FREQ_SEEK can
> seek over, we also want to let user space know for manual tuning
> that we've several ranges, and allow it to query information
> such as min / max freq, stereo capable, etc. per range.
> 
> As discussed with Hans V. this can best be done by extending
> struct v4l2_tuner with a band field.
> 
> Our (Hans V. and me) first idea here was to let this field
> work like an index, where userspace can enumerate available
> bands by calling VIDIOC_G_TUNER, incrementing band each time until
> -EINVAL gets returned.

Not quite. The available bands are signaled through the v4l2_tuner capabilities
field, so the app will know which bands there are. So there is no need to
increment the band.

> So that completes the intro, also known as setting the stage :)
> 
> ###
> 
> Taking the intersection between the 2 proposals and the 2 problems
> makes things interesting :)
> 
> Dividing the VIDIOC_G_TUNER results into bands also makes sense for
> the FM case, at least in a 65.8 - 108 Mhz and a  162 Mhz band, to
> avoid having a not tunable gap in the range reported to userspace.
> 
> But, allowing a EU citizen to tune below 87.5 is also not really
> useful, nor allowing a Japanese citizen to tune above the 90 Mhz, etc.
> 
> So from presenting the user with a sensible UI pov, it makes sense
> to not use 2 bands with FM, but to expose all supported bands
> to userspace as they really are. This also makes sense from a demod
> pov, since FM demodulation for Japanese FM is different then for
> EU/US FM, so maybe the hardware needs to be poked to switch modes.

Right.

> Note that some radio chip drivers already do this effectively by having
> a module parameter to select which band to use.
> 
> So lets expose all the FM bands from Manjunatha Halli's proposal
> in VIDIOC_G_TUNER results. If we then go for the classic enumeration
> strategy where userspace can enumerate available bands by calling
> VIDIOC_G_TUNER, incrementing band each time until -EINVAL gets
> returned, we get another problem...
> 
> How does user space know which band is which (other then checking
> min/max frequency which is ugly!) ? We could make the tuner name field
> different for each band, and let the app display a menu with tuner names
> for the user to select a band, but that is ugly too.
> 
> Not only would doing something like that be ugly, it also makes it
> as good as impossible for userspace to automatically select the
> right band based on location.
> 
> So doing the classic v4l2 enum trick where we increment band each
> time until we get -EINVAL is not a good idea IMHO.
> 
> Luckily Manjunatha Halli's proposal already gives us a solution,
> we can define a fixed set of bands (adding SW/MW/LW bands for AM),
> and userspace can enumerate by trying a G_TUNER for all
> bands it is interested in.
> 
> ###
> 
> So given all of the above I would like to propose the following:
> 
> 1) Add a "band" field to struct v4l2_tuner, and a capability
>     indicating if the driver understands / uses this field
> 2) This field is only valid for radio tuners, for tv tuners it
> should always be 0 (as it was sofar as it is reserved atm)
> 3) This field can have a number of fixed values, for now we have:
> 
> 0 RADIO_BAND_DEFAULT	Entire FM band supported by the tuner, or "default"
>                          band if different bands require switching the tuner to
>                          a different mode, or entire AM band supported by the
> 			tuner for AM only tuners.
> 1 RADIO_BAND_FM_EUROPE_US Europe or US band(87.5 Mhz - 108 MHz) *
> 2 RADIO_BAND_FM_JAPAN	Japan band(76 MHz - 90 MHz) *
> 3 RADIO_BAND_FM_RUSSIAN	OIRT or Russian band(65.8 MHz - 74 MHz) *
> 4 RADIO_BAND_FM_WEATHER	Weather band(162.4 MHz - 162.55 MHz) *
> 
> 256 RADIO_BAND_AM_MW	Mid Wave AM band, covered frequencies are tuner dependent
> 257 RADIO_BAND_AM_LW	Long Wave AM band, covered frequencies are tuner dependent
> 258 RADIO_BAND_AM_SW	Short Wave AM band, covered frequencies are tuner dependent

I wouldn't add LW and SW as long as we don't have hardware that supports it.

> 
> *) Reported (and available) frequency range might be different based on hardware
> capabilities
> 
> Notice how 0, which the current reserved field should be set to for old apps,
> should always cover as much of FM as possible, or AM for AM only tuners, to
> preserve functionality for old non band aware v4l2 radio apps.
> 
> A (radio) tuner should always support RADIO_BAND_DEFAULT
> 
> 4) Apps can find out which bands are supported by doing a VIDIOC_G_TUNER
> with band set to the desired value. If the passed band is not available
> -EINVAL will be returned.

I would propose to add capability flags signaling the presence of each bands.
There are 24 bits available, and the number of bands is very limited. I see
no problem here.

This way an application doesn't need to cycle through all possible bands, but
it can select one immediately.

> 
> 5) Apps can select the active band by doing a VIDIOC_S_TUNER with the band
> field set to the desired band.

OK. Note that the current frequency will have to be clamped to the new band.

> 6) Doing a VIDIOC_S_FREQUENCY with a frequency which falls outside of the
> current band will *not* result in an automatic band switch, instead the
> passed frequency will be clamped to fit into the current band.
 
OK.

> 7) Doing a VIDIOC_S_HW_FREQ_SEEK will seek in the currently active band,
> this matches existing behavior where the seek starts at the currently
> active frequency.

Sounds good. Then we don't need to add a band field here as was in Halli's
first proposal.

> I think / hope that covers everything we need. Suggestions ? Comments ?

Modulators. v4l2_modulator needs a band field as well. The capabilities are
already shared with v4l2_tuner, so that doesn't need to change.

Other than that it looks OK to me.

Regards,

	Hans
