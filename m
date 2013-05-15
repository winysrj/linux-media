Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3EOFo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 01:44:28 -0400
Date: Wed, 15 May 2013 07:44:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v4] V4L2: soc_camera: Renesas R-Car VIN driver
In-Reply-To: <201305150256.36966.sergei.shtylyov@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1305150742470.10596@axis700.grange>
References: <201305150256.36966.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei, Vladimir

On Wed, 15 May 2013, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> Add Renesas R-Car VIN (Video In) V4L2 driver.
> 
> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
> *if* statement  and  used 'bool' values instead of 0/1 where necessary, done
> some reformatting and clarified some comments.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo.
> 
> Changes since version 3:

Why aren't you using this:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/63820

?

Thanks
Guennadi

> - removed the driver's dependency on R-Car M1A/H1 SoCs from Kconfig;
> - made the driver aware of the differences between R-Car E1/M1/H1 SoCs by having
>   different platform device IDs for different SoCs, introcduced 'enum chips_id'
>   to be used as the 'driver_data' field of 'struct platform_device_id' and then
>   copied to the 'chip' field of 'struct rcar_vin_priv';
> - sorted #include's alphabetically, added a number of #includes <media/v4l2-*>;
> - removed the 'data_through' field of the 'struct rcar_vin_priv' and the pass-
>   through logic from set_fmt() method;
> - simplified is_continuous_transfer(), used it where applicable;
> - removed senseless parens from to_buf_list() macro;
> - removed the 'code' field from the 'struct rcar_vin_cam';
> - largely rewrote the queue_setup() method;
> - removed 'input_is_yuv' variable from rcar_vin_setup(), made 'progressive'  and
>   'output_is_yuv' variables 'bool', and made setting VnDMR.EXRGB bit only happen
>   on R-Car E1/H1 there;
> - made use of ALIGN() macro in rcar_vin_setup() and rcar_vin_set_rect();
> - fixed missing {} on one branch of the *if* statement in several places, added
>   {} to the *if* statement where necessary;
> - stopped saving/restoring flags when grabbing/dropping a spinlock in the
>   buf_queue() and buf_cleanup() methods;
> - made 'dsize' variable calculation depend on R-Car E1 in rcar_vin_set_rect()
> - fix the continuous capturing to stop when there is no buffer to be set into
>   the VnMBm registers in rcar_vin_irq();
> - replaced BUG_ON() with WARN_ON() and *return* in the remove() method, also
>   replaced pm_runtime_put_sync() with pm_runtime_put() there;
> - removed size_dst() and calc_scale() as the calls to calc_scale() were also
>   removed from the set_fmt() method;
> - removed the VnMC register value check from capture_restore();
> - removed 'cfg' variable initializers from set_bus_param() method and
>   rcar_vin_try_bus_param();
> - added bus width check to rcar_vin_try_bus_param();
> - removed V4L2_PIX_FMT_YUYV format from rcar_vin_formats[], initialize 'layout'
>   field of every element in this table;
> - changed dev_err() call and *return* -EINVAL to dev_warn() and *return* 0 in
>   the get_formats() method,
> - added rcar_vin_packing_supported() and started handling pass-through mode in
>   the get_formats() method;
> - constified the parameters of is_smaller() and is_inside();
> - redid the scaling logic so that it can't scale RGB32 data on R-Car E1 in the
>   set_fmt() method, also stopped assigning to 'cam->code' there;
> - started selecting the current format if soc_camera_xlate_by_fourcc() call
>   failed in the try_fmt() method, also started letting 'soc-camera' calculate
>   bytes-per-line and image size there;
> - removed pm_runtime_resume() call from the driver's probe() method
> - added setting of the 'timestamp_type' field to the init_videobuf2() method.
> 
> Changes since version 2:
> - replaced Cyrillic characters in comments with the proper Latinic ones.
> 
> Changes since the original posting:
> - added IRQF_SHARED flag in devm_request_irq() call (since on R8A7778 VIN0/1
>   share the same IRQ) and removed deprecated IRQF_DISABLED flag.
> 
>  drivers/media/platform/soc_camera/Kconfig    |    7 
>  drivers/media/platform/soc_camera/Makefile   |    1 
>  drivers/media/platform/soc_camera/rcar_vin.c | 1814 +++++++++++++++++++++++++++
>  include/linux/platform_data/camera-rcar.h    |   25 
>  4 files changed, 1847 insertions(+)

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
