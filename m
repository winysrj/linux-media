Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:32442 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZDUJBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 05:01:12 -0400
Date: Tue, 21 Apr 2009 11:01:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg KH <greg@kroah.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] drivers: move media after i2c
Message-ID: <20090421110102.78886dee@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0904210908360.6551@axis700.grange>
References: <Pine.LNX.4.64.0904210908360.6551@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Apr 2009 09:22:38 +0200 (CEST), Guennadi Liakhovetski wrote:
> Currently drivers/media drivers are linked very early - directly after 
> base, block, misc, and mfd and before ata, scsi, ide, input, firewire, 
> usb, and i2c. This breaks static build of video4linux drivers, that use 
> generic CPU i2c adapter drivers and the v4l2-subdev subsystem, because 
> during video4linux probing the v4l2-subdev core requires a struct 
> i2c_adapter context, which cannot be satisfied before the i2c subsystem is 
> initialised. Moving drivers/media after drivers/i2c fixes this problem.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Looks good to me.

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
> 
> The best way to trigger action is by submitting a patch:-) So, let's see 
> what comes out of it - on the one hand I don't see any reason why media 
> has to be linked this early, and nobody was able to give me one yesterday 
> as this problem has been discussed on linux-media, OTOH, maybe indeed it 
> would be better to move i2c the whole way up above media, but that'd be 
> much bigger of a change, I think.
> 
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 2618a61..1266ead 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -36,7 +36,7 @@ obj-$(CONFIG_FB_INTEL)          += video/intelfb/
>  
>  obj-y				+= serial/
>  obj-$(CONFIG_PARPORT)		+= parport/
> -obj-y				+= base/ block/ misc/ mfd/ media/
> +obj-y				+= base/ block/ misc/ mfd/
>  obj-$(CONFIG_NUBUS)		+= nubus/
>  obj-y				+= macintosh/
>  obj-$(CONFIG_IDE)		+= ide/
> @@ -71,7 +71,7 @@ obj-$(CONFIG_GAMEPORT)		+= input/gameport/
>  obj-$(CONFIG_INPUT)		+= input/
>  obj-$(CONFIG_I2O)		+= message/
>  obj-$(CONFIG_RTC_LIB)		+= rtc/
> -obj-y				+= i2c/
> +obj-y				+= i2c/ media/
>  obj-$(CONFIG_W1)		+= w1/
>  obj-$(CONFIG_POWER_SUPPLY)	+= power/
>  obj-$(CONFIG_HWMON)		+= hwmon/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jean Delvare
