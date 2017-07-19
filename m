Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:52654 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753073AbdGSKuS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 06:50:18 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v5 1/4] v4l: async: fix unbind error in v4l2_async_notifier_unregister()
Date: Wed, 19 Jul 2017 12:49:43 +0200
Message-Id: <20170719104946.7322-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170719104946.7322-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170719104946.7322-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The call to v4l2_async_cleanup() will set sd->asd to NULL so passing it
to notifier->unbind() have no effect and leaves the notifier confused.
Call the unbind() callback prior to cleaning up the subdevice to avoid
this.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-async.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 851f128eba2219ad..0acf288d7227ba97 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -226,14 +226,14 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 
 		d = get_device(sd->dev);
 
+		if (notifier->unbind)
+			notifier->unbind(notifier, sd, sd->asd);
+
 		v4l2_async_cleanup(sd);
 
 		/* If we handled USB devices, we'd have to lock the parent too */
 		device_release_driver(d);
 
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, sd->asd);
-
 		/*
 		 * Store device at the device cache, in order to call
 		 * put_device() on the final step
-- 
2.13.1
