Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:64407 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755267Ab3BENrf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Feb 2013 08:47:35 -0500
Message-ID: <1360071741.1343.42.camel@x61.thuisdomein>
Subject: [PATCH] [media] saa7164: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Feb 2013 14:42:21 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compiling the saa7164 driver without CONFIG_VIDEO_ADV_DEBUG set triggers
these GCC warnings:
    drivers/media/pci/saa7164/saa7164-encoder.c:1301:12: warning: ‘saa7164_g_register’ defined but not used [-Wunused-function]
    drivers/media/pci/saa7164/saa7164-encoder.c:1314:12: warning: ‘saa7164_s_register’ defined but not used [-Wunused-function]

Silence these warnings by wrapping these two functions in an "#ifdef
CONFIG_VIDEO_ADV_DEBUG" and "#endif" pair.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) These warnings are apparently a side effect of commit
5faf7db804e1e67ab8f78edb305d1858779a6279 ("[media] saa7164: get rid of
warning: no previous prototype"): now that these two functions are
static GCC can determine that they are unused in this case.

 drivers/media/pci/saa7164/saa7164-encoder.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 994018e..9bb0903 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1298,6 +1298,7 @@ static int saa7164_g_chip_ident(struct file *file, void *fh,
 	return 0;
 }
 
+#ifdef CONFIG_VIDEO_ADV_DEBUG
 static int saa7164_g_register(struct file *file, void *fh,
 			      struct v4l2_dbg_register *reg)
 {
@@ -1323,6 +1324,7 @@ static int saa7164_s_register(struct file *file, void *fh,
 
 	return 0;
 }
+#endif
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
-- 
1.8.1

