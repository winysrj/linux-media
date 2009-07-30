Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:52405 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZG3FqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 01:46:11 -0400
Received: by qyk34 with SMTP id 34so558821qyk.33
        for <linux-media@vger.kernel.org>; Wed, 29 Jul 2009 22:46:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Jul 2009 00:46:11 -0500
Message-ID: <e3538fbd0907292246k2c75a950u38c2c91d5190f4f7@mail.gmail.com>
Subject: [PATCH] cx23885-417: fix setting tvnorms
From: Joseph Yasi <joe.yasi@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the VIDIOC_S_STD ioctl just returns -EINVAL regardless of
the norm passed.  This patch sets cx23885_mpeg_template.tvnorms and
cx23885_mpeg_template.current_norm so that the VIDIOC_S_STD will work.

Signed-off-by: Joseph A. Yasi <joe.yasi@gmail.com>

---
diff -r ee6cf88cb5d3 linux/drivers/media/video/cx23885/cx23885-417.c
--- a/linux/drivers/media/video/cx23885/cx23885-417.c   Wed Jul 29
01:42:02 2009 -0300
+++ b/linux/drivers/media/video/cx23885/cx23885-417.c   Thu Jul 30
00:38:14 2009 -0500
@@ -1738,6 +1738,8 @@
        .fops          = &mpeg_fops,
        .ioctl_ops     = &mpeg_ioctl_ops,
        .minor         = -1,
+       .tvnorms       = CX23885_NORMS,
+       .current_norm  = V4L2_STD_NTSC_M,
 };

 void cx23885_417_unregister(struct cx23885_dev *dev)
