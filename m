Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:46617 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbeDFFPH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 01:15:07 -0400
Received: by mail-pf0-f193.google.com with SMTP id h69so10135290pfe.13
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 22:15:07 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH v7 0/2] media: video-i2c: add video-i2c driver support
Date: Thu,  5 Apr 2018 22:14:47 -0700
Message-Id: <20180406051449.32157-1-matt.ranostay@konsulko.com>
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

Changes from v6:
* fixed minor coding issues on spacing
* changed device tree table pointers to chip struct data
* add more verbose Kconfig documentation
* destroy mutexes on error path and module removal
* fixed MODULE_LICENSE from GPL to GPLv2
* changes some calls to list_last_entry() to avoid touching next pointer
* moved common code to a function from start/stop_streaming()

Matt Ranostay (2):
  media: dt-bindings: Add bindings for panasonic,amg88xx
  media: video-i2c: add video-i2c driver

 .../bindings/media/i2c/panasonic,amg88xx.txt       |  19 +
 MAINTAINERS                                        |   6 +
 drivers/media/i2c/Kconfig                          |  13 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/video-i2c.c                      | 560 +++++++++++++++++++++
 5 files changed, 599 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt
 create mode 100644 drivers/media/i2c/video-i2c.c

-- 
2.14.1
