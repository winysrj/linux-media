Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51711 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933774AbaJaPJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:09:46 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 8BA0F217D3
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:07:34 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 03/10] uvcvideo: Set buffer field to V4L2_FIELD_NONE
Date: Fri, 31 Oct 2014 17:09:44 +0200
Message-Id: <1414768191-4536-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver doesn't support interlaced video, set field to
V4L2_FIELD_NONE for all vb2 buffers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index df81b9c..b9c7dee 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1021,6 +1021,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 
 		uvc_video_get_ts(&ts);
 
+		buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
 		buf->buf.v4l2_buf.sequence = stream->sequence;
 		buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
 		buf->buf.v4l2_buf.timestamp.tv_usec =
-- 
2.0.4

