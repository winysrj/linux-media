Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41521 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2KSSfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:35:22 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 483/493] staging: solo6x10: remove use of __devexit
Date: Mon, 19 Nov 2012 13:27:12 -0500
Message-Id: <1353349642-3677-483-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: linux-media@vger.kernel.org 
Cc: devel@driverdev.osuosl.org 
---
 drivers/staging/media/solo6x10/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index c0319e6..fd83d6d 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -284,7 +284,7 @@ fail_probe:
 	return ret;
 }
 
-static void __devexit solo_pci_remove(struct pci_dev *pdev)
+static void solo_pci_remove(struct pci_dev *pdev)
 {
 	struct solo_dev *solo_dev = pci_get_drvdata(pdev);
 
-- 
1.8.0

