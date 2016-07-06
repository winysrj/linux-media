Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33713 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbcGFXON (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:14:13 -0400
Received: by mail-pf0-f196.google.com with SMTP id c74so115385pfb.0
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:14:12 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 00/11] adv7180 subdev fixes
Date: Wed,  6 Jul 2016 15:59:53 -0700
Message-Id: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam (11):
  media: adv7180: Fix broken interrupt register access
  Revert "[media] adv7180: fix broken standards handling"
  media: adv7180: add power pin control
  media: adv7180: implement g_parm
  media: adv7180: init chip with AD recommended register settings
  media: adv7180: add bt.656-4 OF property
  media: adv7180: change mbus format to UYVY
  adv7180: send V4L2_EVENT_SOURCE_CHANGE on std change
  v4l: Add signal lock status to source change events
  media: adv7180: enable lock/unlock interrupts
  media: adv7180: fix field type

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  12 +-
 drivers/media/i2c/Kconfig                          |   2 +-
 drivers/media/i2c/adv7180.c                        | 409 +++++++++++++++------
 include/uapi/linux/videodev2.h                     |   1 +
 4 files changed, 308 insertions(+), 116 deletions(-)

-- 
1.9.1

