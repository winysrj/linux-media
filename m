Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4971 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbaCDLbe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 06:31:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, laurent.pinchart@ideasonboard.com
Subject: [RFCv1 PATCH 0/4] add G/S_EDID support for video nodes
Date: Tue,  4 Mar 2014 12:30:55 +0100
Message-Id: <1393932659-13817-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the VIDIOC_SUBDEV_G/S_EDID and struct v4l2_subdev_edid are subdev
APIs. However, that's in reality quite annoying since for simple video
pipelines there is no need to create v4l-subdev device nodes for anything
else except for setting or getting EDIDs.

What happens in practice is that v4l2 bridge drivers add explicit support
for VIDIOC_SUBDEV_G/S_EDID themselves, just to avoid having to create
subdev device nodes just for this.

So this patch series makes the ioctls available as regular ioctls as
well. In that case the pad field should be set to 0 and the bridge driver
will fill in the right pad value internally depending on the current
input or output and pass it along to the actual subdev driver.

Regards,

	Hans

