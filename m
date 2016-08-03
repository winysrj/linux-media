Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33943 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbcHCSD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 14:03:59 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v4 0/8] adv7180 subdev fixes, v4
Date: Wed,  3 Aug 2016 11:03:42 -0700
Message-Id: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Longerbeam (8):
  media: adv7180: fix field type
  media: adv7180: define more registers
  media: adv7180: add support for NEWAVMODE
  media: adv7180: add power pin control
  media: adv7180: implement g_parm
  media: adv7180: change mbus format to UYVY
  v4l: Add signal lock status to source change events
  media: adv7180: enable lock/unlock interrupts

 .../devicetree/bindings/media/i2c/adv7180.txt      |   8 +
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   9 +
 Documentation/media/videodev2.h.rst.exceptions     |   1 +
 drivers/media/i2c/Kconfig                          |   2 +-
 drivers/media/i2c/adv7180.c                        | 200 +++++++++++++++++----
 include/uapi/linux/videodev2.h                     |   1 +
 6 files changed, 183 insertions(+), 38 deletions(-)

-- 
1.9.1

