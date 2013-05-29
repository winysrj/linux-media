Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1777 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965687Ab3E2LBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 25/38] DocBook: remove obsolete note from the dbg_g_register doc.
Date: Wed, 29 May 2013 12:59:58 +0200
Message-Id: <1369825211-29770-26-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
index 8d554db..b3f6100 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
@@ -105,15 +105,6 @@ present with the &VIDIOC-DBG-G-CHIP-INFO; ioctl.</para>
 <constant>V4L2_CHIP_MATCH_SUBDEV</constant>,
 <structfield>match.addr</structfield> selects the nth sub-device.</para>
 
-    <note>
-      <title>Success not guaranteed</title>
-
-      <para>Due to a flaw in the Linux &i2c; bus driver these ioctls may
-return successfully without actually reading or writing a register. To
-catch the most likely failure we recommend a &VIDIOC-DBG-G-CHIP-INFO;
-call confirming the presence of the selected &i2c; chip.</para>
-    </note>
-
     <para>These ioctls are optional, not all drivers may support them.
 However when a driver supports these ioctls it must also support
 &VIDIOC-DBG-G-CHIP-INFO;. Conversely it may support
-- 
1.7.10.4

