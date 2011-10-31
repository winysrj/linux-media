Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1JaPQc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 11:16:32 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/6] v4l2-ctrl: Send change events to all fh for auto cluster slave controls
Date: Mon, 31 Oct 2011 16:16:44 +0100
Message-Id: <1320074209-23473-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
References: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise the fh changing the master control won't get the inactive state
change event for the slave controls.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/v4l2-ctrls.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index fc8666a..69e24f4 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -945,6 +945,7 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 			if (ctrl->cluster[0]->has_volatiles)
 				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 		}
+		fh = NULL;
 	}
 	if (changed || update_inactive) {
 		/* If a control was changed that was not one of the controls
-- 
1.7.7

