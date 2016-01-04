Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54689 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbcADM0G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 07:26:06 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 00/10] [media] tvp5150: add MC and DT support
Date: Mon,  4 Jan 2016 09:25:22 -0300
Message-Id: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

One of my testing platforms for the MC next gen [0] work has been an OMAP3
board (IGEPv2) with a tvp5151 video decoder attached to the OMAP3ISP block.

I've been using some patches from Laurent Pinchart that adds MC support to
the tvp5150 driver. The patches were never posted to the list and it seems
he doesn't have time to continue working on this so I have taken them from
his personal tree [1] and submitting now for review.

The series also contains patches that adds DT support to the driver so it
can be used in DT based platforms.

To test, the following media pipeline was used:

$ media-ctl -r -l '"tvp5150 1-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
$ media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x240 field:alternate]'
$ media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x240 field:interlaced-tb]'

And frames captured with the yavta tool:

$ yavta -f UYVY -s 720x480 -n 1 --field interlaced-tb --capture=1 -F /dev/video2
$ raw2rgbpnm -f UYVY -s 720x480 frame-000000.bin frame-000000.pnm

The patches are on top of [0] not because is a depedency but just to avoid
merge conflicts and I don't expect them to be picked before that anyways.

Best regards,
Javier

[0]: http://lists.infradead.org/pipermail/linux-arm-kernel/2015-August/367109.html
[1]: http://git.linuxtv.org/pinchartl/media.git/log/?h=omap3isp/tvp5151


Eduard Gavin (1):
  [media] tvp5150: Add OF match table

Javier Martinez Canillas (3):
  [media] tvp5150: Add device tree binding document
  [media] tvp5150: Initialize the chip on probe
  [media] tvp5150: Configure data interface via pdata or DT

Laurent Pinchart (6):
  [media] tvp5150: Restructure version detection
  [media] tvp5150: Add tvp5151 support
  [media] tvp5150: Add pad-level subdev operations
  [media] tvp5150: Add pixel rate control support
  [media] tvp5150: Add s_stream subdev operation support
  [media] tvp5150: Add g_mbus_config subdev operation support

 .../devicetree/bindings/media/i2c/tvp5150.txt      |  35 +++
 drivers/media/i2c/tvp5150.c                        | 272 +++++++++++++++++----
 include/media/i2c/tvp5150.h                        |   5 +
 3 files changed, 263 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp5150.txt

-- 
2.4.3

