Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3AGM37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 07:29:59 -0500
Date: Mon, 7 Jan 2013 13:29:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Status of the patches under review at LMML (35 patches)
In-Reply-To: <20130106113455.329ad868@redhat.com>
Message-ID: <Pine.LNX.4.64.1301071317460.23972@axis700.grange>
References: <20130106113455.329ad868@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Sun, 6 Jan 2013, Mauro Carvalho Chehab wrote:

> 		== Guennadi Liakhovetski <g.liakhovetski@gmx.de> == 
> 
> Oct,30 2012: [v2,2/4] media: mx2_camera: Add image size HW limits.                  http://patchwork.linuxtv.org/patch/15298  Javier Martin <javier.martin@vista-silicon.com>

In the mainline as commit 6ec5575c381de50b17e68796435f20ce1b27de79

> Nov,13 2012: sh_vou: Move from videobuf to videobuf2                                http://patchwork.linuxtv.org/patch/15433  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Patch has to be fixed.

> Nov,16 2012: [05/14,media] atmel-isi: Update error check for unsigned variables     http://patchwork.linuxtv.org/patch/15475  Tushar Behera <tushar.behera@linaro.org>

Hmm, I'll push it (or an equivalent of it) in the second 3.9 pull request

> Jan, 3 2013: [1/3] sh_vou: Don't modify const variable in sh_vou_s_crop()           http://patchwork.linuxtv.org/patch/16095  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Jan, 3 2013: [2/3] sh_vou: Use video_drvdata()                                      http://patchwork.linuxtv.org/patch/16097  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Jan, 3 2013: [3/3] sh_vou: Use vou_dev instead of vou_file wherever possible        http://patchwork.linuxtv.org/patch/16096  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

These ones arrived after my pull request, I'll take care of them in the 
next pull round.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
