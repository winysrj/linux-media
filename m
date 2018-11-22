Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35941 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730904AbeKVOaC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 09:30:02 -0500
Received: by mail-pl1-f195.google.com with SMTP id y6-v6so8425733plt.3
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 19:52:35 -0800 (PST)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH v2 0/2] media: video-i2c: add Melexis MLX90640 thermal camera support
Date: Wed, 21 Nov 2018 19:52:27 -0800
Message-Id: <20181122035229.3630-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add initial support for Melexis line of thermal cameras. This is the first part of
processing pipeline in which the real processing is done in userspace using the
V4L2 camera data.

Dependency patchset series: https://patchwork.kernel.org/cover/10650541/

Changes from v1:

* add melexis,mlx90640.txt documentation

Matt Ranostay (2):
  media: video-i2c: check if chip struct has set_power function
  media: video-i2c: add Melexis MLX90640 thermal camera support

 .../bindings/media/i2c/melexis,mlx90640.txt   |  20 +++
 drivers/media/i2c/Kconfig                     |   1 +
 drivers/media/i2c/video-i2c.c                 | 131 +++++++++++++++++-
 3 files changed, 146 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt

-- 
2.17.1
