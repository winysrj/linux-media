Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49532 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbaGHQ7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 12:59:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/8] v4l2-ioctl: remove pointless INFO_FL_CLEAR.
Date: Tue,  8 Jul 2014 18:31:14 +0200
Message-Id: <1404837078-15608-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
References: <1404837078-15608-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The edid field is the last field of the struct, so there is nothing to clear.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index ede9b03..45e2ffa 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2098,8 +2098,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_QUERYMENU, v4l_querymenu, v4l_print_querymenu, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
 	IOCTL_INFO_STD(VIDIOC_G_INPUT, vidioc_g_input, v4l_print_u32, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_EDID, vidioc_g_edid, v4l_print_edid, INFO_FL_CLEAR(v4l2_edid, edid)),
-	IOCTL_INFO_STD(VIDIOC_S_EDID, vidioc_s_edid, v4l_print_edid, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_edid, edid)),
+	IOCTL_INFO_STD(VIDIOC_G_EDID, vidioc_g_edid, v4l_print_edid, 0),
+	IOCTL_INFO_STD(VIDIOC_S_EDID, vidioc_s_edid, v4l_print_edid, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_OUTPUT, vidioc_g_output, v4l_print_u32, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_OUTPUT, v4l_s_output, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
-- 
2.0.0

