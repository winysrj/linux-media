Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0AYONv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 09:13:51 -0500
Message-ID: <4B5DA71B.5010701@infradead.org>
Date: Mon, 25 Jan 2010 12:13:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Franklin Meng <fmeng2002@yahoo.com>
CC: linux-media@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [Patch 3/3] Kworld 315U
References: <879792.63542.qm@web32704.mail.mud.yahoo.com>
In-Reply-To: <879792.63542.qm@web32704.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Franklin Meng wrote:

Also complained about line-wrapping.

Cheers,
Mauro
> Patch to bring device out of power saving mode.  
>  
> Signed-off-by: Franklin Meng<fmeng2002@yahoo.com>
> 
> diff -r b6b82258cf5e linux/drivers/media/video/em28xx/em28xx-core.c                   
> --- a/linux/drivers/media/video/em28xx/em28xx-core.c    Thu Dec 31 19:14:54 2009 -0200
> +++ b/linux/drivers/media/video/em28xx/em28xx-core.c    Sun Jan 17 22:54:21 2010 -0800
> @@ -1132,6 +1132,7 @@                                                                 
>   */                                                                                  
>  void em28xx_wake_i2c(struct em28xx *dev)                                             
>  {                                                                                    
> +       v4l2_device_call_all(&dev->v4l2_dev, 0, core,  s_power, 1);                   
>         v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);                     
>         v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,                     
>                         INPUT(dev->ctl_input)->vmux, 0, 0);                           
> 
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

