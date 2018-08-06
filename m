Return-path: <linux-media-owner@vger.kernel.org>
Received: from bran.ispras.ru ([83.149.199.196]:23653 "EHLO smtp.ispras.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728626AbeHFSAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Aug 2018 14:00:37 -0400
From: Anton Vasilyev <vasilyev@ispras.ru>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Anton Vasilyev <vasilyev@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH v2 1/2] media: davinci: vpif_display: Mix memory leak on probe error path
Date: Mon,  6 Aug 2018 18:50:24 +0300
Message-Id: <20180806155025.8912-1-vasilyev@ispras.ru>
In-Reply-To: <CA+V-a8vXEiZ6widPZRdiw-0QejFHwDcTtMz5iKfkHc9gZLZ79Q@mail.gmail.com>
References: 
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If vpif_probe() fails on v4l2_device_register() then memory allocated
at initialize_vpif() for global vpif_obj.dev[i] become unreleased.

The patch adds deallocation of vpif_obj.dev[i] on the probe error path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
---
v2: divided the original patch into two and made stylistic fixes based
on the Prabhakar's rewiev.
---
 drivers/media/platform/davinci/vpif_display.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 7be636237acf..d9e578ac79c2 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1271,7 +1271,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
 	if (err) {
 		v4l2_err(vpif_dev->driver, "Error registering v4l2 device\n");
-		return err;
+		goto vpif_free;
 	}
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
@@ -1314,7 +1314,9 @@ static __init int vpif_probe(struct platform_device *pdev)
 			if (vpif_obj.sd[i])
 				vpif_obj.sd[i]->grp_id = 1 << i;
 		}
-		vpif_probe_complete();
+		err = vpif_probe_complete();
+		if (err)
+			goto probe_subdev_out;
 	} else {
 		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
 		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
@@ -1334,6 +1336,9 @@ static __init int vpif_probe(struct platform_device *pdev)
 	kfree(vpif_obj.sd);
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
+vpif_free:
+	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++)
+		kfree(vpif_obj.dev[i]);
 
 	return err;
 }
-- 
2.18.0
