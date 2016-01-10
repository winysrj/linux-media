Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:42851 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751534AbcAJH3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 02:29:46 -0500
Message-ID: <1452410981.7773.10.camel@perches.com>
Subject: Re: [PATCH] [media] netup_unidvb: Remove a useless memset
From: Joe Perches <joe@perches.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, serjk@netup.ru,
	mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Date: Sat, 09 Jan 2016 23:29:41 -0800
In-Reply-To: <1452410416-6362-1-git-send-email-christophe.jaillet@wanadoo.fr>
References: <1452410416-6362-1-git-send-email-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2016-01-10 at 08:20 +0100, Christophe JAILLET wrote:
> This memory is allocated using kzalloc so there is no need to call
> memset(..., 0, ...)
[]
> diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
[]
> @@ -774,7 +774,6 @@ static int netup_unidvb_initdev(struct pci_dev *pci_dev,
>  
>  	if (!ndev)
>  		goto dev_alloc_err;
> -	memset(ndev, 0, sizeof(*ndev));
>  	ndev->old_fw = old_firmware;
>  	ndev->wq = create_singlethread_workqueue(NETUP_UNIDVB_NAME);
>  	if (!ndev->wq) {

It's unusual to not see the alloc above the if

Perhaps it'd be more standard to do something like:
---
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 525ebfe..c94cecd 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -771,10 +771,9 @@ static int netup_unidvb_initdev(struct pci_dev *pci_dev,
 
 	/* allocate device context */
 	ndev = kzalloc(sizeof(*ndev), GFP_KERNEL);
-
 	if (!ndev)
 		goto dev_alloc_err;
-	memset(ndev, 0, sizeof(*ndev));
+
 	ndev->old_fw = old_firmware;
 	ndev->wq = create_singlethread_workqueue(NETUP_UNIDVB_NAME);
 	if (!ndev->wq) {

