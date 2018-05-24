Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:45173 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968092AbeEXORE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 10:17:04 -0400
Received: by mail-ua0-f195.google.com with SMTP id j5-v6so1194958uak.12
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 07:17:03 -0700 (PDT)
Received: from mail-ua0-f181.google.com (mail-ua0-f181.google.com. [209.85.217.181])
        by smtp.gmail.com with ESMTPSA id w46-v6sm100120uah.16.2018.05.24.07.17.00
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 May 2018 07:17:00 -0700 (PDT)
Received: by mail-ua0-f181.google.com with SMTP id i2-v6so1204941uah.0
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 07:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-13-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-13-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 24 May 2018 23:16:47 +0900
Message-ID: <CAAFQd5Bj73zyi0vsaSJ2sam2TGm7agshXg+n+sa2c7HoqLRGUw@mail.gmail.com>
Subject: Re: [PATCH v2 12/29] venus: add common capability parser
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On Tue, May 15, 2018 at 5:08 PM Stanimir Varbanov <
stanimir.varbanov@linaro.org> wrote:
[snip]
> diff --git a/drivers/media/platform/qcom/venus/core.c
b/drivers/media/platform/qcom/venus/core.c
> index 41eef376eb2d..381bfdd688db 100644
> --- a/drivers/media/platform/qcom/venus/core.c
> +++ b/drivers/media/platform/qcom/venus/core.c
[snip]
> +static int venus_enumerate_codecs(struct venus_core *core, u32 type)
> +{
[snip]
> +       for (i =3D 0; i < MAX_CODEC_NUM; i++) {
> +               codec =3D (1 << i) & codecs;
> +               if (!codec)
> +                       continue;

Could be simplified to

          for_each_set_bit(i, &codecs, MAX_CODEC_NUM) {

after making codecs an unsigned long.

[snip]
> diff --git a/drivers/media/platform/qcom/venus/core.h
b/drivers/media/platform/qcom/venus/core.h
> index b5b9a84e9155..fe2d2b9e8af8 100644
> --- a/drivers/media/platform/qcom/venus/core.h
> +++ b/drivers/media/platform/qcom/venus/core.h
> @@ -57,6 +57,29 @@ struct venus_format {
>           u32 type;
>    };

> +#define MAX_PLANES             4

We have VIDEO_MAX_PLANES (=3D=3D 8) already.

[snip]
> @@ -224,22 +249,8 @@ struct venus_buffer {
>     * @priv:      a private for HFI operations callbacks
>     * @session_type:      the type of the session (decoder or encoder)
>     * @hprop:     a union used as a holder by get property
> - * @cap_width: width capability
> - * @cap_height:        height capability
> - * @cap_mbs_per_frame: macroblocks per frame capability
> - * @cap_mbs_per_sec:   macroblocks per second capability
> - * @cap_framerate:     framerate capability
> - * @cap_scale_x:               horizontal scaling capability
> - * @cap_scale_y:               vertical scaling capability
> - * @cap_bitrate:               bitrate capability
> - * @cap_hier_p:                hier capability
> - * @cap_ltr_count:     LTR count capability
> - * @cap_secure_output2_threshold: secure OUTPUT2 threshold capability
>     * @cap_bufs_mode_static:      buffers allocation mode capability
>     * @cap_bufs_mode_dynamic:     buffers allocation mode capability
> - * @pl_count:  count of supported profiles/levels
> - * @pl:                supported profiles/levels
> - * @bufreq:    holds buffer requirements
>     */
>    struct venus_inst {
>           struct list_head list;
> @@ -276,6 +287,7 @@ struct venus_inst {
>           bool reconfig;
>           u32 reconfig_width;
>           u32 reconfig_height;
> +       u32 hfi_codec;

Respective line not added to the kerneldoc above.

>           u32 sequence_cap;
>           u32 sequence_out;
>           struct v4l2_m2m_dev *m2m_dev;
> @@ -287,22 +299,8 @@ struct venus_inst {
>           const struct hfi_inst_ops *ops;
>           u32 session_type;
>           union hfi_get_property hprop;
> -       struct hfi_capability cap_width;
> -       struct hfi_capability cap_height;
> -       struct hfi_capability cap_mbs_per_frame;
> -       struct hfi_capability cap_mbs_per_sec;
> -       struct hfi_capability cap_framerate;
> -       struct hfi_capability cap_scale_x;
> -       struct hfi_capability cap_scale_y;
> -       struct hfi_capability cap_bitrate;
> -       struct hfi_capability cap_hier_p;
> -       struct hfi_capability cap_ltr_count;
> -       struct hfi_capability cap_secure_output2_threshold;
>           bool cap_bufs_mode_static;
>           bool cap_bufs_mode_dynamic;
> -       unsigned int pl_count;
> -       struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
> -       struct hfi_buffer_requirements bufreq[HFI_BUFFER_TYPE_MAX];
>    };

>    #define IS_V1(core)    ((core)->res->hfi_version =3D=3D HFI_VERSION_1X=
X)
> @@ -322,4 +320,18 @@ static inline void *to_hfi_priv(struct venus_core
*core)
>           return core->priv;
>    }

> +static inline struct venus_caps *

I'd leave the decision whether to inline this or not to the compiler.
(Although these days the "inline" keyword is just a hint anyway... but
still just wasted bytes in kernel's git repo.)

> +venus_caps_by_codec(struct venus_core *core, u32 codec, u32 domain)
> +{
> +       unsigned int c;
> +
> +       for (c =3D 0; c < MAX_CODEC_NUM; c++) {

Shouldn't we iterate up to core->codecs_count?

> +               if (core->caps[c].codec =3D=3D codec &&
> +                   core->caps[c].domain =3D=3D domain)
> +                       return &core->caps[c];
> +       }
> +
> +       return NULL;
> +}
> +
[snip]
> +       error =3D hfi_parser(core, inst, num_properties, &pkt->data[0],

nit: pkt->data?

[snip]
>   static void hfi_session_init_done(struct venus_core *core,
>                                    struct venus_inst *inst, void *packet)
>   {
>          struct hfi_msg_session_init_done_pkt *pkt =3D packet;
> -       unsigned int error;
> +       u32 rem_bytes, error;

>          error =3D pkt->error_type;
>          if (error !=3D HFI_ERR_NONE)
> @@ -745,8 +423,14 @@ static void hfi_session_init_done(struct venus_core
*core,
>          if (core->res->hfi_version !=3D HFI_VERSION_1XX)
>                  goto done;

> -       error =3D init_done_read_prop(core, inst, pkt);
> +       rem_bytes =3D pkt->shdr.hdr.size - sizeof(*pkt) + sizeof(u32);
> +       if (!rem_bytes) {

I=E2=80=99m not sure how likely it is to happen, but given that pkt->shdr.h=
dr.size
seems to come from hardware, perhaps we should make rem_bytes signed and
check for <=3D 0?

> +               error =3D HFI_ERR_SESSION_INSUFFICIENT_RESOURCES;
> +               goto done;
> +       }

> +       error =3D hfi_parser(core, inst, pkt->num_properties, &pkt->data[=
0],
> +                          rem_bytes);

nit: pkt->data?

>   done:
>          inst->error =3D error;
>          complete(&inst->done);
> diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c
b/drivers/media/platform/qcom/venus/hfi_parser.c
> new file mode 100644
> index 000000000000..f9181d999b23
> --- /dev/null
> +++ b/drivers/media/platform/qcom/venus/hfi_parser.c
> @@ -0,0 +1,295 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2018 Linaro Ltd.
> + *
> + * Author: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> + */
> +#include <linux/kernel.h>
> +
> +#include "core.h"
> +#include "hfi_helper.h"
> +#include "hfi_parser.h"
> +
> +typedef void (*func)(struct venus_caps *cap, void *data, unsigned int
size);

Should we perhaps make data const? (My understanding is that it comes from
firmware packet.)

> +
> +static void init_codecs_vcaps(struct venus_core *core)
> +{
> +       struct venus_caps *caps =3D core->caps;
> +       struct venus_caps *cap;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < 8 * sizeof(core->dec_codecs); i++) {
> +               if ((1 << i) & core->dec_codecs) {

for_each_set_bit()?

> +                       cap =3D &caps[core->codecs_count++];
> +                       cap->codec =3D (1 << i) & core->dec_codecs;

Any need to AND with core->dec_codecs? This code wouldn=E2=80=99t be execut=
ed if
the bit wasn=E2=80=99t set in the first place.

Also BIT(i).

> +                       cap->domain =3D VIDC_SESSION_TYPE_DEC;
> +                       cap->valid =3D false;
> +               }
> +       }
> +
> +       for (i =3D 0; i < 8 * sizeof(core->enc_codecs); i++) {
> +               if ((1 << i) & core->enc_codecs) {

Ditto.

> +                       cap =3D &caps[core->codecs_count++];
> +                       cap->codec =3D (1 << i) & core->enc_codecs;

Ditto.

> +                       cap->domain =3D VIDC_SESSION_TYPE_ENC;
> +                       cap->valid =3D false;
> +               }
> +       }
> +}
> +
> +static void for_each_codec(struct venus_caps *caps, unsigned int
caps_num,
> +                          u32 codecs, u32 domain, func cb, void *data,
> +                          unsigned int size)
> +{
> +       struct venus_caps *cap;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < caps_num; i++) {
> +               cap =3D &caps[i];
> +               if (cap->valid && cap->domain =3D=3D domain)

Is there any need to check cap->domain =3D=3D domain? We could just skip if
cap->valid.

If we want to shorten the code, we could even do (cap->valid || cap->domain
!=3D domain) and remove domain check from the if below.

> +                       continue;
> +               if (cap->codec & codecs && cap->domain =3D=3D domain)
> +                       cb(cap, data, size);
> +       }
> +}
> +
> +static void fill_buf_mode(struct venus_caps *cap, void *data, unsigned
int num)
> +{
> +       u32 *type =3D data;
> +
> +       if (*type =3D=3D HFI_BUFFER_MODE_DYNAMIC)
> +               cap->cap_bufs_mode_dynamic =3D true;
> +}
> +
> +static void parse_alloc_mode(struct venus_core *core, struct venus_inst
*inst,
> +                            u32 codecs, u32 domain, void *data)
> +{
> +       struct hfi_buffer_alloc_mode_supported *mode =3D data;
> +       u32 num_entries =3D mode->num_entries;
> +       u32 *type;
> +
> +       if (num_entries > 16)

What is 16? We should have a macro for it.

> +               return;
> +
> +       type =3D mode->data;
> +
> +       while (num_entries--) {
> +               if (mode->buffer_type =3D=3D HFI_BUFFER_OUTPUT ||
> +                   mode->buffer_type =3D=3D HFI_BUFFER_OUTPUT2) {
> +                       if (*type =3D=3D HFI_BUFFER_MODE_DYNAMIC && inst)
> +                               inst->cap_bufs_mode_dynamic =3D true;
> +
> +                       for_each_codec(core->caps, ARRAY_SIZE(core->caps)=
,
> +                                      codecs, domain, fill_buf_mode,
type, 1);
> +               }
> +
> +               type++;
> +       }
> +}
> +
> +static void parse_profile_level(u32 codecs, u32 domain, void *data)
> +{
> +       struct hfi_profile_level_supported *pl =3D data;
> +       struct hfi_profile_level *proflevel =3D pl->profile_level;
> +       u32 count =3D pl->profile_count;
> +
> +       if (count > HFI_MAX_PROFILE_COUNT)
> +               return;
> +
> +       while (count) {
> +               proflevel =3D (void *)proflevel + sizeof(*proflevel);

Isn=E2=80=99t this just ++proflevel?

> +               count--;
> +       }

Am I missing something or this function doesn=E2=80=99t to do anything?

> +}
> +
> +static void fill_caps(struct venus_caps *cap, void *data, unsigned int
num)
> +{
> +       struct hfi_capability *caps =3D data;
> +       unsigned int i;
> +

Should we have some check to avoid overflowing cap->caps[]?

> +       for (i =3D 0; i < num; i++)
> +               cap->caps[cap->num_caps++] =3D caps[i];
> +}
> +
> +static void parse_caps(struct venus_core *core, struct venus_inst *inst,
> +                      u32 codecs, u32 domain, void *data)
> +{
> +       struct hfi_capabilities *caps =3D data;
> +       struct hfi_capability *cap =3D caps->data;
> +       u32 num_caps =3D caps->num_capabilities;
> +       struct hfi_capability caps_arr[MAX_CAP_ENTRIES] =3D {};
> +       unsigned int i =3D 0;
> +
> +       if (num_caps > MAX_CAP_ENTRIES)
> +               return;
> +
> +       while (num_caps) {
> +               caps_arr[i++] =3D *cap;
> +               cap =3D (void *)cap + sizeof(*cap);

++cap?

> +               num_caps--;
> +       }

Hmm, isn=E2=80=99t the whole loop just

memcpy(caps_arr, cap, num_caps * sizeof(*cap));

?

> +
> +       for_each_codec(core->caps, ARRAY_SIZE(core->caps), codecs, domain=
,
> +                      fill_caps, caps_arr, i);
> +}
> +
> +static void fill_raw_fmts(struct venus_caps *cap, void *fmts,
> +                         unsigned int num_fmts)
> +{
> +       struct raw_formats *formats =3D fmts;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < num_fmts; i++)
> +               cap->fmts[cap->num_fmts++] =3D formats[i];
> +}
> +
> +static void parse_raw_formats(struct venus_core *core, struct venus_inst
*inst,
> +                             u32 codecs, u32 domain, void *data)
> +{
> +       struct hfi_uncompressed_format_supported *fmt =3D data;
> +       struct hfi_uncompressed_plane_info *pinfo =3D fmt->format_info;
> +       struct hfi_uncompressed_plane_constraints *constr;
> +       u32 entries =3D fmt->format_entries;
> +       u32 num_planes;
> +       struct raw_formats rfmts[MAX_FMT_ENTRIES] =3D {};
> +       unsigned int i =3D 0;
> +
> +       while (entries) {
> +               num_planes =3D pinfo->num_planes;
> +
> +               rfmts[i].fmt =3D pinfo->format;
> +               rfmts[i].buftype =3D fmt->buffer_type;
> +               i++;
> +
> +               if (pinfo->num_planes > MAX_PLANES)
> +                       break;
> +
> +               constr =3D pinfo->plane_format;
> +
> +               while (pinfo->num_planes) {
> +                       constr =3D (void *)constr + sizeof(*constr);

++constr?

> +                       pinfo->num_planes--;
> +               }

What is this loop supposed to do?

> +
> +               pinfo =3D (void *)pinfo + sizeof(*constr) * num_planes +
> +                       2 * sizeof(u32);
> +               entries--;
> +       }
> +
> +       for_each_codec(core->caps, ARRAY_SIZE(core->caps), codecs, domain=
,
> +                      fill_raw_fmts, rfmts, i);
> +}
[snip]
> +static void parser_fini(struct venus_core *core, struct venus_inst *inst=
,
> +                       u32 codecs, u32 domain)
> +{
> +       struct venus_caps *caps =3D core->caps;
> +       struct venus_caps *cap;
> +       u32 dom;
> +       unsigned int i;
> +
> +       if (core->res->hfi_version !=3D HFI_VERSION_1XX)
> +               return;

Hmm, if the code below is executed only for 1XX, who will set cap->valid to
true for newer versions?

> +
> +       if (!inst)
> +               return;
> +
> +       dom =3D inst->session_type;
> +
> +       for (i =3D 0; i < MAX_CODEC_NUM; i++) {
> +               cap =3D &caps[i];
> +               if (cap->codec & codecs && cap->domain =3D=3D dom)
> +                       cap->valid =3D true;
> +       }
> +}
> +
> +u32 hfi_parser(struct venus_core *core, struct venus_inst *inst,
> +              u32 num_properties, void *buf, u32 size)
> +{
> +       unsigned int words_count =3D size >> 2;
> +       u32 *word =3D buf, *data, codecs =3D 0, domain =3D 0;
> +
> +       if (size % 4)
> +               return HFI_ERR_SYS_INSUFFICIENT_RESOURCES;
> +
> +       parser_init(core, inst, &codecs, &domain);
> +
> +       while (words_count) {
> +               data =3D word + 1;
> +
> +               switch (*word) {
> +               case HFI_PROPERTY_PARAM_CODEC_SUPPORTED:
> +                       parse_codecs(core, data);
> +                       init_codecs_vcaps(core);
> +                       break;
> +               case HFI_PROPERTY_PARAM_MAX_SESSIONS_SUPPORTED:
> +                       parse_max_sessions(core, data);
> +                       break;
> +               case HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED:
> +                       parse_codecs_mask(&codecs, &domain, data);
> +                       break;
> +               case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED:
> +                       parse_raw_formats(core, inst, codecs, domain,
data);
> +                       break;
> +               case HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED:
> +                       parse_caps(core, inst, codecs, domain, data);
> +                       break;
> +               case HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED:
> +                       parse_profile_level(codecs, domain, data);
> +                       break;
> +               case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED:
> +                       parse_alloc_mode(core, inst, codecs, domain,
data);
> +                       break;
> +               default:

Should we perhaps print something to let us know that something
unrecognized was reported? (Or it is expected that something unrecognized
is there?)

> +                       break;
> +               }
> +
> +               word++;
> +               words_count--;

If data is at |word + 1|, shouldn=E2=80=99t we increment |word| by |1 + |da=
ta
size||?

> +       }
> +
> +       parser_fini(core, inst, codecs, domain);
> +
> +       return HFI_ERR_NONE;
> +}
> diff --git a/drivers/media/platform/qcom/venus/hfi_parser.h
b/drivers/media/platform/qcom/venus/hfi_parser.h
> new file mode 100644
> index 000000000000..c484ac91a8e2
> --- /dev/null
> +++ b/drivers/media/platform/qcom/venus/hfi_parser.h
> @@ -0,0 +1,45 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Linaro Ltd. */
> +#ifndef __VENUS_HFI_PARSER_H__
> +#define __VENUS_HFI_PARSER_H__
> +
> +#include "core.h"
> +
> +u32 hfi_parser(struct venus_core *core, struct venus_inst *inst,
> +              u32 num_properties, void *buf, u32 size);
> +
> +static inline struct hfi_capability *get_cap(struct venus_inst *inst,
u32 type)
> +{
> +       struct venus_core *core =3D inst->core;
> +       struct venus_caps *caps;
> +       unsigned int i;
> +
> +       caps =3D venus_caps_by_codec(core, inst->hfi_codec,
inst->session_type);
> +       if (!caps)
> +               return ERR_PTR(-EINVAL);
> +
> +       for (i =3D 0; i < MAX_CAP_ENTRIES; i++) {

Shouldn=E2=80=99t this iterate up to caps->num_capabilities? Also, shouldn=
=E2=80=99t
caps->caps[i]->valid be checked as well?

> +               if (caps->caps[i].capability_type =3D=3D type)
> +                       return &caps->caps[i];
> +       }
> +
> +       return ERR_PTR(-EINVAL);
> +}

Best regards,
Tomasz
