Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36049
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935237AbcJQPou (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 11:44:50 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 4/5] [media] s5p-cec: Fix module autoload
Date: Mon, 17 Oct 2016 12:44:11 -0300
Message-Id: <1476719053-17600-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
References: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the driver is built as a module, autoload won't work because the module
alias information is not filled. So user-space can't match the registered
device with the corresponding module.

Export the module alias information using the MODULE_DEVICE_TABLE() macro.

Before this patch:

$ modinfo drivers/staging/media/s5p-cec/s5p-cec.ko | grep alias
$

After this patch:

$ modinfo drivers/staging/media/s5p-cec/s5p-cec.ko | grep alias
alias:          of:N*T*Csamsung,s5p-cecC*
alias:          of:N*T*Csamsung,s5p-cec

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/staging/media/s5p-cec/s5p_cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/staging/media/s5p-cec/s5p_cec.c
index 1780a08b73c9..4e41f72dbfaa 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/staging/media/s5p-cec/s5p_cec.c
@@ -263,6 +263,7 @@ static const struct of_device_id s5p_cec_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, s5p_cec_match);
 
 static struct platform_driver s5p_cec_pdrv = {
 	.probe	= s5p_cec_probe,
-- 
2.7.4

