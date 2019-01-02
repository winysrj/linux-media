Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE687C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 10:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A0982171F
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 10:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfABKsy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 05:48:54 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:46849 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728632AbfABKsy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Jan 2019 05:48:54 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id ee4tgBw2qIx4Wee4wgX9fc; Wed, 02 Jan 2019 11:48:51 +0100
Subject: Re: [v4l-utils PATCH v2] v4l2-ctl: Add support for crop and compose
 selection in streaming
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190102083756.11949-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d8c7c224-0df6-9eae-c6d2-8f9c7220964e@xs4all.nl>
Date:   Wed, 2 Jan 2019 11:48:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190102083756.11949-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKlbNaHOUMqaMDehHPDFm8Y1HsUgdF/5w3jYAczbdfpPInGTv9BWtRBDnvPefc8pmHlj6eYrV+MWxOHV1NNGKp8NPJOcnak6VJoxJPOgg5wSS8aV2gyI
 d3lnbBgArQBrs+2h1OkceFSvl1LJ/jPT//maejRpLXkxObF7mcGRvVjLv/1WTWbIsV+F8yddcBmTxZb7QIgEsTAyZfor/9UxeZ/SYGJrsC67gFJkypmV785W
 osKSlRg08lJ8GE/uxhODEA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/02/2019 09:37 AM, Dafna Hirschfeld wrote:
> Support crop and compose selection.
> If the driver supports crop/compose then the raw frame is arranged
> inside a padded buffer.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  utils/common/codec-fwht.patch         |   8 +-
>  utils/common/v4l-stream.c             |  14 +--
>  utils/common/v4l-stream.h             |   6 +-
>  utils/qvidcap/capture.cpp             |   2 +
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 137 ++++++++++++++++++++++++--
>  5 files changed, 146 insertions(+), 21 deletions(-)
> 
> diff --git a/utils/common/codec-fwht.patch b/utils/common/codec-fwht.patch
> index 4d41225b..37ac4672 100644
> --- a/utils/common/codec-fwht.patch
> +++ b/utils/common/codec-fwht.patch
> @@ -1,6 +1,6 @@
> ---- a/utils/common/codec-fwht.h.old	2018-11-23 13:43:52.713731559 +0100
> -+++ b/utils/common/codec-fwht.h	2018-11-23 13:47:55.484198283 +0100
> -@@ -8,8 +8,24 @@
> +--- a/utils/common/codec-fwht.h.old	2018-12-29 11:23:58.128328613 -0800
> ++++ b/utils/common/codec-fwht.h	2018-12-29 11:24:16.099127560 -0800
> +@@ -8,8 +8,26 @@
>   #define CODEC_FWHT_H
>   
>   #include <linux/types.h>
> @@ -17,6 +17,8 @@
>  +#define GENMASK(h, l) \
>  +	(((~0UL) - (1UL << (l)) + 1) & (~0UL >> ((8 * sizeof(long)) - 1 - (h))))
>  +#define pr_err(arg...)
> ++#define __round_mask(x, y) ((__typeof__(x))((y)-1))
> ++#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
>  +
>  +
>  +typedef __u32 u32;
> diff --git a/utils/common/v4l-stream.c b/utils/common/v4l-stream.c
> index 9f842e21..a1cabadb 100644
> --- a/utils/common/v4l-stream.c
> +++ b/utils/common/v4l-stream.c
> @@ -171,25 +171,28 @@ unsigned rle_compress(__u8 *b, unsigned size, unsigned bpl)
>  	return (__u8 *)dst - b;
>  }
>  
> -struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned w, unsigned h,
> +struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned visible_width, unsigned visible_height,
> +			     unsigned coded_width, unsigned coded_height,
>  			     unsigned field, unsigned colorspace, unsigned xfer_func,
>  			     unsigned ycbcr_enc, unsigned quantization)
>  {
>  	struct codec_ctx *ctx;
>  	const struct v4l2_fwht_pixfmt_info *info = v4l2_fwht_find_pixfmt(pixfmt);
>  	unsigned int chroma_div;
> -	unsigned int size = w * h;
> +	unsigned int size = coded_width * coded_height;
>  
>  	// fwht expects macroblock alignment, check can be dropped once that
>  	// restriction is lifted.
> -	if (!info || w % 8 || h % 8)
> +	if (!info || coded_width % 8 || coded_height % 8)
>  		return NULL;
>  
>  	ctx = malloc(sizeof(*ctx));
>  	if (!ctx)
>  		return NULL;
> -	ctx->state.width = w;
> -	ctx->state.height = h;
> +	ctx->state.coded_width = coded_width;
> +	ctx->state.coded_height = coded_height;
> +	ctx->state.visible_width = visible_width;
> +	ctx->state.visible_height = visible_height;
>  	ctx->state.info = info;
>  	ctx->field = field;
>  	ctx->state.colorspace = colorspace;
> @@ -208,7 +211,6 @@ struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned w, unsigned h,
>  		free(ctx);
>  		return NULL;
>  	}
> -	ctx->state.ref_frame.width = ctx->state.ref_frame.height = 0;
>  	ctx->state.ref_frame.cb = ctx->state.ref_frame.luma + size;
>  	ctx->state.ref_frame.cr = ctx->state.ref_frame.cb + size / chroma_div;
>  	ctx->state.ref_frame.alpha = ctx->state.ref_frame.cr + size / chroma_div;
> diff --git a/utils/common/v4l-stream.h b/utils/common/v4l-stream.h
> index c235150b..fe5dfe90 100644
> --- a/utils/common/v4l-stream.h
> +++ b/utils/common/v4l-stream.h
> @@ -9,12 +9,13 @@
>  #define _V4L_STREAM_H_
>  
>  #include <linux/videodev2.h>
> -#include <codec-v4l2-fwht.h>
>  
>  #ifdef __cplusplus
>  extern "C" {
>  #endif /* __cplusplus */
>  
> +#include <codec-v4l2-fwht.h>
> +
>  /* Default port */
>  #define V4L_STREAM_PORT 8362
>  
> @@ -145,7 +146,8 @@ struct codec_ctx {
>  
>  unsigned rle_compress(__u8 *buf, unsigned size, unsigned bytesperline);
>  void rle_decompress(__u8 *buf, unsigned size, unsigned rle_size, unsigned bytesperline);
> -struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned w, unsigned h, unsigned field,
> +struct codec_ctx *fwht_alloc(unsigned pixfmt, unsigned visible_width, unsigned visible_height,
> +			     unsigned coded_width, unsigned coded_height, unsigned field,
>  			     unsigned colorspace, unsigned xfer_func, unsigned ycbcr_enc,
>  			     unsigned quantization);
>  void fwht_free(struct codec_ctx *ctx);
> diff --git a/utils/qvidcap/capture.cpp b/utils/qvidcap/capture.cpp
> index 8c11ac53..e04db6be 100644
> --- a/utils/qvidcap/capture.cpp
> +++ b/utils/qvidcap/capture.cpp
> @@ -749,6 +749,7 @@ void CaptureWin::setModeSocket(int socket, int port)
>  	if (m_ctx)
>  		free(m_ctx);
>  	m_ctx = fwht_alloc(m_v4l_fmt.g_pixelformat(), m_v4l_fmt.g_width(), m_v4l_fmt.g_height(),
> +			   m_v4l_fmt.g_width(), m_v4l_fmt.g_height(),
>  			   m_v4l_fmt.g_field(), m_v4l_fmt.g_colorspace(), m_v4l_fmt.g_xfer_func(),
>  			   m_v4l_fmt.g_ycbcr_enc(), m_v4l_fmt.g_quantization());
>  
> @@ -1114,6 +1115,7 @@ void CaptureWin::listenForNewConnection()
>  	if (m_ctx)
>  		free(m_ctx);
>  	m_ctx = fwht_alloc(fmt.g_pixelformat(), fmt.g_width(), fmt.g_height(),
> +			   fmt.g_width(), fmt.g_height(),
>  			   fmt.g_field(), fmt.g_colorspace(), fmt.g_xfer_func(),
>  			   fmt.g_ycbcr_enc(), fmt.g_quantization());
>  	setPixelAspect(pixelaspect);
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index 79e015ce..cc714008 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -20,7 +20,6 @@
>  
>  #include "v4l2-ctl.h"
>  #include "v4l-stream.h"
> -#include "codec-fwht.h"
>  
>  extern "C" {
>  #include "v4l2-tpg.h"
> @@ -73,6 +72,13 @@ static unsigned bpl_out[VIDEO_MAX_PLANES];
>  static bool last_buffer = false;
>  static codec_ctx *ctx;
>  
> +static unsigned int cropped_width = 0;
> +static unsigned int cropped_height = 0;
> +static unsigned int composed_width = 0;
> +static unsigned int composed_height = 0;
> +static bool support_cap_compose = false;
> +static bool support_out_crop = false;

No need to assign 0/false to these static globals. Statics are always initialized to 0.

> +
>  #define TS_WINDOW 241
>  #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
>  
> @@ -657,7 +663,57 @@ void streaming_cmd(int ch, char *optarg)
>  	}
>  }
>  
> -static bool fill_buffer_from_file(cv4l_queue &q, cv4l_buffer &b, FILE *fin)
> +static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char* buf, FILE *fpointer,

unsigned char *buf

> +				    unsigned &sz, unsigned &len, bool is_read)
> +{
> +	const struct v4l2_fwht_pixfmt_info *vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
> +	unsigned coded_width = fmt.g_width();
> +	unsigned coded_height = fmt.g_height();
> +	unsigned real_width;
> +	unsigned real_height;
> +	unsigned char *buf_p = buf;
> +
> +	if (is_read) {
> +		real_width  = cropped_width;
> +		real_height = cropped_height;
> +	}
> +	else {
> +		real_width  = composed_width;
> +		real_height = composed_height;
> +	}
> +
> +	sz = 0;
> +	len = real_width * real_height * vic_fmt->sizeimage_mult / vic_fmt->sizeimage_div;
> +
> +	for (unsigned plane_idx = 0; plane_idx < vic_fmt->planes_num; plane_idx++) {
> +		unsigned h_div = (plane_idx == 0 || plane_idx == 3) ? 1 : vic_fmt->height_div;
> +		unsigned w_div = (plane_idx == 0 || plane_idx == 3) ? 1 : vic_fmt->width_div;
> +		unsigned step  = (plane_idx == 0 || plane_idx == 3) ? vic_fmt->luma_alpha_step : vic_fmt->chroma_step;
> +
> +		for (unsigned i=0; i <  real_height/h_div; i++) {

Add spaces around '=' and '/'. Remove duplicate space after '<'

> +			unsigned int wsz = 0;
> +			unsigned int consume_sz = step * real_width / w_div;
> +
> +			if (is_read)
> +				wsz = fread(buf_p, 1, consume_sz, fpointer);
> +			else
> +				wsz = fwrite(buf_p, 1, consume_sz, fpointer);
> +			if (wsz == 0 && i == 0 && plane_idx == 0)
> +				break;
> +			if (wsz != consume_sz) {
> +				fprintf(stderr, "padding: needed %u bytes, got %u\n",consume_sz, wsz);

Add space before consume_sz.

> +				return;
> +			}
> +			sz += wsz;
> +			buf_p += step * coded_width / w_div;
> +		}
> +		buf_p += (step * coded_width / w_div) * (coded_height - real_height) / h_div;
> +		if(sz == 0)

Add space after 'if'.

> +			break;
> +	}
> +}
> +
> +static bool fill_buffer_from_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &b, FILE *fin)
>  {
>  	static bool first = true;
>  	static bool is_fwht = false;
> @@ -776,6 +832,8 @@ restart:
>  		void *buf = q.g_dataptr(b.g_index(), j);
>  		unsigned len = q.g_length(j);
>  		unsigned sz;
> +		cv4l_fmt fmt;

Add newline.

> +		fd.g_fmt(fmt, q.g_type());
>  
>  		if (from_with_hdr) {
>  			len = read_u32(fin);
> @@ -785,7 +843,12 @@ restart:
>  				return false;
>  			}
>  		}
> -		sz = fread(buf, 1, len, fin);
> +
> +		if (support_out_crop && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
> +			read_write_padded_frame(fmt, (unsigned char*) buf, fin, sz, len, true);

(unsigned char *)buf

> +		else
> +			sz = fread(buf, 1, len, fin);
> +
>  		if (first && sz != len) {
>  			fprintf(stderr, "Insufficient data\n");
>  			return false;
> @@ -908,7 +971,7 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
>  					tpg_fillbuffer(&tpg, stream_out_std, j, (u8 *)q.g_dataptr(i, j));
>  			}
>  		}
> -		if (fin && !fill_buffer_from_file(q, buf, fin))
> +		if (fin && !fill_buffer_from_file(fd, q, buf, fin))
>  			return -2;
>  
>  		if (qbuf) {
> @@ -926,7 +989,7 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
>  	return 0;
>  }
>  
> -static void write_buffer_to_file(cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
> +static void write_buffer_to_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
>  {
>  #ifndef NO_STREAM_TO
>  	unsigned comp_size[VIDEO_MAX_PLANES];
> @@ -967,6 +1030,8 @@ static void write_buffer_to_file(cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
>  		__u32 used = buf.g_bytesused();
>  		unsigned offset = buf.g_data_offset();
>  		unsigned sz;
> +		cv4l_fmt fmt;

newline

> +		fd.g_fmt(fmt, q.g_type());
>  
>  		if (offset > used) {
>  			// Should never happen
> @@ -985,6 +1050,9 @@ static void write_buffer_to_file(cv4l_queue &q, cv4l_buffer &buf, FILE *fout)
>  		}
>  		if (host_fd_to >= 0)
>  			sz = fwrite(comp_ptr[j] + offset, 1, used, fout);
> +		else if (support_cap_compose && v4l2_fwht_find_pixfmt(fmt.g_pixelformat()))
> +			read_write_padded_frame(fmt, (u8 *)q.g_dataptr(buf.g_index(), j) + offset,
> +						fout, sz, used, false);
>  		else
>  			sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
>  
> @@ -1036,7 +1104,7 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
>  
>  	if (fout && (!stream_skip || ignore_count_skip) &&
>  	    buf.g_bytesused(0) && !(buf.g_flags() & V4L2_BUF_FLAG_ERROR))
> -		write_buffer_to_file(q, buf, fout);
> +		write_buffer_to_file(fd, q, buf, fout);
>  
>  	if (buf.g_flags() & V4L2_BUF_FLAG_KEYFRAME)
>  		ch = 'K';
> @@ -1135,7 +1203,7 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
>  			output_field = V4L2_FIELD_TOP;
>  	}
>  
> -	if (fin && !fill_buffer_from_file(q, buf, fin))
> +	if (fin && !fill_buffer_from_file(fd, q, buf, fin))
>  		return -2;
>  
>  	if (!fin && stream_out_refresh) {
> @@ -1333,10 +1401,15 @@ recover:
>  			write_u32(fout, cfmt.g_bytesperline(i));
>  			bpl_cap[i] = rle_calc_bpl(cfmt.g_bytesperline(i), cfmt.g_pixelformat());
>  		}
> -		if (!host_lossless)
> -			ctx = fwht_alloc(cfmt.g_pixelformat(), cfmt.g_width(), cfmt.g_height(),
> +		if (!host_lossless) {
> +			unsigned visible_width = support_cap_compose ? composed_width : cfmt.g_width();
> +			unsigned visible_height = support_cap_compose ? composed_height : cfmt.g_height();
> +
> +			ctx = fwht_alloc(cfmt.g_pixelformat(), visible_width, visible_height,
> +					 cfmt.g_width(), cfmt.g_height(),
>  					 cfmt.g_field(), cfmt.g_colorspace(), cfmt.g_xfer_func(),
>  					 cfmt.g_ycbcr_enc(), cfmt.g_quantization());
> +		}
>  		fflush(fout);
>  	}
>  #endif
> @@ -1560,7 +1633,11 @@ static void streaming_set_out(cv4l_fd &fd)
>  		cfmt.s_quantization(read_u32(fin));
>  		cfmt.s_xfer_func(read_u32(fin));
>  		cfmt.s_flags(read_u32(fin));
> -		ctx = fwht_alloc(cfmt.g_pixelformat(), cfmt.g_width(), cfmt.g_height(),
> +		unsigned visible_width = support_out_crop ? cropped_width : cfmt.g_width();
> +		unsigned visible_height = support_out_crop ? cropped_height : cfmt.g_height();
> +
> +		ctx = fwht_alloc(cfmt.g_pixelformat(), visible_width, visible_height,
> +				 cfmt.g_width(), cfmt.g_height(),
>  				 cfmt.g_field(), cfmt.g_colorspace(), cfmt.g_xfer_func(),
>  				 cfmt.g_ycbcr_enc(), cfmt.g_quantization());
>  
> @@ -2029,6 +2106,43 @@ done:
>  		fclose(file[OUT]);
>  }
>  
> +static int is_support_compose_on_cap(cv4l_fd &fd) {

{ should be on its own line

This function also does more than just detect if compose is supported.
Perhaps get_cap_compose_rect() is a better name.

> +	v4l2_selection sel;
> +
> +	memset(&sel, 0, sizeof(sel));
> +	sel.type = vidcap_buftype;
> +	sel.target = V4L2_SEL_TGT_COMPOSE;
> +
> +	if (fd.g_selection(sel) == 0) {
> +		support_cap_compose = true;
> +		composed_width = sel.r.width;
> +		composed_height = sel.r.height;
> +		return 0;
> +	}
> +
> +	support_cap_compose = false;
> +	return 0;
> +}
> +
> +
> +static int is_support_crop_on_out(cv4l_fd &fd) {

Ditto.

> +	v4l2_selection sel;
> +
> +	memset(&sel, 0, sizeof(sel));
> +	sel.type = vidout_buftype;
> +	sel.target = V4L2_SEL_TGT_CROP;
> +
> +	if (fd.g_selection(sel) == 0) {
> +		support_out_crop = true;
> +		cropped_width = sel.r.width;
> +		cropped_height = sel.r.height;
> +		return 0;
> +	}
> +
> +	support_out_crop = false;
> +	return 0;
> +}
> +
>  void streaming_set(cv4l_fd &fd, cv4l_fd &out_fd)
>  {
>  	cv4l_disable_trace dt(fd);
> @@ -2036,6 +2150,9 @@ void streaming_set(cv4l_fd &fd, cv4l_fd &out_fd)
>  	int do_cap = options[OptStreamMmap] + options[OptStreamUser] + options[OptStreamDmaBuf];
>  	int do_out = options[OptStreamOutMmap] + options[OptStreamOutUser] + options[OptStreamOutDmaBuf];
>  
> +	is_support_crop_on_out(fd);
> +	is_support_compose_on_cap(fd);
> +
>  	if (out_fd.g_fd() < 0) {
>  		out_capabilities = capabilities;
>  		out_priv_magic = priv_magic;
> 

Regards,

	Hans
