Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45745 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752054AbaBGWtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 17:49:20 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH v4.2 4/4] v4l: Document timestamp buffer flag behaviour
Date: Sat,  8 Feb 2014 00:52:28 +0200
Message-Id: <1391813548-818-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1391813548-818-1-git-send-email-sakari.ailus@iki.fi>
References: <1393149.6OyBNhdFTt@avalon>
 <1391813548-818-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Timestamp buffer flags are constant at the moment. Document them so that 1)
they're always valid and 2) not changed by the drivers. This leaves room to
extend the functionality later on if needed.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/io.xml |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 451626f..f523725 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -654,6 +654,14 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
 In that case, struct <structname>v4l2_buffer</structname> contains an array of
 plane structures.</para>
 
+    <para>Buffers that have been dequeued come with timestamps. These
+    timestamps can be taken from different clocks and at different part of
+    the frame, depending on the driver. Please see flags in the masks
+    <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
+    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
+    linkend="buffer-flags">. These flags are guaranteed to be always valid
+    and will not be changed by the driver.</para>
+
     <table frame="none" pgwide="1" id="v4l2-buffer">
       <title>struct <structname>v4l2_buffer</structname></title>
       <tgroup cols="4">
-- 
1.7.10.4

