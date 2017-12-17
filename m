Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:53612 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757420AbdLQRed (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 12:34:33 -0500
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH v3 0/6] [media] Add analog mode support for Medion MD95700
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f2106752-d4be-8689-081d-fa6ea904cd16@maciej.szmigiero.name>
Date: Sun, 17 Dec 2017 18:34:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
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

Maciej S. Szmigiero (6):
  ivtv: zero-initialize cx25840 platform data
  cx25840: add kernel-doc description of struct cx25840_state
  cx25840: add pin to pad mapping and output format configuration
  tuner-simple: allow setting mono radio mode
  [media] cxusb: implement Medion MD95700 digital / analog coexistence
  [media] cxusb: add analog mode support for Medion MD95700

 drivers/media/i2c/cx25840/cx25840-core.c |  396 +++++-
 drivers/media/i2c/cx25840/cx25840-core.h |   46 +-
 drivers/media/i2c/cx25840/cx25840-vbi.c  |    3 +
 drivers/media/pci/ivtv/ivtv-i2c.c        |    1 +
 drivers/media/tuners/tuner-simple.c      |    5 +-
 drivers/media/usb/dvb-usb/Kconfig        |    8 +-
 drivers/media/usb/dvb-usb/Makefile       |    2 +-
 drivers/media/usb/dvb-usb/cxusb-analog.c | 1927 ++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb/cxusb.c        |  455 ++++++-
 drivers/media/usb/dvb-usb/cxusb.h        |  136 +++
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c  |   20 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c |   13 +
 drivers/media/usb/dvb-usb/dvb-usb.h      |    8 +
 include/media/drv-intf/cx25840.h         |   74 +-
 14 files changed, 3028 insertions(+), 66 deletions(-)
 create mode 100644 drivers/media/usb/dvb-usb/cxusb-analog.c
