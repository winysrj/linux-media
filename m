Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:48901 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab2KBNJx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Nov 2012 09:09:53 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 1/4] [media] vivi: Optimize gen_text()
Date: Fri,  2 Nov 2012 17:10:30 +0400
Message-Id: <9eefaaafbb9ac47d9255291d12f4d15109e79c18.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
References: <cover.1351861552.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1351861552.git.kirr@mns.spb.ru>
References: <cover.1351861552.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've noticed that vivi takes a lot of CPU to produce its frames.

For example for 8 devices and 8 simple programs running, where each
captures YUY2 640x480 and displays it to X via SDL, profile timing is as
follows:

    # cmdline : /home/kirr/local/perf/bin/perf record -g -a sleep 20
    # Samples: 82K of event 'cycles'
    # Event count (approx.): 31551930117
    #
    # Overhead          Command         Shared Object                                                           Symbol
    # ........  ...............  ....................
    #
        49.48%           vivi-*  [vivi]                [k] gen_twopix
        10.79%           vivi-*  [kernel.kallsyms]     [k] memcpy
        10.02%             rawv  libc-2.13.so          [.] __memcpy_ssse3
         8.35%           vivi-*  [vivi]                [k] gen_text.constprop.6
         5.06%             Xorg  [unknown]             [.] 0xa73015f8
         2.32%             rawv  [vivi]                [k] gen_twopix
         1.22%             rawv  [vivi]                [k] precalculate_line
         1.20%           vivi-*  [vivi]                [k] vivi_fillbuff

    (rawv is display program, vivi-* is a combination of vivi-000 through vivi-007)

so a lot of time is spent in gen_twopix() which as the follwing
call-graph profile shows ...

    49.48%           vivi-*  [vivi]                [k] gen_twopix
                     |
                     --- gen_twopix
                        |
                        |--96.30%-- gen_text.constprop.6
                        |          vivi_fillbuff
                        |          vivi_thread
                        |          kthread
                        |          ret_from_kernel_thread
                        |
                         --3.70%-- vivi_fillbuff
                                   vivi_thread
                                   kthread
                                   ret_from_kernel_thread

... is called mostly from gen_text().

If we'll look at gen_text(), in the inner loop, we'll see

    if (chr & (1 << (7 - i)))
            gen_twopix(dev, pos + j * dev->pixelsize, WHITE, (x+y) & 1);
    else
            gen_twopix(dev, pos + j * dev->pixelsize, TEXT_BLACK, (x+y) & 1);

which calls gen_twopix() for every character pixel, and that is very
expensive, because gen_twopix() branches several times.

Now, let's note, that we operate on only two colors - WHITE and
TEXT_BLACK, and that pixel for that colors could be precomputed and
gen_twopix() moved out of the inner loop. Also note, that for black
and white colors even/odd does not make a difference for all supported
pixel formats, so we could stop doing that `odd` gen_twopix() parameter
game.

So the first thing we are doing here is

    1) moving gen_twopix() calls out of gen_text() into vivi_fillbuff(),
       to pregenerate black and white colors, just before printing
       starts.

what we have next is that gen_text's font rendering loop, even with
gen_twopix() calls moved out, was inefficient and branchy, so let's

    2) rewrite gen_text() loop so it uses less variables + unroll char
       horizontal-rendering loop + instantiate 3 code paths for pixelsizes 2,3
       and 4 so that in all inner loops we don't have to branch or make
       indirections (*).

Done all above reworks, for gen_text() we get nice, non-branchy
streamlined code (showing loop for pixelsize=2):

           │       cmp    $0x2,%eax
           │     ↑ jne    26
           │       mov    -0x18(%ebp),%eax
           │       mov    -0x20(%ebp),%edi
           │       imul   -0x20(%ebp),%eax
           │       movzwl 0x3ffc(%ebx),%esi
      0,08 │       movzwl 0x4000(%ebx),%ecx
      0,04 │       add    %edi,%edi
           │       mov    0x0,%ebx
      0,51 │       mov    %edi,-0x1c(%ebp)
           │       mov    %ebx,-0x14(%ebp)
           │       movl   $0x0,-0x10(%ebp)
           │       lea    0x20(%edx,%eax,2),%eax
           │       mov    %eax,-0x18(%ebp)
           │       xchg   %ax,%ax
      0,04 │ a0:   mov    0x8(%ebp),%ebx
           │       mov    -0x18(%ebp),%eax
      0,04 │       movzbl (%ebx),%edx
      0,16 │       test   %dl,%dl
      0,04 │     ↓ je     128
      0,08 │       lea    0x0(%esi),%esi
      1,61 │ b0:┌─→shl    $0x4,%edx
      1,02 │    │  mov    -0x14(%ebp),%edi
      2,04 │    │  add    -0x10(%ebp),%edx
      2,24 │    │  lea    0x1(%ebx),%ebx
      0,27 │    │  movzbl (%edi,%edx,1),%edx
      9,92 │    │  mov    %esi,%edi
      0,39 │    │  test   %dl,%dl
      2,04 │    │  cmovns %ecx,%edi
      4,63 │    │  test   $0x40,%dl
      0,55 │    │  mov    %di,(%eax)
      3,76 │    │  mov    %esi,%edi
      0,71 │    │  cmove  %ecx,%edi
      3,41 │    │  test   $0x20,%dl
      0,75 │    │  mov    %di,0x2(%eax)
      2,43 │    │  mov    %esi,%edi
      0,59 │    │  cmove  %ecx,%edi
      4,59 │    │  test   $0x10,%dl
      0,67 │    │  mov    %di,0x4(%eax)
      2,55 │    │  mov    %esi,%edi
      0,78 │    │  cmove  %ecx,%edi
      4,31 │    │  test   $0x8,%dl
      0,67 │    │  mov    %di,0x6(%eax)
      5,76 │    │  mov    %esi,%edi
      1,80 │    │  cmove  %ecx,%edi
      4,20 │    │  test   $0x4,%dl
      0,86 │    │  mov    %di,0x8(%eax)
      2,98 │    │  mov    %esi,%edi
      1,37 │    │  cmove  %ecx,%edi
      4,67 │    │  test   $0x2,%dl
      0,20 │    │  mov    %di,0xa(%eax)
      2,78 │    │  mov    %esi,%edi
      0,75 │    │  cmove  %ecx,%edi
      3,92 │    │  and    $0x1,%edx
      0,75 │    │  mov    %esi,%edx
      2,59 │    │  mov    %di,0xc(%eax)
      0,59 │    │  cmove  %ecx,%edx
      3,10 │    │  mov    %dx,0xe(%eax)
      2,39 │    │  add    $0x10,%eax
      0,51 │    │  movzbl (%ebx),%edx
      2,86 │    │  test   %dl,%dl
      2,31 │    └──jne    b0
      0,04 │128:   addl   $0x1,-0x10(%ebp)
      4,00 │       mov    -0x1c(%ebp),%eax
      0,04 │       add    %eax,-0x18(%ebp)
      0,08 │       cmpl   $0x10,-0x10(%ebp)
           │     ↑ jne    a0

which almost goes away from the profile:

    # cmdline : /home/kirr/local/perf/bin/perf record -g -a sleep 20
    # Samples: 49K of event 'cycles'
    # Event count (approx.): 16799780016
    #
    # Overhead          Command         Shared Object                                                           Symbol
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

i.e. gen_twopix() overhead dropped from 49% to 4% and gen_text() loops
from ~8% to ~4%, and overal cycles count dropped from 31551930117 to
16799780016 which is ~1.9x whole workload speedup.

(*) for RGB24 rendering I've introduced x24, which could be thought as
    synthetic u24 for simplifying the code. That's done because for
    memcpy used for conditional assignment, gcc generates suboptimal code
    with more indirections.

    Fortunately, in C struct assignment is builtin and that's all we
    need from pixeltype for font rendering.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/platform/vivi.c | 61 ++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index bfac13d..cb2337e 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -245,6 +245,7 @@ struct vivi_dev {
 	u8			   line[MAX_WIDTH * 8];
 	unsigned int		   pixelsize;
 	u8			   alpha_component;
+	u32			   textfg, textbg;
 };
 
 /* ------------------------------------------------------------------
@@ -525,33 +526,54 @@ static void precalculate_line(struct vivi_dev *dev)
 	}
 }
 
+/* need this to do rgb24 rendering */
+typedef struct { u16 __; u8 _; } __attribute__((packed)) x24;
+
 static void gen_text(struct vivi_dev *dev, char *basep,
 					int y, int x, char *text)
 {
 	int line;
+	unsigned int width = dev->width;
 
 	/* Checks if it is possible to show string */
-	if (y + 16 >= dev->height || x + strlen(text) * 8 >= dev->width)
+	if (y + 16 >= dev->height || x + strlen(text) * 8 >= width)
 		return;
 
 	/* Print stream time */
-	for (line = y; line < y + 16; line++) {
-		int j = 0;
-		char *pos = basep + line * dev->width * dev->pixelsize + x * dev->pixelsize;
-		char *s;
-
-		for (s = text; *s; s++) {
-			u8 chr = font8x16[*s * 16 + line - y];
-			int i;
-
-			for (i = 0; i < 7; i++, j++) {
-				/* Draw white font on black background */
-				if (chr & (1 << (7 - i)))
-					gen_twopix(dev, pos + j * dev->pixelsize, WHITE, (x+y) & 1);
-				else
-					gen_twopix(dev, pos + j * dev->pixelsize, TEXT_BLACK, (x+y) & 1);
-			}
-		}
+#define PRINTSTR(PIXTYPE) do {	\
+	PIXTYPE fg;	\
+	PIXTYPE bg;	\
+	memcpy(&fg, &dev->textfg, sizeof(PIXTYPE));	\
+	memcpy(&bg, &dev->textbg, sizeof(PIXTYPE));	\
+	\
+	for (line = 0; line < 16; line++) {	\
+		PIXTYPE *pos = (PIXTYPE *)( basep + ((y + line) * width + x) * sizeof(PIXTYPE) );	\
+		u8 *s;	\
+	\
+		for (s = text; *s; s++) {	\
+			u8 chr = font8x16[*s * 16 + line];	\
+	\
+			pos[0] = (chr & (0x01 << 7) ? fg : bg);	\
+			pos[1] = (chr & (0x01 << 6) ? fg : bg);	\
+			pos[2] = (chr & (0x01 << 5) ? fg : bg);	\
+			pos[3] = (chr & (0x01 << 4) ? fg : bg);	\
+			pos[4] = (chr & (0x01 << 3) ? fg : bg);	\
+			pos[5] = (chr & (0x01 << 2) ? fg : bg);	\
+			pos[6] = (chr & (0x01 << 1) ? fg : bg);	\
+			pos[7] = (chr & (0x01 << 0) ? fg : bg);	\
+	\
+			pos += 8;	\
+		}	\
+	}	\
+} while (0)
+
+	switch (dev->pixelsize) {
+	case 2:
+		PRINTSTR(u16); break;
+	case 4:
+		PRINTSTR(u32); break;
+	case 3:
+		PRINTSTR(x24); break;
 	}
 }
 
@@ -576,6 +598,9 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 
 	/* Updates stream time */
 
+	gen_twopix(dev, (u8 *)&dev->textbg, TEXT_BLACK, /*odd=*/ 0);
+	gen_twopix(dev, (u8 *)&dev->textfg, WHITE, /*odd=*/ 0);
+
 	dev->ms += jiffies_to_msecs(jiffies - dev->jiffies);
 	dev->jiffies = jiffies;
 	ms = dev->ms;
-- 
1.8.0.316.g291341c

