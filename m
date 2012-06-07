Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:29569 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2FGQcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 12:32:10 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-70.cisco.com [10.54.92.70])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q57GW82u015321
	for <linux-media@vger.kernel.org>; Thu, 7 Jun 2012 16:32:08 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.5] And another regression :-(
Date: Thu, 7 Jun 2012 18:32:07 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206071832.07246.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now query/enum_dv_timings finally work again.

The timings API patches and the core ioctl changes clearly sailed right past
each other without realizing that both needed to adapt to the other.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 5ccbd46..1500208 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -679,6 +679,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset);
 	SET_VALID_IOCTL(ops, VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings);
 	SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
+	SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
+	SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings);
 	/* yes, really vidioc_subscribe_event */
 	SET_VALID_IOCTL(ops, VIDIOC_DQEVENT, vidioc_subscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_SUBSCRIBE_EVENT, vidioc_subscribe_event);
