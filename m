Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1JaPQd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 11:16:33 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/6] v4l2-event: Deny subscribing with a type of V4L2_EVENT_ALL
Date: Mon, 31 Oct 2011 16:16:45 +0100
Message-Id: <1320074209-23473-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
References: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
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

