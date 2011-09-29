Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55427 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1I2Taa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 15:30:30 -0400
Date: Thu, 29 Sep 2011 21:30:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: GIGIN JOSE <gigin_jose@yahoo.co.in>
cc: linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: YCbCr 422 on s3c2440
In-Reply-To: <loom.20110929T160147-550@post.gmane.org>
Message-ID: <Pine.LNX.4.64.1109292127370.2405@axis700.grange>
References: <loom.20110929T160147-550@post.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forwarding to the suitable list, although, I don't think s3c24xx SoCs are 
currently supported by V4L.

Thanks
Guennadi

On Thu, 29 Sep 2011, GIGIN JOSE wrote:

> Hi, 
> 
> I am working on s3c2440 ARM linux platform. I am connecting 
> an image sensor device to the camera controller of the s3c2440 
> ARM processor. The image sensor outputs YCbCr 4:2:2 output. 
> Can I pass the output of this format to the preview path of 
> the camera controller to get proper image ? 
> 
> The image sensor also outputs RGB565 format, which I can 
> comfortably view using the preview path. But I would like 
> to get the YCbCr 4:2:2 format from the image sensor device. 
> 
> Is this possible with the preview path ? Any other register
>  settings are required for YCbCr 4:2:2 mode on the preview 
> path, other than that done for the RGB565 format. ?
> 
> Thank You
> GIGIN  
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
