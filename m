Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:63341 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab3C2POK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 11:14:10 -0400
Date: Fri, 29 Mar 2013 16:13:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>,
	Jarod Wilson <jwilson@redhat.com>,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
	Ravi Kumar V <kumarrav@codeaurora.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: Status of the patches under review at LMML (32 patches)
In-Reply-To: <20130324151111.1b2ca8d4@redhat.com>
Message-ID: <Pine.LNX.4.64.1303252344080.19340@axis700.grange>
References: <20130324151111.1b2ca8d4@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Sun, 24 Mar 2013, Mauro Carvalho Chehab wrote:

> 		== Guennadi Liakhovetski <g.liakhovetski@gmx.de> == 
> 
> I suspect that some of the above may be obsoleted:
> 
> Nov,13 2012: sh_vou: Move from videobuf to videobuf2                                http://patchwork.linuxtv.org/patch/15433  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

dropped for now

> Nov,16 2012: [05/14,media] atmel-isi: Update error check for unsigned variables     http://patchwork.linuxtv.org/patch/15475  Tushar Behera <tushar.behera@linaro.org>

I was unsure about the above, and then it rolled under the carpet 
somehow... I think, I'll just apply it.

> Jan, 3 2013: [1/3] sh_vou: Don't modify const variable in sh_vou_s_crop()           http://patchwork.linuxtv.org/patch/16095  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Superseded by "[media] media: sh_vou: fix const cropping related warnings"

> Mar,18 2013: [v2] soc_camera: Add RGB666 & RGB888 formats                           http://patchwork.linuxtv.org/patch/17407  phil.edworthy@renesas.com

An updated version is under review

> Mar,14 2013: [v2,1/8] drivers: media: use module_platform_driver_probe()            http://patchwork.linuxtv.org/patch/17378  Fabio Porcedda <fabio.porcedda@gmail.com>

scheduled for the second soc-camera 3.10 batch

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
