Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZLVAV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 19:21:58 -0500
Message-Id: <200912220021.nBM0LlPG004934@imap1.linux-foundation.org>
Subject: [patch 2/3] proc_fops: convert av7110
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	adobriyan@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 21 Dec 2009 16:21:47 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexey Dobriyan <adobriyan@gmail.com>

Drop S_IRUGO, proc entry doesn't contain read hooks.
Drop S_IFREG, simply unnecessary.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/ttpci/av7110_ir.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/media/dvb/ttpci/av7110_ir.c~proc_fops-convert-av7110 drivers/media/dvb/ttpci/av7110_ir.c
--- a/drivers/media/dvb/ttpci/av7110_ir.c~proc_fops-convert-av7110
+++ a/drivers/media/dvb/ttpci/av7110_ir.c
@@ -268,8 +268,8 @@ int av7110_check_ir_config(struct av7110
 
 
 /* /proc/av7110_ir interface */
-static int av7110_ir_write_proc(struct file *file, const char __user *buffer,
-				unsigned long count, void *data)
+static ssize_t av7110_ir_proc_write(struct file *file, const char __user *buffer,
+				    size_t count, loff_t *pos)
 {
 	char *page;
 	u32 ir_config;
@@ -309,6 +309,10 @@ static int av7110_ir_write_proc(struct f
 	return count;
 }
 
+static const struct file_operations av7110_ir_proc_fops = {
+	.owner		= THIS_MODULE,
+	.write		= av7110_ir_proc_write,
+};
 
 /* interrupt handler */
 static void ir_handler(struct av7110 *av7110, u32 ircom)
@@ -368,11 +372,9 @@ int __devinit av7110_ir_init(struct av71
 	input_dev->timer.data = (unsigned long) &av7110->ir;
 
 	if (av_cnt == 1) {
-		e = create_proc_entry("av7110_ir", S_IFREG | S_IRUGO | S_IWUSR, NULL);
-		if (e) {
-			e->write_proc = av7110_ir_write_proc;
+		e = proc_create("av7110_ir", S_IWUSR, NULL, &av7110_ir_proc_fops);
+		if (e)
 			e->size = 4 + 256 * sizeof(u16);
-		}
 	}
 
 	tasklet_init(&av7110->ir.ir_tasklet, av7110_emit_key, (unsigned long) &av7110->ir);
_
