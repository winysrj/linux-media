Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:43418 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753665AbbBTJ7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 04:59:43 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CF75F2A009F
	for <linux-media@vger.kernel.org>; Fri, 20 Feb 2015 10:59:18 +0100 (CET)
Message-ID: <54E70576.50306@xs4all.nl>
Date: Fri, 20 Feb 2015 10:59:18 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.21] Core cleanups and a docbook fix
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A bunch of nice core cleanups:

The first 6 patches replace the last few .ioctl ops by .unlocked_ioctl,
finally allowing the old .ioctl op to die.

The next two patches do the same for the g/s_priority ioctl ops: this is
now fully handled by the V4L2 core.

The next cleanup I should look into is to have all drivers use v4l2_fh and
make that a requirement. That will allow for some more simplifications.

The last patch fixes a colorspace documentation mistake.

Regards,

	Hans

The following changes since commit 135f9be9194cf7778eb73594aa55791b229cf27c:

  [media] dvb_frontend: start media pipeline while thread is running (2015-02-13 21:10:17 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.21b

for you to fetch changes up to db391cb7e2aba33042c534e42b64f6f52d5fbc21:

  DocBook media: fix xvYCC601 documentation (2015-02-20 10:42:58 +0100)

----------------------------------------------------------------
Hans Verkuil (9):
      pvrusb2: replace .ioctl by .unlocked_ioctl.
      radio-bcm2048: use unlocked_ioctl instead of ioctl
      uvc gadget: switch to v4l2 core locking
      uvc gadget: switch to unlocked_ioctl.
      uvc gadget: set device_caps in querycap.
      v4l2-core: remove the old .ioctl BKL replacement
      pvrusb2: use struct v4l2_fh
      v4l2-core: drop g/s_priority ops
      DocBook media: fix xvYCC601 documentation

 Documentation/DocBook/media/v4l/pixfmt.xml    | 41 ++++++++++++++++-----------------------
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c      | 83 ++++++++++++++-----------------------------------------------------------------
 drivers/media/v4l2-core/v4l2-dev.c            | 35 +++------------------------------
 drivers/media/v4l2-core/v4l2-device.c         |  1 -
 drivers/media/v4l2-core/v4l2-ioctl.c          |  6 ++----
 drivers/staging/media/bcm2048/radio-bcm2048.c |  2 +-
 drivers/usb/gadget/function/f_uvc.c           |  2 ++
 drivers/usb/gadget/function/uvc.h             |  1 +
 drivers/usb/gadget/function/uvc_queue.c       | 79 +++++++++++++--------------------------------------------------------------
 drivers/usb/gadget/function/uvc_queue.h       |  4 ++--
 drivers/usb/gadget/function/uvc_v4l2.c        |  8 +++++---
 drivers/usb/gadget/function/uvc_video.c       |  3 ++-
 include/media/v4l2-dev.h                      |  1 -
 include/media/v4l2-device.h                   |  2 --
 include/media/v4l2-ioctl.h                    |  6 ------
 15 files changed, 62 insertions(+), 212 deletions(-)
