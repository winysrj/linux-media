Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36214 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2GKKhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 06:37:07 -0400
Received: by wibhr14 with SMTP id hr14so978932wib.1
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 03:37:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9798139.lz26YdKuPN@avalon>
References: <1341993409-20870-1-git-send-email-javier.martin@vista-silicon.com>
	<9798139.lz26YdKuPN@avalon>
Date: Wed, 11 Jul 2012 12:37:05 +0200
Message-ID: <CACKLOr1Dyt2f1zR6YzXndgDWRFfNRrsRvQVUX2TLzX933rcO8A@mail.gmail.com>
Subject: Re: [PATCH v5] media: mx2_camera: Fix mbus format handling
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11 July 2012 12:08, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> Thanks for the patch.
>
> On Wednesday 11 July 2012 09:56:49 Javier Martin wrote:
>> Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags
>> so that the driver can negotiate with the attached sensor
>> whether the mbus format needs convertion from UYUV to YUYV
>> or not.
>
> The commit message doesn't really match the content of the patch anymore, as
> you don't remove the MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags but
> just stop using them.
>
> Could you please fix the commit message, and submit a patch that removes the
> flag from arch/arm/plat-mxc/include/mach/mx2_cam.h for v3.6 ?
>
> Please don't forget to add your SoB line.

Ok.

>> ---
>>  drivers/media/video/mx2_camera.c |   28 +++++++++++++++++++++++-----
>>  1 file changed, 23 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c
>> b/drivers/media/video/mx2_camera.c index 11a9353..0f01e7b 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>> @@ -118,6 +118,8 @@
>>  #define CSISR_ECC_INT                (1 << 1)
>>  #define CSISR_DRDY           (1 << 0)
>>
>> +#define CSICR1_FMT_MASK       (CSICR1_PACK_DIR | CSICR1_SWAP16_EN)
>> +
>>  #define CSICR1                       0x00
>>  #define CSICR2                       0x04
>>  #define CSISR                        (cpu_is_mx27() ? 0x08 : 0x18)
>> @@ -230,6 +232,7 @@ struct mx2_prp_cfg {
>>       u32 src_pixel;
>>       u32 ch1_pixel;
>>       u32 irq_flags;
>> +     u32 csicr1;
>>  };
>>
>>  /* prp resizing parameters */
>> @@ -330,6 +333,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
>>                       .ch1_pixel      = 0x2ca00565, /* RGB565 */
>>                       .irq_flags      = PRP_INTR_RDERR | PRP_INTR_CH1WERR |
>>                                               PRP_INTR_CH1FC | PRP_INTR_LBOVF,
>> +                     .csicr1         = 0,
>>               }
>>       },
>>       {
>> @@ -343,6 +347,21 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
>>                       .irq_flags      = PRP_INTR_RDERR | PRP_INTR_CH2WERR |
>>                                       PRP_INTR_CH2FC | PRP_INTR_LBOVF |
>>                                       PRP_INTR_CH2OVF,
>> +                     .csicr1         = CSICR1_PACK_DIR,
>> +             }
>> +     },
>> +     {
>> +             .in_fmt         = V4L2_MBUS_FMT_UYVY8_2X8,
>> +             .out_fmt        = V4L2_PIX_FMT_YUV420,
>> +             .cfg            = {
>> +                     .channel        = 2,
>> +                     .in_fmt         = PRP_CNTL_DATA_IN_YUV422,
>> +                     .out_fmt        = PRP_CNTL_CH2_OUT_YUV420,
>> +                     .src_pixel      = 0x22000888, /* YUV422 (YUYV) */
>> +                     .irq_flags      = PRP_INTR_RDERR | PRP_INTR_CH2WERR |
>> +                                     PRP_INTR_CH2FC | PRP_INTR_LBOVF |
>> +                                     PRP_INTR_CH2OVF,
>> +                     .csicr1         = CSICR1_SWAP16_EN,
>>               }
>
> Have you tested this patch with both YUYV8_2X8 and UYVY8_2X8 ? I'm not
> familiar with the hardware, so I can't really comment on this specific hunk.
> Knowing that it has been tested would be enough for me to ack the patch (after
> fixing the commit message of course).

Yes, with ov7670 and tvp5150.

>>       },
>>  };
>> @@ -1018,14 +1037,14 @@ static int mx2_camera_set_bus_param(struct
>> soc_camera_device *icd) return ret;
>>       }
>>
>> +     csicr1 = (csicr1 & ~CSICR1_FMT_MASK) | pcdev->emma_prp->cfg.csicr1;
>> +
>>       if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
>>               csicr1 |= CSICR1_REDGE;
>>       if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
>>               csicr1 |= CSICR1_SOF_POL;
>>       if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
>>               csicr1 |= CSICR1_HSYNC_POL;
>
> This is a completely different issue (and thus v3.6 material, if needed), but
> can common_flags change between invocations ? If so you should clear the
> CSICR1_* flags before conditionally setting them.

No, this is precisely the aim of this patch. The problem is that these
flags have to be set according to the format that is being used and
not according to the platform code.
So, this chunk is needed.

'common_flags' cannot change between invocations since it depends on
the platform code which is static.

>> -     if (pcdev->platform_flags & MX2_CAMERA_SWAP16)
>> -             csicr1 |= CSICR1_SWAP16_EN;
>>       if (pcdev->platform_flags & MX2_CAMERA_EXT_VSYNC)
>>               csicr1 |= CSICR1_EXT_VSYNC;
>>       if (pcdev->platform_flags & MX2_CAMERA_CCIR)
>> @@ -1036,8 +1055,6 @@ static int mx2_camera_set_bus_param(struct
>> soc_camera_device *icd) csicr1 |= CSICR1_GCLK_MODE;
>>       if (pcdev->platform_flags & MX2_CAMERA_INV_DATA)
>>               csicr1 |= CSICR1_INV_DATA;
>> -     if (pcdev->platform_flags & MX2_CAMERA_PACK_DIR_MSB)
>> -             csicr1 |= CSICR1_PACK_DIR;
>>
>>       pcdev->csicr1 = csicr1;
>>
>> @@ -1112,7 +1129,8 @@ static int mx2_camera_get_formats(struct
>> soc_camera_device *icd, return 0;
>>       }
>>
>> -     if (code == V4L2_MBUS_FMT_YUYV8_2X8) {
>> +     if (code == V4L2_MBUS_FMT_YUYV8_2X8 ||
>> +         code == V4L2_MBUS_FMT_UYVY8_2X8) {
>>               formats++;
>>               if (xlate) {
>>                       /*
> --
> Regards,
>
> Laurent Pinchart
>

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
