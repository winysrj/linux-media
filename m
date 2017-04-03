Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53084 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751963AbdDCJod (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 05:44:33 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Various fixes
Message-ID: <46cdb2fc-0271-de5f-858e-ea701c60a76f@xs4all.nl>
Date: Mon, 3 Apr 2017 11:44:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes, documentation clarifications.

Regards,

	Hans

The following changes since commit c3d4fb0fb41f4b5eafeee51173c14e50be12f839:

  [media] rc: sunxi-cir: simplify optional reset handling (2017-03-24 08:30:03 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12e

for you to fetch changes up to 47b1810e23c9d88136402c496351bf0d8b30aa71:

  atmel-isc: fix off-by-one comparison and out of bounds read issue (2017-04-03 11:41:08 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      vcodec: mediatek: mark pm functions as __maybe_unused

Colin Ian King (1):
      atmel-isc: fix off-by-one comparison and out of bounds read issue

Hans Verkuil (5):
      dev-capture.rst/dev-output.rst: video standards ioctls are optional
      video.rst: a sensor is also considered to be a physical input
      v4l2-compat-ioctl32: VIDIOC_S_EDID should return all fields on error.
      vidioc-enumin/output.rst: improve documentation
      v4l2-ctrls.c: fix RGB quantization range control menu

Johan Hovold (5):
      dib0700: fix NULL-deref at probe
      usbvision: fix NULL-deref at probe
      cx231xx-cards: fix NULL-deref at probe
      cx231xx-audio: fix init error path
      cx231xx-audio: fix NULL-deref at probe

 Documentation/media/uapi/v4l/dev-capture.rst       |  4 ++--
 Documentation/media/uapi/v4l/dev-output.rst        |  4 ++--
 Documentation/media/uapi/v4l/video.rst             |  7 ++++---
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  | 11 ++++++-----
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst | 15 ++++++++-------
 drivers/media/platform/atmel/atmel-isc.c           |  2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    | 12 ++++--------
 drivers/media/usb/cx231xx/cx231xx-audio.c          | 42 +++++++++++++++++++++++++++++-------------
 drivers/media/usb/cx231xx/cx231xx-cards.c          | 45 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/media/usb/dvb-usb/dib0700_core.c           |  3 +++
 drivers/media/usb/usbvision/usbvision-video.c      |  9 ++++++++-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  5 ++++-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  4 ++--
 13 files changed, 113 insertions(+), 50 deletions(-)
