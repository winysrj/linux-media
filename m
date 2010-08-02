Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25515 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0HBOHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 10:07:31 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v7 0/5] TI WL1273 FM Radio driver.
Date: Mon,  2 Aug 2010 17:06:38 +0300
Message-Id: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

and thanks for the comments Hans.

Now I've done a couple of iterations with the codec on the ALSA mailing
list and that still continues... I've removed all "#undef DEBUG" lines,
because the ALSA people didn't like them.

I'll go through the comments and the rest of the changes:

>> +     tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_RDS |
>> +             V4L2_TUNER_CAP_STEREO;
>> +
>
> audmode must be set even when the device is in TX mode. Best is to just set it
> to the last set audmode.

I added a state field for the audmode. I used a boolean variable because
that seemed to lead to clearer code than using an int. Other two valued
entities - like the digital/analog mode - could also be modeled with booleans
but I didn't do it because it could be condemned by the community :-)

Should there also be audmode for the modulator?

>> +     if (val == WL1273_RX_MONO) {
>> +             tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
>> +             tuner->audmode = V4L2_TUNER_MODE_MONO;
>> +     } else {
>> +             tuner->rxsubchans = V4L2_TUNER_SUB_STEREO;
>> +             tuner->audmode = V4L2_TUNER_MODE_STEREO;
>> +     }
>
> There are two separate things: detecting whether the signal is stereo or mono
> and selecting the audio mode (this is the format of the audio that is sent to
> userspace). The first is set in rxsubchans and is dynamic, the second is fixed
> and set by the application.
>
> If the device can detect mono vs stereo signals, then rxsubchans should be set
> accordingly. If the device cannot do this, then both mono and stereo should be
> specified in rxsubchans.
>
> The audmode field is like a control: it does not automatically change if the
> signal switches from mono to stereo or vice versa. Unless the hardware is
> unable to map a mono signal to a stereo audio stream or a stereo signal to a
> mono audio stream.
>
> The fact that the code above sets both rxsubchans and audmode suggests either
> that the hardware cannot map stereo to mono or vice versa, or a program bug.
> In the first case we need a comment here, in the second case it should be
> fixed.

I kind of new I was doing something wrong here... but then I thought: why
isn't there a control variable for the RDS? Anyway, now I've made the
distinction between subchans flags and the audmode field.

>> +
>> +     if (core->rds_on)
>> +             modulator->txsubchans |= V4L2_TUNER_SUB_RDS;
>> +     else
>> +             modulator->txsubchans &= ~V4L2_TUNER_SUB_RDS;
>
> This else is not needed.

Else removed...

> Just make this Hz. There is no need to restrict the precision to
> kHz. S_FREQUENCY supports units of 67.5 Hz, so using kHz for the
> spacing seems unnecessary.
> 
> Alternatively the same resolution as S_FREQUENCY can be used (67.5 Hz
> or 67.5 kHz, depending on the CAP_LOW capability). Not sure which is
> best, though.

I think using Hz is the most straightforward policy here so I chose that.

Cheers,
Matti

Matti J. Aaltonen (5):
  V4L2: Add seek spacing and FM RX class.
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  ASoC: WL1273 FM Radio Digital audio codec.
  V4L2: WL1273 FM Radio: Controls for the FM radio.
  Documentation: v4l: Add hw_seek spacing and FM_RX class

 Documentation/DocBook/v4l/controls.xml             |   71 +
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
 drivers/media/radio/Kconfig                        |   15 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-wl1273.c                 | 1972 ++++++++++++++++++++
 drivers/media/video/v4l2-common.c                  |   12 +
 drivers/mfd/Kconfig                                |    6 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/wl1273-core.c                          |  612 ++++++
 include/linux/mfd/wl1273-core.h                    |  314 ++++
 include/linux/videodev2.h                          |   15 +-
 sound/soc/codecs/Kconfig                           |    6 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/wl1273.c                          |  591 ++++++
 sound/soc/codecs/wl1273.h                          |   42 +
 15 files changed, 3668 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h

