Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2DWLlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:41:35 -0400
Date: Mon, 23 Apr 2012 13:41:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>,
	Magnus <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: Re: Current status of SuperH soc-camera/CEU driver
In-Reply-To: <87ehrf9fjo.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <Pine.LNX.4.64.1204231325300.19312@axis700.grange>
References: <87ehrf9fjo.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san

Thanks for spotting these.

On Sun, 22 Apr 2012, Kuninori Morimoto wrote:

> Hi Guennadi
> 
> Now I'm checking Soc-Camera/CEU driver, and I noticed that
> platform settings (maybe) weren't cared even though driver side was updated.
> I'm not sure for details, but it makes me misunderstand.
> Could you please update these ?
> 
> 1) e1db704326c9a5164da4e24b01e487c0be687fa2
> ([media] V4L: sh_mobile_ceu_camera: convert to the new mbus-config subdev operations)
> 
> 	This patch removed SH_CEU_FLAG_USE_xxBIT_BUS flags from CEU driver,
> 	but below platform still has this flags.
> 
> 	arch/sh/boards/mach-ap325rxa/
> 	arch/sh/boards/mach-ecovec24/
> 	arch/sh/boards/mach-kfr2r09/
> 	arch/sh/boards/mach-migor/
> 	arch/sh/boards/mach-se/7724/
> 	arch/arm/mach-shmobile/board-ap4evb.c
> 	arch/arm/mach-shmobile/board-mackerel.c

AFAICS, all these platforms only use 8 bits, so, none of them is broken. 
OTOH, I'm not sure any more, what was the motivation behind that removal. 
Maybe exactly because we didn't have any platforms with 16-bit camera 
connections and maybe I saw a problem with it, so, I decided to remove 
them until we get a chance to properly implement and test 16-bits? Do you 
have such a board?

> 2) ff51345832628eb641805a01213aeae0bb4a23c1
> ([media] V4L: mt9t112: remove superfluous soc-camera client operations)
> 
> 	this patch remoded MT9T112_FLAG_DATAWIDTH_xx flags from mt9t112 driver,
> 	but Ecovec platform still has it.
> 
> 	arch/sh/boards/mach-ecovec24/

Perhaps, the reason was more or less the same - no users, untested code.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
