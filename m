Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab2CWQuB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 12:50:01 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/6] pwc: Add support for control events
Date: Fri, 23 Mar 2012 17:51:54 +0100
Message-Id: <1332521519-552-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1332521519-552-1-git-send-email-hdegoede@redhat.com>
References: <1332521519-552-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/pwc/pwc-v4l.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index 2834e3e..c1ba1a0 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -1166,4 +1166,6 @@ const struct v4l2_ioctl_ops pwc_ioctl_ops = {
 	.vidioc_enum_frameintervals	    = pwc_enum_frameintervals,
 	.vidioc_g_parm			    = pwc_g_parm,
 	.vidioc_s_parm			    = pwc_s_parm,
+	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
 };
-- 
1.7.9.3

