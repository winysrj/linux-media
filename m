Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38612 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752082AbeFJUnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 16:43:07 -0400
Received: by mail-wr0-f193.google.com with SMTP id e18-v6so10018541wrs.5
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2018 13:43:06 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brian Warner <brian.warner@samsung.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Nasser Afshin <afshin.nasser@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] Revert "[media] tvp5150: fix pad format frame height"
Date: Sun, 10 Jun 2018 22:43:02 +0200
Message-Id: <20180610204302.1825-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 0866df8dffd514185bfab0d205db76e4c02cf1e4.

The v4l uAPI documentation [0] makes clear that in the case of interlaced
video (i.e: field is V4L2_FIELD_ALTERNATE) the height refers to the number
of lines in the field and not the number of lines in the full frame (which
is twice the field height for interlaced formats).

So the original height calculation was correct, and it shouldn't had been
changed by the mentioned commit.

[0]:https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/subdev-formats.html

Fixes: 0866df8dffd5 ("[media] tvp5150: fix pad format frame height")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

---

 drivers/media/i2c/tvp5150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 038e4ae0fe8..3ae543559fe 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -872,7 +872,7 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	f = &format->format;
 
 	f->width = decoder->rect.width;
-	f->height = decoder->rect.height;
+	f->height = decoder->rect.height / 2;
 
 	f->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	f->field = V4L2_FIELD_ALTERNATE;
-- 
2.17.1
