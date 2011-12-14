Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15066 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab1LNKm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 05:42:29 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW600F6XWERK140@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 10:42:27 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW600GX8WEQPP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 10:42:27 +0000 (GMT)
Date: Wed, 14 Dec 2011 11:42:07 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] doc: v4l: selection: choose pixels as units for selection
 rectangles
In-reply-to: <4EDF6DA0.5040406@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1323859327-12223-1-git-send-email-m.szyprowski@samsung.com>
References: <4EDF6DA0.5040406@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

Pixels were preferred units for selection rectangles over driver-dependent
units for almost all use cases. Therefore the units were fixed to pixels.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 Documentation/DocBook/media/v4l/selection-api.xml |   30 ++++++++------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index 46cb47a..2f0bdb4 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -84,9 +84,7 @@ configure the cropping targets before to the composing targets.</para>
 areas that can be sampled is given by the <constant> V4L2_SEL_TGT_CROP_BOUNDS
 </constant> target. It is recommended for the driver developers to put the
 top/left corner at position <constant> (0,0) </constant>.  The rectangle's
-coordinates are expressed in driver dependant units, although the coordinate
-system guarantees that if sizes of the active cropping and the active composing
-rectangles are equal then no scaling is performed.  </para>
+coordinates are expressed in pixels.</para>
 
 <para>The top left corner, width and height of the source rectangle, that is
 the area actually sampled, is given by the <constant> V4L2_SEL_TGT_CROP_ACTIVE
@@ -103,10 +101,10 @@ not later.</para>
 
 <para>The composing targets refer to a memory buffer. The limits of composing
 coordinates are obtained using <constant> V4L2_SEL_TGT_COMPOSE_BOUNDS
-</constant>.  All coordinates are expressed in natural unit for given formats.
-Pixels are highly recommended.  The rectangle's top/left corner must be located
-at position <constant> (0,0) </constant>. The width and height are equal to the
-image size set by <constant> VIDIOC_S_FMT </constant>.</para>
+</constant>.  All coordinates are expressed in pixels. The rectangle's top/left
+corner must be located at position <constant> (0,0) </constant>. The width and
+height are equal to the image size set by <constant> VIDIOC_S_FMT </constant>.
+</para>
 
 <para>The part of a buffer into which the image is inserted by the hardware is
 controlled by the <constant> V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.
@@ -145,10 +143,9 @@ the cropping targets.</para>
 <para>The cropping targets refer to the memory buffer that contains an image to
 be inserted into a video signal or graphical screen. The limits of cropping
 coordinates are obtained using <constant> V4L2_SEL_TGT_CROP_BOUNDS </constant>.
-All coordinates are expressed in natural units for a given format. Pixels are
-highly recommended.  The top/left corner is always point <constant> (0,0)
-</constant>.  The width and height is equal to the image size specified using
-<constant> VIDIOC_S_FMT </constant> ioctl.</para>
+All coordinates are expressed in pixels. The top/left corner is always point
+<constant> (0,0) </constant>.  The width and height is equal to the image size
+specified using <constant> VIDIOC_S_FMT </constant> ioctl.</para>
 
 <para>The top left corner, width and height of the source rectangle, that is
 the area from which image date are processed by the hardware, is given by the
@@ -163,13 +160,10 @@ limitations.</para>
 bounding rectangle.</para>
 
 <para>The part of a video signal or graphics display where the image is
-inserted by the hardware is controlled by <constant> V4L2_SEL_TGT_COMPOSE_ACTIVE
-</constant> target.  The rectangle's coordinates are expressed in driver
-dependant units. The only exception are digital outputs where the units are
-pixels. For other types of devices, the coordinate system guarantees that if
-sizes of the active cropping and the active composing rectangles are equal then
-no scaling is performed.  The composing rectangle must lie completely inside
-the bounds rectangle.  The driver must adjust the area to fit to the bounding
+inserted by the hardware is controlled by <constant>
+V4L2_SEL_TGT_COMPOSE_ACTIVE </constant> target.  The rectangle's coordinates
+are expressed in pixels. The composing rectangle must lie completely inside the
+bounds rectangle.  The driver must adjust the area to fit to the bounding
 limits.  Moreover, the driver can perform other adjustments according to
 hardware limitations. </para>
 
-- 
1.7.1.569.g6f426

