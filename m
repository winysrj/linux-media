Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:46659 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405AbaGEIjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jul 2014 04:39:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] DocBook media: add missing dqevent src_change field.
Date: Sat,  5 Jul 2014 10:31:04 +0200
Message-Id: <1404549065-25042-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1404549065-25042-1-git-send-email-hverkuil@xs4all.nl>
References: <1404549065-25042-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_event union has a new src_change field, but that was never
added to the VIDIOC_DQEVENT documentation of that union. Fixed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 820f86e..9ca2d08 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -94,6 +94,12 @@
 	  </row>
 	  <row>
 	    <entry></entry>
+	    <entry>&v4l2-event-src-change;</entry>
+            <entry><structfield>src_change</structfield></entry>
+	    <entry>Event data for event V4L2_EVENT_SOURCE_CHANGE.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>__u8</entry>
             <entry><structfield>data</structfield>[64]</entry>
 	    <entry>Event data. Defined by the event type. The union
-- 
2.0.0

