Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42476 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752995AbeDSPnv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 11:43:51 -0400
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
Subject: [PATCH v2 01/10] media: v4l2-ctrls: Add missing v4l2 ctrl unlock
Date: Thu, 19 Apr 2018 17:41:15 +0200
Message-Id: <20180419154124.17512-2-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a missing v4l2_ctrl_unlock call that is required to avoid
deadlocks.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f67e9f5531fa..ba05a8b9a095 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3614,10 +3614,12 @@ void v4l2_ctrl_request_complete(struct media_request *req,
 			continue;
 
 		v4l2_ctrl_lock(ctrl);
+
 		if (ref->req)
 			ptr_to_ptr(ctrl, ref->req->p_req, ref->p_req);
 		else
 			ptr_to_ptr(ctrl, ctrl->p_cur, ref->p_req);
+
 		v4l2_ctrl_unlock(ctrl);
 	}
 
@@ -3677,8 +3679,11 @@ void v4l2_ctrl_request_setup(struct media_request *req,
 				}
 			}
 		}
-		if (!have_new_data)
+
+		if (!have_new_data) {
+			v4l2_ctrl_unlock(master);
 			continue;
+		}
 
 		for (i = 0; i < master->ncontrols; i++) {
 			if (master->cluster[i]) {
-- 
2.16.3
