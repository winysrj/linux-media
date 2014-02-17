Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4740 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBQLo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 06:44:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de
Subject: [REVIEW PATCH 0/3] Add g_tvnorms video op
Date: Mon, 17 Feb 2014 12:44:11 +0100
Message-Id: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series addresses a problem that was exposed by commit a5338190e.
The issue is that soc_camera implements s/g_std ioctls and just forwards
those to the subdev, whether or not the subdev actually implements them.

In addition, tvnorms is never set, so even if the subdev implements the
s/g_std the ENUMSTD ioctl will not report anything.

The solution is to add a g_tvnorms video op to v4l2_subdev (there was already
a g_tvnorms_output, so that fits nicely) and to let soc_camera call that so
the video_device tvnorms field is set correctly.

Before registering the video node it will check if tvnorms == 0 and disable
the STD ioctls if that's the case.

While this problem cropped up in soc_camera it is really a problem for any
generic bridge driver, so this is useful to have.

Note that it is untested. The plan is that Laurent tests and Guennadi pulls
it into his tree.

Regards,

	Hans

