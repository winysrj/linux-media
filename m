Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62057 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933175AbdKAVGK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 08/26] media: v4l2-async: shut up an unitialized symbol warning
Date: Wed,  1 Nov 2017 17:05:45 -0400
Message-Id: <e510e9651f4c8672ab7f64df4a55863b4b9cb787.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch reports this warning:
	drivers/media/v4l2-core/v4l2-async.c:597 v4l2_async_register_subdev() error: uninitialized symbol 'ret'.

However, there's nothing wrong there. So, just shut up the
warning.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 49f7eccc76db..5bc861c4ae5c 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -532,7 +532,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 {
 	struct v4l2_async_notifier *subdev_notifier;
 	struct v4l2_async_notifier *notifier;
-	int ret;
+	int uninitialized_var(ret);
 
 	/*
 	 * No reference taken. The reference is held by the device
-- 
2.13.6
