Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:36977
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751570AbdHNGJd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 02:09:33 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] v4l2: av7110_v4l: constify v4l2_audio structure
Date: Mon, 14 Aug 2017 07:43:56 +0200
Message-Id: <1502689436-31008-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This v4l2_audio structure is only copied into other structures,
so it can be const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/pci/ttpci/av7110_v4l.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ttpci/av7110_v4l.c b/drivers/media/pci/ttpci/av7110_v4l.c
index 397fe14..e4cf42c 100644
--- a/drivers/media/pci/ttpci/av7110_v4l.c
+++ b/drivers/media/pci/ttpci/av7110_v4l.c
@@ -218,7 +218,7 @@ static int stv0297_set_tv_freq(struct saa7146_dev *dev, u32 freq)
 static struct saa7146_standard dvb_standard[];
 static struct saa7146_standard standard[];
 
-static struct v4l2_audio msp3400_v4l2_audio = {
+static const struct v4l2_audio msp3400_v4l2_audio = {
 	.index = 0,
 	.name = "Television",
 	.capability = V4L2_AUDCAP_STEREO
