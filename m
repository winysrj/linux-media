Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46724 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753821AbaBOUvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 15:51:38 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com,
	hverkuil@xs4all.nl, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v5 7/7] v4l: Document timestamp buffer flag behaviour
Date: Sat, 15 Feb 2014 22:53:05 +0200
Message-Id: <1392497585-5084-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Timestamp buffer flags are constant at the moment. Document them so that 1)
they're always valid and 2) not changed by the drivers. This leaves room to
extend the functionality later on if needed.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/io.xml |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index fbd0c6e..4f76565 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -653,6 +653,16 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
 In that case, struct <structname>v4l2_buffer</structname> contains an array of
 plane structures.</para>
 
+    <para>Dequeued video buffers come with timestamps. These
+    timestamps can be taken from different clocks and at different
+    part of the frame, depending on the driver. Please see flags in
+    the masks <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
+    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
+    linkend="buffer-flags">. These flags are guaranteed to be always
+    valid and will not be changed by the driver autonomously. Changes
+    in these flags may take place due as a side effect of
+    &VIDIOC-S-INPUT; or &VIDIOC-S-OUTPUT; however.</para>
+
     <table frame="none" pgwide="1" id="v4l2-buffer">
       <title>struct <structname>v4l2_buffer</structname></title>
       <tgroup cols="4">
-- 
1.7.10.4

