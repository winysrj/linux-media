Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:48269 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755774AbcIEMkQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 08:40:16 -0400
Subject: Re: [PATCH v5 00/13] pxa_camera transition to v4l2 standalone device
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cb7496b2-cc64-7c6e-71b3-6c56e596c8dc@xs4all.nl>
Date: Mon, 5 Sep 2016 14:40:05 +0200
MIME-Version: 1.0
In-Reply-To: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2016 07:55 PM, Robert Jarzmik wrote:
> There is no change between v4 and v5, ie. the global diff is empty, only one
> line was shifted to prevent breaking bisectablility.

Against which tree do you develop? Unfortunately this patch series doesn't apply
to the media_tree master branch anymore due to conflicts with a merged patch that
converts s/g_crop to s/g_selection in all subdev drivers.

When you make the new patch series, please use the -M option with git send-email so
patches that move files around are handled cleanly. That makes it much easier to review.

BTW, checkpatch reported issues in a switch statement in function pxa_camera_get_formats():


        switch (code.code) {
        case MEDIA_BUS_FMT_UYVY8_2X8:
                formats++;
                if (xlate) {
                        xlate->host_fmt = &pxa_camera_formats[0];
                        xlate->code     = code.code;
                        xlate++;
                        dev_dbg(dev, "Providing format %s using code %d\n",
                                pxa_camera_formats[0].name, code.code);
                }
        case MEDIA_BUS_FMT_VYUY8_2X8:
        case MEDIA_BUS_FMT_YUYV8_2X8:
        case MEDIA_BUS_FMT_YVYU8_2X8:
        case MEDIA_BUS_FMT_RGB565_2X8_LE:
        case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
                if (xlate)
                        dev_dbg(dev, "Providing format %s packed\n",
                                fmt->name);
                break;
        default:
                if (!pxa_camera_packing_supported(fmt))
                        return 0;
                if (xlate)
                        dev_dbg(dev,
                                "Providing format %s in pass-through mode\n",
                                fmt->name);
        }

Before 'case MEDIA_BUS_FMT_VYUY8_2X8' should there be a break? If not, then
there should be a '/* fall through */' comment.

At the end of the default case there should also be a break statement.

This is already in the existing code, so just make a separate patch fixing
this.

I'm ready to make a pull request as soon as I have a v6 that applies cleanly.

Regards,

	Hans

> 
> All the text in https://lkml.org/lkml/2016/8/15/609 is still applicable.
> 
> Cheers.
> 
> --
> Robert
> 
> Robert Jarzmik (13):
>   media: mt9m111: make a standalone v4l2 subdevice
>   media: mt9m111: use only the SRGB colorspace
>   media: mt9m111: move mt9m111 out of soc_camera
>   media: platform: pxa_camera: convert to vb2
>   media: platform: pxa_camera: trivial move of functions
>   media: platform: pxa_camera: introduce sensor_call
>   media: platform: pxa_camera: make printk consistent
>   media: platform: pxa_camera: add buffer sequencing
>   media: platform: pxa_camera: remove set_crop
>   media: platform: pxa_camera: make a standalone v4l2 device
>   media: platform: pxa_camera: add debug register access
>   media: platform: pxa_camera: change stop_streaming semantics
>   media: platform: pxa_camera: move pxa_camera out of soc_camera
> 
>  drivers/media/i2c/Kconfig                      |    7 +
>  drivers/media/i2c/Makefile                     |    1 +
>  drivers/media/i2c/mt9m111.c                    | 1033 ++++++++++++
>  drivers/media/i2c/soc_camera/Kconfig           |    7 +-
>  drivers/media/i2c/soc_camera/Makefile          |    1 -
>  drivers/media/i2c/soc_camera/mt9m111.c         | 1054 ------------
>  drivers/media/platform/Kconfig                 |    8 +
>  drivers/media/platform/Makefile                |    1 +
>  drivers/media/platform/pxa_camera.c            | 2096 ++++++++++++++++++++++++
>  drivers/media/platform/soc_camera/Kconfig      |    8 -
>  drivers/media/platform/soc_camera/Makefile     |    1 -
>  drivers/media/platform/soc_camera/pxa_camera.c | 1866 ---------------------
>  include/linux/platform_data/media/camera-pxa.h |    2 +
>  13 files changed, 3153 insertions(+), 2932 deletions(-)
>  create mode 100644 drivers/media/i2c/mt9m111.c
>  delete mode 100644 drivers/media/i2c/soc_camera/mt9m111.c
>  create mode 100644 drivers/media/platform/pxa_camera.c
>  delete mode 100644 drivers/media/platform/soc_camera/pxa_camera.c
> 
