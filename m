Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47750 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752457AbdHNNwL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 09:52:11 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] More constify, uvc and some random patches
Message-ID: <d8c321ad-288a-04d2-d199-bab4da506401@xs4all.nl>
Date: Mon, 14 Aug 2017 15:52:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14h

for you to fetch changes up to 23d405327ef551c42cb21c73405710e01a19a9dd:

  v4l2-compat-ioctl32.c: add capabilities field to, v4l2_input32 (2017-08-14 15:39:33 +0200)

----------------------------------------------------------------
Guennadi Liakhovetski (2):
      uvcvideo: Fix .queue_setup() to check the number of planes
      uvcvideo: Convert from using an atomic variable to a reference count

Guenter Roeck (1):
      uvcvideo: Prevent heap overflow when accessing mapped controls

Hans Verkuil (1):
      v4l2-compat-ioctl32.c: add capabilities field to, v4l2_input32

Jim Lin (1):
      uvcvideo: Fix incorrect timeout for Get Request

Julia Lawall (5):
      cx18: constify videobuf_queue_ops structures
      cx231xx: constify videobuf_queue_ops structures
      tm6000: constify videobuf_queue_ops structures
      zr364xx: constify videobuf_queue_ops structures
      uvcvideo: Constify video_subdev structures

Mauro Carvalho Chehab (1):
      media: v4l2-ctrls.h: better document the arguments for v4l2_ctrl_fill

 drivers/media/pci/cx18/cx18-streams.c         |  2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c       |  2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |  2 +-
 drivers/media/usb/uvc/uvc_ctrl.c              |  7 +++++++
 drivers/media/usb/uvc/uvc_driver.c            | 25 +++++++++----------------
 drivers/media/usb/uvc/uvc_entity.c            |  2 +-
 drivers/media/usb/uvc/uvc_queue.c             |  9 +++++++--
 drivers/media/usb/uvc/uvcvideo.h              |  4 ++--
 drivers/media/usb/zr364xx/zr364xx.c           |  2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  3 ++-
 include/media/v4l2-ctrls.h                    | 16 ++++++++--------
 12 files changed, 41 insertions(+), 35 deletions(-)
