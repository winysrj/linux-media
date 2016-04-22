Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:40067 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933AbcDVND5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 09:03:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] tc358743: drop bogus comment
Date: Fri, 22 Apr 2016 15:03:40 +0200
Message-Id: <1461330222-34096-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The control in question is not a private control, so drop that
comment. Copy-and-paste left-over.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/tc358743.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 73e0cef..6cf6d06 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1863,7 +1863,6 @@ static int tc358743_probe(struct i2c_client *client,
 	/* control handlers */
 	v4l2_ctrl_handler_init(&state->hdl, 3);
 
-	/* private controls */
 	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(&state->hdl, NULL,
 			V4L2_CID_DV_RX_POWER_PRESENT, 0, 1, 0, 0);
 
-- 
2.8.0.rc3

