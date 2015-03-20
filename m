Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
 Hans Verkuil <hans.verkuil@cisco.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Arun Kumar K <arun.kk@samsung.com>,
 Sylwester Nawrocki <s.nawrocki@samsung.com>, Antti Palosaari <crope@iki.fi>,
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 4/5] media/v4l2-ctrls: Always execute EXECUTE_ON_WRITE ctrls
Date: Fri, 20 Mar 2015 14:30:47 +0100
Message-id: <1426858247-25746-2-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1426858247-25746-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1426858247-25746-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

Any control with V4L2_CTRL_FLAG_EXECUTE_ON_WRITE set should return
changed == true in cluster_changed.

This forces the value to be passed to the driver even if it has not
changed.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v2: By Sakari Ailus <sakari.ailus@linux.intel.com>

Fix CodeStyle (sorry :S)
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index bacaed6..04d7407 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1611,6 +1611,10 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 		if (ctrl == NULL)
 			continue;
+
+		if (ctrl->flags & V4L2_CTRL_FLAG_EXECUTE_ON_WRITE)
+			changed = true;
+
 		/*
 		 * Set has_changed to false to avoid generating
 		 * the event V4L2_EVENT_CTRL_CH_VALUE
-- 
2.1.4
