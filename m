Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:46907 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751179AbdIKG4X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 02:56:23 -0400
Received: by mail-wm0-f52.google.com with SMTP id i189so31860891wmf.1
        for <linux-media@vger.kernel.org>; Sun, 10 Sep 2017 23:56:23 -0700 (PDT)
Subject: Re: [PATCH v4 12/21] camss: vfe: Format conversion support using PIX
 interface
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
 <1502199018-28250-13-git-send-email-todor.tomov@linaro.org>
 <CAMuHMdV70ajjwKTXLyyJoxNdTf_aQHjwFK6Uu+_PDHmV+Fgjyw@mail.gmail.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5fdb0554-51b7-29e3-34ee-d79c46194253@linaro.org>
Date: Mon, 11 Sep 2017 09:56:20 +0300
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV70ajjwKTXLyyJoxNdTf_aQHjwFK6Uu+_PDHmV+Fgjyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On 10.09.2017 12:58, Geert Uytterhoeven wrote:
> Hi Todor,
> 
> On Tue, Aug 8, 2017 at 3:30 PM, Todor Tomov <todor.tomov@linaro.org> wrote:
>> Use VFE PIX input interface and do format conversion in VFE.
>>
>> Supported input format is UYVY (single plane YUV 4:2:2) and
>> its different sample order variations.
>>
>> Supported output formats are:
>> - NV12/NV21 (two plane YUV 4:2:0)
>> - NV16/NV61 (two plane YUV 4:2:2)
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> 
> This is now commit 9b5833f7b82f1431 upstream.
> 
>> @@ -355,6 +471,38 @@ static void vfe_bus_disconnect_wm_from_rdi(struct vfe_device *vfe, u8 wm,
>>         vfe_reg_clr(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
>>  }
>>
>> +static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output *output,
>> +                            u8 enable)
>> +{
>> +       struct vfe_line *line = container_of(output, struct vfe_line, output);
>> +       u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
>> +       u32 reg;
> 
> With gcc 4.1.2:
> 
>     drivers/media/platform/qcom/camss-8x16/camss-vfe.c: In function
> ‘vfe_set_xbar_cfg’:
>     drivers/media/platform/qcom/camss-8x16/camss-vfe.c:614: warning:
> ‘reg’ may be used uninitialized in this function
> 
> This is a false positive, as output->wm_num is always either 1 or 2, hence the
> index i can never have a value different from 0 or 1, and reg is thus always
> initialized.
> 
>> +       unsigned int i;
>> +
>> +       for (i = 0; i < output->wm_num; i++) {
>> +               if (i == 0) {
>> +                       reg = VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_LUMA <<
>> +                               VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SEL_SHIFT;
>> +               } else if (i == 1) {
>> +                       reg = VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
>> +                       if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV16)
>> +                               reg |= VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_SWAP_INTER_INTRA;
>> +               }
> 
>> @@ -458,6 +728,10 @@ static void vfe_init_outputs(struct vfe_device *vfe)
>>                 output->buf[0] = NULL;
>>                 output->buf[1] = NULL;
>>                 INIT_LIST_HEAD(&output->pending_bufs);
>> +
>> +               output->wm_num = 1;
>> +               if (vfe->line[i].id == VFE_LINE_PIX)
>> +                       output->wm_num = 2;
>>         }
>>  }
>>
> 
>> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>> @@ -30,8 +30,9 @@
>>  #define MSM_VFE_PAD_SRC 1
>>  #define MSM_VFE_PADS_NUM 2
>>
>> -#define MSM_VFE_LINE_NUM 3
>> +#define MSM_VFE_LINE_NUM 4
>>  #define MSM_VFE_IMAGE_MASTERS_NUM 7
>> +#define MSM_VFE_COMPOSITE_IRQ_NUM 4
>>
>>  #define MSM_VFE_VFE0_UB_SIZE 1023
>>  #define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
>> @@ -51,11 +52,13 @@ enum vfe_line_id {
>>         VFE_LINE_NONE = -1,
>>         VFE_LINE_RDI0 = 0,
>>         VFE_LINE_RDI1 = 1,
>> -       VFE_LINE_RDI2 = 2
>> +       VFE_LINE_RDI2 = 2,
>> +       VFE_LINE_PIX = 3
>>  };
>>
>>  struct vfe_output {
>> -       u8 wm_idx;
>> +       u8 wm_num;
>> +       u8 wm_idx[3];
> 
> However, wm_idx[] reserves space for 3 entries, while currently only 2 are
> needed. Why?
> 
> If this is meant to accommodate for a future extension, the false positive
> will become a real issue.

The third entry will be needed if we add any three planar pixel format support
to the driver. If this happens this will involve also changes in
vfe_set_xbar_cfg() to support it. It is fine to change wm_idx[3] to wm_idx[2]
until then. However this will not remove the false positive warning. I suppose
it is best to also change vfe_set_xbar_cfg() now so that there is no warning -
init reg to 0 in all cases?

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

-- 
Best regards,
Todor Tomov
