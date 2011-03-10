Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:56707 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1CJPuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 10:50:19 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: javier Martin <javier.martin@vista-silicon.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Thu, 10 Mar 2011 21:20:12 +0530
Subject: RE: mt9p031 support for Beagleboard.
Message-ID: <19F8576C6E063C45BE387C64729E739404E1F52A8C@dbde02.ent.ti.com>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
In-Reply-To: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of javier Martin
> Sent: Thursday, March 10, 2011 8:55 PM
> To: linux-media@vger.kernel.org
> Cc: Guennadi Liakhovetski
> Subject: mt9p031 support for Beagleboard.
> 
> Hi,
> we are going to receive a Beagleaboard xM board in a couple of days.
> One of the things we would like to test is video capture.
> 
> When it comes to the DM3730 SoC, it seems the support is given through
> these two files:
> http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video/davinci/vpfe_capt
> ure.c
> --> to capture from sensor
> http://lxr.linux.no/#linux+v2.6.37.3/drivers/media/video/davinci/dm644x_cc
> dc.c
> --> to convert from Bayer RGB to YUV

[Hiremath, Vaibhav] Martin,

All above driver files are not applicable for AM/DM37x ISP camera module, you should be looking at driver/media/video/omap3isp/

Thanks,
Vaibhav
> 
> On the other hand, the sensor we would like to test is mt9p031 which
> comes with LI-5M03, a module that can be attached to Beagleboard xM
> directly:
> https://www.leopardimaging.com/Beagle_Board_xM_Camera.html
> 
> By a lot of googling I found this version of a driver for mt9p031
> which is developed by Guennadi Liakhovetski. It is located in a 2.6.32
> based branch:
> http://arago-project.org/git/projects/?p=linux-
> davinci.git;a=blob;f=drivers/media/video/mt9p031.c;h=66b5e54d0368052bf7679
> 6aa846e9464e42204bb;hb=HEAD
> 
> The question is, what does this driver lack for not entering into
> mainline? We would be very interested on helping it make it.
>  
> --
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
