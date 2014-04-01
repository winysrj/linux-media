Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38084 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaDAWSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 18:18:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 6/9] Timestamp source for output buffers
Date: Wed, 02 Apr 2014 00:20:18 +0200
Message-ID: <24499912.nkDMIsTe95@avalon>
In-Reply-To: <1393690690-5004-7-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <1393690690-5004-7-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 01 March 2014 18:18:07 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  yavta.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/yavta.c b/yavta.c
> index a9b192a..71c1477 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -73,6 +73,7 @@ struct device
>  	unsigned int height;
>  	unsigned int bytesperline;
>  	unsigned int imagesize;
> +	uint32_t buffer_output_flags;
> 
>  	void *pattern;
>  	unsigned int patternsize;
> @@ -611,6 +612,7 @@ static int video_queue_buffer(struct device *dev, int
> index, enum buffer_fill_mo buf.m.userptr = (unsigned
> long)dev->buffers[index].mem;
> 
>  	if (dev->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		buf.flags = dev->buffer_output_flags;
>  		buf.bytesused = dev->patternsize;
>  		memcpy(dev->buffers[buf.index].mem, dev->pattern, dev->patternsize);
>  	} else {
> @@ -1255,6 +1257,7 @@ static void usage(const char *argv0)
>  	printf("    --no-query			Don't query capabilities on open\n");
>  	printf("    --offset			User pointer buffer offset from page
> start\n");
>  	printf("    --requeue-last		Requeue the last buffers before
> streamoff\n");
> +	printf("    --timestamp-source		Set timestamp source on output
> buffers [eof, soe]\n");
>  	printf("    --skip n			Skip the first n frames\n");
>  	printf("    --sleep-forever		Sleep forever after configuring the
> device\n"); printf("    --stride value		Line stride in bytes\n");
> @@ -1269,6 +1272,7 @@ static void usage(const char *argv0)
>  #define OPT_REQUEUE_LAST	262
>  #define OPT_STRIDE		263
>  #define OPT_FD			264
> +#define OPT_TSTAMP_SRC		265
> 
>  static struct option opts[] = {
>  	{"capture", 2, 0, 'c'},
> @@ -1298,7 +1302,8 @@ static struct option opts[] = {
>  	{"sleep-forever", 0, 0, OPT_SLEEP_FOREVER},
>  	{"stride", 1, 0, OPT_STRIDE},
>  	{"time-per-frame", 1, 0, 't'},
> -	{"userptr", 0, 0, 'u'},
> +	{"timestamp-source", 1, 0, OPT_TSTAMP_SRC},
> +	{"userptr", 1, 0, 'u'},

This seems to be an unrelated change.

>  	{0, 0, 0, 0}
>  };
> 
> @@ -1487,6 +1492,17 @@ int main(int argc, char *argv[])
>  		case OPT_STRIDE:
>  			stride = atoi(optarg);
>  			break;
> +		case OPT_TSTAMP_SRC:
> +			if (!strcmp(optarg, "eof")) {
> +				dev.buffer_output_flags |= V4L2_BUF_FLAG_TSTAMP_SRC_EOF;

As the buffer_output_flags isn't used for anything else, would it make sense 
to just name it timestamp_source ?

> +			} else if (!strcmp(optarg, "soe")) {
> +				dev.buffer_output_flags |= V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
> +			} else {
> +				printf("Invalid timestamp source %s\n", optarg);
> +				return 1;
> +			}
> +			printf("Using %s timestamp source\n", optarg);

Do we really need this printf ?

> +			break;
>  		case OPT_USERPTR_OFFSET:
>  			userptr_offset = atoi(optarg);
>  			break;

-- 
Regards,

Laurent Pinchart

