Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3951 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab2IGN3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 03/28] DocBook: improve STREAMON/OFF documentation.
Date: Fri,  7 Sep 2012 15:29:03 +0200
Message-Id: <133a249609e30bd0c77fcc12c01b8899f3ff81d7.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Specify that STREAMON/OFF should return 0 if the stream is already
started/stopped.

The spec never specified what the correct behavior is. This ambiguity
was resolved during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
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

