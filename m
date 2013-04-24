Return-path: <linux-media-owner@vger.kernel.org>
Received: from s250.sam-solutions.net ([217.21.49.219]:56623 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab3DXHtq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 03:49:46 -0400
Message-ID: <517787DC.5070309@sam-solutions.com>
Date: Wed, 24 Apr 2013 10:21:00 +0300
From: Andrei Andreyanau <a.andreyanau@sam-solutions.com>
Reply-To: a.andreyanau@sam-solutions.com
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: mt9p031 camera driver issue
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi!
I have found interesting issue with mt9p031 camera driver.
As far as I got the value of hblank in the kernel driver is not
calculated correctly. According to the datasheet, the minimum horizontal
blanking value should be calculated using the following formula:
346 x (Row_Bin + 1) + 64 + (Wdc / 2)
If I'm right, it should look like in the code attached.
Also I wonder why it is decided to use the default value for vblank,
when it's said that is also should be calculated like this:
vblank = max(8, SW - H) + 1,
where SW - shutter width, H - output image height.
Also, there might be an issue with the calculation of xskip/yskip within
the same function (mt9p031_set_params).

xskip = DIV_ROUND_CLOSEST(crop->width, format->width);
yskip = DIV_ROUND_CLOSEST(crop->height, format->height);

As far as I got, these values are calculated using the predefined macros,
that rounds the calculated value to the nearest integer number. I faced
with the problem, that these values rounded correctly when the result
is > 1 (e.g. 1,5 will be rounded to 1).
But what concerns the value 0,8 it will be rounded to 0 by this function
(DIV_ROUND_CLOSEST). Could you please confirm this issue?

With best regards,
Andrei Andreyanau

Signed-off-by: Andrei Andreyanau <a.andreyanau@sam-solutions.com>
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e328332..838b300 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -368,7 +368,7 @@ static int mt9p031_set_params(struct mt9p031 *mt9p031)
 	/* Blanking - use minimum value for horizontal blanking and default
 	 * value for vertical blanking.
 	 */
-	hblank = 346 * ybin + 64 + (80 >> min_t(unsigned int, xbin, 3));
+	hblank = 346 * (xbin + 1) + 64 + ((80 >> clamp_t(unsigned int, xbin,
0, 3)) / 2);
 	vblank = MT9P031_VERTICAL_BLANK_DEF;

 	ret = mt9p031_write(client, MT9P031_HORIZONTAL_BLANK, hblank - 1);
