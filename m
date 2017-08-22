Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:32771 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932729AbdHVM46 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:56:58 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hverkuil@xs4all.nl, mchehab@kernel.org, awalls@md.metrocast.net,
        prabhakar.csengg@gmail.com, royale@zerezo.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 0/4] constify videobuf_queue_ops structures
Date: Tue, 22 Aug 2017 18:26:32 +0530
Message-Id: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_queue_ops are not supposed to change at runtime. All functions
working with videobuf_queue_ops provided by <media/videobuf-core.h> work
with const videobuf_queue_ops. So mark the non-const structs as const.

Arvind Yadav (4):
  [PATCH 1/4] [media] saa7146: constify videobuf_queue_ops structures
  [PATCH 2/4] [media] pci: constify videobuf_queue_ops structures
  [PATCH 3/4] [media] platform: constify videobuf_queue_ops structures
  [PATCH 4/4] [media] usb: constify videobuf_queue_ops structures

 drivers/media/common/saa7146/saa7146_vbi.c    | 2 +-
 drivers/media/common/saa7146/saa7146_video.c  | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c         | 2 +-
 drivers/media/pci/cx18/cx18-streams.c         | 2 +-
 drivers/media/platform/davinci/vpfe_capture.c | 2 +-
 drivers/media/platform/fsl-viu.c              | 2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c       | 2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     | 2 +-
 drivers/media/usb/tm6000/tm6000-video.c       | 2 +-
 drivers/media/usb/zr364xx/zr364xx.c           | 2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

-- 
1.9.1
