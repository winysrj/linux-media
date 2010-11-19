Return-path: <mchehab@gaivota>
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:48250 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452Ab0KSUpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 15:45:14 -0500
Date: Fri, 19 Nov 2010 21:42:40 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media: nuvoton: fix chip id probe v2
Message-ID: <20101119214240.6b87dad7@absol.kitzblitz>
In-Reply-To: <20101119191644.GF5022@redhat.com>
References: <20101116211953.238012db@absol.kitzblitz>
	<20101116215408.GA17140@redhat.com>
	<4CE33527.8090800@infradead.org>
	<20101117113525.1ded029c@absol.kitzblitz>
	<20101119191644.GF5022@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Make sure we have a matching chip id high and one or the other
of the chip id low values.
Print the values if the probe fails.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/media/IR/nuvoton-cir.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/IR/nuvoton-cir.c
index 301be53..e3274ef 100644
--- a/drivers/media/IR/nuvoton-cir.c
+++ b/drivers/media/IR/nuvoton-cir.c
@@ -249,9 +249,12 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 	chip_minor = nvt_cr_read(nvt, CR_CHIP_ID_LO);
 	nvt_dbg("%s: chip id: 0x%02x 0x%02x", chip_id, chip_major, chip_minor);
 
-	if (chip_major != CHIP_ID_HIGH &&
-	    (chip_minor != CHIP_ID_LOW || chip_minor != CHIP_ID_LOW2))
+	if (chip_major != CHIP_ID_HIGH ||
+	    (chip_minor != CHIP_ID_LOW && chip_minor != CHIP_ID_LOW2)) {
+		nvt_pr(KERN_ERR, "%s: unsupported chip, id: 0x%02x 0x%02x",
+		       chip_id, chip_major, chip_minor);
 		ret = -ENODEV;
+	}
 
 	nvt_efm_disable(nvt);
 
-- 
1.7.2.2
