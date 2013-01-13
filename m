Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56984 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756160Ab3AMWoT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 17:44:19 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 3/3] Sort enumerated media bus codes
Date: Mon, 14 Jan 2013 00:47:33 +0200
Message-Id: <1358117253-13707-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1358117253-13707-1-git-send-email-sakari.ailus@iki.fi>
References: <50F3396E.2010505@iki.fi>
 <1358117253-13707-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sort the enumeration result. This makes e.g. matching formats at both ends
of the link much easier.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/v4l2subdev.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 946c030..d553216 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -65,6 +65,19 @@ void v4l2_subdev_close(struct media_entity *entity)
 	}
 }
 
+static int mbus_code_sort(const void *p1, const void *p2)
+{
+	const unsigned int *c1 = p1, *c2 = p2;
+
+	if (*c1 < *c2)
+		return -1;
+
+	if (*c1 > *c2)
+		return 1;
+
+	return 0;
+}
+
 struct v4l2_subdev_mbus_codes *
 v4l2_subdev_enum_mbus_code(struct media_entity *entity, unsigned int pad)
 {
@@ -100,6 +113,7 @@ v4l2_subdev_enum_mbus_code(struct media_entity *entity, unsigned int pad)
 	}
 
 	codes->ncode = c.index;
+	qsort(codes->code, codes->ncode, sizeof(*codes->code), &mbus_code_sort);
 
 	v4l2_subdev_close(entity);
 	return codes;
-- 
1.7.10.4

