Return-path: <mchehab@gaivota>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:49005 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0LRKyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 05:54:46 -0500
Message-ID: <4D0C92F2.90901@gmail.com>
Date: Sat, 18 Dec 2010 11:54:42 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hyunwoong Kim <khw0178.kim@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [PATCH v3] [media] s5p-fimc: fix the value of YUV422 1-plane
 formats
References: <1292559855-2977-1-git-send-email-khw0178.kim@samsung.com>
In-Reply-To: <1292559855-2977-1-git-send-email-khw0178.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hyunwoong,

I wish I could apply and test the patch but there are still some
problems with it. Now it doesn't apply and it seem to be mangled
somehow. Even the patchwork didn't accept it, and v2 looks strange:
https://patchwork.kernel.org/patch/412231/
It is better avoided using "==...==" separators in the change log.

Please also make sure it is rebased onto staging/for_v2.6.37-rc1
branch from repository git://linuxtv.org/media_tree.git
or better onto s5p_fimc_fixes_for_2.6.37 branch in repository
git://git.infradead.org/users/kmpark/linux-2.6-samsung

Your second patch
[PATCH][media] s5p-fimc: fix main scaler SFRs depends on FIMC version
looks OK, except it is created against wrong source tree.
Was there any difference in your environment setup while sending those
2 patches?

On 12/17/2010 05:24 AM, Hyunwoong Kim wrote:
> Some color formats are mismatched in s5p-fimc driver.
> CIOCTRL[1:0], order422_out, should be set 2b'00 not 2b'11
> to use V4L2_PIX_FMT_YUYV. Because in V4L2 standard V4L2_PIX_FMT_YUYV means
> "start + 0: Y'00 Cb00 Y'01 Cr00 Y'02 Cb01 Y'03 Cr01". According to datasheet
> 2b'00 is right value for V4L2_PIX_FMT_YUYV.
>
> ---------------------------------------------------------
> bit |    MSB                                        LSB
> ---------------------------------------------------------
> 00  |  Cr1    Y3    Cb1    Y2    Cr0    Y1    Cb0    Y0
> ---------------------------------------------------------
> 01  |  Cb1    Y3    Cr1    Y2    Cb0    Y1    Cr0    Y0
> ---------------------------------------------------------
> 10  |  Y3    Cr1    Y2    Cb1    Y1    Cr0    Y0    Cb0
> ---------------------------------------------------------
> 11  |  Y3    Cb1    Y2    Cr1    Y1    Cb0    Y0    Cr0
> ---------------------------------------------------------
>
> V4L2_PIX_FMT_YVYU, V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_VYUY are also mismatched
> with datasheet. MSCTRL[17:16], order2p_in, is also mismatched

> in V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YVYU.
>
> Signed-off-by: Hyunwoong Kim<khw0178.kim@samsung.com>
> Reviewed-by: Jonghun Han<jonghun.han@samsung.com>
> ---
> Changes since V2:
> =================
> - Correct the name of Output DMA control register
> - Change definitions of YUV422 input/outut format with datasheet
>    commented by Sylwester Nawrocki.
>
> Changes since V1:
> =================
> - make corrections directly in function fimc_set_yuv_order
>    commented by Sylwester Nawrocki.
> - remove S5P_FIMC_IN_* and S5P_FIMC_OUT_* definitions from fimc-core.h
>
>   drivers/media/video/s5p-fimc/fimc-core.c |   16 ++++++++--------
>   drivers/media/video/s5p-fimc/fimc-core.h |   12 ------------
>   drivers/media/video/s5p-fimc/regs-fimc.h |   12 ++++++------
>   3 files changed, 14 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
> index 7f56987..e2b3db1 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -448,34 +448,34 @@ static void fimc_set_yuv_order(struct fimc_ctx *ctx)
>   	/* Set order for 1 plane input formats. */
>   	switch (ctx->s_frame.fmt->color) {
>   	case S5P_FIMC_YCRYCB422:
> -		ctx->in_order_1p = S5P_FIMC_IN_YCRYCB;
> +		ctx->in_order_1p = S5P_MSCTRL_ORDER422_CBYCRY;
>   		break;
>   	case S5P_FIMC_CBYCRY422:
> -		ctx->in_order_1p = S5P_FIMC_IN_CBYCRY;
> +		ctx->in_order_1p = S5P_MSCTRL_ORDER422_YCRYCB;
>   		break;
>   	case S5P_FIMC_CRYCBY422:
> -		ctx->in_order_1p = S5P_FIMC_IN_CRYCBY;
> +		ctx->in_order_1p = S5P_MSCTRL_ORDER422_YCBYCR;
>   		break;
>   	case S5P_FIMC_YCBYCR422:
>   	default:
> -		ctx->in_order_1p = S5P_FIMC_IN_YCBYCR;
> +		ctx->in_order_1p = S5P_MSCTRL_ORDER422_CRYCBY;
>   		break;
>   	}
>   	dbg("ctx->in_order_1p= %d", ctx->in_order_1p);
>
>   	switch (ctx->d_frame.fmt->color) {
>   	case S5P_FIMC_YCRYCB422:
> -		ctx->out_order_1p = S5P_FIMC_OUT_YCRYCB;
> +		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_CBYCRY;
>   		break;
>   	case S5P_FIMC_CBYCRY422:
> -		ctx->out_order_1p = S5P_FIMC_OUT_CBYCRY;
> +		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_YCRYCB;
>   		break;
>   	case S5P_FIMC_CRYCBY422:
> -		ctx->out_order_1p = S5P_FIMC_OUT_CRYCBY;
> +		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_YCBYCR;
>   		break;
>   	case S5P_FIMC_YCBYCR422:
>   	default:
> -		ctx->out_order_1p = S5P_FIMC_OUT_YCBYCR;
> +		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_CRYCBY;
>   		break;
>   	}
>   	dbg("ctx->out_order_1p= %d", ctx->out_order_1p);
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
> index 4efc1a1..92cca62 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.h
> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
> @@ -95,18 +95,6 @@ enum fimc_color_fmt {
>
>   #define fimc_fmt_is_rgb(x) ((x)&  0x10)
>
> -/* Y/Cb/Cr components order at DMA output for 1 plane YCbCr 4:2:2 formats. */
> -#define	S5P_FIMC_OUT_CRYCBY	S5P_CIOCTRL_ORDER422_YCBYCR
> -#define	S5P_FIMC_OUT_CBYCRY	S5P_CIOCTRL_ORDER422_CBYCRY
> -#define	S5P_FIMC_OUT_YCRYCB	S5P_CIOCTRL_ORDER422_YCRYCB
> -#define	S5P_FIMC_OUT_YCBYCR	S5P_CIOCTRL_ORDER422_CRYCBY
> -
> -/* Input Y/Cb/Cr components order for 1 plane YCbCr 4:2:2 color formats. */
> -#define	S5P_FIMC_IN_CRYCBY	S5P_MSCTRL_ORDER422_CRYCBY
> -#define	S5P_FIMC_IN_CBYCRY	S5P_MSCTRL_ORDER422_CBYCRY
> -#define	S5P_FIMC_IN_YCRYCB	S5P_MSCTRL_ORDER422_YCRYCB
> -#define	S5P_FIMC_IN_YCBYCR	S5P_MSCTRL_ORDER422_YCBYCR
> -
>   /* Cb/Cr chrominance components order for 2 plane Y/CbCr 4:2:2 formats. */
>   #define	S5P_FIMC_LSB_CRCB	S5P_CIOCTRL_ORDER422_2P_LSB_CRCB
>
> diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
> index 57e33f8..cd86c18 100644
> --- a/drivers/media/video/s5p-fimc/regs-fimc.h
> +++ b/drivers/media/video/s5p-fimc/regs-fimc.h
> @@ -98,8 +98,8 @@
>   #define S5P_CIOCTRL			0x4c
>   #define S5P_CIOCTRL_ORDER422_MASK	(3<<  0)
>   #define S5P_CIOCTRL_ORDER422_CRYCBY	(0<<  0)
> -#define S5P_CIOCTRL_ORDER422_YCRYCB	(1<<  0)
> -#define S5P_CIOCTRL_ORDER422_CBYCRY	(2<<  0)
> +#define S5P_CIOCTRL_ORDER422_CBYCRY	(1<<  0)
> +#define S5P_CIOCTRL_ORDER422_YCRYCB	(2<<  0)
>   #define S5P_CIOCTRL_ORDER422_YCBYCR	(3<<  0)
>   #define S5P_CIOCTRL_LASTIRQ_ENABLE	(1<<  2)
>   #define S5P_CIOCTRL_YCBCR_3PLANE	(0<<  3)
> @@ -223,10 +223,10 @@
>   #define S5P_MSCTRL_FLIP_Y_MIRROR	(2<<  13)
>   #define S5P_MSCTRL_FLIP_180		(3<<  13)
>   #define S5P_MSCTRL_ORDER422_SHIFT	4
> -#define S5P_MSCTRL_ORDER422_CRYCBY	(0<<  4)
> -#define S5P_MSCTRL_ORDER422_YCRYCB	(1<<  4)
> -#define S5P_MSCTRL_ORDER422_CBYCRY	(2<<  4)
> -#define S5P_MSCTRL_ORDER422_YCBYCR	(3<<  4)
> +#define S5P_MSCTRL_ORDER422_YCBYCR	(0<<  4)
> +#define S5P_MSCTRL_ORDER422_CBYCRY	(1<<  4)
> +#define S5P_MSCTRL_ORDER422_YCRYCB	(2<<  4)
> +#define S5P_MSCTRL_ORDER422_CRYCBY	(3<<  4)
>   #define S5P_MSCTRL_ORDER422_MASK	(3<<  4)
>   #define S5P_MSCTRL_INPUT_EXTCAM		(0<<  3)
>   #define S5P_MSCTRL_INPUT_MEMORY		(1<<  3)
