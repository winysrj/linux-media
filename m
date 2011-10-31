Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1JaPQg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 11:16:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4/6] v4l2-event: Don't set sev->fh to NULL on unsubcribe
Date: Mon, 31 Oct 2011 16:16:47 +0100
Message-Id: <1320074209-23473-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
References: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1: There is no reason for this after v4l2_event_unsubscribe releases the
spinlock nothing is holding a reference to the sev anymore except for the
local reference in the v4l2_event_unsubscribe function.

2: Setting sev->fh to NULL causes problems for the del op added in the next
patch of this series, since this op needs a way to get to its own data
structures, and typically this will be done by using container_of on an
embedded v4l2_fh struct.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/v4l2-event.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 01cbb7f..3d27300 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -304,7 +304,6 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 			}
 		}
 		list_del(&sev->list);
-		sev->fh = NULL;
 	}
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-- 
1.7.7

