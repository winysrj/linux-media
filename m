Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2109 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2EZQke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 12:40:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Discussion: How to deal with radio tuners which can tune to multiple bands
Date: Sat, 26 May 2012 18:40:27 +0200
Cc: halli manjunatha <hallimanju@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1337032913-18646-1-git-send-email-manjunatha_halli@ti.com> <4FBE8819.80704@redhat.com> <4FC0FE9A.70603@redhat.com>
In-Reply-To: <4FC0FE9A.70603@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205261840.27204.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat May 26 2012 18:02:34 Hans de Goede wrote:
> Hi,
> 
> On 05/24/2012 09:12 PM, Hans de Goede wrote:
> > Hi,
> >
> > On 05/24/2012 05:00 PM, Hans Verkuil wrote:
> >>> I think / hope that covers everything we need. Suggestions ? Comments ?
> >>
> >> Modulators. v4l2_modulator needs a band field as well. The capabilities are
> >> already shared with v4l2_tuner, so that doesn't need to change.
> >
> > Ah, yes modulators, good one, ack.
> >
> > Manjunatha, since the final proposal is close to yours, and you already have
> > a patch for that including all the necessary documentation updates, can I ask
> > you to update your patch to implement this proposal?
> >
> 
> So I've been working a bit on adding AM support to the tea575x driver using
> the agreed upon API, some observations from this:
> 
> 1) There is no way to get which band is currently active

Huh? Didn't G_TUNER return the current band? That's how I interpreted the
proposal. G_TUNER returns the available bands in capabilities and the current
band and its frequency range. You want to find the frequency range of another
band you call have to call S_TUNER first to select that other band, and then
G_TUNER to discover its range.

That also solves case 2. No need for an extra band in v4l2_frequency.

> This is IMHO a big problem, a GUI radio app will quite likely when it starts get
> all the current settings and display them without modifying any settings, so
> it needs a way to find out which band is active.
> 
> 2) What if first a band aware radio app sets a non default band, and then a
> non band aware radio app comes along, it does a g_tuner on the default-band,
> using the lo / high freq-s to build its UI, then the users picks a frequency,
> and the app does a s_freq, and the result is a frequency outside of what the
> app thinks are the lo / high freq limits because a different band is active ->
> not good.
> 
> So I think we need to slightly modify the proposal, esp. to deal with 1), 2)
> is a corner case and not really all that important on its own IMHO.
> 
> I suggest fixing 1) by not only adding a band field to v4l2_tuner, so that
> the different ranges for different bands can be queried, but also adding
> a band field to v4l2_frequency, so that the current active band can be
> reported by g_frequency. Once we make g_frequency report the active band,
> it makes sense to make s_frequency set the active band.

I don't really like this. You run into the same weird situation with G_TUNER
that I did (as that was one of my ideas as well) where you set band to e.g.
the weather band and get back the corresponding frequency range, but the other
fields like signal and rxsubchans still refer to the *current* band. That's
confusing and not logical.

> We would then need no changes to s_tuner at all, it will still only have
> audmode as writeable setting and thus *not* set the active band. Effectively
> s_tuner would just completely ignore the passed in band. Keeping audmode as
> a global (not band specific) setting, and likewise g_tuner would always
> return CAP_STEREO stereo if some bands are stereo capable.
> 
> This also nicely fixes 2). Since the reserved fields should be 0, so a
> s_frequency by a non band aware app will set the band to the default band.
> 
> ###
> 
> So here is a new / amended version of my band proposal:
> 
> 1) Introduce the concept of bands, for radio tuners only
> 
> 2) Define the following bands:
> 
> #define V4L2_BAND_DEFAULT       0
> #define V4L2_BAND_FM_EUROPE_US  1       /* 87.5 Mhz - 108 MHz */
> #define V4L2_BAND_FM_JAPAN      2       /* 76 MHz - 90 MHz */
> #define V4L2_BAND_FM_RUSSIAN    3       /* 65.8 MHz - 74 MHz */
> #define V4L2_BAND_FM_WEATHER    4       /* 162.4 MHz - 162.55 MHz */
> #define V4L2_BAND_AM_MW         5
> 
> 3) radio tuners indicate if they understand any of the non default bands
> with the following tuner caps:
> 
> #define V4L2_TUNER_CAP_BAND_FM_EUROPE_US        0x00010000
> #define V4L2_TUNER_CAP_BAND_FM_JAPAN    	0x00020000
> #define V4L2_TUNER_CAP_BAND_FM_RUSSIAN  	0x00040000
> #define V4L2_TUNER_CAP_BAND_FM_WEATHER  	0x00080000
> #define V4L2_TUNER_CAP_BAND_AM_MW       	0x00100000
> 
> A (radio) tuner should always support RADIO_BAND_DEFAULT, so there is no
> capability flag for this
> 
> 4) Add a band field to v4l2_tuner, apps can query the exact rangelow and
> rangehigh values for a specific band by doing a g_tuner with band set to
> that band. All v4l2_tuner fields returned by g_tuner will be independent
> of the selected band (iow constant) except for: rangelow, rangehigh,
> rxsubchans and signal.
> 4a) rangelow, rangehigh will be the actual values for that band
> 4b) rxsubchans and signal will be 0 if a g_tuner is done for a band different
> then the active band, for the active band they will reflect the actual values.

So I would do this as:

4) Add a band field to v4l2_tuner. Calling g_tuner will set this to the
current band. You change it by calling s_tuner. CAP_STEREO and audmode are
global properties, not per-band. CAP_STEREO really refers to whether the
hardware can do stereo at all.

> 5) s_tuner will be completely unchanged, the band field will not influence
> it, audmode will be a per tuner global, not a per band value

Drop this.

> 6) Add a band field to v4l2_frequency, on a g_frequency this will reflect the
> current band, on a s_frequency this will set the current band

Drop this.

> 7) Doing a VIDIOC_S_HW_FREQ_SEEK will seek in the currently active band,
> iow the band last set by a s_frequency call, this matches existing behavior where
> the seek starts at the currently active frequency (so the frequency set by the
> last s_frequency call, or the frequency from the last seek).

5) Doing a VIDIOC_S_HW_FREQ_SEEK will seek in the currently active band,
iow the band last set by a s_tuner call.

Two fewer items on this list :-)

Regards,

	Hans
