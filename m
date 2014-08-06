Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbaHFGhx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Aug 2014 02:37:53 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 0616E20086
	for <linux-media@vger.kernel.org>; Wed,  6 Aug 2014 09:37:51 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Event documentation fixes
Date: Wed,  6 Aug 2014 09:37:49 +0300
Message-Id: <1407307069-13480-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Constify event type constants and correct motion detection event number
(it's 6, not 5).

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml         | 7 ++++---
 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index cb77325..ce7e700 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -76,21 +76,22 @@
 	    <entry></entry>
 	    <entry>&v4l2-event-vsync;</entry>
             <entry><structfield>vsync</structfield></entry>
-	    <entry>Event data for event V4L2_EVENT_VSYNC.
+	    <entry>Event data for event <constant>V4L2_EVENT_VSYNC</constant>.
             </entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>&v4l2-event-ctrl;</entry>
             <entry><structfield>ctrl</structfield></entry>
-	    <entry>Event data for event V4L2_EVENT_CTRL.
+	    <entry>Event data for event <constant>V4L2_EVENT_CTRL</constant>.
             </entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>&v4l2-event-frame-sync;</entry>
             <entry><structfield>frame_sync</structfield></entry>
-	    <entry>Event data for event V4L2_EVENT_FRAME_SYNC.</entry>
+	    <entry>Event data for event <constant>V4L2_EVENT_FRAME_SYNC
+	    </constant>.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index 9f60956..d7c9365 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -176,7 +176,7 @@
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_EVENT_MOTION_DET</constant></entry>
-	    <entry>5</entry>
+	    <entry>6</entry>
 	    <entry>
 	      <para>Triggered whenever the motion detection state for one or more of the regions
 	      changes. This event has a &v4l2-event-motion-det; associated with it.</para>
-- 
1.8.3.2

