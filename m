Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32800 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933663AbcLSRNA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Dec 2016 12:13:00 -0500
From: Santosh Kumar Singh <kumar.san1093@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Kumar Singh <kumar.san1093@gmail.com>
Subject: [PATCH] ivtv: Clean up file handle in open() error path.
Date: Mon, 19 Dec 2016 22:42:07 +0530
Message-Id: <1482167527-4831-1-git-send-email-kumar.san1093@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix to avoid possible exit file handle in error paths.

Signed-off-by: Santosh Kumar Singh <kumar.san1093@gmail.com>
---
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index a26f980..d0d2c93 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -174,6 +174,7 @@ static int snd_ivtv_pcm_capture_open(struct snd_pcm_substream *substream)
 	/* See if the stream is available */
 	if (ivtv_claim_stream(&item, item.type)) {
 		/* No, it's already in use */
+		v4l2_fh_exit(&item.fh);
 		snd_ivtv_unlock(itvsc);
 		return -EBUSY;
 	}
-- 
1.9.1

