Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70D2C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 12:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCF3120821
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 12:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfBEMQR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 07:16:17 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:39380 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbfBEMQR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 07:16:17 -0500
Received: from [IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5] ([IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id qze9gPMrwNR5yqzeBgp0I4; Tue, 05 Feb 2019 13:16:15 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes/improvements
Message-ID: <7de35b38-381d-b258-9b63-67e53a57c48d@xs4all.nl>
Date:   Tue, 5 Feb 2019 13:16:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOcTHQjdfPmvdJgQ0MfEwQoC8rBJNasHujPekT/0pJLS9atzFTnOO9cva1Ji9Ekzo7oZGUNtxKgxy7rD5uxVT0/zpzPIPAv+n0vzKvGGbviHJ+NYd4yF
 UXzTGBqMppA0Io4FmuIDaS8SmdY31KcFStEsnHOdy5hNnlJeI4Ns9o0txgO7fnkUURgvIzn8aeaDdBc/ObXFK3dTa8V/DXugs8P2p8TZX32wHqVz9Zyz/q0G
 VLOWm0INTjUsF77tdXCrf686PrkPo/QiEM6zCRjIk9zDIuCEbia0aYL+R1Lneygk
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Besides vivid and vimc fixes the main change is to switch to using u64
for the timestamp everywhere.

Regards,

	Hans

The following changes since commit f0ef022c85a899bcc7a1b3a0955c78a3d7109106:

  media: vim2m: allow setting the default transaction time via parameter (2019-01-31 17:17:08 -0200)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1l

for you to fetch changes up to 008448a3d698195c4789b8b967a3e5332a0a2673:

  vivid: add vertical down sampling to imagesize calc (2019-02-05 12:00:48 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
André Almeida (1):
      vivid: add vertical down sampling to imagesize calc

Hans Verkuil (8):
      v4l2-event: keep track of the timestamp in ns
      videobuf: use u64 for the timestamp internally
      meye: use u64 for the timestamp internally
      cpia2: use u64 for the timestamp internally
      stkwebcam: use u64 for the timestamp internally
      usbvision: use u64 for the timestamp internally
      zoran: use u64 for the timestamp internally
      v4l2-common: drop v4l2_get_timestamp

Lucas A. M. Magalhães (1):
      media: vimc: Add vimc-streamer for stream control

 drivers/media/common/saa7146/saa7146_fops.c   |   2 +-
 drivers/media/pci/bt8xx/bttv-driver.c         |   8 +--
 drivers/media/pci/cx18/cx18-mailbox.c         |   2 +-
 drivers/media/pci/meye/meye.c                 |   8 +--
 drivers/media/pci/meye/meye.h                 |   2 +-
 drivers/media/platform/davinci/vpfe_capture.c |   2 +-
 drivers/media/platform/fsl-viu.c              |   2 +-
 drivers/media/platform/omap/omap_vout.c       |  12 ++--
 drivers/media/platform/vimc/Makefile          |   3 +-
 drivers/media/platform/vimc/vimc-capture.c    |  18 +++---
 drivers/media/platform/vimc/vimc-common.c     |  35 -----------
 drivers/media/platform/vimc/vimc-common.h     |  15 +----
 drivers/media/platform/vimc/vimc-debayer.c    |  26 ++------
 drivers/media/platform/vimc/vimc-scaler.c     |  28 ++-------
 drivers/media/platform/vimc/vimc-sensor.c     |  56 ++++-------------
 drivers/media/platform/vimc/vimc-streamer.c   | 188 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vimc/vimc-streamer.h   |  38 ++++++++++++
 drivers/media/platform/vivid/vivid-vid-cap.c  |  10 ++-
 drivers/media/usb/cpia2/cpia2.h               |   2 +-
 drivers/media/usb/cpia2/cpia2_usb.c           |   2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c           |  11 +---
 drivers/media/usb/cx231xx/cx231xx-417.c       |   4 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c       |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |   2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c      |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |   2 +-
 drivers/media/usb/usbvision/usbvision-core.c  |   2 +-
 drivers/media/usb/usbvision/usbvision-video.c |   4 +-
 drivers/media/usb/usbvision/usbvision.h       |   2 +-
 drivers/media/usb/zr364xx/zr364xx.c           |   4 +-
 drivers/media/v4l2-core/v4l2-common.c         |  10 ---
 drivers/media/v4l2-core/v4l2-event.c          |  19 +++---
 drivers/media/v4l2-core/videobuf-core.c       |   4 +-
 drivers/staging/media/zoran/zoran.h           |   2 +-
 drivers/staging/media/zoran/zoran_device.c    |   4 +-
 drivers/staging/media/zoran/zoran_driver.c    |   4 +-
 include/media/v4l2-common.h                   |   9 ---
 include/media/v4l2-event.h                    |   2 +
 include/media/videobuf-core.h                 |   2 +-
 39 files changed, 321 insertions(+), 229 deletions(-)
 create mode 100644 drivers/media/platform/vimc/vimc-streamer.c
 create mode 100644 drivers/media/platform/vimc/vimc-streamer.h
