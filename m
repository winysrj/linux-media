Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4571 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaCGKVa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 05:21:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, laurent.pinchart@ideasonboard.com
Subject: [REVIEWv1 PATCH 0/5] Add G/S_EDID support for video nodes
Date: Fri,  7 Mar 2014 11:21:14 +0100
Message-Id: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl>
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
well. In that case the pad field is interpreted as the input or output
index as returned by ENUMINPUT/OUTPUT.

Changes since RFCv1:

- Split off the compat32 fix (I'll queue this for 3.14)
- Interpret pad as an input or output index when used with a video node.
- S_EDID is now enabled for rx devices instead of tx.
- Fix a one tab too many.

Regards,

        Hans

