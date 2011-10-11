Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40573 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1JKPJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 11:09:29 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so10739016wwf.1
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 08:09:28 -0700 (PDT)
From: Enrico Butera <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Enrico Butera <ebutera@users.berlios.de>,
	linux-media@vger.kernel.org
Subject: [RFC 2/3] omap3isp: ispvideo: export isp_video_mbus_to_pix
Date: Tue, 11 Oct 2011 17:08:54 +0200
Message-Id: <1318345735-16778-3-git-send-email-ebutera@users.berlios.de>
In-Reply-To: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
References: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function will be used in ispccdc.

Signed-off-by: Enrico Butera <ebutera@users.berlios.de>
---
 drivers/media/video/omap3isp/ispvideo.c |    2 +-
 drivers/media/video/omap3isp/ispvideo.h |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index cc73375..d59f886 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -164,7 +164,7 @@ static bool isp_video_is_shiftable(enum v4l2_mbus_pixelcode in,
  *
  * Return the number of padding bytes at end of line.
  */
-static unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
 					  const struct v4l2_mbus_framefmt *mbus,
 					  struct v4l2_pix_format *pix)
 {
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index 52fe46b..5fa8fd7 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -200,7 +200,9 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video,
 					      unsigned int error);
 void omap3isp_video_resume(struct isp_video *video, int continuous);
 struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
-
+extern unsigned int isp_video_mbus_to_pix(const struct isp_video *video,
+				  const struct v4l2_mbus_framefmt *mbus,
+				  struct v4l2_pix_format *pix);
 const struct isp_format_info *
 omap3isp_video_format_info(enum v4l2_mbus_pixelcode code);
 
-- 
1.7.4.1

