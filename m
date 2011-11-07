Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1KGLMx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 06:12:53 -0500
Date: Mon, 7 Nov 2011 12:12:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.2] Menu changes
In-Reply-To: <201111071042.30157.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1111071206440.26363@axis700.grange>
References: <201111071042.30157.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Mon, 7 Nov 2011, Hans Verkuil wrote:

> Hi Mauro,
> 
> This is the patch series that reorganizes the V4L menu.
> 
> The only thing I didn't touch is the SoC camera support submenu.
> 
> Guennadi, what is the status for the SoC camera sensor drivers? I see that
> they still have a menu dependency to SOC_CAMERA. Is that still valid?

Yes, at least most, or, perhaps all "former" soc-camera client (camera, 
decoder) subdev drivers need soc-camera enabled in the kernel and need the 
soc_camera_core module loaded for them to run. Most those driver have been 
converted to work without relying on the soc-camera infrastructure being 
active, but they still need a couple of soc-camera helper functions, 
provided by that module. As the need arises, those helper fuunctions can 
be moved to the v4l2 core.

Thanks
Guennadi

> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 31cea59efb3a4210c063f31c061ebcaff833f583:
> 
>   [media] saa7134.h: Suppress compiler warnings when CONFIG_VIDEO_SAA7134_RC is not set (2011-11-03 16:58:20 -0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/hverkuil/media_tree.git menu
> 
> Hans Verkuil (8):
>       V4L menu: move USB drivers section to the top.
>       V4L menu: move ISA and parport drivers into their own submenu.
>       V4L menu: remove the EXPERIMENTAL tag from vino and c-qcam.
>       V4L menu: move all platform drivers to the bottom of the menu.
>       V4L menu: remove duplicate USB dependency.
>       V4L menu: reorganize the radio menu.
>       V4L menu: move all PCI(e) devices to their own submenu.
>       cx88: fix menu level for the VP-3054 module.
> 
>  drivers/media/radio/Kconfig      |  298 +++++++++++++++--------------
>  drivers/media/video/Kconfig      |  394 +++++++++++++++++++++-----------------
>  drivers/media/video/cx88/Kconfig |   10 +-
>  3 files changed, 377 insertions(+), 325 deletions(-)
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
