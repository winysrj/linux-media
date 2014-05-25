Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2793 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaEYOPk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 10:15:40 -0400
Message-ID: <5381FAE7.2080003@xs4all.nl>
Date: Sun, 25 May 2014 16:15:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Arun Kumar K <arun.kk@samsung.com>
Subject: [PATCH for v3.16] DocBook media: fix typo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The reference to v4l2-event-source-change should have been v4l2-event-src-change.
This caused a failure when building the spec.

Fixed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
index f016254..17efa87 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
@@ -167,7 +167,7 @@
 	       or the pad index (when used with a subdevice node) from which
 	       you want to receive events.</para>
 
-              <para>This event has a &v4l2-event-source-change; associated
+              <para>This event has a &v4l2-event-src-change; associated
 	      with it. The <structfield>changes</structfield> bitfield denotes
 	      what has changed for the subscribed pad. If multiple events
 	      occurred before application could dequeue them, then the changes
-- 
2.0.0.rc0

