Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:61729 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbZJSVzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 17:55:48 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1704001fga.1
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2009 14:55:52 -0700 (PDT)
Subject: [PATCH] sn9c20x: fixed exposure control for HV7131R sensor
From: German Galkin <galkinga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain
Date: Mon, 19 Oct 2009 23:55:49 +0200
Message-Id: <1255989349.4536.22.camel@pexis.zodiac.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Made the range of exposure values (0-0x1770) distribute evenly through
HV7131R's exposure control bytes.

Signed-off-by: German Galkin <galkinga@gmail.com>
---
diff --git a/drivers/media/video/gspca/sn9c20x.c
b/drivers/media/video/gspca/sn9c20x.c
index 99632a7..f173b35 100644
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -1656,9 +1656,9 @@ static int set_exposure(struct gspca_dev
*gspca_dev)
        case SENSOR_HV7131R:
                exp[0] |= (4 << 4);
                exp[2] = 0x25;
-               exp[3] = ((sd->exposure * 0xffffff) / 0xffff) >> 16;
-               exp[4] = ((sd->exposure * 0xffffff) / 0xffff) >> 8;
-               exp[5] = ((sd->exposure * 0xffffff) / 0xffff) & 0xff;
+               exp[3] = (sd->exposure >> 5) & 0xff;
+               exp[4] = (sd->exposure << 3) & 0xff;
+               exp[5] = 0;
                break;
        default:
                return 0;


