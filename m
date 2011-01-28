Return-path: <mchehab@pedra>
Received: from antispam01.maxim-ic.com ([205.153.101.182]:36816 "EHLO
	antispam01.dummydomain.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752963Ab1A1CEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 21:04:36 -0500
Received: from terlingua.dalsemi.com (terlingua.dalsemi.com [180.0.34.46]) by antispam01.dummydomain.com with ESMTP id ejuQKcDpuzXBaaQS for <linux-media@vger.kernel.org>; Thu, 27 Jan 2011 20:04:35 -0600 (CST)
Received: from maxdalex02.maxim-ic.internal (maxdalex02.maxim-ic.internal [10.16.15.104])
	by terlingua.dalsemi.com (8.10.2/8.10.2) with ESMTP id p0S24ZI16210
	for <linux-media@vger.kernel.org>; Thu, 27 Jan 2011 20:04:35 -0600 (CST)
Subject: [PATCH] uvcvideo: Fix uvc_fixup_video_ctrl() format search
From: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 27 Jan 2011 18:04:33 -0800
Message-ID: <1296180273.17673.5.camel@svmlwks101>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The scheme used to index format in uvc_fixup_video_ctrl() is not robust:
format index is based on descriptor ordering, which does not necessarily
match bFormatIndex ordering.  Searching for first matching format will
prevent uvc_fixup_video_ctrl() from using the wrong format/frame to make
adjustments.
---
 drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 5673d67..545c029 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -89,15 +89,19 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl)
 {
-	struct uvc_format *format;
+	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
 	unsigned int i;
 
-	if (ctrl->bFormatIndex <= 0 ||
-	    ctrl->bFormatIndex > stream->nformats)
-		return;
+	for (i = 0; i < stream->nformats; ++i) {
+		if (stream->format[i].index == ctrl->bFormatIndex) {
+			format = &stream->format[i];
+			break;
+		}
+	}
 
-	format = &stream->format[ctrl->bFormatIndex - 1];
+	if (format == NULL)
+		return;
 
 	for (i = 0; i < format->nframes; ++i) {
 		if (format->frame[i].bFrameIndex == ctrl->bFrameIndex) {
-- 
1.7.3.5


