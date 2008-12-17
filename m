Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHCUvPE020194
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 07:30:57 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHCUr3T027579
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 07:30:54 -0500
Date: Wed, 17 Dec 2008 13:31:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20081216103113.13174.97907.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0812171328150.5465@axis700.grange>
References: <20081216103113.13174.97907.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] video: sh_mobile_ceu cleanups and comments V2
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

On Tue, 16 Dec 2008, Magnus Damm wrote:

> From: Magnus Damm <damm@igel.co.jp>

Magnus, sorry, looks like you missed a couple more:

> @@ -452,13 +459,13 @@ static int sh_mobile_ceu_set_bus_param(s

	if ((icd->current_fmt->fourcc == V4L2_PIX_FMT_NV21) ||
	    (icd->current_fmt->fourcc == V4L2_PIX_FMT_NV61))
		value ^= 0x00000100; /* swap U, V to change from NV1x->NVx1 */

	value |= (common_flags & SOCAM_VSYNC_ACTIVE_LOW) ? (1 << 1) : 0;
	value |= (common_flags & SOCAM_HSYNC_ACTIVE_LOW) ? (1 << 0) : 0;
	value |= (buswidth == 16) ? (1 << 12) : 0;

Let's make it complete, ok?

>  
>  	if (yuv_mode) {
>  		width = icd->width * 2;
> -		width = (buswidth == 16) ? width / 2 : width;
> +		width = buswidth == 16 ? width / 2 : width;
>  		cfszr_width = cdwdr_width = icd->width;
>  	} else {
>  		width = icd->width * ((icd->current_fmt->depth + 7) >> 3);
> -		width = (buswidth == 16) ? width / 2 : width;
> -		cfszr_width = (buswidth == 8) ? width / 2 : width;
> -		cdwdr_width = (buswidth == 16) ? width * 2 : width;
> +		width = buswidth == 16 ? width / 2 : width;
> +		cfszr_width = buswidth == 8 ? width / 2 : width;
> +		cdwdr_width = buswidth == 16 ? width * 2 : width;
>  	}
>  
>  	ceu_write(pcdev, CAMOR, 0);
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
