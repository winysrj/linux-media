Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:35213 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754034AbeEaHGU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 03:06:20 -0400
Received: by mail-vk0-f67.google.com with SMTP id o17-v6so297019vka.2
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 00:06:19 -0700 (PDT)
Received: from mail-vk0-f48.google.com (mail-vk0-f48.google.com. [209.85.213.48])
        by smtp.gmail.com with ESMTPSA id q132-v6sm10725500vkd.0.2018.05.31.00.06.17
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 May 2018 00:06:17 -0700 (PDT)
Received: by mail-vk0-f48.google.com with SMTP id o138-v6so2616703vkd.3
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 00:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-13-stanimir.varbanov@linaro.org> <CAAFQd5Bj73zyi0vsaSJ2sam2TGm7agshXg+n+sa2c7HoqLRGUw@mail.gmail.com>
 <13c7aec1-2bb9-f449-6b7d-7ec93be4ec71@linaro.org>
In-Reply-To: <13c7aec1-2bb9-f449-6b7d-7ec93be4ec71@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 31 May 2018 16:06:05 +0900
Message-ID: <CAAFQd5B8UVk3n7m+MV3t68vrDhtd9Hi_CnuYS-4QFaVdByOTyA@mail.gmail.com>
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

On Thu, May 31, 2018 at 1:21 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Tomasz,
>
> On 05/24/2018 05:16 PM, Tomasz Figa wrote:
> > Hi Stanimir,
> >
> > On Tue, May 15, 2018 at 5:08 PM Stanimir Varbanov <
> > [snip]
> >> diff --git a/drivers/media/platform/qcom/venus/core.h
> > b/drivers/media/platform/qcom/venus/core.h
> >> index b5b9a84e9155..fe2d2b9e8af8 100644
> >> --- a/drivers/media/platform/qcom/venus/core.h
> >> +++ b/drivers/media/platform/qcom/venus/core.h
> >> @@ -57,6 +57,29 @@ struct venus_format {
> >>           u32 type;
> >>    };
> >
> >> +#define MAX_PLANES             4
> >
> > We have VIDEO_MAX_PLANES (=3D=3D 8) already.
>
> yes, but venus has maximum of 4
>

Generally we tend to avoid inventing new constants and so you can see
that many drivers just use VIDEO_MAX_PLANES. I can also see drivers
that don't, so I guess we can keep it as is.

> >>    #define IS_V1(core)    ((core)->res->hfi_version =3D=3D HFI_VERSION=
_1XX)
> >> @@ -322,4 +320,18 @@ static inline void *to_hfi_priv(struct venus_core
> > *core)
> >>           return core->priv;
> >>    }
> >
> >> +static inline struct venus_caps *
> >
> > I'd leave the decision whether to inline this or not to the compiler.
> > (Although these days the "inline" keyword is just a hint anyway... but
> > still just wasted bytes in kernel's git repo.)
>
> I just followed the other code examples in the kernel and in venus. If
> you insist I can drop 'inline'.

https://www.kernel.org/doc/html/latest/process/coding-style.html#the-inline=
-disease

> >> +static void for_each_codec(struct venus_caps *caps, unsigned int
> > caps_num,
> >> +                          u32 codecs, u32 domain, func cb, void *data=
,
> >> +                          unsigned int size)
> >> +{
> >> +       struct venus_caps *cap;
> >> +       unsigned int i;
> >> +
> >> +       for (i =3D 0; i < caps_num; i++) {
> >> +               cap =3D &caps[i];
> >> +               if (cap->valid && cap->domain =3D=3D domain)
> >
> > Is there any need to check cap->domain =3D=3D domain? We could just ski=
p if
> > cap->valid.
>
> yes, we need to check the domain because we can have the same codec for
> both domains decoder and encoder but with different capabilities.
>

Sorry, I guess my comment wasn't clear. The second if below was
already checking the domain.

> >
> > If we want to shorten the code, we could even do (cap->valid || cap->do=
main
> > !=3D domain) and remove domain check from the if below.
> >
> >> +                       continue;
> >> +               if (cap->codec & codecs && cap->domain =3D=3D domain)

Here ^

But generally, if we consider second part of my comment, the problem
would disappear.

> >> +                       cb(cap, data, size);
> >> +       }
> >> +}
[snip]
> >> +static void parse_profile_level(u32 codecs, u32 domain, void *data)
> >> +{
> >> +       struct hfi_profile_level_supported *pl =3D data;
> >> +       struct hfi_profile_level *proflevel =3D pl->profile_level;
> >> +       u32 count =3D pl->profile_count;
> >> +
> >> +       if (count > HFI_MAX_PROFILE_COUNT)
> >> +               return;
> >> +
> >> +       while (count) {
> >> +               proflevel =3D (void *)proflevel + sizeof(*proflevel);
> >
> > Isn=E2=80=99t this just ++proflevel?
>
> yes
>
> >
> >> +               count--;
> >> +       }
> >
> > Am I missing something or this function doesn=E2=80=99t to do anything?
>
> yes, currently it is not used. I'll update it.
>

I'd say we should just remove it for now and add it only when it is
actually needed for something.

> >
> >> +}
> >> +
> >> +static void fill_caps(struct venus_caps *cap, void *data, unsigned in=
t
> > num)
> >> +{
> >> +       struct hfi_capability *caps =3D data;
> >> +       unsigned int i;
> >> +
> >
> > Should we have some check to avoid overflowing cap->caps[]?
>
> No, we checked that below 'num_caps > MAX_CAP_ENTRIES'
>

Ack.

> >> +static void parse_raw_formats(struct venus_core *core, struct venus_i=
nst
> > *inst,
> >> +                             u32 codecs, u32 domain, void *data)
> >> +{
> >> +       struct hfi_uncompressed_format_supported *fmt =3D data;
> >> +       struct hfi_uncompressed_plane_info *pinfo =3D fmt->format_info=
;
> >> +       struct hfi_uncompressed_plane_constraints *constr;
> >> +       u32 entries =3D fmt->format_entries;
> >> +       u32 num_planes;
> >> +       struct raw_formats rfmts[MAX_FMT_ENTRIES] =3D {};
> >> +       unsigned int i =3D 0;
> >> +
> >> +       while (entries) {
> >> +               num_planes =3D pinfo->num_planes;
> >> +
> >> +               rfmts[i].fmt =3D pinfo->format;
> >> +               rfmts[i].buftype =3D fmt->buffer_type;
> >> +               i++;
> >> +
> >> +               if (pinfo->num_planes > MAX_PLANES)
> >> +                       break;
> >> +
> >> +               constr =3D pinfo->plane_format;
> >> +
> >> +               while (pinfo->num_planes) {
> >> +                       constr =3D (void *)constr + sizeof(*constr);
> >
> > ++constr?
> >
> >> +                       pinfo->num_planes--;
> >> +               }
> >
> > What is this loop supposed to do?
>
> It is a leftover for constraints per format and plane. Currently we
> don't use them, or at least the values returned by the firmware.
>

I guess it means we can remove it. :)

> >
> >> +
> >> +               pinfo =3D (void *)pinfo + sizeof(*constr) * num_planes=
 +
> >> +                       2 * sizeof(u32);
> >> +               entries--;
> >> +       }
> >> +
> >> +       for_each_codec(core->caps, ARRAY_SIZE(core->caps), codecs, dom=
ain,
> >> +                      fill_raw_fmts, rfmts, i);
> >> +}
> > [snip]
> >> +static void parser_fini(struct venus_core *core, struct venus_inst *i=
nst,
> >> +                       u32 codecs, u32 domain)
> >> +{
> >> +       struct venus_caps *caps =3D core->caps;
> >> +       struct venus_caps *cap;
> >> +       u32 dom;
> >> +       unsigned int i;
> >> +
> >> +       if (core->res->hfi_version !=3D HFI_VERSION_1XX)
> >> +               return;
> >
> > Hmm, if the code below is executed only for 1XX, who will set cap->vali=
d to
> > true for newer versions?
>
> cap::valid is used only for v1xx. Will add a comment in the structure.
>

Yes, please.

> >
> >> +
> >> +       if (!inst)
> >> +               return;
> >> +
> >> +       dom =3D inst->session_type;
> >> +
> >> +       for (i =3D 0; i < MAX_CODEC_NUM; i++) {
> >> +               cap =3D &caps[i];
> >> +               if (cap->codec & codecs && cap->domain =3D=3D dom)
> >> +                       cap->valid =3D true;
> >> +       }
> >> +}
> >> +
> >> +u32 hfi_parser(struct venus_core *core, struct venus_inst *inst,
> >> +              u32 num_properties, void *buf, u32 size)
> >> +{
> >> +       unsigned int words_count =3D size >> 2;
> >> +       u32 *word =3D buf, *data, codecs =3D 0, domain =3D 0;
> >> +
> >> +       if (size % 4)
> >> +               return HFI_ERR_SYS_INSUFFICIENT_RESOURCES;
> >> +
> >> +       parser_init(core, inst, &codecs, &domain);
> >> +
> >> +       while (words_count) {
> >> +               data =3D word + 1;
> >> +
> >> +               switch (*word) {
> >> +               case HFI_PROPERTY_PARAM_CODEC_SUPPORTED:
> >> +                       parse_codecs(core, data);
> >> +                       init_codecs_vcaps(core);
> >> +                       break;
> >> +               case HFI_PROPERTY_PARAM_MAX_SESSIONS_SUPPORTED:
> >> +                       parse_max_sessions(core, data);
> >> +                       break;
> >> +               case HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED:
> >> +                       parse_codecs_mask(&codecs, &domain, data);
> >> +                       break;
> >> +               case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED:
> >> +                       parse_raw_formats(core, inst, codecs, domain,
> > data);
> >> +                       break;
> >> +               case HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED:
> >> +                       parse_caps(core, inst, codecs, domain, data);
> >> +                       break;
> >> +               case HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED:
> >> +                       parse_profile_level(codecs, domain, data);
> >> +                       break;
> >> +               case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED:
> >> +                       parse_alloc_mode(core, inst, codecs, domain,
> > data);
> >> +                       break;
> >> +               default:
> >
> > Should we perhaps print something to let us know that something
> > unrecognized was reported? (Or it is expected that something unrecogniz=
ed
> > is there?)
>
> The default case will be very loaded with the data of the structures, so
> I don't think a print is a good idea.
>

Ack.

> >
> >> +                       break;
> >> +               }
> >> +
> >> +               word++;
> >> +               words_count--;
> >
> > If data is at |word + 1|, shouldn=E2=80=99t we increment |word| by |1 +=
 |data
> > size||?
>
> yes, that could be possible but the firmware packets are with variable
> data length and don't want to make the code so complex.
>
> The idea is to search for HFI_PROPERTY_PARAM* key numbers. Yes it is not
> optimal but this enumeration is happen only once during driver probe.
>

Hmm, do we have a guarantee that we will never find a value that
matches HFI_PROPERTY_PARAM*, but would be actually just some data
inside the payload?

Best regards,
Tomasz
