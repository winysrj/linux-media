Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38164 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbaKEIR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:17:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/8] smipcie: fix sparse warnings
Date: Wed,  5 Nov 2014 09:17:47 +0100
Message-Id: <1415175472-24203-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

smipcie.c:950:31: warning: Using plain integer as NULL pointer
smipcie.c:973:31: warning: Using plain integer as NULL pointer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/smipcie/smipcie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
index d1c1463..8dc6afa 100644
--- a/drivers/media/pci/smipcie/smipcie.c
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -947,7 +947,7 @@ err_del_i2c_adaptor:
 err_pci_iounmap:
 	iounmap(dev->lmmio);
 err_kfree:
-	pci_set_drvdata(pdev, 0);
+	pci_set_drvdata(pdev, NULL);
 	kfree(dev);
 err_pci_disable_device:
 	pci_disable_device(pdev);
@@ -970,7 +970,7 @@ static void smi_remove(struct pci_dev *pdev)
 
 	smi_i2c_exit(dev);
 	iounmap(dev->lmmio);
-	pci_set_drvdata(pdev, 0);
+	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	kfree(dev);
 }
-- 
2.1.1

