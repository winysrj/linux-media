Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:38727 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3ASV1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 16:27:37 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so1325469eaa.2
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2013 13:27:35 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com
Subject: [PATCH 0/3] OV9650/52 image sensor subdev driver
Date: Sat, 19 Jan 2013 22:27:19 +0100
Message-Id: <1358630842-12689-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds a v4l2 subdev driver for Omnivision OV9650/52
image sensors, a helper function at the v4l2 control framework
allowing to modify range of a control and a header file including
definitions of standard image resolutions.

I've tested the ctrl helper function with the OV9650 driver and
a modified v4l2-ctl.

Changes at the sensor driver since the first version include:
 - removed the exposure reference area and gain ceiling private
   controls and control auto cluster used for gain/auto_gain,
   auto/manual exposure controls;
 - v4l2_ctrl_handler_setup() used instead of a function setting
   initial control's values in H/W explicitly;
 - added event subscribe/unsubscribe ioctl handlers so v4l2 events
   are supported at the subdev node;
 - v4l2_ctrl_modify_range() function is now used to modify the
   exposure time control's range when output format/frame rate
   is modified, rather than updating the range manually in the
   driver, without any notification to user space;
 - added description of the platform data structure;
 - removed the contrast control stubs.

Sylwester Nawrocki (3):
  [media] Add header file defining standard image sizes
  v4l2-ctrl: Add helper function for control range update
  V4L: Add driver for OV9650/52 image sensors

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |    6 +
 drivers/media/i2c/Kconfig                          |    7 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov9650.c                         | 1582 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |  142 ++-
 include/media/image-sizes.h                        |   34 +
 include/media/ov9650.h                             |   27 +
 include/media/v4l2-ctrls.h                         |   20 +
 include/uapi/linux/videodev2.h                     |    1 +
 9 files changed, 1781 insertions(+), 39 deletions(-)
 create mode 100644 drivers/media/i2c/ov9650.c
 create mode 100644 include/media/image-sizes.h
 create mode 100644 include/media/ov9650.h

--
1.7.4.1

