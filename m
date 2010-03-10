Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47822 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0CJQTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 11:19:18 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2AGJIK0015491
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 10 Mar 2010 10:19:18 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id o2AGJHgJ010146
	for <linux-media@vger.kernel.org>; Wed, 10 Mar 2010 10:19:17 -0600 (CST)
Received: from dsbe71.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o2AGJHD6014040
	for <linux-media@vger.kernel.org>; Wed, 10 Mar 2010 10:19:17 -0600 (CST)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 10 Mar 2010 10:19:17 -0600
Subject: RE: [PATCH - FIX] V4L: vpfe_capture - free ccdc_lock when memory
 allocation fails
Message-ID: <A69FA2915331DC488A831521EAE36FE4016A5A35CE@dlee06.ent.ti.com>
References: <1268165298-31094-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1268165298-31094-1-git-send-email-m-karicheri2@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

If there are no comments, I will send a pull request for merging this.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Tuesday, March 09, 2010 3:08 PM
>To: linux-media@vger.kernel.org
>Cc: Karicheri, Muralidharan
>Subject: [PATCH - FIX] V4L: vpfe_capture - free ccdc_lock when memory
>allocation fails
>
>From: Murali Karicheri <m-karicheri2@ti.com>
>
>This patch fixes a bug in vpfe_probe() that doesn't call mutex_unlock() if
>memory
>allocation for ccdc_cfg fails. See also the smatch warning report from Dan
>Carpenter that shows this as an issue.
>
>Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>---
> drivers/media/video/davinci/vpfe_capture.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/media/video/davinci/vpfe_capture.c
>b/drivers/media/video/davinci/vpfe_capture.c
>index 885cd54..91f665b 100644
>--- a/drivers/media/video/davinci/vpfe_capture.c
>+++ b/drivers/media/video/davinci/vpfe_capture.c
>@@ -1829,7 +1829,7 @@ static __init int vpfe_probe(struct platform_device
>*pdev)
> 	if (NULL == ccdc_cfg) {
> 		v4l2_err(pdev->dev.driver,
> 			 "Memory allocation failed for ccdc_cfg\n");
>-		goto probe_free_dev_mem;
>+		goto probe_free_lock;
> 	}
>
> 	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
>@@ -1981,8 +1981,9 @@ probe_out_video_release:
> probe_out_release_irq:
> 	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
> probe_free_ccdc_cfg_mem:
>-	mutex_unlock(&ccdc_lock);
> 	kfree(ccdc_cfg);
>+probe_free_lock:
>+	mutex_unlock(&ccdc_lock);
> probe_free_dev_mem:
> 	kfree(vpfe_dev);
> 	return ret;
>--
>1.6.0.4

