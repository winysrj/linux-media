Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36032
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964819AbcJQPoh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 11:44:37 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 2/5] [media] v4l: rcar-fcp: Fix module autoload for OF registration
Date: Mon, 17 Oct 2016 12:44:09 -0300
Message-Id: <1476719053-17600-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
References: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the driver is built as a module, autoload won't work because the module
alias information is not filled. So user-space can't match the registered
device with the corresponding module.

Export the module alias information using the MODULE_DEVICE_TABLE() macro.

Before this patch:

$ modinfo drivers/media/platform/rcar-fcp.ko | grep alias
alias:          rcar-fcp

After this patch:

$ modinfo drivers/media/platform/rcar-fcp.ko | grep alias
alias:          rcar-fcp
alias:          of:N*T*Crenesas,fcpvC*
alias:          of:N*T*Crenesas,fcpv
alias:          of:N*T*Crenesas,fcpfC*
alias:          of:N*T*Crenesas,fcpf

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/rcar-fcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index f3a3f31cdfa9..7146fc5ef168 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -169,6 +169,7 @@ static const struct of_device_id rcar_fcp_of_match[] = {
 	{ .compatible = "renesas,fcpv" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, rcar_fcp_of_match);
 
 static struct platform_driver rcar_fcp_platform_driver = {
 	.probe		= rcar_fcp_probe,
-- 
2.7.4

