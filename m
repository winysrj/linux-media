Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43952 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab0GTLQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 07:16:26 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v6 0/5] WL1273 FM Radio driver...
Date: Tue, 20 Jul 2010 14:15:57 +0300
Message-Id: <1279624562-14125-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All!

And thank for comments Hans and Mauro.

Here is the list of changes from v5:


include/linux/videodev2.h

Hans wrote:
>> +
>> +#define V4L2_CID_FM_RX_BAND                  (V4L2_CID_FM_TX_CLASS_BASE + 1)
>> +enum v4l2_fm_rx_band {
>
> Just a very small change: rename v4l2_fm_rx_band to v4l2_fm_band. We might need
> this enum later for transmitter devices as well so it is better to give it a
> slightly more generic name.

Changed the name to v4l2_fm_band. Also changed the define constant.

Hans wrote:
>Note: you also need to add support for the new class and control to v4l2-common.c.
>The following functions should be extended:
>
>v4l2_ctrl_get_menu()
>v4l2_ctrl_get_name()
>v4l2_ctrl_query_fill()

Added code...


sound/soc/codecs/wl1273.c

Hans wrote:
> You might want to have this reviewed on the alsa mailinglist. I don't think
> anyone on the linux-media list has the expertise to review this audio codec.

Yes, good idea, I'll send it to the ALSA list...

drivers/media/radio/radio-wl1273.c

>> +             return POLLIN | POLLOUT | POLLRDNORM;
>
> You also need to add POLLWRNORM.
>
> I wonder if this code is correct. Doesn't this depend on whether the device
> is in receive or transmit mode? So either poll returns POLLIN|POLLRDNORM or
> POLLOUT|POLLWRNORM. Or am I missing something?

I don't think you are missing anything. I've added code for RX and TX.

>> +     strcpy(tuner->name, WL1273_FM_DRIVER_NAME);
>
> strlcpy

Fixed. There was also another strcpy. Fixed also that.

>> +     tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
>
> You can't detect whether mono or stereo is received? Does the alsa codec always
> receive two channel audio? How does it handle mono vs stereo?

Stereo and mono modes can be detected. ALSA can also handle both...
The codec conforms automatically to the audio source/sink.


>> +     tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_RDS;
>
> Shouldn't CAP_STEREO be added?

Added.

>> +             tuner->rxsubchans |= V4L2_TUNER_SUB_RDS;
>
> tuner->audmode isn't filled!

Filled...

>> +             r = wl1273_fm_set_rds(core, WL1273_RDS_OFF);
>
> There is no support for SUB_MONO or SUB_STEREO?

Actually there is...

>> +     modulator->capability = V4L2_TUNER_CAP_RDS;
>
> Shouldn't CAP_LOW and CAP_STEREO be added here?

I agree.

>> +             modulator->txsubchans &= ~V4L2_TUNER_SUB_RDS;
>
> The SUB_MONO/SUB_STEREO flags aren't handled here.

Handling added.

> The g/s_tuner and g/s_modulator functions are always hard to get right. Lots of
> tricky flags and settings...

I agree... I kind of left the stereo/mono stuff to alsa... 


> As Mauro's review mentioned: please specify the unit of this spacing field! (It should be Hz).
> Don't forget to read and reply to Mauro's review as well!

OK. I put kHz as the spacing unit, that should be fine grained enough? I also
reformulated the text somewhat. And yes, I didn't notice Mauro's comments on
v4 patch set. But now I've read his comments and also given some comments
back.

Cheers,
Matti A.

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
 drivers/media/radio/radio-wl1273.c                 | 1960 ++++++++++++++++++++
 drivers/media/video/v4l2-common.c                  |   12 +
 drivers/mfd/Kconfig                                |    6 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/wl1273-core.c                          |  613 ++++++
 include/linux/mfd/wl1273-core.h                    |  313 ++++
 include/linux/videodev2.h                          |   15 +-
 sound/soc/codecs/Kconfig                           |    6 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/wl1273.c                          |  593 ++++++
 sound/soc/codecs/wl1273.h                          |   42 +
 15 files changed, 3658 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h

