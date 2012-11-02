Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:48919 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab2KBNJ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Nov 2012 09:09:57 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 3/4] [media] vivi: Move computations out of vivi_fillbuf linecopy loop
Date: Fri,  2 Nov 2012 17:10:32 +0400
Message-Id: <f562e12553132bdd90375fd0764989d34b290bf0.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
References: <cover.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
References: <cover.1351861552.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "dev->mvcount % wmax" thing was showing high in profiles (we do it
for each line which ~ 500 per frame)

           │     000010c0 <vivi_fillbuff>:
                 ...
      0,39 │ 70:┌─→mov    0x3ff4(%edi),%esi
      0,22 │ 76:│  mov    0x2a0(%edi),%eax
      0,30 │    │  mov    -0x84(%ebp),%ebx
      0,35 │    │  mov    %eax,%edx
      0,04 │    │  mov    -0x7c(%ebp),%ecx
      0,35 │    │  sar    $0x1f,%edx
      0,44 │    │  idivl  -0x7c(%ebp)
     21,68 │    │  imul   %esi,%ecx
      0,70 │    │  imul   %esi,%ebx
      0,52 │    │  add    -0x88(%ebp),%ebx
      1,65 │    │  mov    %ebx,%eax
      0,22 │    │  imul   %edx,%esi
      0,04 │    │  lea    0x3f4(%edi,%esi,1),%edx
      2,18 │    │→ call   vivi_fillbuff+0xa6
      0,74 │    │  addl   $0x1,-0x80(%ebp)
     62,69 │    │  mov    -0x7c(%ebp),%edx
      1,18 │    │  mov    -0x80(%ebp),%ecx
      0,35 │    │  add    %edx,-0x84(%ebp)
      0,61 │    │  cmp    %ecx,-0x8c(%ebp)
      0,22 │    └──jne    70

so since all variables stay the same for all iterations let's move
computations out of the loop: the abovementioned division and
"width*pixelsize" too

before:

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

after:

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
         0.79%             Xorg  [kernel.kallsyms]     [k] read_hpet
         0.64%             Xorg  [kernel.kallsyms]     [k] unix_poll
         0.45%             Xorg  [kernel.kallsyms]     [k] fget_light
         0.43%             rawv  libxcb.so.1.1.0       [.] 0x0000aae9
         0.40%            runsv  [kernel.kallsyms]     [k] ext2_try_to_allocate
         0.36%             Xorg  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
         0.31%           vivi-*  [vivi]                [k] vivi_fillbuff

(i.e. vivi_fillbuff own overhead is almost gone)

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/platform/vivi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index ddcc712..0272d07 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -579,22 +579,23 @@ static void gen_text(struct vivi_dev *dev, char *basep,
 
 static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 {
-	int wmax = dev->width;
+	int stride = dev->width * dev->pixelsize;
 	int hmax = dev->height;
 	struct timeval ts;
 	void *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 	unsigned ms;
 	char str[100];
 	int h, line = 1;
+	u8 *linestart;
 	s32 gain;
 
 	if (!vbuf)
 		return;
 
+	linestart = dev->line + (dev->mv_count % dev->width) * dev->pixelsize;
+
 	for (h = 0; h < hmax; h++)
-		memcpy(vbuf + h * wmax * dev->pixelsize,
-		       dev->line + (dev->mv_count % wmax) * dev->pixelsize,
-		       wmax * dev->pixelsize);
+		memcpy(vbuf + h * stride, linestart, stride);
 
 	/* Updates stream time */
 
-- 
1.8.0.316.g291341c

