Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4872 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab3LTJb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 10/50] adv7604: support 1366x768 DMT Reduced Blanking
Date: Fri, 20 Dec 2013 10:31:03 +0100
Message-Id: <1387531903-20496-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 00ce271..9f80d2e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -161,6 +161,7 @@ static const struct v4l2_dv_timings adv7604_timings[] = {
 	V4L2_DV_BT_DMT_1792X1344P60,
 	V4L2_DV_BT_DMT_1856X1392P60,
 	V4L2_DV_BT_DMT_1920X1200P60_RB,
+	V4L2_DV_BT_DMT_1366X768P60_RB,
 	V4L2_DV_BT_DMT_1366X768P60,
 	V4L2_DV_BT_DMT_1920X1080P60,
 	{ },
-- 
1.8.4.4

