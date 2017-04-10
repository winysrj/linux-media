Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55187
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752894AbdDJLMa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 07:12:30 -0400
Date: Mon, 10 Apr 2017 08:12:23 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Songjun Wu <Songjun.Wu@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [GIT PULL FOR v4.12] atmel-isi/ov7670/ov2640: convert to
 standalone drivers
Message-ID: <20170410081223.5e3a58e9@vento.lan>
In-Reply-To: <e0f7f4df-baf0-f1f8-ef16-f3ea13329090@xs4all.nl>
References: <e0f7f4df-baf0-f1f8-ef16-f3ea13329090@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 4 Apr 2017 14:46:25 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Converts atmel-isi to a regular v4l2 driver instead of relying on soc-camera.
> 
> The ov2640 and ov7670 drivers are also converted to normal i2c drivers.
> 
> Tested with my sama5d3-Xplained board, the ov2640 sensor and two ov7670
> sensors: one with and one without reset/pwdn pins. Also tested with my
> em28xx-based webcam.
> 
> See here for the patch series' cover letter:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg110532.html
> 
> The only change since this patch series was posted is that last patch updating
> the atmel-isi path in MAINTAINERS.
> 
> After this patch series the only platform driver still using soc-camera is the
> sh_mobile_ceu_camera driver.
> 
> The (tentative) plan is to merge soc-camera into that sh driver, ensuring it
> is no longer available as a stand-alone framework.
> 
> Regarding the other soc-camera i2c drivers: the following drivers are used
> by sh board files: ov772x, tw9910, mt9t112, rj54n1cb0c.
> 
> All others are never used by a soc-camera in-tree device.
> 
> I am considering to make those four drivers depend on the sh_mobile_ceu_camera
> driver. The other soc_camera i2c drivers can be moved to staging/media and
> marked as BROKEN.
> 
> Are there any i2c soc_camera drivers that are also used by non-soc-camera
> drivers? I'm not aware of that.
> 
> I have some of the i2c soc_camera sensors, so when time permits I'll try to
> convert them over as standalone sensor drivers.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:
> 
>   Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git sama5d3
> 
> for you to fetch changes up to 11498c0d43013f51e1041a6dcf8934d62df6f41b:
> 
>   MAINTAINERS: update atmel-isi.c path (2017-04-03 16:50:53 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (15):
>       ov7670: document device tree bindings
>       ov7670: call v4l2_async_register_subdev
>       ov7670: fix g/s_parm
>       ov7670: get xclk
>       ov7670: add devicetree support
>       atmel-isi: update device tree bindings documentation
>       atmel-isi: remove dependency of the soc-camera framework
>       atmel-isi: move out of soc_camera to atmel
>       ov2640: fix colorspace handling
>       ov2640: update bindings
>       ov2640: convert from soc-camera to a standard subdev sensor driver.

This patch has a non-trivial conflict with upstream. I tried to solve it,
but it caused a compilation breakage:

drivers/media/i2c/ov2640.c: In function 'ov2640_g_mbus_config':
drivers/media/i2c/ov2640.c:1001:40: error: implicit declaration of function 'soc_camera_i2c_to_desc' [-Werror=implicit-function-declaration]
  struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
                                        ^~~~~~~~~~~~~~~~~~~~~~
drivers/media/i2c/ov2640.c:1001:40: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
drivers/media/i2c/ov2640.c:1007:15: error: implicit declaration of function 'soc_camera_apply_board_flags' [-Werror=implicit-function-declaration]
  cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/media/i2c/ov2640.c: At top level:
drivers/media/i2c/ov2640.c:1013:14: error: 'ov2640_s_stream' undeclared here (not in a function)
  .s_stream = ov2640_s_stream,
              ^~~~~~~~~~~~~~~
drivers/media/i2c/ov2640.c:1012:43: warning: 'ov2640_subdev_video_ops' defined but not used [-Wunused-const-variable=]
 static const struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
                                           ^~~~~~~~~~~~~~~~~~~~~~~
Please rebase.

I applied already the patches 1 to 10 from this pull request.

Regards,
Mauro

Thanks,
Mauro
