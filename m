Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1KBKNG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 06:13:06 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/5] v4l2-event: Deny subscribing with a type of V4L2_EVENT_ALL
Date: Wed,  2 Nov 2011 11:13:21 +0100
Message-Id: <1320228805-9097-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320228805-9097-1-git-send-email-hdegoede@redhat.com>
References: <1320228805-9097-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 53b190c..9f56f18 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -215,6 +215,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	unsigned long flags;
 	unsigned i;
 
+	if (sub->type == V4L2_EVENT_ALL)
+		return -EINVAL;
+
 	if (elems < 1)
 		elems = 1;
 	if (sub->type == V4L2_EVENT_CTRL) {
-- 
1.7.7

