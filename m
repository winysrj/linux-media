Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60225 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423173AbcFMROH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 13:14:07 -0400
Received: from [192.168.1.20] ([188.108.122.80]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0LiY3U-1biGHe3wJY-00cepD for
 <linux-media@vger.kernel.org>; Mon, 13 Jun 2016 19:14:03 +0200
To: linux-media@vger.kernel.org
From: Andreas Matthies <a.matthies@gmx.net>
Subject: LinuxTv doesn't build anymore after upgrading Ubuntu to 3.13.0-88
Message-ID: <575EE9D9.3030502@gmx.net>
Date: Mon, 13 Jun 2016 19:14:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

Seems that there's a problem in v4.6_i2c_mux.patch. After Ubuntu was 
upgraded to 3.13.0-88 I tried to rebuild the tv drivers and get

make[2]: Entering directory `/home/andreas/Downloads/media_build/linux'
Applying patches for kernel 3.13.0-88-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v4.6_i2c_mux.patch
2 out of 23 hunks FAILED
make[2]: *** [apply_patches] Error 1

Here's the reject file rtl2832.c.rej:
--- drivers/media/dvb-frontends/rtl2832.c
+++ drivers/media/dvb-frontends/rtl2832.c
@@ -1124,7 +1280,7 @@
      else
          u8tmp = 0x00;

-    ret = regmap_update_bits(dev->regmap, 0x061, 0xc0, u8tmp);
+    ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
      if (ret)
          goto err;

@@ -1159,14 +1315,14 @@
      buf[1] = (dev->filters >>  8) & 0xff;
      buf[2] = (dev->filters >> 16) & 0xff;
      buf[3] = (dev->filters >> 24) & 0xff;
-    ret = regmap_bulk_write(dev->regmap, 0x062, buf, 4);
+    ret = rtl2832_bulk_write(client, 0x062, buf, 4);
      if (ret)
          goto err;

      /* add PID */
      buf[0] = (pid >> 8) & 0xff;
      buf[1] = (pid >> 0) & 0xff;
-    ret = regmap_bulk_write(dev->regmap, 0x066 + 2 * index, buf, 2);
+    ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
      if (ret)
          goto err;

And here's what the source file contains for the first reject:
...
     else
         u8tmp = 0x00;

     if (dev->slave_ts)
         ret = regmap_update_bits(dev->regmap, 0x021, 0xc0, u8tmp);
     else
         ret = regmap_update_bits(dev->regmap, 0x061, 0xc0, u8tmp);
     if (ret)
         goto err;
...

Hope you can make the drivers compile again soon.

. Andreas



