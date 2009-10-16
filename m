Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49154 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205AbZJPOLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 10:11:35 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9GEAx5D016729
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 09:10:59 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id n9GEAxV3011889
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 09:10:59 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id n9GEAxtP011634
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 09:10:59 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 16 Oct 2009 09:10:57 -0500
Subject: RE: [PATCH 4/6] Davinci VPFE Capture:Replaced IRQ_VDINT1 with
 vpfe_dev->ccdc_irq1
Message-ID: <A69FA2915331DC488A831521EAE36FE4015555F563@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
 <1255446562-16809-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1255446562-16809-1-git-send-email-hvaibhav@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by : Muralidharan Karicheri <m-karicheri2@ti.com>

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Hiremath, Vaibhav
>Sent: Tuesday, October 13, 2009 11:09 AM
>To: linux-media@vger.kernel.org
>Cc: Hiremath, Vaibhav
>Subject: [PATCH 4/6] Davinci VPFE Capture:Replaced IRQ_VDINT1 with
>vpfe_dev->ccdc_irq1
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
>index c3c37e7..abe21e4 100644
>--- a/drivers/media/video/davinci/vpfe_capture.c
>+++ b/drivers/media/video/davinci/vpfe_capture.c
>@@ -752,7 +752,7 @@ static void vpfe_detach_irq(struct vpfe_device
>*vpfe_dev)
>
> 	frame_format = ccdc_dev->hw_ops.get_frame_format();
> 	if (frame_format == CCDC_FRMFMT_PROGRESSIVE)
>-		free_irq(IRQ_VDINT1, vpfe_dev);
>+		free_irq(vpfe_dev->ccdc_irq1, vpfe_dev);
> }
>
> static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
>--
>1.6.2.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

