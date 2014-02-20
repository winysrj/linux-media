Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38410 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751363AbaBTTky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 14:40:54 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com
Subject: [PATCH v5.1 7/7] v4l: Document timestamp buffer flag behaviour
Date: Thu, 20 Feb 2014 21:42:56 +0200
Message-Id: <1392925376-20562-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20140217233305.GY15635@valkosipuli.retiisi.org.uk>
References: <20140217233305.GY15635@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Timestamp buffer flags are constant at the moment. Document them so that 1)
they're always valid and 2) not changed by the drivers. This leaves room to
extend the functionality later on if needed.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
since v5:
- Clarify timestamp source flag behaviour.

 Documentation/DocBook/media/v4l/io.xml |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 22b87bc..a69e12a 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -653,6 +653,16 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
 In that case, struct <structname>v4l2_buffer</structname> contains an array of
 plane structures.</para>
 
+    <para>Dequeued video buffers come with timestamps. The driver
+    decides at which part of the frame and with which clock the
+    timestamp is taken. Please see flags in the masks
+    <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
+    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
+    linkend="buffer-flags">. These flags are always valid and constant
+    across all buffers during the whole video stream. Changes in these
+    flags may take place as a side effect of &VIDIOC-S-INPUT; or
+    &VIDIOC-S-OUTPUT; however.</para>
+
     <table frame="none" pgwide="1" id="v4l2-buffer">
       <title>struct <structname>v4l2_buffer</structname></title>
       <tgroup cols="4">
-- 
1.7.10.4

