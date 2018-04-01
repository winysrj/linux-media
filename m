Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:40321 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752366AbeDAA7a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 31 Mar 2018 20:59:30 -0400
Received: by mail-pl0-f65.google.com with SMTP id x4-v6so2125576pln.7
        for <linux-media@vger.kernel.org>; Sat, 31 Mar 2018 17:59:30 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH v6 0/2] media: video-i2c: add video-i2c driver support
Date: Sat, 31 Mar 2018 17:59:24 -0700
Message-Id: <20180401005926.18203-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for video-i2c polling driver

Changes from v1:
* Switch to SPDX tags versus GPLv2 license text
* Remove unneeded zeroing of data structures
* Add video_i2c_try_fmt_vid_cap call in video_i2c_s_fmt_vid_cap function

Changes from v2:
* Add missing linux/kthread.h include that broke x86_64 build

Changes from v3:
* Add devicetree binding documents
* snprintf check added
* switched to per chip support based on devicetree or i2c client id
* add VB2_DMABUF to io_modes
* added entry to MAINTAINERS file switched to per chip support based on devicetree or i2c client id

Changes from v4:
* convert pointer from of_device_get_match_data() to long instead of int to avoid compiler warning

Changes from v5:
* fix various issues with v4l2-compliance tool run

Matt Ranostay (2):
  media: dt-bindings: Add bindings for panasonic,amg88xx
  media: video-i2c: add video-i2c driver

 .../bindings/media/i2c/panasonic,amg88xx.txt       |  19 +
 MAINTAINERS                                        |   6 +
 drivers/media/i2c/Kconfig                          |   9 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/video-i2c.c                      | 562 +++++++++++++++++++++
 5 files changed, 597 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt
 create mode 100644 drivers/media/i2c/video-i2c.c

-- 
2.14.1
