Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38172 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdIKHpF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 03:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <5fdb0554-51b7-29e3-34ee-d79c46194253@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
 <1502199018-28250-13-git-send-email-todor.tomov@linaro.org>
 <CAMuHMdV70ajjwKTXLyyJoxNdTf_aQHjwFK6Uu+_PDHmV+Fgjyw@mail.gmail.com> <5fdb0554-51b7-29e3-34ee-d79c46194253@linaro.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 11 Sep 2017 09:45:04 +0200
Message-ID: <CAMuHMdV2XZZjaLdQZ90voyE9AinZy3+Zpg0C0-N+AkADk7768A@mail.gmail.com>
Subject: Re: [PATCH v4 12/21] camss: vfe: Format conversion support using PIX interface
To: Todor Tomov <todor.tomov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Sep 11, 2017 at 8:56 AM, Todor Tomov <todor.tomov@linaro.org> wrote=
:
> On 10.09.2017 12:58, Geert Uytterhoeven wrote:
>> On Tue, Aug 8, 2017 at 3:30 PM, Todor Tomov <todor.tomov@linaro.org> wro=
te:
>>> Use VFE PIX input interface and do format conversion in VFE.
>>>
>>> Supported input format is UYVY (single plane YUV 4:2:2) and
>>> its different sample order variations.
>>>
>>> Supported output formats are:
>>> - NV12/NV21 (two plane YUV 4:2:0)
>>> - NV16/NV61 (two plane YUV 4:2:2)
>>>
>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>
>> This is now commit 9b5833f7b82f1431 upstream.
>>
>>> @@ -355,6 +471,38 @@ static void vfe_bus_disconnect_wm_from_rdi(struct =
vfe_device *vfe, u8 wm,
>>>         vfe_reg_clr(vfe, VFE_0_BUS_XBAR_CFG_x(wm), reg);
>>>  }
>>>
>>> +static void vfe_set_xbar_cfg(struct vfe_device *vfe, struct vfe_output=
 *output,
>>> +                            u8 enable)
>>> +{
>>> +       struct vfe_line *line =3D container_of(output, struct vfe_line,=
 output);
>>> +       u32 p =3D line->video_out.active_fmt.fmt.pix_mp.pixelformat;
>>> +       u32 reg;
>>
>> With gcc 4.1.2:
>>
>>     drivers/media/platform/qcom/camss-8x16/camss-vfe.c: In function
>> =E2=80=98vfe_set_xbar_cfg=E2=80=99:
>>     drivers/media/platform/qcom/camss-8x16/camss-vfe.c:614: warning:
>> =E2=80=98reg=E2=80=99 may be used uninitialized in this function
>>
>> This is a false positive, as output->wm_num is always either 1 or 2, hen=
ce the
>> index i can never have a value different from 0 or 1, and reg is thus al=
ways
>> initialized.
>>
>>> +       unsigned int i;
>>> +
>>> +       for (i =3D 0; i < output->wm_num; i++) {
>>> +               if (i =3D=3D 0) {
>>> +                       reg =3D VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SE=
L_LUMA <<
>>> +                               VFE_0_BUS_XBAR_CFG_x_M_SINGLE_STREAM_SE=
L_SHIFT;
>>> +               } else if (i =3D=3D 1) {
>>> +                       reg =3D VFE_0_BUS_XBAR_CFG_x_M_PAIR_STREAM_EN;
>>> +                       if (p =3D=3D V4L2_PIX_FMT_NV12 || p =3D=3D V4L2=
_PIX_FMT_NV16)
>>> +                               reg |=3D VFE_0_BUS_XBAR_CFG_x_M_PAIR_ST=
REAM_SWAP_INTER_INTRA;
>>> +               }
>>
>>> @@ -458,6 +728,10 @@ static void vfe_init_outputs(struct vfe_device *vf=
e)
>>>                 output->buf[0] =3D NULL;
>>>                 output->buf[1] =3D NULL;
>>>                 INIT_LIST_HEAD(&output->pending_bufs);
>>> +
>>> +               output->wm_num =3D 1;
>>> +               if (vfe->line[i].id =3D=3D VFE_LINE_PIX)
>>> +                       output->wm_num =3D 2;
>>>         }
>>>  }
>>>
>>
>>> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>>> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>>> @@ -30,8 +30,9 @@
>>>  #define MSM_VFE_PAD_SRC 1
>>>  #define MSM_VFE_PADS_NUM 2
>>>
>>> -#define MSM_VFE_LINE_NUM 3
>>> +#define MSM_VFE_LINE_NUM 4
>>>  #define MSM_VFE_IMAGE_MASTERS_NUM 7
>>> +#define MSM_VFE_COMPOSITE_IRQ_NUM 4
>>>
>>>  #define MSM_VFE_VFE0_UB_SIZE 1023
>>>  #define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
>>> @@ -51,11 +52,13 @@ enum vfe_line_id {
>>>         VFE_LINE_NONE =3D -1,
>>>         VFE_LINE_RDI0 =3D 0,
>>>         VFE_LINE_RDI1 =3D 1,
>>> -       VFE_LINE_RDI2 =3D 2
>>> +       VFE_LINE_RDI2 =3D 2,
>>> +       VFE_LINE_PIX =3D 3
>>>  };
>>>
>>>  struct vfe_output {
>>> -       u8 wm_idx;
>>> +       u8 wm_num;
>>> +       u8 wm_idx[3];
>>
>> However, wm_idx[] reserves space for 3 entries, while currently only 2 a=
re
>> needed. Why?
>>
>> If this is meant to accommodate for a future extension, the false positi=
ve
>> will become a real issue.
>
> The third entry will be needed if we add any three planar pixel format su=
pport
> to the driver.

OK.

> If this happens this will involve also changes in
> vfe_set_xbar_cfg() to support it. It is fine to change wm_idx[3] to wm_id=
x[2]
> until then. However this will not remove the false positive warning. I su=
ppose
> it is best to also change vfe_set_xbar_cfg() now so that there is no warn=
ing -
> init reg to 0 in all cases?

Initializing reg to 0 in all cases will kill the warning, but won't prevent
future bugs (e.g. someone forgets to update vfe_set_xbar_cfg()).

Keeping the warning also doesn't help to protect against that, as I only lo=
ok
at newly introduced warnings (all old unfixed ones are supposed to be false
positives).

Well, just don't make mistakes when extending the code ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
