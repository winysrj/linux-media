Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40001 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932261AbcIEIY2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 04:24:28 -0400
Subject: Re: [PATCH v5 2/3] st-hva: multi-format video encoder V4L2 driver
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        linux-media@vger.kernel.org
References: <1472476868-10322-1-git-send-email-jean-christophe.trotin@st.com>
 <1472476868-10322-3-git-send-email-jean-christophe.trotin@st.com>
Cc: kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <398d281c-feb1-d290-b603-d4709914cb0d@xs4all.nl>
Date: Mon, 5 Sep 2016 10:24:22 +0200
MIME-Version: 1.0
In-Reply-To: <1472476868-10322-3-git-send-email-jean-christophe.trotin@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2016 03:21 PM, Jean-Christophe Trotin wrote:
> This patch adds V4L2 HVA (Hardware Video Accelerator) video encoder
> driver for STMicroelectronics SoC. It uses the V4L2 mem2mem framework.
> 
> This patch only contains the core parts of the driver:
> - the V4L2 interface with the userland (hva-v4l2.c)
> - the hardware services (hva-hw.c)
> - the memory management utilities (hva-mem.c)
> 
> This patch doesn't include the support of specific codec (e.g. H.264)
> video encoding: this support is part of subsequent patches.
> 
> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
> ---
>  drivers/media/platform/Kconfig            |   14 +
>  drivers/media/platform/Makefile           |    1 +
>  drivers/media/platform/sti/hva/Makefile   |    2 +
>  drivers/media/platform/sti/hva/hva-hw.c   |  538 ++++++++++++
>  drivers/media/platform/sti/hva/hva-hw.h   |   42 +
>  drivers/media/platform/sti/hva/hva-mem.c  |   59 ++
>  drivers/media/platform/sti/hva/hva-mem.h  |   34 +
>  drivers/media/platform/sti/hva/hva-v4l2.c | 1296 +++++++++++++++++++++++++++++
>  drivers/media/platform/sti/hva/hva.h      |  290 +++++++
>  9 files changed, 2276 insertions(+)
>  create mode 100644 drivers/media/platform/sti/hva/Makefile
>  create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
>  create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
>  create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
>  create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
>  create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
>  create mode 100644 drivers/media/platform/sti/hva/hva.h
> 

<snip>

> +static int hva_s_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
> +{
> +	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
> +	struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
> +
> +	time_per_frame->numerator = sp->parm.capture.timeperframe.numerator;
> +	time_per_frame->denominator =
> +		sp->parm.capture.timeperframe.denominator;
> +
> +	return 0;
> +}
> +
> +static int hva_g_parm(struct file *file, void *fh, struct v4l2_streamparm *sp)
> +{
> +	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
> +	struct v4l2_fract *time_per_frame = &ctx->ctrls.time_per_frame;
> +
> +	sp->parm.capture.timeperframe.numerator = time_per_frame->numerator;
> +	sp->parm.capture.timeperframe.denominator =
> +		time_per_frame->denominator;
> +
> +	return 0;
> +}

In this implementation g/s_parm is supported for both capture and output. Is that
intended? If so, please add a comment. If not, then you should check the type.

Also the V4L2_CAP_TIMEPERFRAME capability isn't set. I've just added a check to
v4l2-compliance to test for that.

As per the kbuild robot report you also need to depend on HAS_DMA in the Kconfig.

I have no other comments, so once these comments are fixed I can make a pull request.

Making a v6 should be quick: if you can post v6 today, then I would very much appreciate
it.

Regards,

	Hans
