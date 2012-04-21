Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2DUIg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 04:36:29 -0400
Date: Sat, 21 Apr 2012 10:36:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alexander Sedunov <san822@yandex.ru>
cc: linux-media@vger.kernel.org
Subject: Re: Camera driver for OV5640 OmniVision CMOS sensor
In-Reply-To: <23621334982988@web17f.yandex.ru>
Message-ID: <alpine.DEB.2.00.1204211015540.7880@axis700.grange>
References: <23621334982988@web17f.yandex.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexander

On Sat, 21 Apr 2012, Alexander Sedunov wrote:

> Hi,
> What kind of hardware did  you used for this project - OMAP, Da Vinci or
> FPGA ?

If you look in the sources, or even at the "SoC camera" article under 
"headlines" at the below page (when the link is fixed to work again), 
you'll see, that currently AT91, i.MX1, i.MX2[57], i.MX3[15], OMAP1, 
PXA270, sh-mobile (CEU unit on SuperH and ARM SoCs), V4L drivers use the 
soc-camera framework. So, it is by no means a single "project."

> http://www.open-technology.de/categories/2-SoC-camera 
> What state have your project ? Is it open or commercial data ? 

It is all Linux kernel mainline, i.e., open-source, GPL.

> Best regards, Alexander.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
