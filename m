Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36022
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934704AbcJQPoe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 11:44:34 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/5] [media] v4l: vsp1: Fix module autoload for OF registration
Date: Mon, 17 Oct 2016 12:44:08 -0300
Message-Id: <1476719053-17600-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
References: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the driver is built as a module, autoload won't work because the module
alias information is not filled. So user-space can't match the registered
device with the corresponding module.

Export the module alias information using the MODULE_DEVICE_TABLE() macro.

Before this patch:

$ modinfo drivers/media/platform/vsp1/vsp1.ko | grep alias
alias:          vsp1

After this patch:

$ modinfo drivers/media/platform/vsp1/vsp1.ko | grep alias
alias:          vsp1
alias:          of:N*T*Crenesas,vsp2C*
alias:          of:N*T*Crenesas,vsp2
alias:          of:N*T*Crenesas,vsp1C*
alias:          of:N*T*Crenesas,vsp1

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/vsp1/vsp1_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 57c713a4e1df..aa237b48ad55 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -770,6 +770,7 @@ static const struct of_device_id vsp1_of_match[] = {
 	{ .compatible = "renesas,vsp2" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, vsp1_of_match);
 
 static struct platform_driver vsp1_platform_driver = {
 	.probe		= vsp1_probe,
-- 
2.7.4

