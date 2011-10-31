Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933209Ab1JaPQg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 11:16:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/6] v4l2-event: Remove pending events from fh event queue when unsubscribing
Date: Mon, 31 Oct 2011 16:16:46 +0100
Message-Id: <1320074209-23473-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
References: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kev pointers inside the pending events queue (the available queue) of the
fh point to data inside the sev, unsubscribing frees the sev, thus making these
pointers point to freed memory!

This patch fixes these dangling pointers in the available queue by removing
all matching pending events on unsubscription.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/v4l2-event.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 9f56f18..01cbb7f 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -284,6 +284,7 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 			   struct v4l2_event_subscription *sub)
 {
 	struct v4l2_subscribed_event *sev;
+	struct v4l2_kevent *kev, *next;
 	unsigned long flags;
 
 	if (sub->type == V4L2_EVENT_ALL) {
@@ -295,6 +296,13 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 
 	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
 	if (sev != NULL) {
+		/* Remove any pending events for this subscription */
+		list_for_each_entry_safe(kev, next, &fh->available, list) {
+			if (kev->sev == sev) {
+				list_del(&kev->list);
+				fh->navailable--;
+			}
+		}
 		list_del(&sev->list);
 		sev->fh = NULL;
 	}
-- 
1.7.7

