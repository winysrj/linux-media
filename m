Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:63255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354Ab1FBKgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:36:24 -0400
Date: Thu, 2 Jun 2011 12:36:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	mch_kot@yahoo.com.cn
Subject: Re: [PATCH v6 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
In-Reply-To: <BANLkTimMrUm58CN6W56N+MR9pKbzZS0DAQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1106021233560.4067@axis700.grange>
References: <1306942609-2440-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1106020946030.4067@axis700.grange>
 <BANLkTimMrUm58CN6W56N+MR9pKbzZS0DAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2 Jun 2011, javier Martin wrote:

> OK Guennadi,
> I'll fix those cosmetics issues in my next version where I will add
> VFLIP and HFLIP control support (which I removed previously to make
> the code less complex).

Please, don't. Let's first get the simple version of your driver in the 
mainline, then it can be extended. Just, please, make sure to address all 
remaining issues without changing anything else:)

Thanks
Guennadi

> 
> Now we talk about controls I have a question regarding controls
> defined in video subdevices like mt9p031 or mt9v032:
> 
> What device node should I use to set these controls through an ioctl() ?
> For instance, with mt9p031 + Beagleboard xM we have:
> 
> ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP
> CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
> ./yavta --stdout -f SGRBG8 -s 320x240 -n 4 --capture=100 --skip 3 -F
> `./media-ctl -e "OMAP3 ISP CCDC output"` | nc 192.168.0.42 3000
> 
> Where
> 
> root@beagleboard:~# ./media-ctl -e "OMAP3 ISP CCDC output"
> /dev/video2
> 
> However, if I try to set sensor controls using /dev/video2 I get an
> error (invalid argument).
> 
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
