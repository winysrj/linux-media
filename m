Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:43310 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbeB0GLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 01:11:42 -0500
Received: by mail-pg0-f66.google.com with SMTP id e9so2833063pgs.10
        for <linux-media@vger.kernel.org>; Mon, 26 Feb 2018 22:11:41 -0800 (PST)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH v4 0/2] media: video-i2c: add video-i2c driver support
Date: Mon, 26 Feb 2018 22:11:34 -0800
Message-Id: <20180227061136.5532-1-matt.ranostay@konsulko.com>
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

Matt Ranostay (2):
  media: dt-bindings: Add bindings for panasonic,amg88xx
  media: video-i2c: add video-i2c driver

 .../bindings/media/i2c/panasonic,amg88xx.txt       |  19 +
 MAINTAINERS                                        |   6 +
 drivers/media/i2c/Kconfig                          |   9 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/video-i2c.c                      | 558 +++++++++++++++++++++
 5 files changed, 593 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,amg88xx.txt
 create mode 100644 drivers/media/i2c/video-i2c.c

-- 
2.14.1
