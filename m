Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203C0C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 12:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFC3217D9
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 12:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbeLRMn4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 07:43:56 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42354 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726403AbeLRMnz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 07:43:55 -0500
Received: from [IPv6:2001:983:e9a7:1:59e2:4cb7:1f98:4b88] ([IPv6:2001:983:e9a7:1:59e2:4cb7:1f98:4b88])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ZEj0gE9f5eA2FZEj2gO9ge; Tue, 18 Dec 2018 13:43:52 +0100
Subject: Re: [PATCH v4l-utils] v4l2-ctl: Add support for CROP selection in m2m
 streaming
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20181218111140.90645-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <603cad44-4a52-73d1-3ad5-5474ee549977@xs4all.nl>
Date:   Tue, 18 Dec 2018 13:43:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181218111140.90645-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFLeDpnqaaPbxHFPcpT4JafVsJ29d8xKSswEJEV3lRQuNDRZeph35aSR9HidDrhIHnfLcZEcjw1xMO9w4ZanT+FRc9HfwbR96ntxC84efShlxu2tbt6d
 7GtSp/8WsTUVm32JbaDZET9CklkD7aHibpYaPYmtW5n8TVBvEjwxumU72y7EX8quurt9xyHJsxZUG0GnMY9SbDpNAJWq8P0fsSXLx1Yq/CuS5tKBaQD13Ap7
 tpIOrMq9VmXay75o/ua+ODfOUvo639tZsE7kBX7vWg8XK3OseqoeHNIQRq+NwzRO6ZgUsLJ++UMpgyup1jJZrNvwXOvQKtGT8MyWlZQJjeQ=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/18/18 12:11 PM, Dafna Hirschfeld wrote:
> Add support for crop in the selection api for m2m encoder.
> This includes reading and writing raw frames with padding.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
> Tested with the jellyfish video, with this script:
> https://github.com/kamomil/outreachy/blob/master/test-v4l2-utils-with-jelly.sh
> Tested on formats yuv420, rgb24, nv12
> 
>  utils/common/v4l-stream.h             |   2 +-
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 257 +++++++++++++++++++++++++-
>  utils/v4l2-ctl/v4l2-ctl-vidcap.cpp    |   6 +
>  utils/v4l2-ctl/v4l2-ctl-vidout.cpp    |   5 +
>  utils/v4l2-ctl/v4l2-ctl.h             |   2 +
>  5 files changed, 261 insertions(+), 11 deletions(-)
> 
> diff --git a/utils/common/v4l-stream.h b/utils/common/v4l-stream.h
> index c235150b..a03d4790 100644
> --- a/utils/common/v4l-stream.h
> +++ b/utils/common/v4l-stream.h
> @@ -9,11 +9,11 @@
>  #define _V4L_STREAM_H_
>  
>  #include <linux/videodev2.h>
> -#include <codec-v4l2-fwht.h>
>  
>  #ifdef __cplusplus
>  extern "C" {
>  #endif /* __cplusplus */

Add an empty line here.

> +#include <codec-v4l2-fwht.h>
>  
>  /* Default port */
>  #define V4L_STREAM_PORT 8362
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index dee104d7..759577dd 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -20,9 +20,9 @@
>  
>  #include "v4l2-ctl.h"
>  #include "v4l-stream.h"
> -#include "codec-fwht.h"
>  
>  extern "C" {
> +#include "codec-v4l2-fwht.h"

No need for this since it is already included by v4l-stream.h

>  #include "v4l2-tpg.h"
>  }
>  
> @@ -73,6 +73,12 @@ static unsigned bpl_out[VIDEO_MAX_PLANES];
>  static bool last_buffer = false;
>  static codec_ctx *ctx;
>  
> +static unsigned int visible_width = 0;
> +static unsigned int visible_height = 0;
> +static unsigned int frame_width = 0;
> +static unsigned int frame_height = 0;

What is 'frame_width/height'? Is that what VIDIOC_G_FMT returns?

> +bool is_m2m_enc = false;

This should be static.

I'm assuming that in a future patch we'll get a is_m2m_dec as well?

> +
>  #define TS_WINDOW 241
>  #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
>  
> @@ -108,6 +114,84 @@ public:
>  	unsigned dropped();
>  };
>  
> +static int get_codec_type(int fd, bool &is_enc) {

{ on the next line.

> +	struct v4l2_capability vcap;
> +
> +	memset(&vcap,0,sizeof(vcap));

Space after ,

Please use the kernel coding style for these v4l utilities.

> +
> +	int ret = ioctl(fd, VIDIOC_QUERYCAP, &vcap);

Please use the cv4l_fd class. It comes with lots of helpers for all these ioctls
and it already used in v4l2-ctl-streaming.cpp.

In this function you can just do:

	if (!fd.has_vid_m2m())
		return -1;

> +	if(ret) {
> +		fprintf(stderr, "get_codec_type: VIDIOC_QUERYCAP failed: %d\n", ret);
> +		return ret;
> +	}
> +	unsigned int caps = vcap.capabilities;
> +	if (caps & V4L2_CAP_DEVICE_CAPS)
> +		caps = vcap.device_caps;
> +	if(!(caps & V4L2_CAP_VIDEO_M2M) && !(caps & V4L2_CAP_VIDEO_M2M_MPLANE)) {
> +		is_enc = false;
> +		fprintf(stderr,"get_codec_type: not an M2M device\n");
> +		return -1;
> +	}
> +
> +	struct v4l2_fmtdesc fmt;
> +	memset(&fmt,0,sizeof(fmt));
> +	fmt.index = 0;
> +	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +	while ((ret = ioctl(fd, VIDIOC_ENUM_FMT, &fmt)) == 0) {
> +		if((fmt.flags & V4L2_FMT_FLAG_COMPRESSED) == 0)
> +			break;
> +		fmt.index++;
> +	}

These tests aren't good enough. You need to enumerate over all formats.
Easiest is to keep a tally of the total number of formats and how many
are compressed.

An encoder is a device where all output formats are uncompressed and
all capture formats are compressed. It's the reverse for a decoder.

If you get a mix on either side, or both sides are raw or both sides
are compressed, then it isn't a codec.

> +	if (ret) {
> +		is_enc = true;
> +		return 0;
> +	}
> +	memset(&fmt,0,sizeof(fmt));
> +	fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	while ((ret = ioctl(fd, VIDIOC_ENUM_FMT, &fmt)) == 0) {
> +		if((fmt.flags & V4L2_FMT_FLAG_COMPRESSED) == 0)
> +			break;
> +		fmt.index++;
> +	}
> +	if (ret) {
> +		is_enc = false;
> +		return 0;
> +	}
> +	fprintf(stderr, "get_codec_type: could no determine codec type\n");
> +	return -1;
> +}
> +
> +static void get_frame_dims(unsigned int &frame_width, unsigned int &frame_height) {
> +
> +	if(is_m2m_enc)
> +		vidout_get_orig_from_set(frame_width, frame_height);
> +	else
> +		vidcap_get_orig_from_set(frame_width, frame_height);
> +}
> +
> +static int get_visible_format(int fd, unsigned int &width, unsigned int &height) {
> +	int ret = 0;
> +	if(is_m2m_enc) {
> +		struct v4l2_selection in_selection;
> +
> +		in_selection.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +		in_selection.target = V4L2_SEL_TGT_CROP;
> +
> +		if ( (ret = ioctl(fd, VIDIOC_G_SELECTION, &in_selection)) != 0) {
> +			fprintf(stderr,"get_visible_format: error in g_selection ioctl: %d\n",ret);
> +			return ret;
> +		}
> +		width = in_selection.r.width;
> +		height = in_selection.r.height;
> +	}
> +	else { //TODO - g_selection with COMPOSE should be used here when implemented in driver
> +		vidcap_get_orig_from_set(width, height);
> +	}
> +	return 0;
> +}
> +
> +
>  void fps_timestamps::determine_field(int fd, unsigned type)
>  {
>  	struct v4l2_format fmt = { };
> @@ -419,7 +503,6 @@ static void print_buffer(FILE *f, struct v4l2_buffer &buf)
>  			fprintf(f, "\t\tData Offset: %u\n", p->data_offset);
>  		}
>  	}
> -			
>  	fprintf(f, "\n");
>  }
>  
> @@ -657,7 +740,131 @@ void streaming_cmd(int ch, char *optarg)
>  	}
>  }
>  
> -static bool fill_buffer_from_file(cv4l_queue &q, cv4l_buffer &b, FILE *fin)
> +bool padding(cv4l_fd &fd, cv4l_queue &q, unsigned char* buf, FILE *fpointer, unsigned &sz, unsigned &len, bool is_read)

This should definitely be a static function. Also, this is not a very good name.

Why not call it fill_padded_buffer_from_file()?

> +{
> +	cv4l_fmt fmt(q.g_type());

No need to use q.g_type(). 'cv4l_fmt fmt;' is sufficient.

> +	fd.g_fmt(fmt, q.g_type());

After all, it's filled here.

> +	const struct v4l2_fwht_pixfmt_info *vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());

This test should be moved to fill_buffer_from_file. If it is not an encoder and
the pixelformat is not known (v4l2_fwht_find_pixfmt() returns NULL), then it should
fallback to the old behavior. So this function should only be called when you have
all the information about the pixelformat.

> +	unsigned coded_width = fmt.g_width();
> +	unsigned coded_height = fmt.g_height();
> +	unsigned real_width;
> +	unsigned real_height;
> +	unsigned char *buf_p = (unsigned char*) buf;
> +
> +	if(is_read) {
> +		real_width  = frame_width;
> +		real_height = frame_height;
> +	}
> +	else {
> +		real_width  = visible_width;
> +		real_height = visible_height;
> +	}
> +	sz = 0;
> +	len = real_width * real_height * vic_fmt->sizeimage_mult / vic_fmt->sizeimage_div;
> +	switch(vic_fmt->id) {
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_YVYU:
> +	case V4L2_PIX_FMT_UYVY:
> +	case V4L2_PIX_FMT_VYUY:
> +	case V4L2_PIX_FMT_RGB24:
> +	case V4L2_PIX_FMT_HSV24:
> +	case V4L2_PIX_FMT_BGR24:
> +	case V4L2_PIX_FMT_RGB32:
> +	case V4L2_PIX_FMT_XRGB32:
> +	case V4L2_PIX_FMT_HSV32:
> +	case V4L2_PIX_FMT_BGR32:
> +	case V4L2_PIX_FMT_XBGR32:
> +	case V4L2_PIX_FMT_ARGB32:
> +	case V4L2_PIX_FMT_ABGR32:

I'd put this all under a 'default' case. I think GREY can also be added here.

What I would really like to see is that only the information from v4l2_fwht_pixfmt_info
can be used here without requiring a switch.

I think all that is needed to do that is that struct v4l2_fwht_pixfmt_info is extended
with a 'planes_num' field, which is 1 for interleaved formats, 2 for luma/interleaved chroma
planar formats and 3 for luma/cr/cb planar formats.

> +		for(unsigned i=0; i < real_height; i++) {
> +			unsigned int consume_sz = vic_fmt->bytesperline_mult*real_width;
> +			unsigned int wsz = 0;
> +			if(is_read)
> +				wsz = fread(buf_p, 1, consume_sz, fpointer);
> +			else
> +				wsz = fwrite(buf_p, 1, consume_sz, fpointer);
> +			sz += wsz;
> +			if(wsz == 0 && i == 0)
> +				break;
> +			if(wsz != consume_sz) {
> +				fprintf(stderr, "padding: needed %u bytes, got %u\n",consume_sz, wsz);
> +				return false;
> +			}
> +			buf_p += vic_fmt->chroma_step*coded_width;
> +		}
> +	break;
> +
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV24:
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_NV42:
> +		for(unsigned plane_idx = 0; plane_idx < 2; plane_idx++) {
> +			unsigned h_div = (plane_idx == 0) ? 1 : vic_fmt->height_div;
> +			unsigned w_div = (plane_idx == 0) ? 1 : vic_fmt->width_div;
> +			unsigned step  =  (plane_idx == 0) ? vic_fmt->luma_alpha_step : vic_fmt->chroma_step;
> +
> +			for(unsigned i=0; i <  real_height/h_div; i++) {
> +				unsigned int wsz = 0;
> +				unsigned int consume_sz = step * real_width / w_div;
> +				if(is_read)
> +					wsz = fread(buf_p, 1,  consume_sz, fpointer);
> +				else
> +					wsz = fwrite(buf_p, 1, consume_sz, fpointer);
> +				if(wsz == 0 && i == 0 && plane_idx == 0)
> +					break;
> +				if(wsz != consume_sz) {
> +					fprintf(stderr, "padding: needed %u bytes, got %u\n",consume_sz, wsz);
> +					return true;
> +				}
> +				sz += wsz;
> +				buf_p += step*coded_width/w_div;
> +			}
> +			buf_p += (coded_width / w_div) * (coded_height - real_height) / h_div;
> +
> +			if(sz == 0)
> +				break;
> +		}
> +	break;
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_YVU420:
> +	case V4L2_PIX_FMT_GREY:
> +		for(unsigned comp_idx = 0; comp_idx < vic_fmt->components_num; comp_idx++) {
> +			unsigned h_div = (comp_idx == 0) ? 1 : vic_fmt->height_div;
> +			unsigned w_div = (comp_idx == 0) ? 1 : vic_fmt->width_div;
> +
> +			for(unsigned i=0; i < real_height/h_div; i++) {
> +				unsigned int wsz = 0;
> +				unsigned int consume_sz = real_width/w_div;
> +				if(is_read)
> +					wsz = fread(buf_p, 1, consume_sz, fpointer);
> +				else
> +					wsz = fwrite(buf_p, 1, consume_sz, fpointer);
> +				if(wsz == 0 && i == 0 && comp_idx == 0)
> +					break;
> +				if(wsz != consume_sz) {
> +					fprintf(stderr, "padding: needed %u bytes, got %u\n",consume_sz, wsz);
> +					return true;
> +				}
> +				sz += wsz;
> +				buf_p += coded_width/w_div;
> +			}
> +			buf_p += (coded_width / w_div) * (coded_height - real_height) / h_div;
> +
> +			if(sz == 0)
> +				break;
> +		}
> +		break;
> +	default:
> +		fprintf(stderr,"the format is not supported yet\n");
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static bool fill_buffer_from_file(cv4l_fd &fd, cv4l_queue &q, cv4l_buffer &b, FILE *fin)
>  {
>  	static bool first = true;
>  	static bool is_fwht = false;
> @@ -785,7 +992,15 @@ restart:
>  				return false;
>  			}
>  		}
> -		sz = fread(buf, 1, len, fin);
> +
> +		if(is_m2m_enc) {
> +			if(!padding(fd, q, (unsigned char*) buf, fin, sz, len, true))
> +				return false;
> +		}
> +		else {
> +			sz = fread(buf, 1, len, fin);
> +		}
> +
>  		if (first && sz != len) {
>  			fprintf(stderr, "Insufficient data\n");
>  			return false;
> @@ -908,7 +1123,7 @@ static int do_setup_out_buffers(cv4l_fd &fd, cv4l_queue &q, FILE *fin, bool qbuf
>  					tpg_fillbuffer(&tpg, stream_out_std, j, (u8 *)q.g_dataptr(i, j));
>  			}
>  		}
> -		if (fin && !fill_buffer_from_file(q, buf, fin))
> +		if (fin && !fill_buffer_from_file(fd, q, buf, fin))
>  			return -2;
>  
>  		if (qbuf) {
> @@ -960,7 +1175,7 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
>  		if (fd.qbuf(buf))
>  			return -1;
>  	}
> -	
> +

Seems to be a whitespace only change, just drop this change.

>  	double ts_secs = buf.g_timestamp().tv_sec + buf.g_timestamp().tv_usec / 1000000.0;
>  	fps_ts.add_ts(ts_secs, buf.g_sequence(), buf.g_field());
>  
> @@ -1023,8 +1238,15 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
>  			}
>  			if (host_fd_to >= 0)
>  				sz = fwrite(comp_ptr[j] + offset, 1, used, fout);
> -			else
> -				sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
> +			else {
> +				if(!is_m2m_enc) {
> +					if(!padding(fd, q, (u8 *)q.g_dataptr(buf.g_index(), j) + offset, fout, sz, used, false))
> +						return false;
> +				}
> +				else {
> +					sz = fwrite((u8 *)q.g_dataptr(buf.g_index(), j) + offset, 1, used, fout);
> +				}
> +			}

This doesn't feel right.

I think a write_buffer_to_file() function should be introduced that deals with these
variations.

>  
>  			if (sz != used)
>  				fprintf(stderr, "%u != %u\n", sz, used);
> @@ -1130,7 +1352,7 @@ static int do_handle_out(cv4l_fd &fd, cv4l_queue &q, FILE *fin, cv4l_buffer *cap
>  			output_field = V4L2_FIELD_TOP;
>  	}
>  
> -	if (fin && !fill_buffer_from_file(q, buf, fin))
> +	if (fin && !fill_buffer_from_file(fd, q, buf, fin))
>  		return -2;
>  
>  	if (!fin && stream_out_refresh) {
> @@ -1227,7 +1449,7 @@ static void streaming_set_cap(cv4l_fd &fd)
>  		}
>  		break;
>  	}
> -	
> +
>  	memset(&sub, 0, sizeof(sub));
>  	sub.type = V4L2_EVENT_EOS;
>  	fd.subscribe_event(sub);
> @@ -2031,6 +2253,21 @@ void streaming_set(cv4l_fd &fd, cv4l_fd &out_fd)
>  	int do_cap = options[OptStreamMmap] + options[OptStreamUser] + options[OptStreamDmaBuf];
>  	int do_out = options[OptStreamOutMmap] + options[OptStreamOutUser] + options[OptStreamOutDmaBuf];
>  
> +	int r = get_codec_type(fd.g_fd(), is_m2m_enc);
> +	if(r) {
> +		fprintf(stderr, "error checking codec type\n");
> +		return;
> +	}
> +
> +	r = get_visible_format(fd.g_fd(), visible_width, visible_height);
> +
> +	if(r) {
> +		fprintf(stderr, "error getting the visible width\n");
> +		return;
> +	}
> +
> +	get_frame_dims(frame_width, frame_height);
> +
>  	if (out_fd.g_fd() < 0) {
>  		out_capabilities = capabilities;
>  		out_priv_magic = priv_magic;
> diff --git a/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp b/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> index dc17a868..932f1fd2 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-vidcap.cpp
> @@ -244,6 +244,12 @@ void vidcap_get(cv4l_fd &fd)
>  	}
>  }
>  
> +void vidcap_get_orig_from_set(unsigned int &r_width, unsigned int &r_height) {
> +	r_height = height;
> +	r_width = width;
> +}
> +
> +
>  void vidcap_list(cv4l_fd &fd)
>  {
>  	if (options[OptListFormats]) {
> diff --git a/utils/v4l2-ctl/v4l2-ctl-vidout.cpp b/utils/v4l2-ctl/v4l2-ctl-vidout.cpp
> index 5823df9c..05bd43ed 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-vidout.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-vidout.cpp
> @@ -208,6 +208,11 @@ void vidout_get(cv4l_fd &fd)
>  	}
>  }
>  
> +void vidout_get_orig_from_set(unsigned int &r_width, unsigned int &r_height) {
> +	r_height = height;
> +	r_width = width;
> +}

Don't do this (same for vidcap_get_orig_from_set).

I think you just want to get the width and height from VIDIOC_G_FMT here,
so why not just call that?

Remember that you can call v4l2-ctl without setting the output width and height
if the defaults that the driver sets are already fine. In that case the width and height
variables in this source are just 0.

> +
>  void vidout_list(cv4l_fd &fd)
>  {
>  	if (options[OptListOutFormats]) {
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 5a52a0a4..ab2994b2 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -357,6 +357,8 @@ void vidout_cmd(int ch, char *optarg);
>  void vidout_set(cv4l_fd &fd);
>  void vidout_get(cv4l_fd &fd);
>  void vidout_list(cv4l_fd &fd);
> +void vidcap_get_orig_from_set(unsigned int &r_width, unsigned int &r_height);
> +void vidout_get_orig_from_set(unsigned int &r_width, unsigned int &r_height);
>  
>  // v4l2-ctl-overlay.cpp
>  void overlay_usage(void);
> 

This patch needs more work (not surprisingly, since it takes a bit of time to
understand the v4l2-ctl source code).

Please stick to the kernel coding style! Using a different style makes it harder
for me to review since my pattern matches routines in my brain no longer work
optimally. It's like reading text with spelling mistakes, you cn stil undrstant iT,
but it tekes moore teem. :-)

Regards,

	Hans
