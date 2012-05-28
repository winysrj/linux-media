Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2686 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2E1Kqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 06:46:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 6/6] V4L2 spec: clarify a few modulator issues.
Date: Mon, 28 May 2012 12:46:45 +0200
Message-Id: <6a1402e7817616461f18f4c6cd053afaaf3cca58.1338201853.git.hans.verkuil@cisco.com>
In-Reply-To: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <e874de9bb774639e0ea58054862853b9703dc2aa.1338201853.git.hans.verkuil@cisco.com>
References: <e874de9bb774639e0ea58054862853b9703dc2aa.1338201853.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 4101aeb..b91d253 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -464,14 +464,14 @@ The <structfield>type</structfield> field of the respective
 <structfield>tuner</structfield> field contains the index number of
 the tuner.</para>
 
-      <para>Radio devices have exactly one tuner with index zero, no
+      <para>Radio input devices have exactly one tuner with index zero, no
 video inputs.</para>
 
       <para>To query and change tuner properties applications use the
 &VIDIOC-G-TUNER; and &VIDIOC-S-TUNER; ioctl, respectively. The
 &v4l2-tuner; returned by <constant>VIDIOC_G_TUNER</constant> also
 contains signal status information applicable when the tuner of the
-current video input, or a radio tuner is queried. Note that
+current video or radio input is queried. Note that
 <constant>VIDIOC_S_TUNER</constant> does not switch the current tuner,
 when there is more than one at all. The tuner is solely determined by
 the current video input. Drivers must support both ioctls and set the
@@ -491,8 +491,17 @@ the modulator. The <structfield>type</structfield> field of the
 respective &v4l2-output; returned by the &VIDIOC-ENUMOUTPUT; ioctl is
 set to <constant>V4L2_OUTPUT_TYPE_MODULATOR</constant> and its
 <structfield>modulator</structfield> field contains the index number
-of the modulator. This specification does not define radio output
-devices.</para>
+of the modulator.</para>
+
+      <para>Radio output devices have exactly one modulator with index
+zero, no video outputs.</para>
+
+      <para>A video or radio device cannot support both a tuner and a
+modulator. Two separate device nodes will have to be used for such
+hardware, one that supports the tuner functionality and one that supports
+the modulator functionality. The reason is a limitation with the
+&VIDIOC-S-FREQUENCY; ioctl where you cannot specify whether the frequency
+is for a tuner or a modulator.</para>
 
       <para>To query and change modulator properties applications use
 the &VIDIOC-G-MODULATOR; and &VIDIOC-S-MODULATOR; ioctl. Note that
-- 
1.7.10

