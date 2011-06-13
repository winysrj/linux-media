Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1707 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1FMMxc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 08:53:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 8/9] feature-removal-schedule: change in how radio device nodes are handled.
Date: Mon, 13 Jun 2011 14:53:19 +0200
Message-Id: <27a47117049ec53e31cb2d55e011344aea2ee14f.1307969319.git.hans.verkuil@cisco.com>
In-Reply-To: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
References: <1307969600-31536-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6f25028df2439cef04708e3fd8d57b05662793a6.1307969319.git.hans.verkuil@cisco.com>
References: <6f25028df2439cef04708e3fd8d57b05662793a6.1307969319.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Radio devices have weird side-effects when used with combined TV/radio
tuners and the V4L2 spec is ambiguous on how it should work. This results
in inconsistent driver behavior which makes life hard for everyone.

Be more strict in when and how the switch between radio and tv mode
takes place and make sure all drivers behave the same.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/feature-removal-schedule.txt |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1a9446b..9df0e09 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -600,3 +600,25 @@ Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
 Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 
 ----------------------------
+
+What:	For VIDIOC_S_FREQUENCY the type field must match the device node's type.
+	If not, return -EINVAL.
+When:	3.2
+Why:	It makes no sense to switch the tuner to radio mode by calling
+	VIDIOC_S_FREQUENCY on a video node, or to switch the tuner to tv mode by
+	calling VIDIOC_S_FREQUENCY on a radio node. This is the first step of a
+	move to more consistent handling of tv and radio tuners.
+Who:	Hans Verkuil <hans.verkuil@cisco.com>
+
+----------------------------
+
+What:	Opening a radio device node will no longer automatically switch the
+	tuner mode from tv to radio.
+When:	3.3
+Why:	Just opening a V4L device should not change the state of the hardware
+	like that. It's very unexpected and against the V4L spec. Instead, you
+	switch to radio mode by calling VIDIOC_S_FREQUENCY. This is the second
+	and last step of the move to consistent handling of tv and radio tuners.
+Who:	Hans Verkuil <hans.verkuil@cisco.com>
+
+----------------------------
-- 
1.7.1

