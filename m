Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2152 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934062Ab3DJGis (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 02:38:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Tzu-Jung Lee" <roylee17@gmail.com>
Subject: Re: [PATCH 1/2] v4l2-ctl: break down the streaming_set()
Date: Wed, 10 Apr 2013 08:38:30 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	k.debski@samsung.com, "Tzu-Jung Lee" <tjlee@ambarella.com>
References: <1365572135-2311-1-git-send-email-tjlee@ambarella.com>
In-Reply-To: <1365572135-2311-1-git-send-email-tjlee@ambarella.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304100838.30260.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed April 10 2013 07:35:34 Tzu-Jung Lee wrote:
> This patch breaks down the streaming_set() into smaller
> ones, which can be resued for supporting m2m devices.
> 
> Further cleanup or consolidation can be applied with
> separate patches, since this one tries not to modify
> logics.
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 888 ++++++++++++++++++----------------
>  1 file changed, 480 insertions(+), 408 deletions(-)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index c29565f..f8e782d 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -27,7 +27,8 @@ static unsigned stream_skip;
>  static unsigned stream_pat;
>  static bool stream_loop;
>  static unsigned reqbufs_count = 3;
> -static char *file;
> +static char *file_cap;
> +static char *file_out;
>  
>  #define NUM_PATTERNS (4)
>  
> @@ -198,12 +199,12 @@ void streaming_cmd(int ch, char *optarg)
>  		stream_pat %= NUM_PATTERNS;
>  		break;
>  	case OptStreamTo:
> -		file = optarg;
> -		if (!strcmp(file, "-"))
> +		file_cap = optarg;
> +		if (!strcmp(file_cap, "-"))
>  			options[OptSilent] = true;
>  		break;
>  	case OptStreamFrom:
> -		file = optarg;
> +		file_out = optarg;
>  		break;
>  	case OptStreamMmap:
>  	case OptStreamUser:
> @@ -526,475 +527,546 @@ static bool fill_buffer_from_file(void *buffers[], unsigned buffer_lengths[],
>  	return true;
>  }
>  
> -void streaming_set(int fd)
> +static void do_setup_cap_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
> +				 bool is_mplane, unsigned num_planes, bool is_mmap,

num_planes should be a reference: 'unsigned &num_planes'. This function changes
num_planes and the caller needs that! Ditto for do_setup_out_buffers.

Regards,

	Hans
