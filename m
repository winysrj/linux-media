Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:48928 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab2KBNJ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Nov 2012 09:09:59 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 4/4] [media] vivi: Optimize precalculate_line()
Date: Fri,  2 Nov 2012 17:10:33 +0400
Message-Id: <23c010fd06bf4378ee46820e4ce91b5f02dcec07.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
References: <cover.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
References: <cover.1351861552.git.kirr@mns.spb.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

precalculate_line() is not very high on profile, but it calls expensive
gen_twopix(), so let's polish it too:

    call gen_twopix() only once for every color bar and then distribute
    the result.

before:

    # cmdline : /home/kirr/local/perf/bin/perf record -g -a sleep 20
    #
    # Samples: 46K of event 'cycles'
    # Event count (approx.): 15574200568
    #
    # Overhead          Command         Shared Object
    # ........  ...............  ....................
    #
        27.99%             rawv  libc-2.13.so          [.] __memcpy_ssse3
        23.29%           vivi-*  [kernel.kallsyms]     [k] memcpy
        10.30%             Xorg  [unknown]             [.] 0xa75c98f8
         5.34%           vivi-*  [vivi]                [k] gen_text.constprop.6
         4.61%             rawv  [vivi]                [k] gen_twopix
         2.64%             rawv  [vivi]                [k] precalculate_line
         1.37%          swapper  [kernel.kallsyms]     [k] read_hpet

after:

    # cmdline : /home/kirr/local/perf/bin/perf record -g -a sleep 20
    #
    # Samples: 45K of event 'cycles'
    # Event count (approx.): 15561769214
    #
    # Overhead          Command         Shared Object
    # ........  ...............  ....................
    #
        30.73%             rawv  libc-2.13.so          [.] __memcpy_ssse3
        26.78%           vivi-*  [kernel.kallsyms]     [k] memcpy
        10.68%             Xorg  [unknown]             [.] 0xa73015e9
         5.55%           vivi-*  [vivi]                [k] gen_text.constprop.6
         1.36%          swapper  [kernel.kallsyms]     [k] read_hpet
         0.96%             Xorg  [kernel.kallsyms]     [k] read_hpet
         ...
         0.16%             rawv  [vivi]                [k] precalculate_line
         ...
         0.14%             rawv  [vivi]                [k] gen_twopix

(i.e. gen_twopix and precalculate_line overheads are almost gone)

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/platform/vivi.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 0272d07..37d0af8 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -517,12 +517,22 @@ static void gen_twopix(struct vivi_dev *dev, u8 *buf, int colorpos, bool odd)
 
 static void precalculate_line(struct vivi_dev *dev)
 {
-	int w;
-
-	for (w = 0; w < dev->width * 2; w++) {
-		int colorpos = w / (dev->width / 8) % 8;
-
-		gen_twopix(dev, dev->line + w * dev->pixelsize, colorpos, w & 1);
+	unsigned pixsize  = dev->pixelsize;
+	unsigned pixsize2 = 2*pixsize;
+	int colorpos;
+	u8 *pos;
+
+	for (colorpos = 0; colorpos < 16; ++colorpos) {
+		u8 pix[8];
+		int wstart =  colorpos    * dev->width / 8;
+		int wend   = (colorpos+1) * dev->width / 8;
+		int w;
+
+		gen_twopix(dev, &pix[0],        colorpos % 8, 0);
+		gen_twopix(dev, &pix[pixsize],  colorpos % 8, 1);
+
+		for (w = wstart/2*2, pos = dev->line + w*pixsize; w < wend; w += 2, pos += pixsize2)
+			memcpy(pos, pix, pixsize2);
 	}
 }
 
-- 
1.8.0.316.g291341c

