Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44149 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbcAGMrM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:12 -0500
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
Subject: [PATCH v2 02/10] [media] tvp5150: Add tvp5151 support
Date: Thu,  7 Jan 2016 09:46:42 -0300
Message-Id: <1452170810-32346-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Expand the version detection code to identity the tvp5151.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

Changes in v2: None

 drivers/media/i2c/tvp5150.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 9e953e5a7ec9..b3b34e24db13 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1139,6 +1139,8 @@ static int tvp5150_detect_version(struct tvp5150 *core)
 
 		/* ITU-T BT.656.4 timing */
 		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
+	} else if (dev_id == 0x5151 && rom_ver == 0x0100) { /* TVP5151 */
+		v4l2_info(sd, "tvp5151 detected.\n");
 	} else {
 		v4l2_info(sd, "*** unknown tvp%04x chip detected.\n", dev_id);
 	}
-- 
2.4.3

