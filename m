Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4148 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966014Ab3E2OTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 11/14] v4l2-ioctl: clarify querystd comment.
Date: Wed, 29 May 2013 16:19:04 +0200
Message-Id: <1369837147-8747-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Improve the querystd comment.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f81bda1..768f606 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1407,10 +1407,10 @@ static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
 	v4l2_std_id *p = arg;
 
 	/*
-	 * If nothing detected, it should return all supported
-	 * standard.
-	 * Drivers just need to mask the std argument, in order
-	 * to remove the standards that don't apply from the mask.
+	 * If no signal is detected, then the driver should return
+	 * V4L2_STD_UNKNOWN. Otherwise it should return tvnorms with
+	 * any standards that do not apply removed.
+	 *
 	 * This means that tuners, audio and video decoders can join
 	 * their efforts to improve the standards detection.
 	 */
-- 
1.7.10.4

