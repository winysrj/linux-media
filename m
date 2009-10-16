Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46688 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759944AbZJPO1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 10:27:34 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9GEQv5G029688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 09:26:57 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id n9GEQvGx013632
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 09:26:57 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id n9GEQvu4018980
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 09:26:57 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 16 Oct 2009 09:26:55 -0500
Subject: RE: [PATCH 1/6] Davinci VPFE Capture: Specify device pointer in
 videobuf_queue_dma_contig_init
Message-ID: <A69FA2915331DC488A831521EAE36FE4015555F574@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
 <1255446412-16642-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1255446412-16642-1-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by Muralidharan Karicheri <m-karicheri2@ti.com>

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
>Sent: Tuesday, October 13, 2009 11:07 AM
>To: linux-media@vger.kernel.org
>Cc: Hiremath, Vaibhav
>Subject: [PATCH 1/6] Davinci VPFE Capture: Specify device pointer in
>videobuf_queue_dma_contig_init
>
>From: Vaibhav Hiremath <hvaibhav@ti.com>
>
>Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>---
> drivers/media/video/davinci/vpfe_capture.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/media/video/davinci/vpfe_capture.c
>b/drivers/media/video/davinci/vpfe_capture.c
>index ff43446..dc32de0 100644
>--- a/drivers/media/video/davinci/vpfe_capture.c
>+++ b/drivers/media/video/davinci/vpfe_capture.c
>@@ -1547,7 +1547,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
> 	vpfe_dev->memory = req_buf->memory;
> 	videobuf_queue_dma_contig_init(&vpfe_dev->buffer_queue,
> 				&vpfe_videobuf_qops,
>-				NULL,
>+				vpfe_dev->pdev,
> 				&vpfe_dev->irqlock,
> 				req_buf->type,
> 				vpfe_dev->fmt.fmt.pix.field,
>--
>1.6.2.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

