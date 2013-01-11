Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1303 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3AKN5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:57:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCHv3 3/3] DocBook: mention that EINVAL can be returned for invalid menu indices.
Date: Fri, 11 Jan 2013 14:57:02 +0100
Message-Id: <30dc44447961be7e7d2a24ef152bfdeae48c8b8a.1357912476.git.hans.verkuil@cisco.com>
In-Reply-To: <1357912622-24736-1-git-send-email-hverkuil@xs4all.nl>
References: <1357912622-24736-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <66daf776429bc348c156f96eb36141588087783b.1357912476.git.hans.verkuil@cisco.com>
References: <66daf776429bc348c156f96eb36141588087783b.1357912476.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The documentation suggested that if the control value is wrong only
ERANGE can be returned. But in some cases (an invalid menu index)
EINVAL can also be returned. Clarify this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml      |    8 ++++++--
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |   10 +++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml b/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
index 12b1d05..ee2820d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml
@@ -64,7 +64,9 @@ return an &EINVAL;. When the <structfield>value</structfield> is out
 of bounds drivers can choose to take the closest valid value or return
 an &ERANGE;, whatever seems more appropriate. However,
 <constant>VIDIOC_S_CTRL</constant> is a write-only ioctl, it does not
-return the actual new value.</para>
+return the actual new value. If the <structfield>value</structfield>
+is inappropriate for the control (e.g. if it refers to an unsupported
+menu index of a menu control), then &EINVAL; is returned as well.</para>
 
     <para>These ioctls work only with user controls. For other
 control classes the &VIDIOC-G-EXT-CTRLS;, &VIDIOC-S-EXT-CTRLS; or
@@ -99,7 +101,9 @@ application.</entry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-control; <structfield>id</structfield> is
-invalid.</para>
+invalid or the <structfield>value</structfield> is inappropriate for
+the given control (i.e. if a menu item is selected that is not supported
+by the driver according to &VIDIOC-QUERYMENU;).</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 42ffbff..4e16112 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -106,7 +106,9 @@ value or if an error is returned.</para>
 &EINVAL;. When the value is out of bounds drivers can choose to take
 the closest valid value or return an &ERANGE;, whatever seems more
 appropriate. In the first case the new value is set in
-&v4l2-ext-control;.</para>
+&v4l2-ext-control;. If the new control value is inappropriate (e.g. the
+given menu index is not supported by the menu control), then this will
+also result in an &EINVAL; error.</para>
 
     <para>The driver will only set/get these controls if all control
 values are correct. This prevents the situation where only some of the
@@ -331,8 +333,10 @@ These controls are described in <xref
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-ext-control; <structfield>id</structfield>
-is invalid or the &v4l2-ext-controls;
-<structfield>ctrl_class</structfield> is invalid. This error code is
+is invalid, the &v4l2-ext-controls;
+<structfield>ctrl_class</structfield> is invalid, or the &v4l2-ext-control;
+<structfield>value</structfield> was inappropriate (e.g. the given menu
+index is not supported by the driver). This error code is
 also returned by the <constant>VIDIOC_S_EXT_CTRLS</constant> and
 <constant>VIDIOC_TRY_EXT_CTRLS</constant> ioctls if two or more
 control values are in conflict.</para>
-- 
1.7.10.4

