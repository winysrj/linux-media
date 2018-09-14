Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57262 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbeINPKS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 11:10:18 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for request_api branch] v4l2-ctrls.c: fix smatch error
Message-ID: <0964af69-fd97-ecca-467e-a11b5e731666@xs4all.nl>
Date: Fri, 14 Sep 2018 11:56:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this smatch error:

drivers/media/v4l2-core/v4l2-ctrls.c:2971 v4l2_ctrl_request_clone() error: uninitialized symbol 'err'.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 73665c7d7045..65e3cf838ac7 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2942,7 +2942,7 @@ static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
 				   const struct v4l2_ctrl_handler *from)
 {
 	struct v4l2_ctrl_ref *ref;
-	int err;
+	int err = 0;

 	if (WARN_ON(!hdl || hdl == from))
 		return -EINVAL;
