Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37315 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbbD3GWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 02:22:13 -0400
Message-ID: <5541CA09.2090508@xs4all.nl>
Date: Thu, 30 Apr 2015 08:22:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	mjpeg-users@lists.sourceforge.net
Subject: Re: [PATCH 09/14] zoran: fix indent
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com> <c803709a49957c2be8f0a43782cd3140b4aedf4a.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <c803709a49957c2be8f0a43782cd3140b4aedf4a.1430235781.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/28/2015 05:43 PM, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> 	drivers/media/pci/zoran/zoran_device.c:1594 zoran_init_hardware() warn: inconsistent indenting
> 
> Fix indent. While here, fix CodingStyle and remove dead code, as it
> can always be recovered from git logs.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
> index b6801e035ea4..40119b3c52c1 100644
> --- a/drivers/media/pci/zoran/zoran_device.c
> +++ b/drivers/media/pci/zoran/zoran_device.c
> @@ -1584,14 +1584,11 @@ zoran_init_hardware (struct zoran *zr)
>  	jpeg_codec_sleep(zr, 1);
>  	jpeg_codec_sleep(zr, 0);
>  
> -	/* set individual interrupt enables (without GIRQ1)
> -	 * but don't global enable until zoran_open() */
> -
> -	//btwrite(IRQ_MASK & ~ZR36057_ISR_GIRQ1, ZR36057_ICR);  // SW
> -	// It looks like using only JPEGRepIRQEn is not always reliable,
> -	// may be when JPEG codec crashes it won't generate IRQ? So,
> -	 /*CP*/			//        btwrite(IRQ_MASK, ZR36057_ICR); // Enable Vsync interrupts too. SM    WHY ? LP
> -	    zr36057_init_vfe(zr);
> +	/*
> +	 * set individual interrupt enables (without GIRQ1)
> +	 * but don't global enable until zoran_open()
> +	 */
> +	zr36057_init_vfe(zr);
>  
>  	zr36057_enable_jpg(zr, BUZ_MODE_IDLE);
>  
> 

