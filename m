Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1KBKNI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 06:13:08 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/5] v4l2-event: Remove pending events from fh event queue when unsubscribing
Date: Wed,  2 Nov 2011 11:13:22 +0100
Message-Id: <1320228805-9097-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320228805-9097-1-git-send-email-hdegoede@redhat.com>
References: <1320228805-9097-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kev pointers inside the pending events queue (the available queue) of the
fh point to data inside the sev, unsubscribing frees the sev, thus making these
pointers point to freed memory!

This patch fixes these dangling pointers in the available queue by removing
all matching pending events on unsubscription.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/v4l2-event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 9f56f18..4d01f17 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -285,6 +285,7 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 {
 	struct v4l2_subscribed_event *sev;
 	unsigned long flags;
+	int i;
 
 	if (sub->type == V4L2_EVENT_ALL) {
 		v4l2_event_unsubscribe_all(fh);
@@ -295,6 +296,11 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 
 	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
 	if (sev != NULL) {
+		/* Remove any pending events for this subscription */
+		for (i = 0; i < sev->in_use; i++) {
+			list_del(&sev->events[sev_pos(sev, i)].list);
+			fh->navailable--;
+		}
 		list_del(&sev->list);
 		sev->fh = NULL;
 	}
-- 
1.7.7

