Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:57605 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab1LNPWv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 10:22:51 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, snjw23@gmail.com,
	t.stanislaws@samsung.com, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl
Subject: [RFC 3/3] v4l: Add pad op for pipeline validation
Date: Wed, 14 Dec 2011 17:22:27 +0200
Message-Id: <1323876147-18107-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111201143044.GI29805@valkosipuli.localdomain>
References: <20111201143044.GI29805@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smiapp_pad_ops.validate_pipeline is intended to validate the full pipeline
which is implemented by the driver to which the subdev implementing this op
belongs to. The validate_pipeline op must also call validate_pipeline on
any external entity which is linked to its sink pads.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/media/v4l2-subdev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 26eeaa4..a5ebe86 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -470,6 +470,7 @@ struct v4l2_subdev_pad_ops {
 			     struct v4l2_subdev_selection *sel);
 	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			     struct v4l2_subdev_selection *sel);
+	int (*validate_pipeline)(struct v4l2_subdev *sd);
 };
 
 struct v4l2_subdev_ops {
-- 
1.7.2.5

