Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2575 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0EAJWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 May 2010 05:22:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH 0/3] TI WL1273 FM Radio Driver v2.
Date: Sat, 1 May 2010 11:23:18 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
References: <1272632388-16048-1-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1272632388-16048-1-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201005011123.18211.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 April 2010 14:59:45 Matti J. Aaltonen wrote:
> Hello.
> 
> I've implemented most of the changes proposed on the previous review round. 
> There are some things to be done in the RDS handling...
> 
> I've left the region handling as it was because neither of the chip's
> regions cover the complete range. Japan is from 76 - 90MHz and
> Europe/US is 87.5 to 108 MHz.
> 
> Some of the private IOCTL were not necessary because corresponding standardized
> controls already exist. And for setting the audio mode to digital or analog
> I created an ALSA control because that's an audio thing anyway. 
> 
> A couple of private IOCTLs are still there: 
> 
> 1. WL1273_CID_FM_REGION for setting the region. This may not be a good
> candidate for standardization as the region control shouldn't exist 
> in the kernel in general...

Is this region relevant for receive, transmit or both?
 
> 2. WL1273_CID_FM_SEEK_SPACING: defines what resolution is used when scanning 
> automatically for stations (50KHz, 100KHz or 200KHz). This could be
> useful in genaral. Could this be a field in the v4l2_hw_freq_seek struct?

I think this belongs in v4l2_hw_freq_seek.

> 3. WL1273_CID_FM_RDS_CTRL for turning on and off the RDS reception / 
> transmission. To me this seems like a useful standard control...

This already exists. You can enable/disable RDS by setting the V4L2_TUNER_SUB_RDS
subchannel bit when calling S_TUNER or S_MODULATOR.

> 4. WL1273_CID_SEARCH_LVL for setting the threshold level when detecting radio
> channels when doing automatic scan. This could be useful for fine tuning
> because automatic  scanning seems to be kind of problematic... This could also
> be a field in the v4l2_hw_freq_seek struct?

This too seems reasonable to add to v4l2_hw_freq_seek. Although what sort of
unit this level would have might be tricky. What is the unit for your hardware?
 
> 5. WL1273_CID_FM_RADIO_MODE: Now the radio has the following modes: off, 
> suspend, rx and tx. It probably would be better to separate the powering 
> state (off, on, suspend) from the FM radio state (rx, tx)... 
> 
> Could the VIDIOC_S_MODULATOR and VIDIOC_S_TUNER IOCTLs be used for setting the
> TX/RX mode?

Not entirely sure what you want to achieve here. I gather that the radio is
either receiving, transmitting or off? So it can't receive and transmit at the
same time, right?

I would expect in that case that calling S_TUNER or S_MODULATOR would switch it
to either receive or transmit mode. S_HW_FREQ_SEEK would of course also switch
it to receive mode.

There isn't anything to turn off the radio at the moment. Perhaps you can just
automatically turn it off if nobody has the radio device or alsa device open?
 
> Now there already exits a class for fm transmitters: V4L2_CTRL_CLASS_FM_TX.
> Should a corresponding class be created for FM tuners?

I'm not sure that we need any. I think the only control that we need is to set
the region, and I think that is more appropriate as a private (?) user control
since it is definitely something that users should be easily able to change.

This probably should be discussed a bit more.

Regards,

	Hans

> 
> B.R.
> Matti A.
> 
> Matti J. Aaltonen (3):
>   MFD: WL1273 FM Radio: MFD driver for the FM radio.
>   WL1273 FM Radio: Digital audio codec.
>   V4L2: WL1273 FM Radio: Controls for the FM radio.
> 
>  drivers/media/radio/Kconfig        |   15 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-wl1273.c | 1849 ++++++++++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig                |    6 +
>  drivers/mfd/Makefile               |    2 +
>  drivers/mfd/wl1273-core.c          |  609 ++++++++++++
>  include/linux/mfd/wl1273-core.h    |  323 +++++++
>  sound/soc/codecs/Kconfig           |    6 +
>  sound/soc/codecs/Makefile          |    2 +
>  sound/soc/codecs/wl1273.c          |  587 ++++++++++++
>  sound/soc/codecs/wl1273.h          |   40 +
>  11 files changed, 3440 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-wl1273.c
>  create mode 100644 drivers/mfd/wl1273-core.c
>  create mode 100644 include/linux/mfd/wl1273-core.h
>  create mode 100644 sound/soc/codecs/wl1273.c
>  create mode 100644 sound/soc/codecs/wl1273.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
