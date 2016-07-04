Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:46564 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844AbcGDLx4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 07:53:56 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Various v4l2/gspca/pwc fixes/improvements
Message-ID: <86de261b-ac90-1216-b8f6-226e0fcd2b1b@xs4all.nl>
Date: Mon, 4 Jul 2016 13:53:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ab46f6d24bf57ddac0f5abe2f546a78af57b476c:

  [media] videodev2.h: Fix V4L2_PIX_FMT_YUV411P description (2016-06-28 11:54:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8e

for you to fetch changes up to ed537d47e271ddefd1a5192d18bb293a4ce36f44:

  hdpvr: Remove deprecated create_singlethread_workqueue (2016-07-04 10:44:32 +0200)

----------------------------------------------------------------
Antonio Ospite (5):
      gspca: ov534/topro: use a define for the default framerate
      gspca: fix setting frame interval type in vidioc_enum_frameintervals()
      gspca: rename wxh_to_mode() to wxh_to_nearest_mode()
      gspca: fix a v4l2-compliance failure about VIDIOC_ENUM_FRAMEINTERVALS
      gspca: fix a v4l2-compliance failure about buffer timestamp

Arnd Bergmann (1):
      pwc: hide unused label

Bhaktipriya Shridhar (5):
      sn9c20x: Remove deprecated create_singlethread_workqueue
      adv7842: Remove deprecated create_singlethread_workqueue
      tc358743: Remove deprecated create_singlethread_workqueue
      adv7604: Remove deprecated create_singlethread_workqueue
      hdpvr: Remove deprecated create_singlethread_workqueue

 drivers/media/i2c/adv7604.c           | 14 +-------------
 drivers/media/i2c/adv7842.c           | 16 ++--------------
 drivers/media/i2c/tc358743.c          | 15 +--------------
 drivers/media/usb/gspca/gspca.c       | 27 ++++++++++++++++++++++-----
 drivers/media/usb/gspca/ov534.c       |  7 +++----
 drivers/media/usb/gspca/sn9c20x.c     | 14 ++++----------
 drivers/media/usb/gspca/topro.c       |  6 ++++--
 drivers/media/usb/hdpvr/hdpvr-core.c  | 10 ++--------
 drivers/media/usb/hdpvr/hdpvr-video.c |  6 +++---
 drivers/media/usb/hdpvr/hdpvr.h       |  2 --
 drivers/media/usb/pwc/pwc-if.c        |  2 ++
 11 files changed, 44 insertions(+), 75 deletions(-)
