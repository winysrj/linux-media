Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52260 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbcEJDGi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2016 23:06:38 -0400
From: Helen Koike <helen.koike@collabora.co.uk>
To: linux-media@vger.kernel.org, ezequiel@vanguardiasur.com.ar,
	hans.verkuil@cisco.com, mchehab@osg.samsung.com
Cc: Helen Koike <helen.koike@collabora.co.uk>
Subject: [PATCH] [media] stk1160: Check *nplanes in queue_setup
Date: Tue, 10 May 2016 00:06:14 -0300
Message-Id: <1462849574-15334-1-git-send-email-helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If *nplanes is not zero, it should use the requested size if valid

Signed-off-by: Helen Koike <helen.koike@collabora.co.uk>
---
 drivers/media/usb/stk1160/stk1160-v4l.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 77131fd..7ddbc02 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -680,6 +680,9 @@ static int queue_setup(struct vb2_queue *vq,
 	*nbuffers = clamp_t(unsigned int, *nbuffers,
 			STK1160_MIN_VIDEO_BUFFERS, STK1160_MAX_VIDEO_BUFFERS);
 
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
+
 	/* This means a packed colorformat */
 	*nplanes = 1;
 
-- 
1.9.1

