Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:26151 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaEWQgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 12:36:11 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N61002Y2CS9SL40@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 May 2014 12:36:09 -0400 (EDT)
Date: Fri, 23 May 2014 13:36:03 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: Re: [GIT PULL FOR v3.16] Various fixes
Message-id: <20140523133603.7d5e78ff.m.chehab@samsung.com>
In-reply-to: <537086CE.9000800@xs4all.nl>
References: <537086CE.9000800@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 12 May 2014 10:31:10 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> (Updated version of my pull request of May 9th, adding the remaining em28xx patches
> from Frank.)
> 
> Hi Mauro,
> 
> I went through my pending patches queue and managed to go through most of it.
> 
> Most patches are fairly trivial, but you should take a close look at the
> videobuf-dma-contig patch from Ma Haijun since you introduced the vm_iomap_memory()
> change. I reviewed it carefully and tested it and it seems sound to me, but
> that's one patch that needs an extra pair of eyeballs.
> 
> Also note that I tested the saa7134 querybuf patch from Mikhail Domrachev successfully
> using my signal generator.
> 
> Regards,
> 
> 	Hans
> 
> 
> The following changes since commit 393cbd8dc532c1ebed60719da8d379f50d445f28:
> 
>   [media] smiapp: Use %u for printing u32 value (2014-04-23 16:05:06 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.16d
> 
> for you to fetch changes up to 87b3628098449bb09e2bebf14bf9ce1978cec524:
> 
>   em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio (2014-05-12 10:27:00 +0200)
> 
> ----------------------------------------------------------------
> Alexander Shiyan (1):
>       media: coda: Use full device name for request_irq()
> 
> Bartlomiej Zolnierkiewicz (1):
>       v4l: ti-vpe: fix devm_ioremap_resource() return value checking
> 
> Daeseok Youn (1):
>       s2255drv: fix memory leak s2255_probe()
> 
> Dan Carpenter (1):
>       av7110: fix confusing indenting
> 
> Frank Schaefer (24):
>       em28xx: fix indenting in em28xx_usb_probe()
>       em28xx: remove some unused fields from struct em28xx
>       em28xx: remove function em28xx_compression_disable() and its call
>       em28xx: move norm_maxw() and norm_maxh() from em28xx.h to em28xx-video.c
>       em28xx: remove the i2c_set_adapdata() call in em28xx_i2c_register()
>       em28xx: move sub-module data structs to a common place in the main struct
>       em28xx-video: simplify usage of the pointer to struct v4l2_ctrl_handler in em28xx_v4l2_init()
>       em28xx: start moving em28xx-v4l specific data to its own struct
>       em28xx: move struct v4l2_ctrl_handler ctrl_handler from struct em28xx to struct v4l2
>       em28xx: move struct v4l2_clk *clk from struct em28xx to struct v4l2
>       em28xx: move video_device structs from struct em28xx to struct v4l2
>       em28xx: move videobuf2 related data from struct em28xx to struct v4l2
>       em28xx: move v4l2 frame resolutions and scale data from struct em28xx to struct v4l2
>       em28xx: move vinmode and vinctrl data from struct em28xx to struct v4l2
>       em28xx: move TV norm from struct em28xx to struct v4l2
>       em28xx: move struct em28xx_fmt *format from struct em28xx to struct v4l2
>       em28xx: move progressive/interlaced fields from struct em28xx to struct v4l2
>       em28xx: move sensor parameter fields from struct em28xx to struct v4l2
>       em28xx: move capture state tracking fields from struct em28xx to struct v4l2
>       em28xx: move v4l2 user counting fields from struct em28xx to struct v4l2
>       em28xx: move tuner frequency field from struct em28xx to struct v4l2
>       em28xx: remove field tda9887_conf from struct em28xx
>       em28xx: remove field tuner_addr from struct em28xx
>       em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio

Hans,

Almost all those em28xx patches don't have any description!

Please either enforce with the patch author for them to add a description
for each patch or add yourself some description for them. 

I'm really annoyed by merging this series, due to that, especially
when some answers why certain design decisions taken on some of those
patches are not answered...

For example, on "em28xx: move sensor parameter fields from struct em28xx to struct v4l2",

We have 3 fields being moved to em28xx_v4l2 struct:
-       int sensor_xres, sensor_yres;
-       int sensor_xtal;

But this one was kept there:

+       enum em28xx_sensor em28xx_sensor;       /* camera specific */

I would be expecting, on this particular, changeset, a comment like:

[media] em28xx: move sensor parameter fields from struct em28xx to struct v4l2
    
Move camera sensor resolution and xtal out of em28xx common struct,
as thore are used only by the em28xx v4l2 submodule.

The em28xx_sensor firmware, however, couldn't be moved there because
*some reason*.

Btw, probably several of those data merging stuff would be better
handled if merged into a single patch, stating how much memory
was saved on digital-only devices where all those V4L2-specific
data are not allocated anymore.

Thanks,
Mauro
