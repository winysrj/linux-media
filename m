Return-path: <linux-media-owner@vger.kernel.org>
Received: from mis07.de ([93.186.196.80]:35086 "EHLO mis07.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbZJWO2Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 10:28:25 -0400
Message-ID: <62C779E180BB45FB828023FAF1233BAA@pcvirus>
From: "rath" <mailings@hardware-datenbank.de>
To: <linux-media@vger.kernel.org>
Cc: <hvaibhav@ti.com>
References: <4ADAF16B.1090409@hardware-datenbank.de>
Subject: Re: cpu load of webcam read out with omap3/beagleboard
Date: Fri, 23 Oct 2009 16:28:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-15";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nobody has an idea? I think this cpu load isn't normal, becuase everywhere 
you can read, that the bealgeboard is very fast and it has 500MHz...

Regards, Joern


----- Original Message ----- 
From: "Rath" <mailings@hardware-datenbank.de>
To: "Linux-Media" <linux-media@vger.kernel.org>
Sent: Sunday, October 18, 2009 12:43 PM
Subject: cpu load of webcam read out with omap3/beagleboard


> Hi,
>
> I have beagleboard with the OMAP3530 processor and I want to read a usb 
> webcam out. But I only get usable results at 160x120 resolution.
> I set the pixelformat to "V4L2_PIX_FMT_RGB24" and the resolution to 
> 160x120. With these settings I get 30fps at 4% cpu load. But when I set 
> the resolution to 320x240 or 640x480 the cpu load is at 98% and I get only 
> 17 or 4fps. Also I get at 640x480 errors like "libv4lconvert: Error 
> decompressing JPEG: fill_nbits error: need 9 more bits".
>
> Is this a normal behavior or is  there a way to fix  this?  I think the 
> problem is the conversion from MJPEG to RGB, because when I set the 
> pixelformat to MJPEG the cpu load is <1%.  But  I need RGB data for image 
> processing.
>
> I hope someone can help me.
>
> Regards, Joern
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

