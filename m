Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:60478 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754302AbcLYSwD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:52:03 -0500
Subject: [PATCH 18/19] [media] uvc_video: Enclose an expression for the sizeof
 operator by parentheses
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, trivial@kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <73208c2d-38b6-425c-88e6-7cb9706d4881@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:51:55 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 18:50:35 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: sizeof *ctrl should be sizeof(*ctrl)

Thus fix the affected source code place.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 61320ef82553..aba21e0abf02 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -191,7 +191,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		uvc_warn_once(stream->dev,
 			      UVC_WARN_MINMAX,
 			      "UVC non compliance - GET_MIN/MAX(PROBE) incorrectly supported. Enabling workaround.\n");
-		memset(ctrl, 0, sizeof *ctrl);
+		memset(ctrl, 0, sizeof(*ctrl));
 		ctrl->wCompQuality = le16_to_cpup((__le16 *)data);
 		ret = 0;
 		goto out;
-- 
2.11.0

