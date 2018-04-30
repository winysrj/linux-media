Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:39221 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754906AbeD3W6S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 18:58:18 -0400
Received: by mail-vk0-f65.google.com with SMTP id g83-v6so6124615vkc.6
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2018 15:58:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180427185925.222682-1-samitolvanen@google.com>
References: <20180427185925.222682-1-samitolvanen@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Apr 2018 15:58:17 -0700
Message-ID: <CAGXu5j+_uVdLM8gWPFB5pgHKWKGxSjasK9_wsqv+x6oLZsEh0A@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2-ioctl: fix function types for IOCTL_INFO_STD
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 27, 2018 at 11:59 AM, Sami Tolvanen <samitolvanen@google.com> wrote:
> This change fixes indirect call mismatches with Control-Flow Integrity
> checking, which are caused by calling standard ioctls using a function
> pointer that doesn't match the type of the actual function.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

I think this actually makes things much more readable in the end. Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees


> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 72 ++++++++++++++++++----------
>  1 file changed, 46 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index f48c505550e0..d50a06ab3509 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2489,11 +2489,8 @@ struct v4l2_ioctl_info {
>         unsigned int ioctl;
>         u32 flags;
>         const char * const name;
> -       union {
> -               u32 offset;
> -               int (*func)(const struct v4l2_ioctl_ops *ops,
> -                               struct file *file, void *fh, void *p);
> -       } u;
> +       int (*func)(const struct v4l2_ioctl_ops *ops, struct file *file,
> +                   void *fh, void *p);
>         void (*debug)(const void *arg, bool write_only);
>  };
>
> @@ -2501,27 +2498,24 @@ struct v4l2_ioctl_info {
>  #define INFO_FL_PRIO           (1 << 0)
>  /* This control can be valid if the filehandle passes a control handler. */
>  #define INFO_FL_CTRL           (1 << 1)
> -/* This is a standard ioctl, no need for special code */
> -#define INFO_FL_STD            (1 << 2)
>  /* This is ioctl has its own function */
> -#define INFO_FL_FUNC           (1 << 3)
> +#define INFO_FL_FUNC           (1 << 2)
>  /* Queuing ioctl */
> -#define INFO_FL_QUEUE          (1 << 4)
> +#define INFO_FL_QUEUE          (1 << 3)
>  /* Always copy back result, even on error */
> -#define INFO_FL_ALWAYS_COPY    (1 << 5)
> +#define INFO_FL_ALWAYS_COPY    (1 << 4)
>  /* Zero struct from after the field to the end */
>  #define INFO_FL_CLEAR(v4l2_struct, field)                      \
>         ((offsetof(struct v4l2_struct, field) +                 \
>           sizeof(((struct v4l2_struct *)0)->field)) << 16)
>  #define INFO_FL_CLEAR_MASK     (_IOC_SIZEMASK << 16)
>
> -#define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)                        \
> -       [_IOC_NR(_ioctl)] = {                                           \
> -               .ioctl = _ioctl,                                        \
> -               .flags = _flags | INFO_FL_STD,                          \
> -               .name = #_ioctl,                                        \
> -               .u.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),   \
> -               .debug = _debug,                                        \
> +#define DEFINE_IOCTL_STD_FNC(_vidioc)                          \
> +       static int __v4l_ ## _vidioc ## _fnc(                   \
> +                       const struct v4l2_ioctl_ops *ops,       \
> +                       struct file *file, void *fh, void *p)   \
> +       {                                                       \
> +               return ops->_vidioc(file, fh, p);               \
>         }
>
>  #define IOCTL_INFO_FNC(_ioctl, _func, _debug, _flags)                  \
> @@ -2529,10 +2523,42 @@ struct v4l2_ioctl_info {
>                 .ioctl = _ioctl,                                        \
>                 .flags = _flags | INFO_FL_FUNC,                         \
>                 .name = #_ioctl,                                        \
> -               .u.func = _func,                                        \
> +               .func = _func,                                          \
>                 .debug = _debug,                                        \
>         }
>
> +#define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)        \
> +       IOCTL_INFO_FNC(_ioctl, __v4l_ ## _vidioc ## _fnc, _debug, _flags)
> +
> +DEFINE_IOCTL_STD_FNC(vidioc_g_fbuf)
> +DEFINE_IOCTL_STD_FNC(vidioc_s_fbuf)
> +DEFINE_IOCTL_STD_FNC(vidioc_expbuf)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_std)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_audio)
> +DEFINE_IOCTL_STD_FNC(vidioc_s_audio)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_input)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_edid)
> +DEFINE_IOCTL_STD_FNC(vidioc_s_edid)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_output)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_audout)
> +DEFINE_IOCTL_STD_FNC(vidioc_s_audout)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_jpegcomp)
> +DEFINE_IOCTL_STD_FNC(vidioc_s_jpegcomp)
> +DEFINE_IOCTL_STD_FNC(vidioc_enumaudio)
> +DEFINE_IOCTL_STD_FNC(vidioc_enumaudout)
> +DEFINE_IOCTL_STD_FNC(vidioc_enum_framesizes)
> +DEFINE_IOCTL_STD_FNC(vidioc_enum_frameintervals)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_enc_index)
> +DEFINE_IOCTL_STD_FNC(vidioc_encoder_cmd)
> +DEFINE_IOCTL_STD_FNC(vidioc_try_encoder_cmd)
> +DEFINE_IOCTL_STD_FNC(vidioc_decoder_cmd)
> +DEFINE_IOCTL_STD_FNC(vidioc_try_decoder_cmd)
> +DEFINE_IOCTL_STD_FNC(vidioc_s_dv_timings)
> +DEFINE_IOCTL_STD_FNC(vidioc_g_dv_timings)
> +DEFINE_IOCTL_STD_FNC(vidioc_enum_dv_timings)
> +DEFINE_IOCTL_STD_FNC(vidioc_query_dv_timings)
> +DEFINE_IOCTL_STD_FNC(vidioc_dv_timings_cap)
> +
>  static struct v4l2_ioctl_info v4l2_ioctls[] = {
>         IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
>         IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
> @@ -2717,14 +2743,8 @@ static long __video_do_ioctl(struct file *file,
>         }
>
>         write_only = _IOC_DIR(cmd) == _IOC_WRITE;
> -       if (info->flags & INFO_FL_STD) {
> -               typedef int (*vidioc_op)(struct file *file, void *fh, void *p);
> -               const void *p = vfd->ioctl_ops;
> -               const vidioc_op *vidioc = p + info->u.offset;
> -
> -               ret = (*vidioc)(file, fh, arg);
> -       } else if (info->flags & INFO_FL_FUNC) {
> -               ret = info->u.func(ops, file, fh, arg);
> +       if (info->flags & INFO_FL_FUNC) {
> +               ret = info->func(ops, file, fh, arg);
>         } else if (!ops->vidioc_default) {
>                 ret = -ENOTTY;
>         } else {
> --
> 2.17.0.441.gb46fe60e1d-goog
>



-- 
Kees Cook
Pixel Security
