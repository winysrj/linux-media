Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:37583 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751581AbdJIK3G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:29:06 -0400
Subject: Re: [PATCH 24/24] media: v4l2-tpg.h: rename color structs
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <8147d5ab86cb4e0a3d120f1df0a246a2b2359c11.1507544011.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <35ab6e7a-5fa0-4be5-b5fc-e0d6ca748e06@xs4all.nl>
Date: Mon, 9 Oct 2017 12:29:04 +0200
MIME-Version: 1.0
In-Reply-To: <8147d5ab86cb4e0a3d120f1df0a246a2b2359c11.1507544011.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 12:19, Mauro Carvalho Chehab wrote:
> The color structs right now are just "color" and "color16".
> That may lead into conflicts, and don't define precisely what
> they meant. As those are used by two drivers (vivid and vimc),
> this is even on a somewhat public header!
> 
> So rename them to:
> 	color ->  tpg_rbg_color8
> 	color16 ->  tpg_rbg_color16
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c | 6 +++---
>  include/media/tpg/v4l2-tpg.h                    | 8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
> index 95b26f6a0d54..43180204fab2 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
> @@ -39,7 +39,7 @@
>  #include <media/tpg/v4l2-tpg.h>
>  
>  /* sRGB colors with range [0-255] */
> -const struct color tpg_colors[TPG_COLOR_MAX] = {
> +const struct tpg_rbg_color8 tpg_colors[TPG_COLOR_MAX] = {
>  	/*
>  	 * Colors to test colorspace conversion: converting these colors
>  	 * to other colorspaces will never lead to out-of-gamut colors.
> @@ -597,7 +597,7 @@ const unsigned short tpg_linear_to_rec709[255 * 16 + 1] = {
>  };
>  
>  /* Generated table */
> -const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_SMPTE2084 + 1][TPG_COLOR_CSC_BLACK + 1] = {
> +const struct tpg_rbg_color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_SMPTE2084 + 1][TPG_COLOR_CSC_BLACK + 1] = {
>  	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][0] = { 2939, 2939, 2939 },
>  	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][1] = { 2953, 2963, 586 },
>  	[V4L2_COLORSPACE_SMPTE170M][V4L2_XFER_FUNC_709][2] = { 0, 2967, 2937 },
> @@ -1392,7 +1392,7 @@ int main(int argc, char **argv)
>  	printf("\n};\n\n");
>  
>  	printf("/* Generated table */\n");
> -	printf("const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_SMPTE2084 + 1][TPG_COLOR_CSC_BLACK + 1] = {\n");
> +	printf("const struct tpg_rbg_color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1][V4L2_XFER_FUNC_SMPTE2084 + 1][TPG_COLOR_CSC_BLACK + 1] = {\n");
>  	for (c = 0; c <= V4L2_COLORSPACE_DCI_P3; c++) {
>  		for (x = 1; x <= V4L2_XFER_FUNC_SMPTE2084; x++) {
>  			for (i = 0; i <= TPG_COLOR_CSC_BLACK; i++) {
> diff --git a/include/media/tpg/v4l2-tpg.h b/include/media/tpg/v4l2-tpg.h
> index 028d81182011..bc0b38440719 100644
> --- a/include/media/tpg/v4l2-tpg.h
> +++ b/include/media/tpg/v4l2-tpg.h
> @@ -27,11 +27,11 @@
>  #include <linux/vmalloc.h>
>  #include <linux/videodev2.h>
>  
> -struct color {
> +struct tpg_rbg_color8 {
>  	unsigned char r, g, b;
>  };
>  
> -struct color16 {
> +struct tpg_rbg_color16 {
>  	int r, g, b;
>  };
>  
> @@ -65,10 +65,10 @@ enum tpg_color {
>  	TPG_COLOR_MAX = TPG_COLOR_RAMP + 256
>  };
>  
> -extern const struct color tpg_colors[TPG_COLOR_MAX];
> +extern const struct tpg_rbg_color8 tpg_colors[TPG_COLOR_MAX];
>  extern const unsigned short tpg_rec709_to_linear[255 * 16 + 1];
>  extern const unsigned short tpg_linear_to_rec709[255 * 16 + 1];
> -extern const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1]
> +extern const struct tpg_rbg_color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1]
>  					  [V4L2_XFER_FUNC_SMPTE2084 + 1]
>  					  [TPG_COLOR_CSC_BLACK + 1];
>  enum tpg_pattern {
> 
