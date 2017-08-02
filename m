Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28982 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752544AbdHBPTm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 11:19:42 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Lad Prabhakar" <prabhakar.csengg@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] DaVinci-VPBE: constify vpbe_dev_ops
Date: Wed,  2 Aug 2017 16:54:13 +0200
Message-Id: <1501685653-4284-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vpbe_dev_ops is only copied into the ops field at the end of a vpbe_device
structure, so it can be const.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---

Does the ops field need to be inlined into the vpbe_device structure?

 drivers/media/platform/davinci/vpbe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 3679b1e..7f64625 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -790,7 +790,7 @@ static void vpbe_deinitialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	vpss_enable_clock(VPSS_VPBE_CLOCK, 0);
 }
 
-static struct vpbe_device_ops vpbe_dev_ops = {
+static const struct vpbe_device_ops vpbe_dev_ops = {
 	.g_cropcap = vpbe_g_cropcap,
 	.enum_outputs = vpbe_enum_outputs,
 	.set_output = vpbe_set_output,
