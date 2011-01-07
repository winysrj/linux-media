Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2887 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1AGMrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 07:47:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC PATCH 3/5] v4l2-ctrls: v4l2_ctrl_handler_setup must set has_new to 1
Date: Fri,  7 Jan 2011 13:47:33 +0100
Message-Id: <98ff8980e72e4493d7b7e26c4054d818916a9720.1294402580.git.hverkuil@xs4all.nl>
In-Reply-To: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl>
References: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
References: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Drivers can use the has_new field to determine if a new value was specified
for a control. The v4l2_ctrl_handler_setup() must always set this to 1 since
the setup has to force a full update of all controls.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-ctrls.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 8f81efc..64f56bb 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1280,8 +1280,10 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 		if (ctrl->done)
 			continue;
 
-		for (i = 0; i < master->ncontrols; i++)
+		for (i = 0; i < master->ncontrols; i++) {
 			cur_to_new(master->cluster[i]);
+			master->cluster[i]->has_new = 1;
+		}
 
 		/* Skip button controls and read-only controls. */
 		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
-- 
1.7.0.4

