Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34468 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751973AbdHZKU2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:20:28 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, hverkuil@xs4all.nl,
        corbet@lwn.net, kyungmin.park@samsung.com, kamil@wypas.org,
        a.hajda@samsung.com, bparrot@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 00/10] [media] platform: make video_device const
Date: Sat, 26 Aug 2017 15:50:02 +0530
Message-Id: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make make video_device const.

Bhumika Goyal (10):
  [media] cx88: make video_device const
  [media] dt3155: make video_device const
  [media]: marvell-ccic: make video_device const
  [media] mx2-emmaprp: make video_device const
  [media]: s5p-g2d: make video_device const
  [media]: ti-vpe:  make video_device const
  [media] via-camera: make video_device const
  [media]: fsl-viu: make video_device const
  [media] m2m-deinterlace: make video_device const
  [media] vim2m: make video_device const

 drivers/media/pci/cx88/cx88-blackbird.c         | 2 +-
 drivers/media/pci/dt3155/dt3155.c               | 2 +-
 drivers/media/platform/fsl-viu.c                | 2 +-
 drivers/media/platform/m2m-deinterlace.c        | 2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c | 2 +-
 drivers/media/platform/mx2_emmaprp.c            | 2 +-
 drivers/media/platform/s5p-g2d/g2d.c            | 2 +-
 drivers/media/platform/ti-vpe/cal.c             | 2 +-
 drivers/media/platform/ti-vpe/vpe.c             | 2 +-
 drivers/media/platform/via-camera.c             | 2 +-
 drivers/media/platform/vim2m.c                  | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

-- 
1.9.1
