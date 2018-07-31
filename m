Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36672 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732215AbeGaSnc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 14:43:32 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Brian Warner <brian.warner@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Antti Palosaari <crope@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuah@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: [PATCH RFC 0/4] Better handle pads for tuning/decoder part of the devices
Date: Tue, 31 Jul 2018 14:02:09 -0300
Message-Id: <cover.1533055990.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At PC consumer devices, it is very common that the bridge same driver 
to be attached to different types of tuners and demods. We need a way
for the Kernel to properly identify what kind of signal is provided by each
PAD, in order to properly setup the pipelines.

The previous approach were to hardcode a fixed number of PADs for all
elements of the same type. This is not good, as different devices may 
actually have a different number of pads.

It was acceptable in the past, as there were a promisse of adding "soon"
a properties API that would allow to identify the type for each PADs, but
this was never merged (or even a patchset got submitted).

So, replace this approach by another one: add a "taint" mark to pads that
contain different types of signals.

I tried to minimize the number of signals, in order to make it simpler to
convert from the past way. However, I'm not inspired today to give
names to the signals each pad contain. So, feel free to give better
suggestions if this one doesn't fit too well.

For now, this is just a RFC, compile-tested only, as the main goal here is to
discuss about an approach. Once I get enough feedback, I'll do some
tests.


Mauro Carvalho Chehab (4):
  media: v4l2: remove VBI output pad
  media: v4l2: taint pads with the signal types for consumer devices
  v4l2-mc: switch it to use the new approach to setup pipelines
  media: dvb: use signals to discover pads

 drivers/media/dvb-core/dvbdev.c              | 37 ++++++++-
 drivers/media/dvb-frontends/au8522_decoder.c |  4 +-
 drivers/media/i2c/msp3400-driver.c           |  2 +
 drivers/media/i2c/saa7115.c                  |  3 +-
 drivers/media/i2c/tvp5150.c                  |  3 +-
 drivers/media/pci/saa7134/saa7134-core.c     |  3 +-
 drivers/media/tuners/si2157.c                |  3 +
 drivers/media/usb/dvb-usb-v2/mxl111sf.c      |  2 +
 drivers/media/v4l2-core/tuner-core.c         |  5 ++
 drivers/media/v4l2-core/v4l2-mc.c            | 87 ++++++++++++++++----
 include/media/media-entity.h                 | 33 ++++++++
 include/media/v4l2-mc.h                      |  2 -
 12 files changed, 158 insertions(+), 26 deletions(-)

-- 
2.17.1
