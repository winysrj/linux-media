Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32958 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752113Ab3CWWA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 18:00:28 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com,
	hverkuil@xs4all.nl
Subject: [PATCH v2 1/1] v4l: Document timestamp behaviour to correspond to reality
Date: Sun, 24 Mar 2013 00:04:34 +0200
Message-Id: <1364076274-726-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document that monotonic timestamps are taken after the corresponding frame
has been received, not when the reception has begun. This corresponds to the
reality of current drivers: the timestamp is naturally taken when the
hardware triggers an interrupt to tell the driver to handle the received
frame.

Remove the note on timestamp accurary as it is fairly subjective what is
actually an unstable timestamp.

Also remove explanation that output buffer timestamps can be used to delay
outputting a frame.

Remove the footnote saying we always use realtime clock.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi all,

This is the second version of the patch fixing timestamp behaviour
documentation. I've tried to address the comments I've received albeit I
don't think there was a definitive conclusion on all the trails of
discussion. What has changed since v1 is:

- Removed discussion on timestamp stability.

- Removed notes that timestamps on output buffers define when frames will be
  displayed. It appears no driver has ever implemented this, or at least
  does not implement this now.

- Monotonic time is not affected by harms that the wall clock time is
  subjected to. Remove notes on that.

 Documentation/DocBook/media/v4l/io.xml |   47 ++++++--------------------------
 1 file changed, 8 insertions(+), 39 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index e6c5855..46d5a41 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -654,38 +654,11 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
 In that case, struct <structname>v4l2_buffer</structname> contains an array of
 plane structures.</para>
 
-      <para>Nominally timestamps refer to the first data byte transmitted.
-In practice however the wide range of hardware covered by the V4L2 API
-limits timestamp accuracy. Often an interrupt routine will
-sample the system clock shortly after the field or frame was stored
-completely in memory. So applications must expect a constant
-difference up to one field or frame period plus a small (few scan
-lines) random error. The delay and error can be much
-larger due to compression or transmission over an external bus when
-the frames are not properly stamped by the sender. This is frequently
-the case with USB cameras. Here timestamps refer to the instant the
-field or frame was received by the driver, not the capture time. These
-devices identify by not enumerating any video standards, see <xref
-linkend="standard" />.</para>
-
-      <para>Similar limitations apply to output timestamps. Typically
-the video hardware locks to a clock controlling the video timing, the
-horizontal and vertical synchronization pulses. At some point in the
-line sequence, possibly the vertical blanking, an interrupt routine
-samples the system clock, compares against the timestamp and programs
-the hardware to repeat the previous field or frame, or to display the
-buffer contents.</para>
-
-      <para>Apart of limitations of the video device and natural
-inaccuracies of all clocks, it should be noted system time itself is
-not perfectly stable. It can be affected by power saving cycles,
-warped to insert leap seconds, or even turned back or forth by the
-system administrator affecting long term measurements. <footnote>
-	  <para>Since no other Linux multimedia
-API supports unadjusted time it would be foolish to introduce here. We
-must use a universally supported clock to synchronize different media,
-hence time of day.</para>
-	</footnote></para>
+      <para>On timestamp types that are sampled from the system clock
+(V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC) it is guaranteed that the timestamp is
+taken after the complete frame has been received (or transmitted in
+case of video output devices). For other kinds of
+timestamps this may vary depending on the driver.</para>
 
     <table frame="none" pgwide="1" id="v4l2-buffer">
       <title>struct <structname>v4l2_buffer</structname></title>
@@ -745,13 +718,9 @@ applications when an output stream.</entry>
 	    byte was captured, as returned by the
 	    <function>clock_gettime()</function> function for the relevant
 	    clock id; see <constant>V4L2_BUF_FLAG_TIMESTAMP_*</constant> in
-	    <xref linkend="buffer-flags" />. For output streams the data
-	    will not be displayed before this time, secondary to the nominal
-	    frame rate determined by the current video standard in enqueued
-	    order. Applications can for example zero this field to display
-	    frames as soon as possible. The driver stores the time at which
-	    the first data byte was actually sent out in the
-	    <structfield>timestamp</structfield> field. This permits
+	    <xref linkend="buffer-flags" />. For output streams he driver
+	    stores the time at which the first data byte was actually sent out
+	    in the  <structfield>timestamp</structfield> field. This permits
 	    applications to monitor the drift between the video and system
 	    clock.</para></entry>
 	  </row>
-- 
Kind regards,
Sakari
