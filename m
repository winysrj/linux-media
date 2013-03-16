Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3CPGvc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Mar 2013 02:51:32 -0400
Date: Sat, 16 Mar 2013 07:50:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 4/5] v4l2: add const to argument of write-only
 s_register ioctl.
In-Reply-To: <60593e2e438a51d9ba5be2179f56a0858df458db.1363342714.git.hans.verkuil@cisco.com>
Message-ID: <Pine.LNX.4.64.1303160747100.12165@axis700.grange>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl>
 <60593e2e438a51d9ba5be2179f56a0858df458db.1363342714.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Mar 2013, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This ioctl is defined as IOW, so pass the argument as const.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

[snip]

>  drivers/media/i2c/soc_camera/mt9m001.c          |    2 +-
>  drivers/media/i2c/soc_camera/mt9m111.c          |    2 +-
>  drivers/media/i2c/soc_camera/mt9t031.c          |    2 +-
>  drivers/media/i2c/soc_camera/mt9t112.c          |    2 +-
>  drivers/media/i2c/soc_camera/mt9v022.c          |    2 +-
>  drivers/media/i2c/soc_camera/ov2640.c           |    2 +-
>  drivers/media/i2c/soc_camera/ov5642.c           |    2 +-
>  drivers/media/i2c/soc_camera/ov6650.c           |    2 +-
>  drivers/media/i2c/soc_camera/ov772x.c           |    2 +-
>  drivers/media/i2c/soc_camera/ov9640.c           |    2 +-
>  drivers/media/i2c/soc_camera/ov9740.c           |    2 +-
>  drivers/media/i2c/soc_camera/rj54n1cb0c.c       |    2 +-
>  drivers/media/i2c/soc_camera/tw9910.c           |    2 +-

[snip]

>  drivers/media/platform/sh_vou.c                 |    2 +-
>  drivers/media/platform/soc_camera/soc_camera.c  |    2 +-

For the above

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
