Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50196 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3ACLnS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 06:43:18 -0500
Date: Thu, 3 Jan 2013 12:43:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bill Pemberton <wfp5p@virginia.edu>
cc: gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Subject: Re: =?UTF-8?q?=5BPATCH=20133/493=5D=20remove=20use=20of=20=5F=5Fdevexit=5Fp?=
In-Reply-To: <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
Message-ID: <Pine.LNX.4.64.1301031235370.17494@axis700.grange>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bill

On Mon, 19 Nov 2012, Bill Pemberton wrote:

> CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
> needed.

Doesn't this also make the use of __refdata in many locations like this

[snip]

> diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> index 0528650..0d0344a 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> @@ -382,7 +382,7 @@ static __devexit int sh_csi2_remove(struct platform_device *pdev)
>  }
>  
>  static struct platform_driver __refdata sh_csi2_pdrv = {
> -	.remove	= __devexit_p(sh_csi2_remove),
> +	.remove	= sh_csi2_remove,
>  	.probe	= sh_csi2_probe,
>  	.driver	= {
>  		.name	= "sh-mobile-csi2",

superfluous? If so, I'm sure you'd be happy to make a couple more patches 
to continue this series ;-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
