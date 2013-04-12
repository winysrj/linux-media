Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:51613 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3DLV3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 17:29:01 -0400
Received: by mail-yh0-f45.google.com with SMTP id 26so492049yhr.32
        for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 14:28:58 -0700 (PDT)
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [PATCH] solo6x10: Update the encoder mode on VIDIOC_S_FMT
Date: Fri, 12 Apr 2013 18:28:33 -0300
Message-Id: <1365802113-23730-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index 6147bb2..d132d3b 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -872,6 +872,7 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 	if (pix->priv)
 		solo_enc->type = SOLO_ENC_TYPE_EXT;
 	 */
+	solo_update_mode(solo_enc);
 	return 0;
 }
 
-- 
1.8.2

