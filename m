Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3H1N2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 09:28:32 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] V4L2: add a v4l2-clk helper macro to produce an I2C device ID
Date: Wed, 28 Aug 2013 15:28:27 +0200
Message-Id: <1377696508-3190-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To obtain a clock reference consumers supply their device object to the
V4L2 clock framework. The latter then uses the consumer device name to
find a matching clock. For that to work V4L2 clock providers have to
provide the same device name, when registering clocks. This patch adds
a helper macro to generate a suitable device name for I2C devices.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
V4L2 clocks use device ID matching, which in case of I2C devices involves
comparing a specially constructed from an I2C adapter number and a device
address
---
 include/media/v4l2-clk.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
index a354a9d..0b36cc1 100644
--- a/include/media/v4l2-clk.h
+++ b/include/media/v4l2-clk.h
@@ -65,4 +65,7 @@ static inline struct v4l2_clk *v4l2_clk_register_fixed(const char *dev_id,
 	return __v4l2_clk_register_fixed(dev_id, id, rate, THIS_MODULE);
 }
 
+#define v4l2_clk_name_i2c(name, size, adap, client) snprintf(name, size, \
+			  "%d-%04x", adap, client)
+
 #endif
-- 
1.7.2.5

