Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:48907 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab2KBNJy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Nov 2012 09:09:54 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 2/4] [media] vivi: vivi_dev->line[] was not aligned
Date: Fri,  2 Nov 2012 17:10:31 +0400
Message-Id: <483c58f72b5549ba5d8558ba4621c2489f231668.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
References: <cover.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
References: <cover.1351861552.git.kirr@mns.spb.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Though dev->line[] is u8 array we work with it as with u16, u24 or u32
pixels, and also pass it to memcpy() and it's better to align it to at
least 4.

Before the patch, on x86 offsetof(vivi_dev, line) was 1003 and after
patch it is 1004.

There is slight performance increase, but I think is is slight, only
because we start copying not from line[0]:

    ---- 8< ---- drivers/media/platform/vivi.c
    static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
    {
            ...

            for (h = 0; h < hmax; h++)
                    memcpy(vbuf + h * wmax * dev->pixelsize,
                           dev->line + (dev->mv_count % wmax) * dev->pixelsize,
                           wmax * dev->pixelsize);

before:

    # cmdline : /home/kirr/local/perf/bin/perf record -g -a sleep 20
    #
    # Samples: 49K of event 'cycles'
    # Event count (approx.): 16799780016
    #
    # Overhead          Command         Shared Object
    # ........  ...............  ....................
    #
        27.51%             rawv  libc-2.13.so          [.] __memcpy_ssse3
        23.77%           vivi-*  [kernel.kallsyms]     [k] memcpy
         9.96%             Xorg  [unknown]             [.] 0xa76f5e12
         4.94%           vivi-*  [vivi]                [k] gen_text.constprop.6
         4.44%             rawv  [vivi]                [k] gen_twopix
         3.17%           vivi-*  [vivi]                [k] vivi_fillbuff
         2.45%             rawv  [vivi]                [k] precalculate_line
         1.20%          swapper  [kernel.kallsyms]     [k] read_hpet

    23.77%           vivi-*  [kernel.kallsyms]     [k] memcpy
                     |
                     --- memcpy
                        |
                        |--99.28%-- vivi_fillbuff
                        |          vivi_thread
                        |          kthread
                        |          ret_from_kernel_thread
                         --0.72%-- [...]
after:

    # cmdline : /home/kirr/local/perf/bin/perf record -g -a sleep 20
    #
    # Samples: 49K of event 'cycles'
    # Event count (approx.): 16475832370
    #
    # Overhead          Command           Shared Object
    # ........  ...............  ......................
    #
        29.07%             rawv  libc-2.13.so            [.] __memcpy_ssse3
        20.57%           vivi-*  [kernel.kallsyms]       [k] memcpy
        10.20%             Xorg  [unknown]               [.] 0xa7301494
         5.16%           vivi-*  [vivi]                  [k] gen_text.constprop.6
         4.43%             rawv  [vivi]                  [k] gen_twopix
         4.36%           vivi-*  [vivi]                  [k] vivi_fillbuff
         2.42%             rawv  [vivi]                  [k] precalculate_line
         1.33%          swapper  [kernel.kallsyms]       [k] read_hpet

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/platform/vivi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index cb2337e..ddcc712 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -242,7 +242,7 @@ struct vivi_dev {
 	unsigned int		   field_count;
 
 	u8			   bars[9][3];
-	u8			   line[MAX_WIDTH * 8];
+	u8			   line[MAX_WIDTH * 8] __attribute__((__aligned__(4)));
 	unsigned int		   pixelsize;
 	u8			   alpha_component;
 	u32			   textfg, textbg;
-- 
1.8.0.316.g291341c

