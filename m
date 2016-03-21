Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39108 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755072AbcCUMsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 08:48:07 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 06293180B83
	for <linux-media@vger.kernel.org>; Mon, 21 Mar 2016 13:48:02 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Various fixes, small device_caps enhancement
Message-ID: <56EFED81.7040000@xs4all.nl>
Date: Mon, 21 Mar 2016 13:48:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes.

Note the small enhancement where the device_caps field is added to struct video_device.

This means that the core now knows the caps of the device. This will be useful
going forward.

My five patches were originally part of a pull request for 4.6 that never made it in
for some reason. Trying again :-)

Regards,

	Hans

The following changes since commit b39950960d2b890c21465c69c7c0e4ff6253c6b5:

  [media] media: au0828 fix to clear enable/disable/change source handlers (2016-03-18 07:37:22 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.7a

for you to fetch changes up to ff0fbc445cab75cba0399d7d553657b2a5a6d4e1:

  m5mols: potential uninitialized variable (2016-03-21 13:34:31 +0100)

----------------------------------------------------------------
Arnd Bergmann (2):
      cobalt: add MTD dependency
      am437x-vfpe: fix typo in vpfe_get_app_input_index

Dan Carpenter (3):
      am437x-vpfe: fix an uninitialized variable bug
      cx23885: uninitialized variable in cx23885_av_work_handler()
      m5mols: potential uninitialized variable

Hans Verkuil (5):
      v4l2: add device_caps to struct video_device
      v4l2-pci-skeleton.c: fill in device_caps in video_device
      vivid: set device_caps in video_device.
      v4l2-ioctl: simplify code
      v4l2-ioctl: improve cropcap handling

Sudip Mukherjee (2):
      cx231xx: fix memory leak
      dw2102: fix unreleased firmware

Tiffany Lin (1):
      media: v4l2-compat-ioctl32: fix missing reserved field copy in put_v4l2_create32

 Documentation/video4linux/v4l2-pci-skeleton.c |  5 ++---
 drivers/media/i2c/m5mols/m5mols_controls.c    |  2 +-
 drivers/media/pci/cobalt/Kconfig              |  1 +
 drivers/media/pci/cx23885/cx23885-av.c        |  2 +-
 drivers/media/platform/am437x/am437x-vpfe.c   |  4 ++--
 drivers/media/platform/vivid/vivid-core.c     | 22 ++++++------------
 drivers/media/usb/cx231xx/cx231xx-417.c       |  9 ++++++++
 drivers/media/usb/dvb-usb/dw2102.c            |  3 +++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  3 ++-
 drivers/media/v4l2-core/v4l2-ioctl.c          | 81 +++++++++++++++++++++++++++++++++++++++++++++----------------------
 include/media/v4l2-dev.h                      |  3 +++
 11 files changed, 86 insertions(+), 49 deletions(-)
