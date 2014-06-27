Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2477 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaF0HlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 03:41:00 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id s5R7es0I036180
	for <linux-media@vger.kernel.org>; Fri, 27 Jun 2014 09:40:58 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.83.144] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id B98A22A1FCD
	for <linux-media@vger.kernel.org>; Fri, 27 Jun 2014 09:40:46 +0200 (CEST)
Message-ID: <53AD2003.7020503@xs4all.nl>
Date: Fri, 27 Jun 2014 09:40:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] Add support for compound controls, use in solo/go7007
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the pull request for the compound control patch series. The only
change made since the REVIEWv4 series (1) is that the v4l2_query_ext_ctrl
reserved[] field has been increased from 16 to 32 elements based on feedback
from Sakari.

Note that I did not go for variable number of dimensions for multi-dimensional
arrays. Instead I set the maximum at 8. Based on the feedback Sakari (2) gave
me and my own feelings on this topic I did not want to replace the
dims[V4L2_CTRL_MAX_DIMS] array with a dims pointer. If changing to a u32 *dims
is the only way to get this in, then I will do so but I am not ready to give
up on this. We're dealing with video hardware, not with 11-dimensional string
theory and introducing a pointer makes both kernel and (more importantly)
userspace unnecessarily complex.

I have added support for getting/setting multidimensional arrays to
v4l2-ctl here:

http://git.linuxtv.org/cgit.cgi/hverkuil/v4l-utils.git/log/?h=compound

I've also tested this with the solo and go7007 driver.

Regards,

	Hans

(1) https://www.mail-archive.com/linux-media@vger.kernel.org/msg75929.html
(2) http://www.spinics.net/lists/linux-media/msg77233.html

The following changes since commit b5b620584b9c4644b85e932895a742e0c192d66c:

   [media] technisat-sub2: Fix stream curruption on high bitrate (2014-06-26 09:20:18 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git propapi-part4

for you to fetch changes up to 1ac3c9ba06f6c08ced9ef18520b05fea1deb1253:

   go7007: add motion detection support. (2014-06-27 09:22:47 +0200)

----------------------------------------------------------------
Hans Verkuil (34):
       v4l2-ctrls: increase internal min/max/step/def to 64 bit
       v4l2-ctrls: use pr_info/cont instead of printk.
       videodev2.h: add initial support for compound controls.
       videodev2.h: add struct v4l2_query_ext_ctrl and VIDIOC_QUERY_EXT_CTRL.
       v4l2-ctrls: add support for compound types.
       v4l2: integrate support for VIDIOC_QUERY_EXT_CTRL.
       v4l2-ctrls: create type_ops.
       v4l2-ctrls: rewrite copy routines to operate on union v4l2_ctrl_ptr.
       v4l2-ctrls: compare values only once.
       v4l2-ctrls: use ptrs for all but the s32 type.
       v4l2-ctrls: prepare for array support
       v4l2-ctrls: prepare for array support.
       v4l2-ctrls: type_ops can handle array elements.
       v4l2-ctrls: add array support.
       v4l2-ctrls: return elem_size instead of strlen
       v4l2-ctrl: fix error return of copy_to/from_user.
       DocBook media: document VIDIOC_QUERY_EXT_CTRL.
       DocBook media: update VIDIOC_G/S/TRY_EXT_CTRLS.
       DocBook media: fix coding style in the control example code
       DocBook media: improve control section.
       DocBook media: update control section.
       v4l2-controls.txt: update to the new way of accessing controls.
       v4l2-ctrls/videodev2.h: add u8 and u16 types.
       DocBook media: document new u8 and u16 control types.
       v4l2-ctrls: fix comments
       v4l2-ctrls/v4l2-controls.h: add MD controls
       DocBook media: document new motion detection controls.
       v4l2: add a motion detection event.
       DocBook: document new v4l motion detection event.
       solo6x10: implement the new motion detection controls.
       solo6x10: implement the motion detection event.
       solo6x10: fix 'dma from stack' warning.
       solo6x10: check dma_map_sg() return value
       go7007: add motion detection support.

  Documentation/DocBook/media/v4l/controls.xml               | 278 ++++++++++++++++------
  Documentation/DocBook/media/v4l/vidioc-dqevent.xml         |  44 ++++
  Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml     |  51 +++-
  Documentation/DocBook/media/v4l/vidioc-queryctrl.xml       | 232 ++++++++++++++++---
  Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml |   8 +
  Documentation/video4linux/v4l2-controls.txt                |  63 +++--
  drivers/media/i2c/mt9v032.c                                |   4 +-
  drivers/media/i2c/smiapp/smiapp-core.c                     |   8 +-
  drivers/media/pci/ivtv/ivtv-controls.c                     |   4 +-
  drivers/media/platform/vivi.c                              |   9 +-
  drivers/media/radio/si4713/si4713.c                        |   4 +-
  drivers/media/v4l2-core/v4l2-common.c                      |   6 +-
  drivers/media/v4l2-core/v4l2-ctrls.c                       | 847 ++++++++++++++++++++++++++++++++++++++++++++++---------------------
  drivers/media/v4l2-core/v4l2-dev.c                         |   2 +
  drivers/media/v4l2-core/v4l2-ioctl.c                       |  33 +++
  drivers/media/v4l2-core/v4l2-subdev.c                      |   3 +
  drivers/staging/media/go7007/go7007-driver.c               | 127 +++++++---
  drivers/staging/media/go7007/go7007-fw.c                   |  28 ++-
  drivers/staging/media/go7007/go7007-priv.h                 |  16 ++
  drivers/staging/media/go7007/go7007-v4l2.c                 | 317 +++++++++++++++++--------
  drivers/staging/media/go7007/go7007.h                      |  40 ----
  drivers/staging/media/go7007/saa7134-go7007.c              |   1 -
  drivers/staging/media/msi3101/msi001.c                     |   2 +-
  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c           |   4 +-
  drivers/staging/media/solo6x10/solo6x10-disp.c             |  14 +-
  drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c         | 183 ++++++++-------
  drivers/staging/media/solo6x10/solo6x10.h                  |  26 +--
  include/media/v4l2-ctrls.h                                 | 123 +++++++---
  include/media/v4l2-ioctl.h                                 |   2 +
  include/uapi/linux/v4l2-controls.h                         |  17 ++
  include/uapi/linux/videodev2.h                             |  51 +++-
  31 files changed, 1804 insertions(+), 743 deletions(-)
  delete mode 100644 drivers/staging/media/go7007/go7007.h
