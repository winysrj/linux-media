Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1182 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246AbaFLLys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 21/34] DocBook media: update control section.
Date: Thu, 12 Jun 2014 13:52:53 +0200
Message-Id: <f28ad7d1aba691d4d3c0da425de23357a25ede96.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the support for compound types in controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 73bae13..e7b8b72 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -660,16 +660,29 @@ supported.</para>
 &v4l2-control;, except for the fact that it also allows for 64-bit
 values and pointers to be passed.</para>
 
+      <para>Since the &v4l2-ext-control; supports pointers it is now
+also possible to have controls with compound types such as N-dimensional arrays
+and/or structures. You need to specify the <constant>V4L2_CTRL_FLAG_NEXT_COMPOUND</constant>
+when enumerating controls to actually be able to see such compound controls.
+In other words, these controls with compound types should only be used
+programmatically.</para>
+
+      <para>Since such compound controls need to expose more information
+about themselves than is possible with &VIDIOC-QUERYCTRL; the
+&VIDIOC-QUERY-EXT-CTRL; ioctl was added. In particular, this ioctl gives
+the dimensions of the N-dimensional array if this control consists of more than
+one element.</para>
+
       <para>It is important to realize that due to the flexibility of
 controls it is necessary to check whether the control you want to set
 actually is supported in the driver and what the valid range of values
-is. So use the &VIDIOC-QUERYCTRL; and &VIDIOC-QUERYMENU; ioctls to
-check this. Also note that it is possible that some of the menu
-indices in a control of type <constant>V4L2_CTRL_TYPE_MENU</constant>
-may not be supported (<constant>VIDIOC_QUERYMENU</constant> will
-return an error). A good example is the list of supported MPEG audio
-bitrates. Some drivers only support one or two bitrates, others
-support a wider range.</para>
+is. So use the &VIDIOC-QUERYCTRL; (or &VIDIOC-QUERY-EXT-CTRL;) and
+&VIDIOC-QUERYMENU; ioctls to check this. Also note that it is possible
+that some of the menu indices in a control of type
+<constant>V4L2_CTRL_TYPE_MENU</constant> may not be supported
+(<constant>VIDIOC_QUERYMENU</constant> will return an error). A good
+example is the list of supported MPEG audio bitrates. Some drivers only
+support one or two bitrates, others support a wider range.</para>
 
       <para>
 	All controls use machine endianness.
-- 
2.0.0.rc0

