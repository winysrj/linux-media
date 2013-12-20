Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3099 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab3LTJcD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 27/50] adv7842: corrected setting of cp-register 0x91 and 0x8f.
Date: Fri, 20 Dec 2013 10:31:20 +0100
Message-Id: <1387531903-20496-28-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Bit 6 of register 0x8f was cleared incorrectly (must be 1), and bit 4
of register 0x91 was set incorrectly (must be 0).

These bits are undocumented, so we shouldn't modify them to values different
from what the datasheet specifies.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 22fa4ca..6434a93 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -927,7 +927,7 @@ static int configure_predefined_video_timings(struct v4l2_subdev *sd,
 	cp_write(sd, 0x27, 0x00);
 	cp_write(sd, 0x28, 0x00);
 	cp_write(sd, 0x29, 0x00);
-	cp_write(sd, 0x8f, 0x00);
+	cp_write(sd, 0x8f, 0x40);
 	cp_write(sd, 0x90, 0x00);
 	cp_write(sd, 0xa5, 0x00);
 	cp_write(sd, 0xa6, 0x00);
@@ -1408,7 +1408,7 @@ static int adv7842_s_dv_timings(struct v4l2_subdev *sd,
 
 	state->timings = *timings;
 
-	cp_write(sd, 0x91, bt->interlaced ? 0x50 : 0x10);
+	cp_write(sd, 0x91, bt->interlaced ? 0x40 : 0x00);
 
 	/* Use prim_mode and vid_std when available */
 	err = configure_predefined_video_timings(sd, timings);
-- 
1.8.4.4

