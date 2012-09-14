Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:11309 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab2INLPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 07:15:44 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id q8EBFghQ000742
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 11:15:43 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 API PATCH 4/4] tuner-core: map audmode to STEREO for radio devices.
Date: Fri, 14 Sep 2012 13:15:36 +0200
Message-Id: <97c2130954d0c14e16e0e7b08b29405e48a9687e.1347620872.git.hans.verkuil@cisco.com>
In-Reply-To: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <da47f14735bb06321de298db1cb50172f8e1f480.1347620872.git.hans.verkuil@cisco.com>
References: <da47f14735bb06321de298db1cb50172f8e1f480.1347620872.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes a v4l2-compliance error: setting audmode to a value other than mono
or stereo for a radio device should map to MODE_STEREO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/tuner-core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index b5a819a..ea71371 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -1235,8 +1235,11 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	if (set_mode(t, vt->type))
 		return 0;
 
-	if (t->mode == V4L2_TUNER_RADIO)
+	if (t->mode == V4L2_TUNER_RADIO) {
 		t->audmode = vt->audmode;
+		if (t->audmode > V4L2_TUNER_MODE_STEREO)
+			t->audmode = V4L2_TUNER_MODE_STEREO;
+	}
 	set_freq(t, 0);
 
 	return 0;
-- 
1.7.10.4

