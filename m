Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46791 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbeKANQv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 09:16:51 -0400
Received: by mail-pl1-f193.google.com with SMTP id c13-v6so442723plz.13
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 21:15:38 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH 0/2] media: video-i2c: add Melexis MLX90640 thermal camera support
Date: Wed, 31 Oct 2018 21:15:32 -0700
Message-Id: <20181101041534.5913-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add initial support for Melexis line of thermal cameras. This is the first part of
processing pipeline in which the real processing is done in userspace using the
V4L2 camera data.

Dependency patchset series: https://patchwork.kernel.org/cover/10650541/

Matt Ranostay (2):
  media: video-i2c: check if chip struct has set_power function
  media: video-i2c: add Melexis MLX90640 thermal camera support

 drivers/media/i2c/Kconfig     |   1 +
 drivers/media/i2c/video-i2c.c | 131 ++++++++++++++++++++++++++++++++--
 2 files changed, 126 insertions(+), 6 deletions(-)

-- 
2.17.1
