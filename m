Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:37997 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752007AbeEGKQU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 06:16:20 -0400
Subject: Re: [PATCH] media: v4l2-ioctl: fix function types for IOCTL_INFO_STD
To: Sami Tolvanen <samitolvanen@google.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180427185925.222682-1-samitolvanen@google.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <44310a2b-2797-223c-fab4-0214490e5201@xs4all.nl>
Date: Mon, 7 May 2018 12:16:17 +0200
MIME-Version: 1.0
In-Reply-To: <20180427185925.222682-1-samitolvanen@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sami,

This patch can simplify things further, see my comments below:

On 27/04/18 20:59, Sami Tolvanen wrote:
> This change fixes indirect call mismatches with Control-Flow Integrity
> checking, which are caused by calling standard ioctls using a function
> pointer that doesn't match the type of the actual function.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 72 ++++++++++++++++++----------
>  1 file changed, 46 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index f48c505550e0..d50a06ab3509 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2489,11 +2489,8 @@ struct v4l2_ioctl_info {
>  	unsigned int ioctl;
>  	u32 flags;
>  	const char * const name;
> -	union {
> -		u32 offset;
> -		int (*func)(const struct v4l2_ioctl_ops *ops,
> -				struct file *file, void *fh, void *p);
> -	} u;
> +	int (*func)(const struct v4l2_ioctl_ops *ops, struct file *file,
> +		    void *fh, void *p);
>  	void (*debug)(const void *arg, bool write_only);
>  };
>  
> @@ -2501,27 +2498,24 @@ struct v4l2_ioctl_info {
>  #define INFO_FL_PRIO		(1 << 0)
>  /* This control can be valid if the filehandle passes a control handler. */
>  #define INFO_FL_CTRL		(1 << 1)
> -/* This is a standard ioctl, no need for special code */
> -#define INFO_FL_STD		(1 << 2)
>  /* This is ioctl has its own function */
> -#define INFO_FL_FUNC		(1 << 3)
> +#define INFO_FL_FUNC		(1 << 2)

This flag can be removed as well since all array entries are now of this type.

>  /* Queuing ioctl */
> -#define INFO_FL_QUEUE		(1 << 4)
> +#define INFO_FL_QUEUE		(1 << 3)
>  /* Always copy back result, even on error */
> -#define INFO_FL_ALWAYS_COPY	(1 << 5)
> +#define INFO_FL_ALWAYS_COPY	(1 << 4)
>  /* Zero struct from after the field to the end */
>  #define INFO_FL_CLEAR(v4l2_struct, field)			\
>  	((offsetof(struct v4l2_struct, field) +			\
>  	  sizeof(((struct v4l2_struct *)0)->field)) << 16)
>  #define INFO_FL_CLEAR_MASK	(_IOC_SIZEMASK << 16)
>  
> -#define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)			\
> -	[_IOC_NR(_ioctl)] = {						\
> -		.ioctl = _ioctl,					\
> -		.flags = _flags | INFO_FL_STD,				\
> -		.name = #_ioctl,					\
> -		.u.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),	\
> -		.debug = _debug,					\
> +#define DEFINE_IOCTL_STD_FNC(_vidioc)				\
> +	static int __v4l_ ## _vidioc ## _fnc(			\
> +			const struct v4l2_ioctl_ops *ops,	\
> +			struct file *file, void *fh, void *p)	\
> +	{							\
> +		return ops->_vidioc(file, fh, p);		\
>  	}
>  
>  #define IOCTL_INFO_FNC(_ioctl, _func, _debug, _flags)			\
> @@ -2529,10 +2523,42 @@ struct v4l2_ioctl_info {
>  		.ioctl = _ioctl,					\
>  		.flags = _flags | INFO_FL_FUNC,				\
>  		.name = #_ioctl,					\
> -		.u.func = _func,					\
> +		.func = _func,						\
>  		.debug = _debug,					\
>  	}
>  
> +#define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)	\
> +	IOCTL_INFO_FNC(_ioctl, __v4l_ ## _vidioc ## _fnc, _debug, _flags)

Drop this define, instead just replace the IOCTL_INFO_STD defines in the array
by IOCTL_INFO_FNC.

Even better, rename IOCTL_INFO_FNC to IOCTL_INFO. The suffix is no longer needed
since there is no difference between FNC and STD anymore.

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
>  	IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
>  	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
> @@ -2717,14 +2743,8 @@ static long __video_do_ioctl(struct file *file,
>  	}
>  
>  	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
> -	if (info->flags & INFO_FL_STD) {
> -		typedef int (*vidioc_op)(struct file *file, void *fh, void *p);
> -		const void *p = vfd->ioctl_ops;
> -		const vidioc_op *vidioc = p + info->u.offset;
> -
> -		ret = (*vidioc)(file, fh, arg);
> -	} else if (info->flags & INFO_FL_FUNC) {
> -		ret = info->u.func(ops, file, fh, arg);
> +	if (info->flags & INFO_FL_FUNC) {

Replace this with:

	if (info != &default_info) {

> +		ret = info->func(ops, file, fh, arg);
>  	} else if (!ops->vidioc_default) {
>  		ret = -ENOTTY;
>  	} else {
> 

This is a nice cleanup, so I'm looking forward to v2.

Regards,

	Hans
