Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59517 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbaLSOvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 09:51:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com
Subject: [RFCv2 PATCH 00/11] v4l2 subdev: Removing duplicate video/pad ops
Date: Fri, 19 Dec 2014 15:51:25 +0100
Message-Id: <1419000696-25202-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series attempts to remove some of the duplicate video/pad ops.
The first four patches are here for completeness as a pull request has
been posted for them.

The fifth patch has been updated with Laurent's review comments.

The main change with RFCv1 is that instead of creating a
v4l2_subdev_create_pad_configs function I am adding a which field to the
enum pad ops. Bridge drivers that don't need to support pad_configs can
just pass NULL for the pad_configs and V4L2_SUBDEV_FORMAT_ACTIVE as the
'which' field value.

Patches 6-9 implement this.

Patches 10 and 11 are effectively identical to RFCv1, except for some
small changes in patch 10 to set the which field.

Missing in this patch series are:

- proper commit log messages for patches 6-11
- documentation updates for the new 'which' field.

Note that I have not tested these changes with soc-camera. I'm having
major problems getting the video input and output to work on my
Renesas board. I wonder if the current kernel board code is broken
for the SH7724 board.

Feedback for this approach is welcome.

Regards,

	Hans

