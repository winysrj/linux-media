Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab2CYLyv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Mar 2012 07:54:51 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 01/10] pwc: Add support for control events
Date: Sun, 25 Mar 2012 13:56:41 +0200
Message-Id: <1332676610-14953-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1332676610-14953-1-git-send-email-hdegoede@redhat.com>
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com>
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

