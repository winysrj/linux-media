Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59270 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757606Ab0GTBWY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:22:24 -0400
Subject: [PATCH 13/17] cx23885: Add a v4l2_subdev group id for the
 CX2388[578] integrated AV core
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M.Liplianin" <liplianin@me.by>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:22:47 -0400
Message-ID: <1279588967.31145.10.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-cards.c |    5 ++++-
 drivers/media/video/cx23885/cx23885.h       |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 191bda0..96da11f 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -1152,7 +1152,10 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", "cx25840", 0x88 >> 1, NULL);
-		v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
+		if (dev->sd_cx25840) {
+			dev->sd_cx25840->grp_id = CX23885_HW_AV_CORE;
+			v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
+		}
 		break;
 	}
 
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index a33f2b7..460f430 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -403,7 +403,8 @@ static inline struct cx23885_dev *to_cx23885(struct v4l2_device *v4l2_dev)
 #define call_all(dev, o, f, args...) \
 	v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
 
-#define CX23885_HW_888_IR (1 << 0)
+#define CX23885_HW_888_IR  (1 << 0)
+#define CX23885_HW_AV_CORE (1 << 1)
 
 #define call_hw(dev, grpid, o, f, args...) \
 	v4l2_device_call_all(&dev->v4l2_dev, grpid, o, f, ##args)
-- 
1.7.1.1


