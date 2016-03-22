Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57838 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbcCVJ6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 05:58:32 -0400
To: linux-media <linux-media@vger.kernel.org>
Cc: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] tc358743: zero the reserved array
Message-ID: <56F11766.5030202@xs4all.nl>
Date: Tue, 22 Mar 2016 10:59:02 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance complained about this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 972e0d4..73e0cef 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1551,6 +1551,8 @@ static int tc358743_g_edid(struct v4l2_subdev *sd,
 {
 	struct tc358743_state *state = to_state(sd);

+	memset(edid->reserved, 0, sizeof(edid->reserved));
+
 	if (edid->pad != 0)
 		return -EINVAL;

@@ -1585,6 +1587,8 @@ static int tc358743_s_edid(struct v4l2_subdev *sd,
 	v4l2_dbg(2, debug, sd, "%s, pad %d, start block %d, blocks %d\n",
 		 __func__, edid->pad, edid->start_block, edid->blocks);

+	memset(edid->reserved, 0, sizeof(edid->reserved));
+
 	if (edid->pad != 0)
 		return -EINVAL;

