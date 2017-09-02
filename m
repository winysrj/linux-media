Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:63213 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdIBUrK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 16:47:10 -0400
Subject: [PATCH 7/7] [media] Mantis: Delete an unnecessary variable
 initialisation in mantis_pci_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <9ba22d42-0ec0-b865-dec5-4ce67ad443fb@users.sourceforge.net>
Message-ID: <cf171abc-7865-e031-99ee-0c33a0ed68be@users.sourceforge.net>
Date: Sat, 2 Sep 2017 22:47:04 +0200
MIME-Version: 1.0
In-Reply-To: <9ba22d42-0ec0-b865-dec5-4ce67ad443fb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 22:05:22 +0200

The variable "err" will eventually be set to an appropriate value
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/mantis/mantis_cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 6182ae44dd23..33dd99da0ed8 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -171,6 +171,6 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 	struct mantis_pci_drvdata *drvdata;
 	struct mantis_pci *mantis;
 	struct mantis_hwconfig *config;
-	int err = 0;
+	int err;
 
 	mantis = kzalloc(sizeof(*mantis), GFP_KERNEL);
-- 
2.14.1
