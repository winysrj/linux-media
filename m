Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60831 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932528AbcGDNfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:35:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/7] v4l2-ioctl: zero the v4l2_bt_timings reserved field
Date: Mon,  4 Jul 2016 15:34:52 +0200
Message-Id: <1467639292-1066-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
References: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This field should be zeroed. Both for s_dv_timings and for enum_dv_timings.
In fact, for the latter anything after the pad field can be zeroed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 28e5be2..f899bf1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2541,14 +2541,14 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_DBG_S_REGISTER, v4l_dbg_s_register, v4l_print_dbg_register, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_REGISTER, v4l_dbg_g_register, v4l_print_dbg_register, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_dv_timings, bt.flags)),
 	IOCTL_INFO_STD(VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_FNC(VIDIOC_DQEVENT, v4l_dqevent, v4l_print_event, 0),
 	IOCTL_INFO_FNC(VIDIOC_SUBSCRIBE_EVENT, v4l_subscribe_event, v4l_print_event_subscription, 0),
 	IOCTL_INFO_FNC(VIDIOC_UNSUBSCRIBE_EVENT, v4l_unsubscribe_event, v4l_print_event_subscription, 0),
 	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, INFO_FL_QUEUE),
-	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, 0),
+	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, INFO_FL_CLEAR(v4l2_enum_dv_timings, pad)),
 	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
-- 
2.8.1

