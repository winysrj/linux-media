Return-path: <mchehab@pedra>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:56265 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab0IXL4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 07:56:13 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v10 0/4] WL1273 FM Radio driver.
Date: Fri, 24 Sep 2010 14:55:28 +0300
Message-Id: <1285329332-4380-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello all.

This is the tenth version of this patch set. Thank you for
comments, especially to Mauro.

I'll go through Mauro's comments one by one.

Patch 1/4:

>> +     case V4L2_CID_FM_BAND:                  return "FM Band";
>
> There's no need for a FM control, as there's already an ioctl pair
> that allows get/set the frequency bandwidth: VIDIOC_S_TUNER and
> VIDIOC_G_TUNER. So, the entire patch here seems uneeded/unwanted.

OK, I've taken this approach to bands.

2/4:

>> +MODULE_PARM_DESC(radio_band, "Band: 0=USA-Europe, 1=Japan");
>
> There's no need for a parameter to set the bandwidth.

Agreed & removed...


>> +MODULE_PARM_DESC(rds_buf, "RDS buffer entries: *100*");
>
> Hmm... it would be better to use, instead:
> 
> MODULE_PARM_DESC(rds_buf, "Number of RDS buffer entries. Default = 100");

Yes that's a better wording. Changed.

>> +EXPORT_SYMBOL(wl1273_fm_read_reg);
>
> Hmm... why do you need to export a symbol here?

This is something I didn't change (yet). I'll try to explain. Our original
idea for the driver structure was like this.

            codec       v4l2 controls
               \           /
                \         /
                 \       /
               the mfd core 

Mauro's idea is to merge the control child to the core and get rid of
the function exports. But because of the codec child many of the
exports would still be needed. And it makes sense to have the codec as
a separate module because the radio could be used without digital
audio. So I'm kind of against a major rewrite between v9 and v10
because in my view having v4l2 part as a separate module is not that
bad...

>> +static void wl1273_fm_rds_work(struct wl1273_core *core)
>> +{
>> +     wl1273_fm_rds(core);
>> +}
>
> Wouldn't be better to just use wl1273_fm_rds() instead of this?

Yes... fixed.

>> +     /* RDS buffer allocation */
>> +     core->buf_size = rds_buf * 3;
>
> Why it should be multiplied by a "random"value of 3?

Added a #define for the RDS block length.

>> +obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
>>
>
> From what I saw, wl1273-core and radio-wl1273 are just part of the
> same radio driver.  So, the better would be to just merge them into
> one driver module, with something like:
> 
>obj-wl1273.o = radio-wl1273.o wl1273-core.o
>obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
> 
> And remove all those export_symbol' s from wl1273-core.

Didn't do this (yet) for the reasons mentioned above....

3/4:

>> +#define DRIVER_DESC "Wl1273 FM Radio - V4L2"
>
> Why V4L2??? Just call it as "Wl1273 FM Radio".

That is - I guess - a good question, and I removed the " - V4L2". My
idea was to differentiate between the core, codec and the v4l2 part, 
that idea evidently wasn't a good one...

>> +     msgs = kmalloc((packet_num + 1)*sizeof(struct i2c_msg), GFP_KERNEL);
>
> Small CodingStyle issue: please use spaces between "*" operator: msgs
>        = kmalloc((packet_num + 1) * sizeof(struct i2c_msg),
>        GFP_KERNEL);

Fixed...

>> +static int wl1273_fm_set_band(struct wl1273_core *core, unsigned int band)
>> +{
>
> Should be adjusted to use VIDIOC_[G|S]_TUNER for RX.

Done. Internally the driver still kind of has two bands because that's
how the chip is. g_tuner returns the range 76 - 108MHz, which is the 
combination of the two internal ranges.

s_tuner select either of the ranges, and returns an error if the requested
range doesn't fit into either supported ranges. Are you happy with this
approach?

>> +     /* calculate block count from byte count */
>> +     count /= 3;
>
> Why the "magic" value of 3? Instead, please define a constant, naming
> it in a way that a casual code reviewer could understand why you're
> multiplying/dividing by 3.

Replaced all the magic numbers with the define constant.

>> +             r = wl1273_fm_set_band(core, ctrl->val);
>> +             break;
>
> Not needed. Instead, please implement it via VIDIOC_S_TUNER.

Done...


>> +     dev_dbg(radio->dev, "tuner->rangehigh: %d\n", tuner->rangehigh);
>
> Ranges should be using tuner->rangelow/rangehigh to change band limits.

Yes. Fixed.

>> +     }
>
> Please do the registration of the device at the end. Applications may
> try to open (and udev, in fact does it) the device while you're still
> initializing it. If you need to do it earlier, you'll need a lock
> protecting open/close/init, to avoid race conditions.

Moved the registration to the end of the probe function.

4/4:

>> new FM RX control class.
>
> Same comment as patch 1/4: FM bandwidth can already be defined via
> VIDIOC_[G|S]_TUNER.  So, this patch is just creating a duplicated API
> for something already defined.

Changed the documentation to reflect the changes in the code.


Cheers,
Matti

Matti J. Aaltonen (4): V4L2: Add seek spacing and RDS CAP bits.  MFD:
  WL1273 FM Radio: MFD driver for the FM radio.  V4L2: WL1273 FM
  Radio: Controls for the FM radio.  Documentation: v4l: Add hw_seek
  spacing and two TUNER_RDS_CAP flags.

 Documentation/DocBook/v4l/dev-rds.xml              |   10 +-
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
 drivers/media/radio/Kconfig                        |   15 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-wl1273.c                 | 1859 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |    5 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/wl1273-core.c                          |  585 ++++++
 include/linux/mfd/wl1273-core.h                    |  320 ++++
 include/linux/videodev2.h                          |    5 +-
 10 files changed, 2808 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h

