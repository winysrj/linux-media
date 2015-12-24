Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51340 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbbLXNSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 08:18:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Dec 2015 14:18:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb <linux-media@vger.kernel.org>
Cc: "laurent.pinchart" <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] DocBook media: make explicit that standard/timings never
 change automatically
Message-ID: <2176a82408f1a6cf55a94bc25cfe5dc4@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A driver might detect a new standard or DV timings, but it will never 
change to
those new timings automatically. Instead it will send an event and let 
the application
take care of it.

Make this explicit in the documentation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
  .../DocBook/media/v4l/vidioc-query-dv-timings.xml          | 14 
++++++++++++--
  Documentation/DocBook/media/v4l/vidioc-querystd.xml        | 10 
++++++++++
  2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml 
b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
index e9c70a8..eba0293 100644
--- a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
@@ -60,9 +60,19 @@ input</refpurpose>
  automatically, similar to sensing the video standard. To do so, 
applications
  call <constant>VIDIOC_QUERY_DV_TIMINGS</constant> with a pointer to a
  &v4l2-dv-timings;. Once the hardware detects the timings, it will fill 
in the
-timings structure.
+timings structure.</para>

-If the timings could not be detected because there was no signal, then
+<para>Please note that drivers will <emphasis>never</emphasis> switch 
timings automatically
+if new timings are detected. Instead, drivers will send the
+<constant>V4L2_EVENT_SOURCE_CHANGE</constant> event (if they support 
this) and expect
+that userspace will take action by calling 
<constant>VIDIOC_QUERY_DV_TIMINGS</constant>.
+The reason is that new timings usually mean different buffer sizes as 
well, and you
+cannot change buffer sizes on the fly. In general, applications that 
receive the
+Source Change event will have to call 
<constant>VIDIOC_QUERY_DV_TIMINGS</constant>,
+and if the detected timings are valid they will have to stop streaming, 
set the new
+timings, allocate new buffers and start streaming again.</para>
+
+<para>If the timings could not be detected because there was no signal, 
then
  <errorcode>ENOLINK</errorcode> is returned. If a signal was detected, 
but
  it was unstable and the receiver could not lock to the signal, then
  <errorcode>ENOLCK</errorcode> is returned. If the receiver could lock 
to the signal,
diff --git a/Documentation/DocBook/media/v4l/vidioc-querystd.xml 
b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
index 2223485..8efa917 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querystd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
@@ -59,6 +59,16 @@ then the driver will return V4L2_STD_UNKNOWN. When 
detection is not
  possible or fails, the set must contain all standards supported by the
  current video input or output.</para>

+<para>Please note that drivers will <emphasis>never</emphasis> switch 
the video standard
+automatically if a new video standard is detected. Instead, drivers 
will send the
+<constant>V4L2_EVENT_SOURCE_CHANGE</constant> event (if they support 
this) and expect
+that userspace will take action by calling 
<constant>VIDIOC_QUERYSTD</constant>.
+The reason is that a new video standard can mean different buffer sizes 
as well, and you
+cannot change buffer sizes on the fly. In general, applications that 
receive the
+Source Change event will have to call 
<constant>VIDIOC_QUERYSTD</constant>,
+and if the detected video standard is valid they will have to stop 
streaming, set the new
+standard, allocate new buffers and start streaming again.</para>
+
    </refsect1>

    <refsect1>
-- 
2.6.4

