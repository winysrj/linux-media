Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:37571 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933282AbeGBJaY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 05:30:24 -0400
Received: by mail-yb0-f193.google.com with SMTP id r3-v6so4850965ybo.4
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 02:30:24 -0700 (PDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com. [209.85.161.182])
        by smtp.gmail.com with ESMTPSA id k10-v6sm6127584ywk.101.2018.07.02.02.30.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 02:30:22 -0700 (PDT)
Received: by mail-yw0-f182.google.com with SMTP id l189-v6so38861ywb.10
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 02:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-28-stanimir.varbanov@linaro.org> <CAAFQd5Cyk2=YG+LVGt0qEcrRGdarpHJDJ73AzG1iWBbyhr+nAA@mail.gmail.com>
In-Reply-To: <CAAFQd5Cyk2=YG+LVGt0qEcrRGdarpHJDJ73AzG1iWBbyhr+nAA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 2 Jul 2018 18:30:10 +0900
Message-ID: <CAAFQd5C=__+qTXsCtr7uS+7T6Dpgpeh8m6TuNEiYe5W2K2gaSw@mail.gmail.com>
Subject: Re: [PATCH v2 27/29] venus: implementing multi-stream support
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On Thu, May 31, 2018 at 6:51 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Tue, May 15, 2018 at 5:00 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
> >
> > This is implementing a multi-stream decoder support. The multi
> > stream gives an option to use the secondary decoder output
> > with different raw format (or the same in case of crop).
> >
> > Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> > ---
> >  drivers/media/platform/qcom/venus/core.h    |   1 +
> >  drivers/media/platform/qcom/venus/helpers.c | 204 +++++++++++++++++++++++++++-
> >  drivers/media/platform/qcom/venus/helpers.h |   6 +
> >  drivers/media/platform/qcom/venus/vdec.c    |  91 ++++++++++++-
> >  drivers/media/platform/qcom/venus/venc.c    |   1 +
> >  5 files changed, 299 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> > index 4d6c05f156c4..85e66e2dd672 100644
> > --- a/drivers/media/platform/qcom/venus/core.h
> > +++ b/drivers/media/platform/qcom/venus/core.h
> > @@ -259,6 +259,7 @@ struct venus_inst {
> >         struct list_head list;
> >         struct mutex lock;
> >         struct venus_core *core;
> > +       struct list_head dpbbufs;
> >         struct list_head internalbufs;
> >         struct list_head registeredbufs;
> >         struct list_head delayed_process;
> > diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> > index ed569705ecac..87dcf9973e6f 100644
> > --- a/drivers/media/platform/qcom/venus/helpers.c
> > +++ b/drivers/media/platform/qcom/venus/helpers.c
> > @@ -85,6 +85,112 @@ bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
> >  }
> >  EXPORT_SYMBOL_GPL(venus_helper_check_codec);
> >
> > +static int venus_helper_queue_dpb_bufs(struct venus_inst *inst)
> > +{
> > +       struct intbuf *buf;
> > +       int ret = 0;
> > +
> > +       if (list_empty(&inst->dpbbufs))
> > +               return 0;
>
> Does this special case give us anything other than few more source lines?
>
> > +
> > +       list_for_each_entry(buf, &inst->dpbbufs, list) {
> > +               struct hfi_frame_data fdata;
> > +
> > +               memset(&fdata, 0, sizeof(fdata));
> > +               fdata.alloc_len = buf->size;
> > +               fdata.device_addr = buf->da;
> > +               fdata.buffer_type = buf->type;
> > +
> > +               ret = hfi_session_process_buf(inst, &fdata);
> > +               if (ret)
> > +                       goto fail;
> > +       }
> > +
> > +fail:
> > +       return ret;
> > +}
> > +
> > +int venus_helper_free_dpb_bufs(struct venus_inst *inst)
> > +{
> > +       struct intbuf *buf, *n;
> > +
> > +       if (list_empty(&inst->dpbbufs))
> > +               return 0;
>
> Ditto.
>
> > +
> > +       list_for_each_entry_safe(buf, n, &inst->dpbbufs, list) {
> > +               list_del_init(&buf->list);
> > +               dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
> > +                              buf->attrs);
> > +               kfree(buf);
> > +       }
> > +
> > +       INIT_LIST_HEAD(&inst->dpbbufs);
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(venus_helper_free_dpb_bufs);
> [snip]
> > +int venus_helper_get_out_fmts(struct venus_inst *inst, u32 v4l2_fmt,
> > +                             u32 *out_fmt, u32 *out2_fmt, bool ubwc)
> > +{
> > +       struct venus_core *core = inst->core;
> > +       struct venus_caps *caps;
> > +       u32 ubwc_fmt, fmt = to_hfi_raw_fmt(v4l2_fmt);
> > +       bool found, found_ubwc;
> > +
> > +       *out_fmt = *out2_fmt = 0;
> > +
> > +       if (!fmt)
> > +               return -EINVAL;
> > +
> > +       caps = venus_caps_by_codec(core, inst->hfi_codec, inst->session_type);
> > +       if (!caps)
> > +               return -EINVAL;
> > +
> > +       if (ubwc) {
> > +               ubwc_fmt = fmt | HFI_COLOR_FORMAT_UBWC_BASE;
>
> Does the UBWC base format have to be the same as fmt? Looking at
> HFI_COLOR_FORMAT_* macros, UBWC variants seem to exist only for few
> selected raw formats, for example there is none for NV21.

Ping.

None of the comments I posted above have been addressed in v4.

Best regards,
Tomasz
