Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43380 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeIPBer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:47 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2 06/14] media: au0828: use signals instead of hardcoding a pad number
Date: Sat, 15 Sep 2018 17:14:21 -0300
Message-Id: <a03f927673a3f430db842c179fa5e91cd6ef6d9b.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When creating the audio link, use pad signals, instead of
hardcoding using the pad index number.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index cd363a2100d4..4729b2a2f21c 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -266,11 +266,13 @@ static void au0828_media_graph_notify(struct media_entity *new,
 
 create_link:
 	if (decoder && mixer) {
-		ret = media_create_pad_link(decoder,
-					    DEMOD_PAD_AUDIO_OUT,
-					    mixer, 0,
-					    MEDIA_LNK_FL_ENABLED);
-		if (ret)
+		ret = media_get_pad_index(decoder, false,
+					  PAD_SIGNAL_AUDIO);
+		if (ret >= 0)
+			ret = media_create_pad_link(decoder, ret,
+						    mixer, 0,
+						    MEDIA_LNK_FL_ENABLED);
+		if (ret < 0)
 			dev_err(&dev->usbdev->dev,
 				"Mixer Pad Link Create Error: %d\n", ret);
 	}
-- 
2.17.1
