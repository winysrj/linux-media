Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:54840 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0HZJCn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 05:02:43 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v8 0/5] TI WL1273 FM Radio driver.
Date: Thu, 26 Aug 2010 12:02:13 +0300
Message-Id: <1282813338-13882-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

and thank you for the comments.

The audio codec has been accepted on the ALSA list...

I've converted the driver to the new control framework
as Hans strongly suggested. 

P.S. I thought that I sent the patches on the day I created them,
but something clearly went wrong here...

Hans wrote:
> Use ERANGE instead of EDOM. EDOM is for math functions only.

Changed EDOM to ERANGE.

>> +     if (r)
>> +             core->mode = old_mode ;
>
> Remove space before ';'.

Space removed...


>> +     if (radio->rds_on) {
>> +             if (mutex_lock_interruptible(&core->lock))
>> +                     return -EINTR;
>> +
>> +             core->irq_flags &= ~WL1273_RDS_EVENT;
>
> This is dangerous: you probably want to use a usecount instead. With this
> code opening the device one will turn on the RDS events, but opening and
> closing it via another application (e.g. v4l2-ctl) will disable it while
> the first still needs it.

Replaced the bool variable with a usage counter.


Alexey wrote:
> > +       if (!radio->write_buf)
> > +               return -ENOMEM;
> 
> I'm not sure but it looks like possible memory leak. Shouldn't you
> call to kfree(radio) before returning ENOMEM?

and

> > +err_device_alloc:
> > +       kfree(radio);
> 
> And i'm not sure about this error path.. Before kfree(radio) it's
> needed to call kfree(radio->write_buf), rigth?
> Looks like all erorr paths in this probe function have to be checked.

Rewrote the error handling in the probe function.

Pramodh wrote:
> > +    r = wl1273_fm_write_cmd(core, WL1273_POWER_LEV_SET, power);
> 
> Output power level is specified in units of dBuV (as explained at 
> http://www.linuxtv.org/downloads/v4l-dvb-apis/ch01s09.html#fm-tx-controls).
> Shouldn't it be converted to WL1273 specific power level value?
> 
> My understanding:
> If output power level specified using "V4L2_CID_TUNE_POWER_LEVEL" is 122 
> (dB/uV), then
> power level value to be passed for WL1273 should be '0'.
> Please correct me, if I got this conversion wrong.

Fixed the TX power level handling...

Thanks

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
 drivers/media/radio/radio-wl1273.c                 | 1947 ++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c                   |   12 +
 drivers/mfd/Kconfig                                |    5 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/wl1273-core.c                          |  612 ++++++
 include/linux/mfd/wl1273-core.h                    |  314 ++++
 include/linux/videodev2.h                          |   15 +-
 sound/soc/codecs/Kconfig                           |    6 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/wl1273.c                          |  593 ++++++
 sound/soc/codecs/wl1273.h                          |   42 +
 15 files changed, 3644 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h

