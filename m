Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44672 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3EOUED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 16:04:03 -0400
Received: by mail-ea0-f172.google.com with SMTP id d10so1332675eaj.31
        for <linux-media@vger.kernel.org>; Wed, 15 May 2013 13:04:02 -0700 (PDT)
Message-ID: <5193EA11.7080705@cogentembedded.com>
Date: Wed, 15 May 2013 23:03:29 +0300
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp
Subject: Re: [PATCH v4] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201305150256.36966.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1305150742470.10596@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1305150742470.10596@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 05/15/2013 08:44 AM, Guennadi Liakhovetski wrote:
> Hi Sergei, Vladimir
>
> On Wed, 15 May 2013, Sergei Shtylyov wrote:
>
>> From: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
>>
>> Add Renesas R-Car VIN (Video In) V4L2 driver.
>>
>> Based on the patch by Phil Edworthy<phil.edworthy@renesas.com>.
>>
>> Signed-off-by: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
>> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
>> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
>> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
>> *if* statement  and  used 'bool' values instead of 0/1 where necessary, done
>> some reformatting and clarified some comments.]
>> Signed-off-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
>>
>> ---
>> This patch is against the 'media_tree.git' repo.
>>
>> Changes since version 3:
> Why aren't you using this:
>
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/63820
>
> ?
I've just figured out that missed this part of your review.
Please take my apologies for this and let me quickly rework it.

Regards,
Vladimir
>
> Thanks
> Guennadi
>
>> - removed the driver's dependency on R-Car M1A/H1 SoCs from Kconfig;
>> - made the driver aware of the differences between R-Car E1/M1/H1 SoCs by having
>>    different platform device IDs for different SoCs, introcduced 'enum chips_id'
>>    to be used as the 'driver_data' field of 'struct platform_device_id' and then
>>    copied to the 'chip' field of 'struct rcar_vin_priv';
>> - sorted #include's alphabetically, added a number of #includes<media/v4l2-*>;
>> - removed the 'data_through' field of the 'struct rcar_vin_priv' and the pass-
>>    through logic from set_fmt() method;
>> - simplified is_continuous_transfer(), used it where applicable;
>> - removed senseless parens from to_buf_list() macro;
>> - removed the 'code' field from the 'struct rcar_vin_cam';
>> - largely rewrote the queue_setup() method;
>> - removed 'input_is_yuv' variable from rcar_vin_setup(), made 'progressive'  and
>>    'output_is_yuv' variables 'bool', and made setting VnDMR.EXRGB bit only happen
>>    on R-Car E1/H1 there;
>> - made use of ALIGN() macro in rcar_vin_setup() and rcar_vin_set_rect();
>> - fixed missing {} on one branch of the *if* statement in several places, added
>>    {} to the *if* statement where necessary;
>> - stopped saving/restoring flags when grabbing/dropping a spinlock in the
>>    buf_queue() and buf_cleanup() methods;
>> - made 'dsize' variable calculation depend on R-Car E1 in rcar_vin_set_rect()
>> - fix the continuous capturing to stop when there is no buffer to be set into
>>    the VnMBm registers in rcar_vin_irq();
>> - replaced BUG_ON() with WARN_ON() and *return* in the remove() method, also
>>    replaced pm_runtime_put_sync() with pm_runtime_put() there;
>> - removed size_dst() and calc_scale() as the calls to calc_scale() were also
>>    removed from the set_fmt() method;
>> - removed the VnMC register value check from capture_restore();
>> - removed 'cfg' variable initializers from set_bus_param() method and
>>    rcar_vin_try_bus_param();
>> - added bus width check to rcar_vin_try_bus_param();
>> - removed V4L2_PIX_FMT_YUYV format from rcar_vin_formats[], initialize 'layout'
>>    field of every element in this table;
>> - changed dev_err() call and *return* -EINVAL to dev_warn() and *return* 0 in
>>    the get_formats() method,
>> - added rcar_vin_packing_supported() and started handling pass-through mode in
>>    the get_formats() method;
>> - constified the parameters of is_smaller() and is_inside();
>> - redid the scaling logic so that it can't scale RGB32 data on R-Car E1 in the
>>    set_fmt() method, also stopped assigning to 'cam->code' there;
>> - started selecting the current format if soc_camera_xlate_by_fourcc() call
>>    failed in the try_fmt() method, also started letting 'soc-camera' calculate
>>    bytes-per-line and image size there;
>> - removed pm_runtime_resume() call from the driver's probe() method
>> - added setting of the 'timestamp_type' field to the init_videobuf2() method.
>>
>> Changes since version 2:
>> - replaced Cyrillic characters in comments with the proper Latinic ones.
>>
>> Changes since the original posting:
>> - added IRQF_SHARED flag in devm_request_irq() call (since on R8A7778 VIN0/1
>>    share the same IRQ) and removed deprecated IRQF_DISABLED flag.
>>
>>   drivers/media/platform/soc_camera/Kconfig    |    7
>>   drivers/media/platform/soc_camera/Makefile   |    1
>>   drivers/media/platform/soc_camera/rcar_vin.c | 1814 +++++++++++++++++++++++++++
>>   include/linux/platform_data/camera-rcar.h    |   25
>>   4 files changed, 1847 insertions(+)
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

