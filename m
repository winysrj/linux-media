Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1967 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab2JQJSj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:18:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <mats.randgaard@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH for v3.7 1/4] adv7604: cleanup references
Date: Wed, 17 Oct 2012 11:18:30 +0200
Message-Id: <c970cc0b7e589a05fbf258792412e5564f648f79.1350465202.git.hans.verkuil@cisco.com>
In-Reply-To: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
References: <1350465513-7304-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Mats Randgaard <mats.randgaard@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 109bc9b..75a8395 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1123,7 +1123,7 @@ static int adv7604_query_dv_timings(struct v4l2_subdev *sd,
 		adv7604_fill_optional_dv_timings_fields(sd, timings);
 	} else {
 		/* find format
-		 * Since LCVS values are inaccurate (REF_03, page 275-276),
+		 * Since LCVS values are inaccurate [REF_03, p. 275-276],
 		 * stdi2dv_timings() is called with lcvs +-1 if the first attempt fails.
 		 */
 		if (!stdi2dv_timings(sd, &stdi, timings))
@@ -1712,9 +1712,9 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	cp_write(sd, 0xba, (pdata->hdmi_free_run_mode << 1) | 0x01); /* HDMI free run */
 	cp_write(sd, 0xf3, 0xdc); /* Low threshold to enter/exit free run mode */
 	cp_write(sd, 0xf9, 0x23); /*  STDI ch. 1 - LCVS change threshold -
-				      ADI recommended setting [REF_01 c. 2.3.3] */
+				      ADI recommended setting [REF_01, c. 2.3.3] */
 	cp_write(sd, 0x45, 0x23); /*  STDI ch. 2 - LCVS change threshold -
-				      ADI recommended setting [REF_01 c. 2.3.3] */
+				      ADI recommended setting [REF_01, c. 2.3.3] */
 	cp_write(sd, 0xc9, 0x2d); /* use prim_mode and vid_std as free run resolution
 				     for digital formats */
 
-- 
1.7.10.4

