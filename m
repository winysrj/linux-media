Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2120 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab2FIK7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 06:59:53 -0400
Received: from alastor.dyndns.org (189.80-203-102.nextgentel.com [80.203.102.189] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id q59AxpDI079264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 9 Jun 2012 12:59:52 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 5E20BCDE000A
	for <linux-media@vger.kernel.org>; Sat,  9 Jun 2012 12:59:45 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.5] Fix VIDIOC_DQEVENT docbook entry
Date: Sat, 9 Jun 2012 12:59:45 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206091259.45508.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index e8714aa..98a856f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -89,7 +89,7 @@
 	  <row>
 	    <entry></entry>
 	    <entry>&v4l2-event-frame-sync;</entry>
-            <entry><structfield>frame</structfield></entry>
+            <entry><structfield>frame_sync</structfield></entry>
 	    <entry>Event data for event V4L2_EVENT_FRAME_SYNC.</entry>
 	  </row>
 	  <row>
