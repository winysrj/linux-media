Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4730 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2FFVsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 17:48:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.5] V4L2 spec fix
Date: Wed, 6 Jun 2012 23:48:46 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206062348.46728.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two small docbook fixes:

- prepare-buf was not positioned in alphabetical order, moved to the right place.
- the format field in create_bufs had the wrong type in the documentation

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 015c561..008c2d7 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -560,6 +560,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-g-tuner;
     &sub-log-status;
     &sub-overlay;
+    &sub-prepare-buf;
     &sub-qbuf;
     &sub-querybuf;
     &sub-querycap;
@@ -567,7 +568,6 @@ and discussions on the V4L mailing list.</revremark>
     &sub-query-dv-preset;
     &sub-query-dv-timings;
     &sub-querystd;
-    &sub-prepare-buf;
     &sub-reqbufs;
     &sub-s-hw-freq-seek;
     &sub-streamon;
diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 765549f..6cd2bc3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -108,7 +108,7 @@ information.</para>
 /></entry>
 	  </row>
 	  <row>
-	    <entry>__u32</entry>
+	    <entry>struct&nbsp;v4l2_format</entry>
 	    <entry><structfield>format</structfield></entry>
 	    <entry>Filled in by the application, preserved by the driver.
 	    See <xref linkend="v4l2-format" />.</entry>
