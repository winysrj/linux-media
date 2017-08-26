Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38172 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbdHZIf1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:35:27 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, crope@iki.fi, mchehab@kernel.org,
        hans.verkuil@cisco.com, isely@pobox.com,
        ezequiel@vanguardiasur.com.ar, royale@zerezo.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 00/11] [media]: make video_device const
Date: Sat, 26 Aug 2017 14:05:04 +0530
Message-Id: <1503736515-15366-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make video_device const.

Bhumika Goyal (11):
  [media] zr364xx: make video_device const
  [media] stkwebcam:  make video_device const
  [media] stk1160: make video_device const
  [media] s2255drv:  make video_device const
  [media] pwc: make video_device const
  [media] pvrusb2: make video_device const
  [media] msi2500: make video_device const
  [media] hackrf:  make video_device const
  [media] go7007: make video_device const
  [media] cpia2: make video_device const
  [media] airspy: make video_device const

 drivers/media/usb/airspy/airspy.c        | 2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c      | 2 +-
 drivers/media/usb/go7007/go7007-v4l2.c   | 2 +-
 drivers/media/usb/hackrf/hackrf.c        | 2 +-
 drivers/media/usb/msi2500/msi2500.c      | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 2 +-
 drivers/media/usb/pwc/pwc-if.c           | 2 +-
 drivers/media/usb/s2255/s2255drv.c       | 2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c  | 2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c | 2 +-
 drivers/media/usb/zr364xx/zr364xx.c      | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

-- 
1.9.1
