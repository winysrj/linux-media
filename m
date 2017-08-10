Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:46509 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbdHJWLe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 18:11:34 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH 0/5] [media] Add analog mode support for Medion MD95700
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Message-ID: <a9722867-8f83-d93b-f002-52cab073e587@maciej.szmigiero.name>
Date: Thu, 10 Aug 2017 23:49:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for analog part of Medion 95700 in the cxusb
driver.

What works:
* Video capture at various sizes with sequential fields,
* Input switching (TV Tuner, Composite, S-Video),
* TV and radio tuning,
* Video standard switching and auto detection,
* Radio mode switching (stereo / mono),
* Unplugging while capturing,
* DVB / analog coexistence,
* Raw BT.656 stream support.

What does not work yet:
* Audio,
* VBI,
* Picture controls.

This series (as an one patch) was submitted for inclusion few years ago,
then waited few months in a patch queue.
Unfortunately, by the time it was supposed to be merged there
were enough changes in media that it was no longer mergable.

I thought at that time that I will be able to rebase and retest it soon
but unfortunately up till now I was never able to find enough time to do
so.
Also, with the passing of time the implementation diverged more and
more from the current kernel code, necessitating even more reworking.

The previous iteration can be found here:
https://patchwork.linuxtv.org/patch/8048/

Since that version there had been the following changes:
* Adaptation to changes in V4L2 / DVB core,

* Radio device was added, with a possibility to tune to a FM radio
station and switch between stereo and mono modes (tested by taping
audio signal directly at tuner output pin),

* DVB / analog coexistence was improved - resolved a few cases where
DVB core would switch off power or reset the tuner when the device
was still being used but in the analog mode,

* Fixed issues reported by v4l2-compliance,

* Switching to raw BT.656 mode is now done by a custom streaming
parameter set via VIDIOC_S_PARM ioctl instead of using a
V4L2_BUF_TYPE_PRIVATE buffer (which was removed from V4L2),

* General small code cleanups (like using BIT() or ARRAY_SIZE() macros
instead of open coding them, code formatting improvements, etc.).

 drivers/media/i2c/cx25840/cx25840-core.c |  422 ++++++-
 drivers/media/i2c/cx25840/cx25840-core.h |   11 +
 drivers/media/i2c/cx25840/cx25840-vbi.c  |    3 +
 drivers/media/pci/ivtv/ivtv-i2c.c        |    1 +
 drivers/media/tuners/tuner-simple.c      |    5 +-
 drivers/media/usb/dvb-usb/Kconfig        |    8 +-
 drivers/media/usb/dvb-usb/Makefile       |    2 +-
 drivers/media/usb/dvb-usb/cxusb-analog.c | 1867 ++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb/cxusb.c        |  453 +++++++-
 drivers/media/usb/dvb-usb/cxusb.h        |  137 +++
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c  |   20 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c |   13 +
 drivers/media/usb/dvb-usb/dvb-usb.h      |    8 +
 include/media/drv-intf/cx25840.h         |   74 +-
 14 files changed, 2957 insertions(+), 67 deletions(-)
 create mode 100644 drivers/media/usb/dvb-usb/cxusb-analog.c
