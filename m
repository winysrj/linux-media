Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3LNFeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 00:34:10 -0500
Date: Sat, 14 Dec 2013 06:34:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Josh Wu <josh.wu@atmel.com>
Subject: Re: [GIT PULL FOR v3.14] Atmel ISI patches
In-Reply-To: <1408503.CfMV1Tiy7q@avalon>
Message-ID: <Pine.LNX.4.64.1312140631130.31318@axis700.grange>
References: <1408503.CfMV1Tiy7q@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, 14 Dec 2013, Laurent Pinchart wrote:

> Hi Mauro,
> 
> The following changes since commit 675722b0e3917c6c917f1aa5f6d005cd3a0479f5:
> 
>   Merge branch 'upstream-fixes' into patchwork (2013-12-13 05:04:00 -0200)
> 
> are available in the git repository at:
> 
> 
>   git://linuxtv.org/pinchartl/media.git atmel/isi

Thanks for your patches. Any specific reason you're asking Mauro to pull 
directly from you instead of letting them go via my tree as usual for 
soc-camera patches?

Thanks
Guennadi

> 
> for you to fetch changes up to 8f94dee5c528d1334fd1cb548966757ba2cf1431:
> 
>   v4l: atmel-isi: Should clear bits before set the hardware register 
> (2013-12-14 03:46:39 +0100)
> 
> ----------------------------------------------------------------
> Josh Wu (2):
>       v4l: atmel-isi: remove SOF wait in start_streaming()
>       v4l: atmel-isi: Should clear bits before set the hardware register
> 
> Laurent Pinchart (5):
>       v4l: atmel-isi: Use devm_* managed allocators
>       v4l: atmel-isi: Defer clock (un)preparation to enable/disable time
>       v4l: atmel-isi: Reset the ISI when starting the stream
>       v4l: atmel-isi: Make the MCK clock optional
>       v4l: atmel-isi: Fix color component ordering
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 179 +++++++------------------
>  include/media/atmel-isi.h                     |   2 +
>  2 files changed, 55 insertions(+), 126 deletions(-)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
