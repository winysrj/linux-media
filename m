Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38007 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaDAWDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 18:03:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 3/9] Allow supporting mem2mem devices by adding forced OUTPUT device type
Date: Wed, 02 Apr 2014 00:05:47 +0200
Message-ID: <1418044.66HOjVbqSU@avalon>
In-Reply-To: <1393690690-5004-4-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <1393690690-5004-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 01 March 2014 18:18:04 Sakari Ailus wrote:
> The option is --output, or -o.

Wouldn't it make sense to have an option to force the device type to a user-
specified value instead of just an option for the output type ? "-o" is also 
usually used to select an output file, I'd like to keep it for that.

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  yavta.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/yavta.c b/yavta.c
> index 8e43ce5..e010252 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -1240,6 +1240,7 @@ static void usage(const char *argv0)
>  	printf("-I, --fill-frames		Fill frames with check pattern before 
queuing
> them\n"); printf("-l, --list-controls		List available controls\n");
>  	printf("-n, --nbufs n			Set the number of video buffers\n");
> +	printf("-o, --output			Use video node as output\n");
>  	printf("-p, --pause			Pause before starting the video 
stream\n");
>  	printf("-q, --quality n			MJPEG quality (0-100)\n");
>  	printf("-r, --get-control ctrl		Get control 'ctrl'\n");
> @@ -1282,6 +1283,7 @@ static struct option opts[] = {
>  	{"nbufs", 1, 0, 'n'},
>  	{"no-query", 0, 0, OPT_NO_QUERY},
>  	{"offset", 1, 0, OPT_USERPTR_OFFSET},
> +	{"output", 0, 0, 'o'},
>  	{"pause", 0, 0, 'p'},
>  	{"quality", 1, 0, 'q'},
>  	{"get-control", 1, 0, 'r'},
> @@ -1304,7 +1306,7 @@ int main(int argc, char *argv[])
>  	int ret;
> 
>  	/* Options parsings */
> -	int do_file = 0, do_capture = 0, do_pause = 0;
> +	int do_file = 0, do_capture = 0, do_pause = 0, do_output = 0;
>  	int do_set_time_per_frame = 0;
>  	int do_enum_formats = 0, do_set_format = 0;
>  	int do_enum_inputs = 0, do_set_input = 0;
> @@ -1385,6 +1387,9 @@ int main(int argc, char *argv[])
>  			if (nbufs > V4L_BUFFERS_MAX)
>  				nbufs = V4L_BUFFERS_MAX;
>  			break;
> +		case 'o':
> +			do_output = 1;
> +			break;
>  		case 'p':
>  			do_pause = 1;
>  			break;
> @@ -1500,6 +1505,9 @@ int main(int argc, char *argv[])
>  	if (dev.type == (enum v4l2_buf_type)-1)
>  		no_query = 1;
> 
> +	if (do_output)
> +		dev.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +
>  	dev.memtype = memtype;
> 
>  	if (do_get_control) {

-- 
Regards,

Laurent Pinchart

