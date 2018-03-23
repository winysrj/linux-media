Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38821 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754037AbeCWL5a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/30] media: cx88: fix two warnings
Date: Fri, 23 Mar 2018 07:56:59 -0400
Message-Id: <aea629c1261f9a8ba06a8ee93b45ac5bd4475943.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/cx88/cx88-alsa.c:295 cx88_alsa_dma_init() warn: argument 3 to %08lx specifier is cast from pointer
drivers/media/pci/cx88/cx88-alsa.c:669 snd_cx88_wm8775_volume_put() warn: potential negative subtraction from max '65535 - (32768 * left) / right'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx88/cx88-alsa.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 9740326bc93f..ab09bb55cf45 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -292,8 +292,8 @@ static int cx88_alsa_dma_init(struct cx88_audio_dev *chip, int nr_pages)
 		return -ENOMEM;
 	}
 
-	dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
-		(unsigned long)buf->vaddr, nr_pages << PAGE_SHIFT);
+	dprintk(1, "vmalloc is at addr %p, size=%d\n",
+		buf->vaddr, nr_pages << PAGE_SHIFT);
 
 	memset(buf->vaddr, 0, nr_pages << PAGE_SHIFT);
 	buf->nr_pages = nr_pages;
@@ -656,8 +656,8 @@ static void snd_cx88_wm8775_volume_put(struct snd_kcontrol *kcontrol,
 {
 	struct cx88_audio_dev *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core = chip->core;
-	int left = value->value.integer.value[0];
-	int right = value->value.integer.value[1];
+	u16 left = value->value.integer.value[0];
+	u16 right = value->value.integer.value[1];
 	int v, b;
 
 	/* Pass volume & balance onto any WM8775 */
-- 
2.14.3
