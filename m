Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37474 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752663AbeDFWwy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 18:52:54 -0400
Received: by mail-pf0-f193.google.com with SMTP id x16so1755747pfm.4
        for <linux-media@vger.kernel.org>; Fri, 06 Apr 2018 15:52:53 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH v8 0/2] media: video-i2c: add video-i2c driver support
Date: Fri,  6 Apr 2018 15:52:29 -0700
Message-Id: <20180406225231.13831-1-matt.ranostay@konsulko.com>
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

Changes from v7:
* add const to several structs
* corrected a few over 80 column lines 
* change DT check to generic dev_fwnode() call

Matt Ranostay (2):
  media: dt-bindings: Add bindings for panasonic,amg88xx
  media: video-i2c: add video-i2c driver

 .../bindings/media/i2c/panasonic,amg88xx.txt       |  19 +
 MAINTAINERS                                        |   6 +
 drivers/media/i2c/Kconfig                          |  13 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/video-i2c.c                      | 563 +++++++++++++++++++++
 5 files changed, 602 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt
 create mode 100644 drivers/media/i2c/video-i2c.c

-- 
2.14.1
