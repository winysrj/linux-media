Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43202 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbeG0EY7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 00:24:59 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: hans.verkuil@cisco.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: pci: cobalt: Replace GFP_ATOMIC with GFP_KERNEL in cobalt_probe()
Date: Fri, 27 Jul 2018 11:05:09 +0800
Message-Id: <20180727030509.2668-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cobalt_probe() is never called in atomic context.
It calls kzalloc() with GFP_ATOMIC, which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/pci/cobalt/cobalt-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index c8b1a6206c65..4885e833c052 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -670,7 +670,7 @@ static int cobalt_probe(struct pci_dev *pci_dev,
 	/* FIXME - module parameter arrays constrain max instances */
 	i = atomic_inc_return(&cobalt_instance) - 1;
 
-	cobalt = kzalloc(sizeof(struct cobalt), GFP_ATOMIC);
+	cobalt = kzalloc(sizeof(struct cobalt), GFP_KERNEL);
 	if (cobalt == NULL)
 		return -ENOMEM;
 	cobalt->pci_dev = pci_dev;
-- 
2.17.0
