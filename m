Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2036 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab1FNHOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 06/10] feature-removal-schedule: change in how radio device nodes are handled.
Date: Tue, 14 Jun 2011 09:14:38 +0200
Message-Id: <80ede17446fe736640549d37f8888e9de8a4405a.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
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

