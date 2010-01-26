Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:61598 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0AZViD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 16:38:03 -0500
Message-ID: <4B5F60B0.7090709@freemail.hu>
Date: Tue, 26 Jan 2010 22:37:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] uvcvideo: check minimum border of control
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check also the minimum border of a value before setting it
to a control value.

See also http://bugzilla.kernel.org/show_bug.cgi?id=12824 .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
 drivers/media/video/uvc/uvc_ctrl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1068,6 +1068,8 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 				    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));

 		xctrl->value = min + (xctrl->value - min + step/2) / step * step;
+		if (xctrl->value < min)
+			xctrl->value = min;
 		if (xctrl->value > max)
 			xctrl->value = max;
 		value = xctrl->value;

