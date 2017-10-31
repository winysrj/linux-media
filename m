Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42024 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbdJaLbt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 07:31:49 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] drivers/media/pci/zoran: remove redundant assignment to pointer h
Date: Tue, 31 Oct 2017 11:31:42 +0000
Message-Id: <20171031113142.21794-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The pointer h is already initialized to codeclist_top so the second
identical assignment is redundant and can be removed. Cleans up clang
warning:

drivers/media/pci/zoran/videocodec.c:322:21: warning: Value stored to 'h'
during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/zoran/videocodec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/zoran/videocodec.c b/drivers/media/pci/zoran/videocodec.c
index 303289a7fd3f..5ff23ef89215 100644
--- a/drivers/media/pci/zoran/videocodec.c
+++ b/drivers/media/pci/zoran/videocodec.c
@@ -325,7 +325,6 @@ static int proc_videocodecs_show(struct seq_file *m, void *v)
 	seq_printf(m, "<S>lave or attached <M>aster name  type flags    magic    ");
 	seq_printf(m, "(connected as)\n");
 
-	h = codeclist_top;
 	while (h) {
 		seq_printf(m, "S %32s %04x %08lx %08lx (TEMPLATE)\n",
 			      h->codec->name, h->codec->type,
-- 
2.14.1
