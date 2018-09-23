Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37000 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbeIWWdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Sep 2018 18:33:12 -0400
Received: by mail-pl1-f196.google.com with SMTP id q1-v6so2581700plr.4
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2018 09:35:10 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 0/6] media: video-i2c: support changing frame interval and runtime PM
Date: Mon, 24 Sep 2018 01:34:46 +0900
Message-Id: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds support for changing frame interval and runtime PM for
video-i2c driver.  This also adds an helper macro to v4l2 common
internal API that is used to to find a suitable frame interval.

There are a couple of unrelated changes that are included for simplifying
driver initialization code and register accesses.

* v2
- Add Acked-by and Reviewed-by tags
- Update commit log to clarify the use after free
- Add thermistor and termperature register address definisions
- Stop adding v4l2_find_closest_fract() in v4l2 common internal API
- Add V4L2_FRACT_COMPARE() macro in v4l2 common internal API
- Use V4L2_FRACT_COMPARE() to find suitable frame interval instead of
  v4l2_find_closest_fract()
- Add comment for register address definisions

Akinobu Mita (6):
  media: video-i2c: avoid accessing released memory area when removing
    driver
  media: video-i2c: use i2c regmap
  media: v4l2-common: add V4L2_FRACT_COMPARE
  media: vivid: use V4L2_FRACT_COMPARE
  media: video-i2c: support changing frame interval
  media: video-i2c: support runtime PM

 drivers/media/i2c/video-i2c.c                | 286 ++++++++++++++++++++++-----
 drivers/media/platform/vivid/vivid-vid-cap.c |   9 +-
 include/media/v4l2-common.h                  |   5 +
 3 files changed, 247 insertions(+), 53 deletions(-)

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4
