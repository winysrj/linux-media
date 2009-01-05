Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n05KRtYa007657
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 15:27:55 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n05KRb5v008938
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 15:27:37 -0500
Date: Mon, 5 Jan 2009 21:27:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Luotao Fu <l.fu@pengutronix.de>
In-Reply-To: <1231175487-3293-1-git-send-email-l.fu@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0901052125480.8605@axis700.grange>
References: <1231175487-3293-1-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove duplicated defines in pxa_camera.c
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

On Mon, 5 Jan 2009, Luotao Fu wrote:

> Defines for CIR Registers have been moved to pxa_camera.h. So remove them from
> pxa_camera.c to avoid compiler warnings.
> 
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> ---
>  drivers/media/video/pxa_camera.c |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index cb8c5e1..4eda750 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -44,19 +44,6 @@
>  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
>  #define PXA_CAM_DRV_NAME "pxa27x-camera"
>  
> -/* Camera Interface */
> -#define CICR0		0x0000
> -#define CICR1		0x0004
> -#define CICR2		0x0008
> -#define CICR3		0x000C
> -#define CICR4		0x0010
> -#define CISR		0x0014
> -#define CIFR		0x0018
> -#define CITOR		0x001C
> -#define CIBR0		0x0028
> -#define CIBR1		0x0030
> -#define CIBR2		0x0038
> -
>  #define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
>  #define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
>  #define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
> -- 
> 1.5.6.5

NAK. Please, see an earlier patch from Eric Miao, a correct fix for this 
is in the queue.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
