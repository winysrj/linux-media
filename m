Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2385 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2EaIOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 04:14:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] Improve HW_FREQ_SEEK and add frequency band support
Date: Thu, 31 May 2012 10:14:34 +0200
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205311014.34625.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches improve VIDIOC_S_HW_FREQ_SEEK and add frequency band support.
These changes are needed for both existing drivers (wl128x and radio-cadet)
and new drivers (the Griffin RadioShark driver that Hans de Goede made).

Once this is in these drivers can follow.

Regards,

	Hans

The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24 09:27:24 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git bands

for you to fetch changes up to a89deec1006c7489302fdcb63977a3a2da48b0a6:

  V4L2 Spec: fix typo: NTSC -> NRSC (2012-05-31 10:09:08 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      videodev2.h: add new hwseek capability bits.
      v4l2 spec: document the new v4l2_tuner capabilities
      S_HW_FREQ_SEEK: set capability flags and return ENODATA instead of EAGAIN.
      videodev2.h: add frequency band information.
      V4L2 spec: add frequency band documentation.
      V4L2 spec: clarify a few modulator issues.
      V4L2 Spec: fix typo: NTSC -> NRSC

 Documentation/DocBook/media/v4l/biblio.xml                |    2 +-
 Documentation/DocBook/media/v4l/common.xml                |   17 ++++++++---
 Documentation/DocBook/media/v4l/vidioc-g-frequency.xml    |    6 ++++
 Documentation/DocBook/media/v4l/vidioc-g-modulator.xml    |   38 ++++++++++++++++---------
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml        |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml |   21 +++++++++++---
 drivers/media/radio/radio-mr800.c                         |    5 ++--
 drivers/media/radio/radio-wl1273.c                        |    3 +-
 drivers/media/radio/si470x/radio-si470x-common.c          |    6 ++--
 drivers/media/radio/wl128x/fmdrv_rx.c                     |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c                   |    4 ++-
 include/linux/videodev2.h                                 |   22 ++++++++++++--
 sound/i2c/other/tea575x-tuner.c                           |    4 ++-
 13 files changed, 200 insertions(+), 44 deletions(-)
