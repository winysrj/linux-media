Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:57399 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933534AbeF2Jkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 05:40:47 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix gain when autogain is on
Message-ID: <b7ae30af-dcaa-f8ef-4171-e73cb0107884@xs4all.nl>
Date: Fri, 29 Jun 2018 11:40:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the vivid driver you want gain to continuous change while autogain
is on. However, dev->jiffies_vid_cap doesn't actually change. It probably
did in the past, but changes in the code caused this to be a fixed value
that is only set when you start streaming.

Replace it by jiffies, which is always changing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 6b0bfa091592..6eb8ad7fb12c 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -295,7 +295,7 @@ static int vivid_user_vid_g_volatile_ctrl(struct v4l2_ctrl *ctrl)

 	switch (ctrl->id) {
 	case V4L2_CID_AUTOGAIN:
-		dev->gain->val = dev->jiffies_vid_cap & 0xff;
+		dev->gain->val = (jiffies / HZ) & 0xff;
 		break;
 	}
 	return 0;
