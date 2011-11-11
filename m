Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58993 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1KKH76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 02:59:58 -0500
Date: Fri, 11 Nov 2011 08:59:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: soc_camera.h compiler warning: should be fixed
In-Reply-To: <201111101026.47226.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1111110856350.4608@axis700.grange>
References: <201111101026.47226.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Thu, 10 Nov 2011, Hans Verkuil wrote:

> Hi Guennadi,
> 
> The daily build gives these compiler warnings when compiling on a 64-bit
> platform:
> 
> In file included from drivers/media/video/imx074.c:19:0:
> include/media/soc_camera.h: In function ‘soc_camera_i2c_to_vdev’:
> include/media/soc_camera.h:257:34: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> In file included from drivers/media/video/mt9m111.c:18:0:
> include/media/soc_camera.h: In function ‘soc_camera_i2c_to_vdev’:
> include/media/soc_camera.h:257:34: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Yes, this warnings have already been reported and yes, they should be 
fixed.

> (and a whole bunch more of these warnings).
> 
> The culprit is this inline function:
> 
> static inline struct video_device *soc_camera_i2c_to_vdev(const struct i2c_client *client)
> {
>         struct v4l2_subdev *sd = i2c_get_clientdata(client);
>         struct soc_camera_device *icd = (struct soc_camera_device *)sd->grp_id;
>         return icd ? icd->vdev : NULL;
> }
> 
> sd->grp_id is a u32, so obviously this will fail on a 64-bit arch.
> 
> Since ARM is moving to 64-bits as well we should fix this.
> 
> Instead of abusing grp_id it is better to use the relatively new v4l2_subdev
> 'host_priv' field. This is a proper void pointer, and can be used by the host
> driver as it pleases.

I don't think this would work though. .grp_id is not only used to pass a 
value between drivers, but also to filter, which subdevices will execute 
this operation, as in v4l2_device_call_all(). I'll have to find time to 
think of a solution.

> Can you make a patch for this? It would be nice to get rid of these warnings.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
