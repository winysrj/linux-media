Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3991 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3LJNZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/15] adv7604: support 1366x768 DMT Reduced Blanking
Date: Tue, 10 Dec 2013 14:23:08 +0100
Message-Id: <343ed77bfb73b36dbe81245bd168f06e2d344ae4.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 99734b2..417468c 100644
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
1.8.4.rc3

