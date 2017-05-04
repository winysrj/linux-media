Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:58919 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752997AbdEDRVz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 13:21:55 -0400
To: linux-media@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] bdisp-debug: Replace a seq_puts() call by seq_putc()
 in seven functions
Message-ID: <e47a5e4b-9a4a-97fc-931a-20ab5742fdd0@users.sourceforge.net>
Date: Thu, 4 May 2017 19:21:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 4 May 2017 19:14:15 +0200

Seven single characters (line breaks) should be put into a sequence.
Thus use the corresponding function "seq_putc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/sti/bdisp/bdisp-debug.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c b/drivers/media/platform/sti/bdisp/bdisp-debug.c
index 7af66860d624..2cc289e4dea1 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
@@ -104,7 +104,7 @@ static void bdisp_dbg_dump_ins(struct seq_file *s, u32 val)
 	if (val & BLT_INS_IRQ)
 		seq_puts(s, "IRQ - ");
 
-	seq_puts(s, "\n");
+	seq_putc(s, '\n');
 }
 
 static void bdisp_dbg_dump_tty(struct seq_file *s, u32 val)
@@ -153,7 +153,7 @@ static void bdisp_dbg_dump_tty(struct seq_file *s, u32 val)
 	if (val & BLT_TTY_BIG_END)
 		seq_puts(s, "BigEndian - ");
 
-	seq_puts(s, "\n");
+	seq_putc(s, '\n');
 }
 
 static void bdisp_dbg_dump_xy(struct seq_file *s, u32 val, char *name)
@@ -230,7 +230,7 @@ static void bdisp_dbg_dump_sty(struct seq_file *s,
 		seq_puts(s, "BigEndian - ");
 
 done:
-	seq_puts(s, "\n");
+	seq_putc(s, '\n');
 }
 
 static void bdisp_dbg_dump_fctl(struct seq_file *s, u32 val)
@@ -247,7 +247,7 @@ static void bdisp_dbg_dump_fctl(struct seq_file *s, u32 val)
 	else if ((val & BLT_FCTL_HV_SCALE) == BLT_FCTL_HV_SAMPLE)
 		seq_puts(s, "Sample Chroma");
 
-	seq_puts(s, "\n");
+	seq_putc(s, '\n');
 }
 
 static void bdisp_dbg_dump_rsf(struct seq_file *s, u32 val, char *name)
@@ -266,7 +266,7 @@ static void bdisp_dbg_dump_rsf(struct seq_file *s, u32 val, char *name)
 	seq_printf(s, "V: %d(6.10) / scale~%dx0.1", inc, 1024 * 10 / inc);
 
 done:
-	seq_puts(s, "\n");
+	seq_putc(s, '\n');
 }
 
 static void bdisp_dbg_dump_rzi(struct seq_file *s, u32 val, char *name)
@@ -281,7 +281,7 @@ static void bdisp_dbg_dump_rzi(struct seq_file *s, u32 val, char *name)
 	seq_printf(s, "V: init=%d repeat=%d", val & 0x3FF, (val >> 12) & 7);
 
 done:
-	seq_puts(s, "\n");
+	seq_putc(s, '\n');
 }
 
 static void bdisp_dbg_dump_ivmx(struct seq_file *s,
@@ -293,7 +293,7 @@ static void bdisp_dbg_dump_ivmx(struct seq_file *s,
 	seq_printf(s, "IVMX3\t0x%08X\t", c3);
 
 	if (!c0 && !c1 && !c2 && !c3) {
-		seq_puts(s, "\n");
+		seq_putc(s, '\n');
 		return;
 	}
 
-- 
2.12.2
