Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:23132 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab2INK5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:57:55 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBY013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:53 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 03/31] DocBook: improve STREAMON/OFF documentation.
Date: Fri, 14 Sep 2012 12:57:18 +0200
Message-Id: <be8d4f090e3bdd797604f1bedf0c44b37b583b22.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Specify that STREAMON/OFF should return 0 if the stream is already
started/stopped.

The spec never specified what the correct behavior is. This ambiguity
was resolved during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/vidioc-streamon.xml |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
index 81cca45..716ea15 100644
--- a/Documentation/DocBook/media/v4l/vidioc-streamon.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
@@ -74,7 +74,12 @@ not transmitted yet. I/O returns to the same state as after calling
 stream type. This is the same as &v4l2-requestbuffers;
 <structfield>type</structfield>.</para>
 
-    <para>Note applications can be preempted for unknown periods right
+    <para>If <constant>VIDIOC_STREAMON</constant> is called when streaming
+is already in progress, or if <constant>VIDIOC_STREAMOFF</constant> is called
+when streaming is already stopped, then the ioctl does nothing and 0 is
+returned.</para>
+
+    <para>Note that applications can be preempted for unknown periods right
 before or after the <constant>VIDIOC_STREAMON</constant> or
 <constant>VIDIOC_STREAMOFF</constant> calls, there is no notion of
 starting or stopping "now". Buffer timestamps can be used to
-- 
1.7.10.4

