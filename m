Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33257 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbcGTAEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 20:04:11 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: lars@metafoo.de
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 00/10] adv7180 subdev fixes, v2
Date: Tue, 19 Jul 2016 17:03:27 -0700
Message-Id: <1468973017-17647-1-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This version adds a new v4l2 endpoint property and BT.656 bus flag
for the "NEWAVMODE" setting of Analog Devices decoders. The i.MX6
capture backend is not able to sync on the bt.656 stream from the
ADV7180 when the latter is in manual video standard setting mode,
unless NEWWAVMODE is used in conjunction. The backend needs to be
aware of NEWAVMODE so that it can make adjustments to the AV code
detection.

That's the biggest addition in this version, besides the requested
feedback changes from last version.


Steve Longerbeam (10):
  v4l: of: add "newavmode" property for Analog Devices codecs
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
 .../devicetree/bindings/media/i2c/adv7180.txt      |   5 +
 .../devicetree/bindings/media/video-interfaces.txt |   2 +
 drivers/media/i2c/Kconfig                          |   2 +-
 drivers/media/i2c/adv7180.c                        | 233 ++++++++++++++++-----
 drivers/media/v4l2-core/v4l2-of.c                  |   4 +
 include/media/v4l2-mediabus.h                      |   5 +
 include/uapi/linux/videodev2.h                     |   1 +
 8 files changed, 214 insertions(+), 50 deletions(-)

-- 
1.9.1

