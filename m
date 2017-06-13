Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:60487 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753024AbdFMObH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:31:07 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 1/2] v4l: async: check for v4l2_dev in v4l2_async_notifier_register()
Date: Tue, 13 Jun 2017 16:30:35 +0200
Message-Id: <20170613143036.533-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170613143036.533-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170613143036.533-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a check for v4l2_dev to v4l2_async_notifier_register() as to fail as
early as possible since this will fail later in v4l2_async_test_notify().

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index cbd919d4edd27e17..c16200c88417b151 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -148,7 +148,8 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	struct v4l2_async_subdev *asd;
 	int i;
 
-	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
+	if (!v4l2_dev || !notifier->num_subdevs ||
+	    notifier->num_subdevs > V4L2_MAX_SUBDEVS)
 		return -EINVAL;
 
 	notifier->v4l2_dev = v4l2_dev;
-- 
2.13.1
