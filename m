Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A473C282F6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B25A2085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 09:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfAUJqP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:46:15 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55999 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbfAUJqP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 04:46:15 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lW9hgWFNYBDyIlW9lgNxhQ; Mon, 21 Jan 2019 10:46:13 +0100
Subject: Re: [v4l-utils PATCH 5/6] v4l2-ctl: Add support for source change
 event for m2m decoder
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190120111520.114305-1-dafna3@gmail.com>
 <20190120111520.114305-6-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <92439cfe-592f-d236-73a9-e373bf5732bd@xs4all.nl>
Date:   Mon, 21 Jan 2019 10:46:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190120111520.114305-6-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEUkuDiHT5Ex6ujodM3KvSFgyG3rY2PM3lsWl4yY7RZC0OzCKr9Kp7MUuOJ2IkfQQTCGrq5tF5of5tsSzlJMiSs47Ph2+e9OVfMrcC9yG+mjX5Dmu4Kn
 HjuRrNbmqfgKaXJpUcgMch2C/4jahHFmLH1TnzI31/KV9BC/BmMGXBXlZf+sSliITT7Fl2brXTD7pflNY6O9Lmj21z41+g2XbmBtGCFCDRn5o/JVGzVSFAAR
 kCLbC2eVmeRXnVFwpkGzXQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/20/2019 12:15 PM, Dafna Hirschfeld wrote:
> Subscribe to source change event.
> The capture setup sequence is executed only due to a
> change event.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 90 ++++++++++++++++++++++-----
>  1 file changed, 76 insertions(+), 14 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index cd20dec7..61dd84db 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -78,6 +78,7 @@ static unsigned int composed_width;
>  static unsigned int composed_height;
>  static bool support_cap_compose;
>  static bool support_out_crop;
> +static bool in_source_change_event;
>  
>  #define TS_WINDOW 241
>  #define FILE_HDR_ID			v4l2_fourcc('V', 'h', 'd', 'r')
> @@ -755,8 +756,11 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
>  				    FILE *fpointer, unsigned &sz,
>  				    unsigned &len, bool is_read)
>  {
> -	const struct v4l2_fwht_pixfmt_info *vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
> -	unsigned coded_height = fmt.g_height();
> +	const struct v4l2_fwht_pixfmt_info *vic_fmt;
> +	const static struct v4l2_fwht_pixfmt_info *old_info =
> +		v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
> +	static cv4l_fmt old_fmt = fmt;
> +	unsigned coded_height;
>  	unsigned real_width;
>  	unsigned real_height;
>  	unsigned char *plane_p = buf;
> @@ -770,6 +774,21 @@ static void read_write_padded_frame(cv4l_fmt &fmt, unsigned char *buf,
>  		real_height = composed_height;
>  	}
>  
> +	/*
> +	 * if the source change event was dequeued but the stream was not yet
> +	 * restarted then the current buffers still fit the old resolution so
> +	 * we need to save it
> +	 */
> +	if (in_source_change_event) {
> +		vic_fmt = old_info;
> +		fmt = old_fmt;
> +	} else {
> +		vic_fmt = v4l2_fwht_find_pixfmt(fmt.g_pixelformat());
> +		old_info = vic_fmt;
> +		old_fmt = fmt;
> +	}
> +
> +	coded_height = fmt.g_height();
>  	sz = 0;
>  	len = real_width * real_height * vic_fmt->sizeimage_mult / vic_fmt->sizeimage_div;
>  
> @@ -1208,8 +1227,18 @@ static int do_handle_cap(cv4l_fd &fd, cv4l_queue &q, FILE *fout, int *index,
>  				     host_fd_to >= 0 ? 100 - comp_perc / comp_perc_count : -1);
>  		comp_perc_count = comp_perc = 0;
>  	}
> -	if (!last_buffer && index == NULL && fd.qbuf(buf))
> -		return -1;
> +	if (!last_buffer && index == NULL) {
> +		/*
> +		 * EINVAL in qbuf can happen if this is the last buffer before
> +		 * a dynamic resolution change sequence. In this case the buffer
> +		 * has the size that fits the old resolution and might not
> +		 * fit to the new one.
> +		 */
> +		if (fd.qbuf(buf) && errno != EINVAL) {
> +			fprintf(stderr, "%s: qbuf error\n", __func__);
> +			return -1;
> +		}
> +	}
>  	if (index)
>  		*index = buf.g_index();
>  
> @@ -1890,6 +1919,7 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  	fd_set *rd_fds = &fds[0]; /* for capture */
>  	fd_set *ex_fds = &fds[1]; /* for capture */
>  	fd_set *wr_fds = &fds[2]; /* for output */
> +	bool cap_streaming = false;
>  
>  	if (!fd.has_vid_m2m()) {
>  		fprintf(stderr, "unsupported m2m stream type\n");
> @@ -1920,6 +1950,11 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  		is_encoder = !fmt.g_bytesperline();
>  	}
>  
> +	memset(&sub, 0, sizeof(sub));
> +	sub.type = V4L2_EVENT_SOURCE_CHANGE;
> +	if (fd.subscribe_event(sub))
> +		goto done;
> +
>  	if (file_to) {
>  		if (!strcmp(file_to, "-"))
>  			file[CAP] = stdout;
> @@ -1941,6 +1976,10 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  			return;
>  		}
>  	}
> +	enum codec_type codec_type;
> +
> +	if (get_codec_type(fd, codec_type))
> +		goto done;
>  
>  	if (out.reqbufs(&fd, reqbufs_count_out))
>  		goto done;
> @@ -1951,8 +1990,9 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  	if (fd.streamon(out.g_type()))
>  		goto done;
>  
> -	if (capture_setup(fd, in))
> -		goto done;
> +	if (codec_type != DECODER)
> +		if (capture_setup(fd, in))
> +			goto done;
>  
>  	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
>  	fps_ts[OUT].determine_field(fd.g_fd(), out.g_type());
> @@ -1999,12 +2039,25 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  			struct v4l2_event ev;
>  
>  			while (!fd.dqevent(ev)) {
> -				if (ev.type != V4L2_EVENT_EOS)
> -					continue;
> -				wr_fds = NULL;
> -				fprintf(stderr, "EOS");
> -				fflush(stderr);
> -				break;
> +				if (ev.type == V4L2_EVENT_EOS) {
> +					wr_fds = NULL;
> +					fprintf(stderr, "EOS");
> +					fflush(stderr);
> +				} else if (ev.type == V4L2_EVENT_SOURCE_CHANGE) {
> +					fprintf(stderr, "SOURCE CHANGE\n");
> +
> +					/*
> +					 * if capture is already streaming,
> +					 * wait to the a capture buffer with
> +					 * LAST_BUFFER flag
> +					 */
> +					if (cap_streaming) {
> +						in_source_change_event = true;
> +						continue;
> +					}
> +					if (capture_setup(fd, in))
> +						goto done;

I would change this to:

					in_source_change_event = true;
					if (!cap_streaming)
						last_buffer = true;

This simplifies the code since you don't have to call capture_setup
here anymore.

> +				}
>  			}
>  		}
>  
> @@ -2018,8 +2071,17 @@ static void streaming_set_m2m(cv4l_fd &fd)
>  					break;
>  				}
>  			}
> -			if (last_buffer)
> -				break;

Keep this...

> +			if (last_buffer) {
> +				if (in_source_change_event) {
> +					in_source_change_event = false;
> +					last_buffer = false;
> +					if (capture_setup(fd, in))
> +						goto done;
> +					cap_streaming = true;
> +				} else {
> +					break;
> +				}
> +			}

...and move this to just before the end of the 'while (rd_fds || wr_fds || ex_fds)' loop.

That avoids the need for patch 3/6, unless I missed something.

>  		}
>  
>  		if (wr_fds && FD_ISSET(fd.g_fd(), wr_fds)) {
> 

Regards,

	Hans
