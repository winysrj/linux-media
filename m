Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42498 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753002AbeDSPnw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 11:43:52 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH v2 02/10] media-request: Add a request complete operation to allow m2m scheduling
Date: Thu, 19 Apr 2018 17:41:16 +0200
Message-Id: <20180419154124.17512-3-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using the request API in the context of a m2m driver, the
operations that come with a m2m run scheduling call in their
(m2m-specific) ioctl handler are delayed until the request is queued
(for instance, this includes queuing buffers and streamon).

Thus, the m2m run scheduling calls are not called in due time since the
request AP's internal plumbing will (rightfully) use the relevant core
functions directly instead of the ioctl handler.

This ends up in a situation where nothing happens if there is no
run-scheduling ioctl called after queuing the request.

In order to circumvent the issue, a new media operation is introduced,
called at the time of handling the media request queue ioctl. It gives
m2m drivers a chance to schedule a m2m device run at that time.

The existing req_queue operation cannot be used for this purpose, since
it is called with the request queue mutex held, that is eventually needed
in the device_run call to apply relevant controls.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/media/media-request.c | 3 +++
 include/media/media-device.h  | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 415f7e31019d..28ac5ccfe6a2 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -157,6 +157,9 @@ static long media_request_ioctl_queue(struct media_request *req)
 		media_request_get(req);
 	}
 
+	if (mdev->ops->req_complete)
+		mdev->ops->req_complete(req);
+
 	return ret;
 }
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 07e323c57202..c7dcf2079cc9 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -55,6 +55,7 @@ struct media_entity_notify {
  * @req_alloc: Allocate a request
  * @req_free: Free a request
  * @req_queue: Queue a request
+ * @req_complete: Complete a request
  */
 struct media_device_ops {
 	int (*link_notify)(struct media_link *link, u32 flags,
@@ -62,6 +63,7 @@ struct media_device_ops {
 	struct media_request *(*req_alloc)(struct media_device *mdev);
 	void (*req_free)(struct media_request *req);
 	int (*req_queue)(struct media_request *req);
+	void (*req_complete)(struct media_request *req);
 };
 
 /**
-- 
2.16.3
