Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60006 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbcECU22 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 16:28:28 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 3/3] [media] s5p-mfc: Fix race between s5p_mfc_probe() and s5p_mfc_open()
Date: Tue,  3 May 2016 16:27:18 -0400
Message-Id: <1462307238-21815-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
References: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s5p_mfc_probe() function registers the video devices before all the
resources needed by s5p_mfc_open() are correctly initalized.

So if s5p_mfc_open() function is called before s5p_mfc_probe() finishes
(since the video dev is already registered), a NULL pointer dereference
will happen due s5p_mfc_open() accessing uninitialized vars such as the
struct s5p_mfc_dev .watchdog_timer and .mfc_ops fields.

An example is following BUG caused by add_timer() getting a NULL pointer:

[   45.765374] kernel BUG at kernel/time/timer.c:790!
[   45.765381] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
...
[   45.766149] [<c016fdf4>] (mod_timer) from [<bf181d18>] (s5p_mfc_open+0x274/0x4d4 [s5p_mfc])
[   45.766416] [<bf181d18>] (s5p_mfc_open [s5p_mfc]) from [<bf0214a0>] (v4l2_open+0x9c/0x100 [videodev])
[   45.766547] [<bf0214a0>] (v4l2_open [videodev]) from [<c01e355c>] (chrdev_open+0x9c/0x178)
[   45.766575] [<c01e355c>] (chrdev_open) from [<c01dceb4>] (do_dentry_open+0x1e0/0x300)
[   45.766595] [<c01dceb4>] (do_dentry_open) from [<c01ec2f0>] (path_openat+0x800/0x10d4)
[   45.766610] [<c01ec2f0>] (path_openat) from [<c01ed8b8>] (do_filp_open+0x5c/0xc0)
[   45.766624] [<c01ed8b8>] (do_filp_open) from [<c01de218>] (do_sys_open+0x10c/0x1bc)
[   45.766642] [<c01de218>] (do_sys_open) from [<c01078c0>] (ret_fast_syscall+0x0/0x3c)
[   45.766655] Code: eaffffe3 e3a00001 e28dd008 e8bd81f0 (e7f001f2)

Fix it by registering the video devs as the last step in s5p_mfc_probe().

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/s5p-mfc/s5p_mfc.c | 39 +++++++++++++++++---------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index beb4fd5bd326..501d822cad6b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1212,14 +1212,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->vfl_dir	= VFL_DIR_M2M;
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_DEC_NAME);
 	dev->vfd_dec	= vfd;
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		video_device_release(vfd);
-		goto err_dec_reg;
-	}
-	v4l2_info(&dev->v4l2_dev,
-		  "decoder registered as /dev/video%d\n", vfd->num);
 	video_set_drvdata(vfd, dev);
 
 	/* encoder */
@@ -1237,14 +1229,6 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->vfl_dir	= VFL_DIR_M2M;
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_ENC_NAME);
 	dev->vfd_enc	= vfd;
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		video_device_release(vfd);
-		goto err_enc_reg;
-	}
-	v4l2_info(&dev->v4l2_dev,
-		  "encoder registered as /dev/video%d\n", vfd->num);
 	video_set_drvdata(vfd, dev);
 	platform_set_drvdata(pdev, dev);
 
@@ -1261,15 +1245,34 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	s5p_mfc_init_hw_cmds(dev);
 	s5p_mfc_init_regs(dev);
 
+	/* Register decoder and encoder */
+	ret = video_register_device(dev->vfd_dec, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		video_device_release(dev->vfd_dec);
+		goto err_dec_reg;
+	}
+	v4l2_info(&dev->v4l2_dev,
+		  "decoder registered as /dev/video%d\n", dev->vfd_dec->num);
+
+	ret = video_register_device(dev->vfd_enc, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		video_device_release(dev->vfd_enc);
+		goto err_enc_reg;
+	}
+	v4l2_info(&dev->v4l2_dev,
+		  "encoder registered as /dev/video%d\n", dev->vfd_enc->num);
+
 	pr_debug("%s--\n", __func__);
 	return 0;
 
 /* Deinit MFC if probe had failed */
 err_enc_reg:
-	video_device_release(dev->vfd_enc);
-err_enc_alloc:
 	video_unregister_device(dev->vfd_dec);
 err_dec_reg:
+	video_device_release(dev->vfd_enc);
+err_enc_alloc:
 	video_device_release(dev->vfd_dec);
 err_dec_alloc:
 	v4l2_device_unregister(&dev->v4l2_dev);
-- 
2.5.5

