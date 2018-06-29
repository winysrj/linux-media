Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:58988 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933124AbeF2VAJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 17:00:09 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RESEND][PATCH v6 0/6] [media] Add analog mode support for Medion MD95700
Date: Fri, 29 Jun 2018 22:59:57 +0200
Message-Id: <cover.1530305665.git.mail@maciej.szmigiero.name>
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

This series (as a one patch) was submitted for inclusion few years ago,
then waited few months in a patch queue.
Unfortunately, by the time it was supposed to be merged there
were enough changes in media that it was no longer mergable.

I thought at that time that I will be able to rebase and retest it soon
but unfortunately up till now I was never able to find enough time to do
so.
Also, with the passing of time the implementation diverged more and
more from the current kernel code, necessitating even more reworking.

That last iteration can be found here:
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

Changes from v1:
* Only support configuration of cx25840 pins that the cxusb driver is
actually using so there is no need for an ugly CX25840_PIN() macro,

* Split cxusb changes into two patches: first one implementing
digital / analog coexistence in this driver, second one adding the
actual implementation of the analog mode,

* Fix a warning reported by kbuild test robot.

Changes from v2:
* Split out ivtv cx25840 platform data zero-initialization to a separate
commit,

* Add kernel-doc description of struct cx25840_state,

* Make sure that all variables used in CX25840_VCONFIG_OPTION() and
CX25840_VCONFIG_SET_BIT() macros are their explicit parameters,

* Split out some code from cxusb_medion_copy_field() and
cxusb_medion_v_complete_work() functions to separate ones to increase
their readability,

* Generate masks using GENMASK() and BIT() macros in cx25840.h and
cxusb.h.

Changes from v3:
Add SPDX tag to a newly added "cxusb-analog.c" file.

Changes from v4:
* Make analog support conditional on a new DVB_USB_CXUSB_ANALOG Kconfig
option,

* Use '//' comments in the header of a newly added "cxusb-analog.c"
file,

* Don't print errors on memory allocation failures,

* Get rid of the driver MODULE_VERSION(),

* Small formating fix of a one line.

Changes from v5:
Rebase onto current media_tree/master.

 drivers/media/i2c/cx25840/cx25840-core.c |  396 ++++-
 drivers/media/i2c/cx25840/cx25840-core.h |   46 +-
 drivers/media/i2c/cx25840/cx25840-vbi.c  |    3 +
 drivers/media/pci/ivtv/ivtv-i2c.c        |    1 +
 drivers/media/tuners/tuner-simple.c      |    5 +-
 drivers/media/usb/dvb-usb/Kconfig        |   16 +-
 drivers/media/usb/dvb-usb/Makefile       |    3 +
 drivers/media/usb/dvb-usb/cxusb-analog.c | 1914 ++++++++++++++++++++++
 drivers/media/usb/dvb-usb/cxusb.c        |  452 ++++-
 drivers/media/usb/dvb-usb/cxusb.h        |  154 ++
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c  |   20 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c |   13 +
 drivers/media/usb/dvb-usb/dvb-usb.h      |    8 +
 include/media/drv-intf/cx25840.h         |   74 +-
 14 files changed, 3042 insertions(+), 63 deletions(-)
 create mode 100644 drivers/media/usb/dvb-usb/cxusb-analog.c
