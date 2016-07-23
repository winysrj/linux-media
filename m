Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36255 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbcGWRA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2016 13:00:58 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 0/9] adv7180 subdev fixes, v3
Date: Sat, 23 Jul 2016 10:00:40 -0700
Message-Id: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam (9):
  media: adv7180: Fix broken interrupt register access
  media: adv7180: define more registers
  media: adv7180: add support for NEWAVMODE
  media: adv7180: add power pin control
  media: adv7180: implement g_parm
  media: adv7180: change mbus format to UYVY
  v4l: Add signal lock status to source change events
  media: adv7180: enable lock/unlock interrupts
  media: adv7180: fix field type

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  12 +-
 .../devicetree/bindings/media/i2c/adv7180.txt      |   8 +
 drivers/media/i2c/Kconfig                          |   2 +-
 drivers/media/i2c/adv7180.c                        | 232 ++++++++++++++++-----
 include/uapi/linux/videodev2.h                     |   1 +
 5 files changed, 205 insertions(+), 50 deletions(-)

-- 
1.9.1

