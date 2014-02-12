Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4569 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaBLLnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 06:43:07 -0500
Message-ID: <52FB5D63.4080406@xs4all.nl>
Date: Wed, 12 Feb 2014 12:39:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com
Subject: [REVIEWv2 PATCH 36/34] v4l2-ctrls: break off loop on first changed
 element
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to loop over all elements of a matrix checking if
there are changes. Just stop at the first changed element.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e8e2caa..23febc4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1502,8 +1502,9 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 		if (ctrl == NULL)
 			continue;
-		for (idx = 0; idx < ctrl->rows * ctrl->cols; idx++)
-			ctrl_changed |= !ctrl->type_ops->equal(ctrl, idx,
+		for (idx = 0; !ctrl_changed &&
+			      idx < ctrl->rows * ctrl->cols; idx++)
+			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
 						ctrl->stores[0], ctrl->new);
 		ctrl->has_changed = ctrl_changed;
 		changed |= ctrl->has_changed;
-- 
1.8.5.2


