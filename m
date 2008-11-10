Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAIu5xg005110
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 13:56:05 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mAAItg1X006200
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 13:55:49 -0500
Date: Mon, 10 Nov 2008 19:55:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081109235940.4c009a68.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0811101946200.8315@axis700.grange>
References: <20081107125919.ddf028a6.ospite@studenti.unina.it>
	<874p2jbegl.fsf@free.fr>
	<Pine.LNX.4.64.0811082119280.8956@axis700.grange>
	<20081109235940.4c009a68.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH, RFC] mt9m111: allow data to be received on pixelclock
 falling edge?
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

(please, use reply-to-all, thanks)

On Sun, 9 Nov 2008, Antonio Ospite wrote:

> > So, shall we add inverter flags?
> 
> Would you accept this change instead?
> 
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -845,7 +845,7 @@ static int pxa_camera_set_bus_param(struct
> soc_camera_device *icd, __u32 pixfmt) cicr4 |= CICR4_PCLK_EN;
>   if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
>     cicr4 |= CICR4_MCLK_EN;
> - if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
> + if (pcdev->platform_flags & PXA_CAMERA_PCP)
>     cicr4 |= CICR4_PCP;
>   if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
>     cicr4 |= CICR4_HSP;
> 
> and maybe for other cicr4 bits too, in the spirit of using the SOCAM_
> defines only for icd set_bus_param() but still giving preference to
> platform data for host settings.
> 
> It is kind of tricky I know, but it would allow to overcome unexpected
> hardware setups.

I would prefer not to disregard camera flags. If we don't find a better 
solution, I would introduce platform inverter flags, and, I think, we 
better put them in camera platform data - not host platform data, to 
provide a finer granularity. In the end, inverters can also be located on 
camera boards, then you plug-in a different camera and, if your 
inverter-flags were in host platform data, it doesn't work again.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
