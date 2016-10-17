Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36059
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935206AbcJQPos (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 11:44:48 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        kernel@stlinux.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 5/5] [media] st-cec: Fix module autoload
Date: Mon, 17 Oct 2016 12:44:12 -0300
Message-Id: <1476719053-17600-6-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
References: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the driver is built as a module, autoload won't work because the module
alias information is not filled. So user-space can't match the registered
device with the corresponding module.

Export the module alias information using the MODULE_DEVICE_TABLE() macro.

Before this patch:

$ modinfo drivers/staging/media//st-cec/stih-cec.ko | grep alias
$

After this patch:

$ modinfo drivers/staging/media//st-cec/stih-cec.ko | grep alias
alias:          of:N*T*Cst,stih-cecC*
alias:          of:N*T*Cst,stih-cec

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/staging/media/st-cec/stih-cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/media/st-cec/stih-cec.c
index 214344866a6b..19d3ff30c8f8 100644
--- a/drivers/staging/media/st-cec/stih-cec.c
+++ b/drivers/staging/media/st-cec/stih-cec.c
@@ -363,6 +363,7 @@ static const struct of_device_id stih_cec_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, stih_cec_match);
 
 static struct platform_driver stih_cec_pdrv = {
 	.probe	= stih_cec_probe,
-- 
2.7.4

