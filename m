Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55267 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbcBETKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:17 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 0/8] [media] tvp5150: add HW input connectors support
Date: Fri,  5 Feb 2016 16:09:50 -0300
Message-Id: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

One of my test machines for MC is an IGEPv2 board that has a tvp5151
decoder attached to the OMAP3 ISP bridge.

The board has 2 composite RCA input connectors on it but I've no way
to switch those using the MC framework.

The driver currently uses the s_routing callback to change the input
but the documentation is clear that user level input IDs should never
be used (e.g. Composite, S-Video, etc). See: include/media/v4l2-subdev.h.

Also, these are HW blocks and other interface-centric drivers use
media entities to represent the input connectors (i.e: au0828 and
cx231xx) so this patch series do the same for the tvp5150 driver.

By having media entities for the input connectors, switching the
current input can be easily done with the MEDIA_IOC_SETUP_LINK ioctl:

$ media-ctl -r -l '"Composite0":0->"tvp5150 1-005c":0[1]'

Since the driver is responsible for registering the media entities
and creating the pad links, the associated v4l2 media device is needed.

But the driver registers the sub-dev using v4l2_async_register_subdev()
so a subdev core operation operating has been added so the v4l2 async
core can invoke the driver's initialization routing after the sub-dev
has been registered.

Please let me know if you think there's a better way to solve this.

Best regards,
Javier


Javier Martinez Canillas (8):
  [media] v4l2-subdev: add registered_async subdev core operation
  [media] v4l2-async: call registered_async after subdev registration
  [media] tvp5150: put endpoint node on error
  [media] tvp5150: store dev id and rom version
  [media] tvp5150: add internal signal generator to HW input list
  [media] tvp5150: move input definition header to dt-bindings
  [media] tvp5150: document input connectors DT bindings
  [media] tvp5150: add HW input connectors support

 .../devicetree/bindings/media/i2c/tvp5150.txt      |  43 +++++
 drivers/media/i2c/tvp5150.c                        | 179 +++++++++++++++++++--
 drivers/media/v4l2-core/v4l2-async.c               |   7 +
 include/{media/i2c => dt-bindings/media}/tvp5150.h |   9 +-
 include/media/v4l2-subdev.h                        |   3 +
 5 files changed, 226 insertions(+), 15 deletions(-)
 rename include/{media/i2c => dt-bindings/media}/tvp5150.h (85%)

-- 
2.5.0

