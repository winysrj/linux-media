Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:55694 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751663AbdC0JBf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 05:01:35 -0400
Subject: Re: [PATCH v7] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Helen Koike <helen.koike@collabora.com>
References: <6c85eaf4-1f91-7964-1cf9-602005b62a94@collabora.co.uk>
 <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
Cc: linux-media@vger.kernel.org, jgebben@codeaurora.org,
        mchehab@osg.samsung.com,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e9e3493a-5b3b-a47f-0993-b738811d5d0a@xs4all.nl>
Date: Mon, 27 Mar 2017 11:00:05 +0200
MIME-Version: 1.0
In-Reply-To: <1490461896-19221-1-git-send-email-helen.koike@collabora.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two small comments:

On 25/03/17 18:11, Helen Koike wrote:
> First version of the Virtual Media Controller.
> Add a simple version of the core of the driver, the capture and
> sensor nodes in the topology, generating a grey image in a hardcoded
> format.
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> 
> Patch based in media/master tree, and available here:
> https://github.com/helen-fornazier/opw-staging/tree/vimc/devel/v7
> 
> Changes since v6:
> - add kernel-docs in vimc-core.h
> - reorder list_del call in vimc_cap_return_all_buffers()
> - call media_pipeline_stop in vimc_cap_start_streaming when fail
> - remove DMA comment (left over from the sample driver)
> - remove vb2_set_plane_payload call in vimc_cap_buffer_prepare
> - remove format verification in vimc_cap_link_validate
> - set vimc_pix_map_list as static
> - use MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN in vimc_raw_create()
> - register media device after creating the topology and unregister it before destroying the topology
> - replace devm_kzalloc by kzalloc for allocating struct vimc_device
> - uset TASK_UNINTERRUPTIBLE for vimc_thread_sen
> - do not allow the creation of a sensor with no pads
> - add more verbose description in Kconfig
> - change copyright to 2017
> - arrange includes: number before letters
> - remove v4l2_dev pointer from vimc_cap_device structure
> - coding style adjustments
> - remove entity variable in vimc_cap_pipeline_s_stream
> - declare and assign variables in vimc_cap_link_validate
> - declare vimc_dev_release() and vimc_pdev closer to vimc_init()
> - remove pad check in vimc_sen_enum_{mbus_code,frame_size} that is already performed by v4l2-subdev.c
> - fix multiline comments to start with /*
> - reorder variable declaration in functions
> - remove pad and subdevice type check in vimc_cap_pipeline_s_stream
> - add a note that sensor nodes can can have more then one source pad
> - remove the use of entity->use_count in the core and attach the ved structure in sd or vd, use
>   ent->obj_type to know which structure (sd or vd) to use
> - rename vdev (video_device) to vd to be similar to sd (subdev)

Hmm, vdev is what everyone uses, so I would prefer that this change is reverted.
Did someone comment on this in a code review?

> 
> Changes since v5:
> - Fix message "Entity type for entity Sensor A was not initialized!"
>   by initializing the sensor entity.function after the calling
>   v4l2_subded_init
> - populate device_caps in vimc_cap_create instead of in
>   vimc_cap_querycap
> - Fix typo in vimc-core.c s/de/the
> 
> Changes since v4:
> - coding style fixes
> - remove BUG_ON
> - change copyright to 2016
> - depens on VIDEO_V4L2_SUBDEV_API instead of select
> - remove assignement of V4L2_CAP_DEVICE_CAPS
> - s/vimc_cap_g_fmt_vid_cap/vimc_cap_fmt_vid_cap
> - fix vimc_cap_queue_setup declaration type
> - remove wrong buffer size check and add it in vimc_cap_buffer_prepare
> - vimc_cap_create: remove unecessary check if v4l2_dev or v4l2_dev->dev is null
> - vimc_cap_create: only allow a single pad
> - vimc_sen_create: only allow source pads, remove unecessary source pads
> checks in vimc_thread_sen
> 
> Changes since v3: fix rmmod crash and built-in compile
> - Re-order unregister calls in vimc_device_unregister function (remove
> rmmod issue)
> - Call media_device_unregister_entity in vimc_raw_destroy
> - Add depends on VIDEO_DEV && VIDEO_V4L2 and select VIDEOBUF2_VMALLOC
> - Check *nplanes in queue_setup (this remove v4l2-compliance fail)
> - Include <linux/kthread.h> in vimc-sensor.c
> - Move include of <linux/slab.h> from vimc-core.c to vimc-core.h
> - Generate 60 frames per sec instead of 1 in the sensor
> 
> Changes since v2: update with current media master tree
> - Add struct media_pipeline in vimc_cap_device
> - Use vb2_v4l2_buffer instead of vb2_buffer
> - Typos
> - Remove usage of entity->type and use entity->function instead
> - Remove fmt argument from queue setup
> - Use ktime_get_ns instead of v4l2_get_timestamp
> - Iterate over link's list using list_for_each_entry
> - Use media_device_{init, cleanup}
> - Use entity->use_count to keep track of entities instead of the old
> entity->id
> - Replace media_entity_init by media_entity_pads_init
> ---
>  drivers/media/platform/Kconfig             |   2 +
>  drivers/media/platform/Makefile            |   1 +
>  drivers/media/platform/vimc/Kconfig        |  14 +
>  drivers/media/platform/vimc/Makefile       |   3 +
>  drivers/media/platform/vimc/vimc-capture.c | 536 ++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-capture.h |  28 ++
>  drivers/media/platform/vimc/vimc-core.c    | 696 +++++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-core.h    | 123 +++++
>  drivers/media/platform/vimc/vimc-sensor.c  | 279 ++++++++++++
>  drivers/media/platform/vimc/vimc-sensor.h  |  28 ++
>  10 files changed, 1710 insertions(+)
>  create mode 100644 drivers/media/platform/vimc/Kconfig
>  create mode 100644 drivers/media/platform/vimc/Makefile
>  create mode 100644 drivers/media/platform/vimc/vimc-capture.c
>  create mode 100644 drivers/media/platform/vimc/vimc-capture.h
>  create mode 100644 drivers/media/platform/vimc/vimc-core.c
>  create mode 100644 drivers/media/platform/vimc/vimc-core.h
>  create mode 100644 drivers/media/platform/vimc/vimc-sensor.c
>  create mode 100644 drivers/media/platform/vimc/vimc-sensor.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 53f6f12..6dab7e6 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -466,6 +466,8 @@ menuconfig V4L_TEST_DRIVERS
>  
>  if V4L_TEST_DRIVERS
>  
> +source "drivers/media/platform/vimc/Kconfig"
> +
>  source "drivers/media/platform/vivid/Kconfig"
>  
>  config VIDEO_VIM2M
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 8959f6e..4af4cce 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
>  
>  obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
>  
> +obj-$(CONFIG_VIDEO_VIMC)		+= vimc/
>  obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
>  obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
>  
> diff --git a/drivers/media/platform/vimc/Kconfig b/drivers/media/platform/vimc/Kconfig
> new file mode 100644
> index 0000000..dd285fa
> --- /dev/null
> +++ b/drivers/media/platform/vimc/Kconfig
> @@ -0,0 +1,14 @@
> +config VIDEO_VIMC
> +	tristate "Virtual Media Controller Driver (VIMC)"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	select VIDEOBUF2_VMALLOC
> +	default n
> +	---help---
> +	  Skeleton driver for Virtual Media Controller
> +
> +	  This drivers can be compared to the Vivid driver for emulating
> +	  a media node that exposes a complex media topology. The topology
> +	  is hard coded for now but is meant to be highly configurable in
> +	  the future.
> +
> +	  When in doubt, say N.
> diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
> new file mode 100644
> index 0000000..c45195e
> --- /dev/null
> +++ b/drivers/media/platform/vimc/Makefile
> @@ -0,0 +1,3 @@
> +vimc-objs := vimc-core.o vimc-capture.o vimc-sensor.o
> +
> +obj-$(CONFIG_VIDEO_VIMC) += vimc.o
> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
> new file mode 100644
> index 0000000..8f77fc8
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -0,0 +1,536 @@
> +/*
> + * vimc-capture.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2017 Helen Koike F. <helen.fornazier@gmail.com>

As Mauro mentioned: since you started development in 2016 (or even 2015?) use a range:
2016-2017.

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */

Regards,

	Hans
