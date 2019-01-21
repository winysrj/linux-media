Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D99C2F3A6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 299252085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbfAUNcf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:35 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55916 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728570AbfAUNcf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:35 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgngPCJV; Mon, 21 Jan 2019 14:32:33 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Subject: [PATCH 0/8] Preparing for Y2038 support
Date:   Mon, 21 Jan 2019 14:32:21 +0100
Message-Id: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfM0QK8gYafaF5b9P2oUlVqe7L2gMxiwSFDhXm9+vhpenhzggc7JtWtqYYGCj/cRy01IMSfGRO/Tfa7qDlNtpGu5j69/sCR8lb4RpeORFp4JKFkkiYS0m
 rgmjYCL9Xc/be0zfAF9P6ENjJ5yYmxNBes9K5awmKeu4XqHmt+Zh5Df/2qg1wg7mP+Ts9LMBXUDd4A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

This patch series modifies v4l2-event, videobuf and various
drivers that do not use vb2 or videobuf at all to store the
event and buffer timestamps internally as a u64 (ktime_get_ns()).

Only when interfacing with the userspace API are these timestamps
converted to a timespec or timeval.

The final patch drops the now unused v4l2_get_timestamp().

This simplifies the work needed to support Y2038-compatible
timeval/timespec structures. It also ensures consistent
behavior for all media drivers.

Regards,

	Hans

Hans Verkuil (8):
  v4l2-event: keep track of the timestamp in ns
  videobuf: use u64 for the timestamp internally
  meye: use u64 for the timestamp internally
  cpia2: use u64 for the timestamp internally
  stkwebcam: use u64 for the timestamp internally
  usbvision: use u64 for the timestamp internally
  zoran: use u64 for the timestamp internally
  v4l2-common: drop v4l2_get_timestamp

 drivers/media/common/saa7146/saa7146_fops.c   |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c         |  8 +++-----
 drivers/media/pci/cx18/cx18-mailbox.c         |  2 +-
 drivers/media/pci/meye/meye.c                 |  8 ++++----
 drivers/media/pci/meye/meye.h                 |  2 +-
 drivers/media/platform/davinci/vpfe_capture.c |  2 +-
 drivers/media/platform/fsl-viu.c              |  2 +-
 drivers/media/platform/omap/omap_vout.c       | 12 ++++++------
 drivers/media/usb/cpia2/cpia2.h               |  2 +-
 drivers/media/usb/cpia2/cpia2_usb.c           |  2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c           | 11 +++--------
 drivers/media/usb/cx231xx/cx231xx-417.c       |  4 ++--
 drivers/media/usb/cx231xx/cx231xx-vbi.c       |  2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |  2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c      |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |  2 +-
 drivers/media/usb/usbvision/usbvision-core.c  |  2 +-
 drivers/media/usb/usbvision/usbvision-video.c |  4 ++--
 drivers/media/usb/usbvision/usbvision.h       |  2 +-
 drivers/media/usb/zr364xx/zr364xx.c           |  4 ++--
 drivers/media/v4l2-core/v4l2-common.c         | 10 ----------
 drivers/media/v4l2-core/v4l2-event.c          | 19 +++++++++----------
 drivers/media/v4l2-core/videobuf-core.c       |  4 ++--
 drivers/staging/media/zoran/zoran.h           |  2 +-
 drivers/staging/media/zoran/zoran_device.c    |  4 ++--
 drivers/staging/media/zoran/zoran_driver.c    |  4 ++--
 include/media/v4l2-common.h                   |  9 ---------
 include/media/v4l2-event.h                    |  2 ++
 include/media/videobuf-core.h                 |  2 +-
 29 files changed, 54 insertions(+), 79 deletions(-)

-- 
2.20.1

