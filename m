Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42613 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932970AbbFEO3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 10:29:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] v4l2-ioctl: log buffer type 0 correctly
Date: Fri,  5 Jun 2015 16:28:51 +0200
Message-Id: <1433514532-23306-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433514532-23306-1-git-send-email-hverkuil@xs4all.nl>
References: <1433514532-23306-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If userspace passed the invalid buffer type 0 to the kernel, then the
kernel log would show 'type=(null)' since there was no string defined
for type 0. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 368bc3a..1ce89a4 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -142,6 +142,7 @@ const char *v4l2_field_names[] = {
 EXPORT_SYMBOL(v4l2_field_names);
 
 const char *v4l2_type_names[] = {
+	[0]				   = "0",
 	[V4L2_BUF_TYPE_VIDEO_CAPTURE]      = "vid-cap",
 	[V4L2_BUF_TYPE_VIDEO_OVERLAY]      = "vid-overlay",
 	[V4L2_BUF_TYPE_VIDEO_OUTPUT]       = "vid-out",
-- 
2.1.4

