Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42585 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaAUCnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 21:43:16 -0500
Received: by mail-pb0-f52.google.com with SMTP id jt11so5691560pbb.39
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 18:43:15 -0800 (PST)
Message-ID: <52DDDEBF.1090603@gmail.com>
Date: Tue, 21 Jan 2014 10:43:11 +0800
From: KS Ng - dmbth <hk.dmbth@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Patch for max2165.c to correct invalid max frequency
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Maintainers,

I would like to request for a patch as captioned below to correct the 
invalid max. frequency as currently set in max2165.c. It's resulting in 
a new TV channel using frequency 802MHz not receivable. I've tested it 
OK for my dvb adapter.

Thanks,
K.S. Ng

diff -r -u a/linux/drivers/media/tuners/max2165.c 
b/linux/drivers/media/tuners/max2165.c
--- a/linux/drivers/media/tuners/max2165.c    2014-01-17 
08:46:25.000000000 +0800
+++ b/linux/drivers/media/tuners/max2165.c    2014-01-17 
08:47:06.000000000 +0800
@@ -385,7 +385,7 @@
      .info = {
          .name           = "Maxim MAX2165",
          .frequency_min  = 470000000,
-        .frequency_max  = 780000000,
+        .frequency_max  = 868000000,
          .frequency_step =     50000,
      },

