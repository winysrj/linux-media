Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4474 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935370Ab3FTO0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 10:26:25 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5KEQEIv084897
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 16:26:16 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 6579C35E00D8
	for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 16:26:13 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Use v4l2_dev instead of the deprecated parent field
Date: Thu, 20 Jun 2013 16:26:13 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201626.13583.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request makes sure all drivers set v4l2_dev, which is needed for
correct behavior of the debug ioctls if sub-devices are present.

It also fixes a bug in cx88 where the wrong parent was used, causing an
incorrect sysfs hierarchy.

This pull request is identical to the earlier posted series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg63227.html

except for correcting a typo in a commit and in v4l2-framework.txt.

Regards,

	Hans

The following changes since commit 37c1d2e4098e48d9107858246027510efcfd7774:

  Merge branch 'linus' into patchwork (2013-06-20 05:19:09 -0300)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git parent

for you to fetch changes up to 655772893f595334b0d20a44c3d973aa7577436e:

  v4l2-framework: update documentation (2013-06-20 15:58:07 +0200)

----------------------------------------------------------------
Hans Verkuil (13):
      v4l2-device: check if already unregistered.
      soc_camera: replace vdev->parent by vdev->v4l2_dev.
      cx23885-417: use v4l2_dev instead of the deprecated parent field.
      zoran: use v4l2_dev instead of the deprecated parent field.
      sn9c102_core: add v4l2_device and replace parent with v4l2_dev
      saa7164: add v4l2_device and replace parent with v4l2_dev
      pvrusb2: use v4l2_dev instead of the deprecated parent field.
      f_uvc: add v4l2_device and replace parent with v4l2_dev
      omap24xxcam: add v4l2_device and replace parent with v4l2_dev
      saa7134: use v4l2_dev instead of the deprecated parent field
      v4l2: always require v4l2_dev, rename parent to dev_parent
      cx88: set dev_parent to the correct parent PCI bus.
      v4l2-framework: update documentation

 Documentation/video4linux/v4l2-framework.txt   | 17 +++++++++++------
 drivers/media/pci/cx23885/cx23885-417.c        |  2 +-
 drivers/media/pci/cx88/cx88-core.c             |  7 +++++++
 drivers/media/pci/saa7134/saa7134-empress.c    |  2 +-
 drivers/media/pci/saa7164/saa7164-core.c       |  7 +++++++
 drivers/media/pci/saa7164/saa7164-encoder.c    |  2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c        |  2 +-
 drivers/media/pci/saa7164/saa7164.h            |  3 +++
 drivers/media/pci/zoran/zoran_card.c           |  2 +-
 drivers/media/platform/omap24xxcam.c           |  9 ++++++++-
 drivers/media/platform/omap24xxcam.h           |  3 +++
 drivers/media/platform/soc_camera/soc_camera.c |  5 +++--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c        |  4 ++++
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h        |  4 ++++
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c       |  7 ++++---
 drivers/media/usb/sn9c102/sn9c102.h            |  3 +++
 drivers/media/usb/sn9c102/sn9c102_core.c       | 13 ++++++++++++-
 drivers/media/v4l2-core/v4l2-dev.c             | 34 +++++++++++++++-------------------
 drivers/media/v4l2-core/v4l2-device.c          |  9 +++++++--
 drivers/media/v4l2-core/v4l2-ioctl.c           |  7 +------
 drivers/usb/gadget/f_uvc.c                     |  9 ++++++++-
 drivers/usb/gadget/uvc.h                       |  2 ++
 include/media/soc_camera.h                     |  4 ++--
 include/media/v4l2-dev.h                       |  4 ++--
 24 files changed, 111 insertions(+), 50 deletions(-)
