Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36039
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932930AbcJQPol (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 11:44:41 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Carlo Caione <carlo@caione.org>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 3/5] [media] rc: meson-ir: Fix module autoload
Date: Mon, 17 Oct 2016 12:44:10 -0300
Message-Id: <1476719053-17600-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
References: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the driver is built as a module, autoload won't work because the module
alias information is not filled. So user-space can't match the registered
device with the corresponding module.

Export the module alias information using the MODULE_DEVICE_TABLE() macro.

Before this patch:

$ modinfo drivers/media/rc/meson-ir.ko | grep alias
$

After this patch:

$ modinfo drivers/media/rc/meson-ir.ko | grep alias
alias:          of:N*T*Camlogic,meson-gxbb-irC*
alias:          of:N*T*Camlogic,meson-gxbb-ir
alias:          of:N*T*Camlogic,meson8b-irC*
alias:          of:N*T*Camlogic,meson8b-ir
alias:          of:N*T*Camlogic,meson6-irC*
alias:          of:N*T*Camlogic,meson6-ir

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/rc/meson-ir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index 003fff07ade2..7eb3f4f1ddcd 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -218,6 +218,7 @@ static const struct of_device_id meson_ir_match[] = {
 	{ .compatible = "amlogic,meson-gxbb-ir" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, meson_ir_match);
 
 static struct platform_driver meson_ir_driver = {
 	.probe		= meson_ir_probe,
-- 
2.7.4

