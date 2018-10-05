Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49282 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728200AbeJEOqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/11] v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE
Date: Fri,  5 Oct 2018 09:49:01 +0200
Message-Id: <20181005074911.47574-2-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop the deprecated _ACTIVE part.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7de041bae84f..9c2370e4d05c 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2212,9 +2212,9 @@ static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
 
 	/* crop means compose for output devices */
 	if (V4L2_TYPE_IS_OUTPUT(p->type))
-		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+		s.target = V4L2_SEL_TGT_COMPOSE;
 	else
-		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+		s.target = V4L2_SEL_TGT_CROP;
 
 	ret = v4l_g_selection(ops, file, fh, &s);
 
@@ -2239,9 +2239,9 @@ static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
 
 	/* crop means compose for output devices */
 	if (V4L2_TYPE_IS_OUTPUT(p->type))
-		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
+		s.target = V4L2_SEL_TGT_COMPOSE;
 	else
-		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
+		s.target = V4L2_SEL_TGT_CROP;
 
 	return v4l_s_selection(ops, file, fh, &s);
 }
-- 
2.18.0
