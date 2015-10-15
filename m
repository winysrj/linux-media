Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60451 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbJOXfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 19:35:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 1/1] List supported formats with -f help
Date: Fri, 16 Oct 2015 02:35:20 +0300
Message-ID: <3000041.A8eUVloPiB@avalon>
In-Reply-To: <1441887560-21768-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441887560-21768-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 10 September 2015 15:19:20 Sakari Ailus wrote:
> Passing format "help" to the -f option will list the supported formats and
> exit.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Applied, thank you.

> ---
>  yavta.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/yavta.c b/yavta.c
> index 7d8ac8e..b627725 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -215,6 +215,20 @@ static struct v4l2_format_info {
>  	{ "MPEG", V4L2_PIX_FMT_MPEG, 1 },
>  };
> 
> +static void list_formats(void)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(pixel_formats); i++)
> +		printf("%s (\"%c%c%c%c\", %u planes)\n",
> +		       pixel_formats[i].name,
> +		       pixel_formats[i].fourcc & 0xff,
> +		       (pixel_formats[i].fourcc >> 8) & 0xff,
> +		       (pixel_formats[i].fourcc >> 16) & 0xff,
> +		       (pixel_formats[i].fourcc >> 24) & 0xff,
> +		       pixel_formats[i].n_planes);
> +}
> +
>  static const struct v4l2_format_info *v4l2_format_by_fourcc(unsigned int
> fourcc) {
>  	unsigned int i;
> @@ -1734,6 +1748,7 @@ static void usage(const char *argv0)
>  	printf("-C, --check-overrun		Verify dequeued frames for buffer
> overrun\n"); printf("-d, --delay			Delay (in ms) before requeuing
> buffers\n"); printf("-f, --format format		Set the video format\n");
> +	printf("				use -f help to list the supported formats\n");
>  	printf("-F, --file[=name]		Read/write frames from/to disk\n");
>  	printf("\tFor video capture devices, the first '#' character in the file
> name is\n"); printf("\texpanded to the frame sequence number. The default
> file name is\n"); @@ -1899,6 +1914,10 @@ int main(int argc, char *argv[])
>  			delay = atoi(optarg);
>  			break;
>  		case 'f':
> +			if (!strcmp("help", optarg)) {
> +				list_formats();
> +				return 0;
> +			}
>  			do_set_format = 1;
>  			info = v4l2_format_by_name(optarg);
>  			if (info == NULL) {

-- 
Regards,

Laurent Pinchart

