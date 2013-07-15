Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55616 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab3GOTMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 15:12:25 -0400
Received: by mail-lb0-f178.google.com with SMTP id y6so9480474lbh.23
        for <linux-media@vger.kernel.org>; Mon, 15 Jul 2013 12:12:23 -0700 (PDT)
To: mchehab@redhat.com, linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: [PATCH] ml86v7667: override default field interlace order
Cc: matsu@igel.co.jp, linux-sh@vger.kernel.org,
	vladimir.barinov@cogentembedded.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Mon, 15 Jul 2013 23:12:21 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307152312.22371.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

ML86V7667 always transmits top field first for both PAL and  NTSC -- that makes
application incorrectly  treat interlaced  fields when relying on the standard.
Hence we must set V4L2_FIELD_INTERLACED_TB format explicitly.

Reported-by: Katsuya MATSUBARA <matsu@igel.co.jp>
Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
[Sergei: added a comment.]
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo.

 drivers/media/i2c/ml86v7667.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: media_tree/drivers/media/i2c/ml86v7667.c
===================================================================
--- media_tree.orig/drivers/media/i2c/ml86v7667.c
+++ media_tree/drivers/media/i2c/ml86v7667.c
@@ -209,7 +209,8 @@ static int ml86v7667_mbus_fmt(struct v4l
 
 	fmt->code = V4L2_MBUS_FMT_YUYV8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	fmt->field = V4L2_FIELD_INTERLACED;
+	/* The top field is always transferred first by the chip */
+	fmt->field = V4L2_FIELD_INTERLACED_TB;
 	fmt->width = 720;
 	fmt->height = priv->std & V4L2_STD_525_60 ? 480 : 576;
 
