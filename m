Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m71NVLKG000739
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 19:31:21 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m71NV9P4021247
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 19:31:09 -0400
Date: Sat, 2 Aug 2008 01:31:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <1217629566-26637-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0808020128060.14927@axis700.grange>
References: <87tze4cr3g.fsf@free.fr>
	<1217629566-26637-1-git-send-email-robert.jarzmik@free.fr>
	<1217629566-26637-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, 2 Aug 2008, Robert Jarzmik wrote:

> PXA suspend switches off DMA core, which loses all context
> of previously assigned descriptors. As pxa_camera driver
> relies on DMA transfers, setup the lost descriptors on
> resume and retrigger frame acquisition if needed.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

_Conditionally_ applied: I changed the subject to "Add suspend/resume 
to...", upgraded to the current Linus' top-of-tree, and, most importantly, 
changed this:

> +static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
> +{
> +	struct soc_camera_host *ici =
> +		to_soc_camera_host(icd->dev.parent);
> +	struct pxa_camera_dev *pcdev = ici->priv;
> +	int i = 0, ret = 0;
> +
> +	pcdev->save_cicr[i++] = CICR0;
> +	pcdev->save_cicr[i++] = CICR1;
> +	pcdev->save_cicr[i++] = CICR2;
> +	pcdev->save_cicr[i++] = CICR3;
> +	pcdev->save_cicr[i++] = CICR4;
> +
> +	if ((pcdev->icd) && (pcdev->icd->ops->resume))
> +		ret = pcdev->icd->ops->resume(pcdev->icd);

To 

+	if ((pcdev->icd) && (pcdev->icd->ops->suspend))
+		ret = pcdev->icd->ops->suspend(pcdev->icd);

Which I assume was a typo. Please, test these patches with this my change, 
and confirm they are ok now. I'll push both of them upstream then.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
