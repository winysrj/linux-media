Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58605 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755972Ab2JPUSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 16:18:07 -0400
Message-ID: <507DC0F7.207@xenotime.net>
Date: Tue, 16 Oct 2012 13:17:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sangwook Lee <sangwook.lee@linaro.org>,
	Seok-Young Jang <quartz.jang@samsung.com>
Subject: [PATCH -next] media: fix i2c/s5k4ecgx printk format warning
References: <20121016145856.cfddc9c898c31b1c686804d7@canb.auug.org.au>
In-Reply-To: <20121016145856.cfddc9c898c31b1c686804d7@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning for size_t variable:

drivers/media/i2c/s5k4ecgx.c:346:2: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Sangwook Lee <sangwook.lee@linaro.org>
Cc: Seok-Young Jang <quartz.jang@samsung.com>
---
 drivers/media/i2c/s5k4ecgx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20121016.orig/drivers/media/i2c/s5k4ecgx.c
+++ linux-next-20121016/drivers/media/i2c/s5k4ecgx.c
@@ -343,7 +343,7 @@ static int s5k4ecgx_load_firmware(struct
 	}
 	regs_num = le32_to_cpu(get_unaligned_le32(fw->data));
 
-	v4l2_dbg(3, debug, sd, "FW: %s size %d register sets %d\n",
+	v4l2_dbg(3, debug, sd, "FW: %s size %zu register sets %d\n",
 		 S5K4ECGX_FIRMWARE, fw->size, regs_num);
 
 	regs_num++; /* Add header */
