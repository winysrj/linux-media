Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34850 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeIQVbY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 17:31:24 -0400
Received: by mail-pf1-f196.google.com with SMTP id p12-v6so7780031pfh.2
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 09:03:24 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 0/5] media: video-i2c: support changing frame interval and runtime PM
Date: Tue, 18 Sep 2018 01:03:06 +0900
Message-Id: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds support for changing frame interval and runtime PM for
video-i2c driver.  This also adds an helper function to v4l2 common
internal API that is used to to find a suitable frame interval.

There are a couple of unrelated changes that are included for simplifying
driver initialization code and register accesses.

Akinobu Mita (5):
  media: video-i2c: avoid accessing released memory area when removing
    driver
  media: video-i2c: use i2c regmap
  media: v4l2-common: add v4l2_find_closest_fract()
  media: video-i2c: support changing frame interval
  media: video-i2c: support runtime PM

 drivers/media/i2c/video-i2c.c         | 276 ++++++++++++++++++++++++++++------
 drivers/media/v4l2-core/v4l2-common.c |  26 ++++
 include/media/v4l2-common.h           |  12 ++
 3 files changed, 267 insertions(+), 47 deletions(-)

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4
