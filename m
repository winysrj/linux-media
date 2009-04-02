Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:25235 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZDBMFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 08:05:24 -0400
Date: Thu, 2 Apr 2009 15:02:11 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
Subject: Re: [PATCH 0/3] FM Transmitter driver
Message-ID: <20090402120211.GJ13493@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1238579011-12435-1-git-send-email-eduardo.valentin@nokia.com> <200904020947.11256.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904020947.11256.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Apr 02, 2009 at 09:47:11AM +0200, ext Hans Verkuil wrote:
> On Wednesday 01 April 2009 11:43:28 Eduardo Valentin wrote:
> > Hello Mauro and v4l guys,
> >
> > This series contains a v4l2 radio driver which
> > adds support for Silabs si4713 devices. That is
> > a FM transmitter device.
> >
> > As you should know, v4l2 does not contain representation
> > of FM Transmitters (at least that I know). So this driver
> > was written highly based on FM receivers API, which can
> > cover most of basic functionality. However, as expected,
> > there are some properties which were not covered.
> > For those properties, sysfs nodes were added in order
> > to get user interactions.
> >
> > Comments are wellcome.
> 
> Can you explain in reasonable detail the extra properties needed for a 
> device like this? You will need to document that anyway :-) Rather than 
> implementing a private API it would be much more interesting to turn this 
> into a public V4L2 API that everyone can use.

Yes, here is a little description of them:

Pilot is an audible tone sent by the device.

pilot_frequency - Configures the frequency of the stereo pilot tone.
pilot_deviation - Configures pilot tone frequency deviation level.
pilot_enabled - Enables or disables the pilot tone feature.

The si4713 device is capable of applying audio compression to the transmitted signal.

acomp_enabled - Enables or disables the audio dynamic range control feature.
acomp_gain - Sets the gain for audio dynamic range control.
acomp_threshold - Sets the threshold level for audio dynamic range control.
acomp_attack_time - Sets the attack time for audio dynamic range control.
acomp_release_time - Sets the release time for audio dynamic range control.

Limiter setups audio deviation limiter feature. Once a over deviation occurs,
it is possible to adjust the front-end gain of the audio input and always
prevent over deviation.

limiter_enabled - Enables or disables the limiter feature.
limiter_deviation - Configures audio frequency deviation level.
limiter_release_time - Sets the limiter release time.

power_level - Sets the output power level for signal transmission.

RDS related

rds_enabled - Enables or disables the RDS feature.
rds_ps_name - Sets the RDS ps name field for transmission.
rds_radio_text - Sets the RDS radio text for transmission.
rds_pi - Sets the RDS PI field for transmission.
rds_pty - Sets the RDS PTY field for transmission.

Region related

Setting region will affect other region properties.

region_bottom_frequency
region_channel_spacing
region_preemphasis
region_top_frequency

stereo_enabled - Enables or disables stereo mode.

> 
> How does one pass the audio and rds data to the driver? Note that for 2.6.31 
> we will finalize the V4L2 RDS decoder API (I recently posted an RFC for 
> that, but I haven't had the time to implement the few changes needed). It 
> would be nice if rds modulator support would be modeled after this 
> demodulator API if possible.

I see. This is good. I think the best way is to have a rds modulator
interface. This driver have implemented it as sys properties, as
described above.

> 
> Does region information really belong in the driver? Perhaps this should be 
> in a user-space library? (just a suggestion, I'm not sure at this stage).

Ok. Yes, this could be better to implement in user land. However,
depending on region that would restrict other properties as well.
So, letting user space control that, would allow device operate in wrong
intervals for frequencies for instance.

> 
> A general comment: the si4713 driver should be a stand-alone i2c driver. 
> That way it can be reused by other drivers/platforms that use this chip. 
> The v4l2_subdev framework should be used for this.

Right. I'll take a look at the v4l2_subdev framework.

> 
> Always interesting to see new functionality arrive in V4L2 :-)
> 
> Regards,
> 
> 	Hans
> 
> >
> > Eduardo Valentin (3):
> >   FMTx: si4713: Add files to handle si4713 device
> >   FMTx: si4713: Add files to add radio interface for si4713
> >   FMTx: si4713: Add Kconfig and Makefile entries
> >
> >  drivers/media/radio/Kconfig        |   12 +
> >  drivers/media/radio/Makefile       |    2 +
> >  drivers/media/radio/radio-si4713.c |  834 ++++++++++++++
> >  drivers/media/radio/radio-si4713.h |   32 +
> >  drivers/media/radio/si4713.c       | 2238
> > ++++++++++++++++++++++++++++++++++++ drivers/media/radio/si4713.h       |
> >  294 +++++
> >  6 files changed, 3412 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/radio/radio-si4713.c
> >  create mode 100644 drivers/media/radio/radio-si4713.h
> >  create mode 100644 drivers/media/radio/si4713.c
> >  create mode 100644 drivers/media/radio/si4713.h
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

-- 
Eduardo Valentin
