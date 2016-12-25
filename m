Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:62951 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753180AbcLYSyQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:54:16 -0500
Subject: [PATCH 19/19] [media] uvc_video: Add some spaces for better code
 readability
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, trivial@kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <f79cea5b-ed9a-b1a1-e9bb-e4518a95e2f1@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:54:05 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:00:29 +0100

Use space characters at some source code places according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index aba21e0abf02..9c0b8b325157 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1814,7 +1814,7 @@ int uvc_video_init(struct uvc_streaming *stream)
 	 * available format otherwise.
 	 */
 	for (i = stream->nformats; i > 0; --i) {
-		format = &stream->format[i-1];
+		format = &stream->format[i - 1];
 		if (format->index == probe->bFormatIndex)
 			break;
 	}
@@ -1831,7 +1831,7 @@ int uvc_video_init(struct uvc_streaming *stream)
 	 * descriptor is not found, use the first available frame.
 	 */
 	for (i = format->nframes; i > 0; --i) {
-		frame = &format->frame[i-1];
+		frame = &format->frame[i - 1];
 		if (frame->bFrameIndex == probe->bFrameIndex)
 			break;
 	}
-- 
2.11.0

