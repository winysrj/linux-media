Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:51370 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWWWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:22:12 -0500
Received: by mail-ea0-f173.google.com with SMTP id i1so3306923eaa.32
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 14:22:11 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com
Subject: [PATCH RFC v3 0/6] OV9650/52 sensor driver and some v4l2 core additions
Date: Wed, 23 Jan 2013 23:21:55 +0100
Message-Id: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an update of my previous [1] patch series adding subdev driver
for OV9650/52 image sensors. Changes in this version are:
 - addition of patches introducing v4l2 core helper functions:
   v4l2_ctrl_subdev_log_status(), v4l2_ctrl_subdev_subscribe_event(),
   v4l2_event_subdev_unsubscribe(),
 - file image-sizes.h renamed to v4l2-image-sizes.h,
 - a small documentation improvement a bug fix in patch 2/6.

[1] http://www.spinics.net/lists/linux-media/msg58893.html

Thank you for all reviews!


Regards,
Sylwester


Sylwester Nawrocki (6):
  [media] Add header file defining standard image sizes
  v4l2-ctrl: Add helper function for control range update
  V4L: Add v4l2_event_subdev_unsubscribe() helper function
  V4L: Add v4l2_ctrl_subdev_subscribe_event() helper function
  V4L: Add v4l2_ctrl_subdev_log_status() helper function
  V4L: Add driver for OV9650/52 image sensors

 Documentation/DocBook/media/v4l/compat.xml         |    4 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    4 +-
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |    6 +
 drivers/media/i2c/Kconfig                          |    7 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov9650.c                         | 1562 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |  159 ++-
 drivers/media/v4l2-core/v4l2-event.c               |    7 +
 include/media/ov9650.h                             |   27 +
 include/media/v4l2-ctrls.h                         |   28 +
 include/media/v4l2-event.h                         |    4 +-
 include/media/v4l2-image-sizes.h                   |   34 +
 include/uapi/linux/videodev2.h                     |    1 +
 13 files changed, 1803 insertions(+), 41 deletions(-)
 create mode 100644 drivers/media/i2c/ov9650.c
 create mode 100644 include/media/ov9650.h
 create mode 100644 include/media/v4l2-image-sizes.h

--
1.7.4.1

