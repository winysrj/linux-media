Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:32231 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab0EXMVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 08:21:48 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v3 0/4] WL1273 FM Radio Driver
Date: Mon, 24 May 2010 15:21:39 +0300
Message-Id: <1274703703-11670-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again.

And thanks for the comments.

It the first patch I'm kind of suggesting a couple of additions to the
general interface: signal level stuff in the hw seek struct and then a 
function / IOCTL for asking for minimum and maximum for the level.

There are many changes I'll follow by commenting to Hans's comments:

>> 1. WL1273_CID_FM_REGION for setting the region. This may not be a good
>> candidate for standardization as the region control shouldn't exist 
>> in the kernel in general...
>
>Is this region relevant for receive, transmit or both?

Region is relevant for receiving only. Now I've changes the naming to "band"
because TI uses that in their latest document version.

>> 2. WL1273_CID_FM_SEEK_SPACING: defines what resolution is used when scanning 
>> automatically for stations (50KHz, 100KHz or 200KHz). This could be
>> useful in general. Could this be a field in the v4l2_hw_freq_seek struct?
>
>I think this belongs in v4l2_hw_freq_seek.

I've added spacing to the hw seek struct.

>> 3. WL1273_CID_FM_RDS_CTRL for turning on and off the RDS reception / 
>> transmission. To me this seems like a useful standard control...
>
>This already exists. You can enable/disable RDS by setting the 
> V4L2_TUNER_SUB_RDS subchannel bit when calling S_TUNER or S_MODULATOR.

I did this.

>> 4. WL1273_CID_SEARCH_LVL for setting the threshold level when detecting radio
>> channels when doing automatic scan. This could be useful for fine tuning
>> because automatic  scanning seems to be kind of problematic... This could 
>> also be a field in the v4l2_hw_freq_seek struct?
>
>This too seems reasonable to add to v4l2_hw_freq_seek. Although what sort of
>unit this level would have might be tricky. What is the unit for your hardware?

I've added this as well. The unit is some kind of dB value: "8 bit signed
number in 2âs complement format Each LSB = 1.5051 dBuV". I also added min
and max values for the level.


>> Could the VIDIOC_S_MODULATOR and VIDIOC_S_TUNER IOCTLs be used for setting
>> the TX/RX mode?
>
>Not entirely sure what you want to achieve here. I gather that the radio is
>either receiving, transmitting or off? So it can't receive and transmit at the
>same time, right?

Yes the radio can only transmit or receive at a time. And the states are:
On (RX or TX), Off and Suspended. In the suspended mode that firmware patch
is kept in the memory and it doesn't need to get uploaded again when operation
resumes.

> would expect in that case that calling S_TUNER or S_MODULATOR would switch it
> to either receive or transmit mode. S_HW_FREQ_SEEK would of course also switch
> it to receive mode.

I added this...

> There isn't anything to turn off the radio at the moment. Perhaps you can just
> automatically turn it off if nobody has the radio device or alsa device open?

Yes that can be done. Also volume control could be used. But also there's
nothing to put the radio to stand-by (suspension).
 
>> Now there already exits a class for fm transmitters: V4L2_CTRL_CLASS_FM_TX.
>> Should a corresponding class be created for FM tuners?
>
>I'm not sure that we need any. I think the only control that we need is to set
>the region, and I think that is more appropriate as a private (?) user control
>since it is definitely something that users should be easily able to change.

OK, that's fine by me

>This probably should be discussed a bit more.

Ok.

There's also two "new" things. The chip supports in addition to the normal
HW seek a HW block seek, which finds all receivable channels at once. And
then there's  a RSSI block scan that be used in both RX and TX modes to find
transmitting radio stations. Should we try to get these also into the
general interface?

Cheers,
Matti


Matti J. Aaltonen (4):
  V4L2: Add features to the interface.
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  ASoC: WL1273 FM Radio Digital audio codec.
  V4L2: WL1273 FM Radio: Controls for the FM radio.

 drivers/media/radio/Kconfig        |   15 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-wl1273.c | 1876 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |    6 +
 drivers/mfd/Makefile               |    2 +
 drivers/mfd/wl1273-core.c          |  606 ++++++++++++
 include/linux/mfd/wl1273-core.h    |  326 +++++++
 include/linux/videodev2.h          |    6 +-
 include/media/v4l2-ioctl.h         |    2 +
 sound/soc/codecs/Kconfig           |    6 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/wl1273.c          |  588 +++++++++++
 sound/soc/codecs/wl1273.h          |   40 +
 13 files changed, 3475 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h

