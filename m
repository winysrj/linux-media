Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f176.google.com ([209.85.210.176]:45199 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbeKMBzC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 20:55:02 -0500
Received: by mail-pf1-f176.google.com with SMTP id g62so1265815pfd.12
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 08:01:11 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 0/7] media: i2c: small enhancements for camera sensor drivers
Date: Tue, 13 Nov 2018 01:00:47 +0900
Message-Id: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset addds relatively small enhancements (log_status ioctl, event
interface, V4L2_CID_TEST_PATTERN control, and V4L2_CID_COLORFX control) for
mt9m111, ov2640, ov5640, ov7670, and ov772x drivers.  I have these devices
so these patches are tested with real devices.

Akinobu Mita (7):
  media: mt9m111: support log_status ioctl and event interface
  media: mt9m111: add V4L2_CID_COLORFX control
  media: ov2640: add V4L2_CID_TEST_PATTERN control
  media: ov2640: support log_status ioctl and event interface
  media: ov5640: support log_status ioctl and event interface
  media: ov7670: support log_status ioctl and event interface
  media: ov772x: support log_status ioctl and event interface

 drivers/media/i2c/mt9m111.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/media/i2c/ov2640.c  | 21 +++++++++++++++++++--
 drivers/media/i2c/ov5640.c  |  7 ++++++-
 drivers/media/i2c/ov7670.c  |  6 +++++-
 drivers/media/i2c/ov772x.c  |  7 ++++++-
 5 files changed, 78 insertions(+), 7 deletions(-)

Cc: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jacopo Mondi <jacopo@jmondi.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4
