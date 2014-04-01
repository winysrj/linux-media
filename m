Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38068 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaDAWPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 18:15:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 5/9] Allow passing file descriptors to yavta
Date: Wed, 02 Apr 2014 00:16:57 +0200
Message-ID: <349099482.s11F5mBja6@avalon>
In-Reply-To: <1393690690-5004-6-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi> <1393690690-5004-6-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 01 March 2014 18:18:06 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  yavta.c |   63 ++++++++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 43 insertions(+), 20 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index 870682e..a9b192a 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -62,6 +62,7 @@ struct buffer
>  struct device
>  {
>  	int fd;
> +	int opened;
> 
>  	enum v4l2_buf_type type;
>  	enum v4l2_memory memtype;
> @@ -180,13 +181,8 @@ static unsigned int v4l2_format_code(const char *name)
>  	return 0;
>  }
> 
> -static int video_open(struct device *dev, const char *devname, int
> no_query)
> +static int video_open(struct device *dev, const char *devname)
>  {
> -	dev->fd = -1;
> -	dev->memtype = V4L2_MEMORY_MMAP;
> -	dev->buffers = NULL;
> -	dev->type = (enum v4l2_buf_type)-1;
> -
>  	dev->fd = open(devname, O_RDWR);
>  	if (dev->fd < 0) {
>  		printf("Error opening device %s: %s (%d).\n", devname,
> @@ -196,6 +192,16 @@ static int video_open(struct device *dev, const char
> *devname, int no_query)
> 
>  	printf("Device %s opened.\n", devname);
> 
> +	dev->opened = 1;
> +
> +	return 0;
> +}
> +
> +static int video_querycap(struct device *dev, int no_query) {
> +	struct v4l2_capability cap;
> +	unsigned int capabilities;
> +	int ret;
> +

video_querycap ends up setting the dev->type field, which isn't really the job 
of a query function. Would there be a clean way to pass the fd to the 
video_open() function instead ? Maybe video_open() could be split and/or 
renamed to video_init() ?

>  	if (no_query) {
>  		/* Assume capture device. */
>  		dev->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> @@ -215,9 +221,7 @@ static int video_open(struct device *dev, const char
> *devname, int no_query) else if (capabilities & V4L2_CAP_VIDEO_OUTPUT)
>  		dev->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>  	else {
> -		printf("Error opening device %s: neither video capture "
> -			"nor video output supported.\n", devname);
> -		close(dev->fd);
> +		printf("Device supports neither capture nor output.\n");
>  		return -EINVAL;
>  	}
> 
> @@ -231,7 +235,8 @@ static void video_close(struct device *dev)
>  {
>  	free(dev->pattern);
>  	free(dev->buffers);
> -	close(dev->fd);
> +	if (dev->opened)
> +		close(dev->fd);
>  }
> 
>  static unsigned int get_control_type(struct device *dev, unsigned int id)
> @@ -1246,6 +1251,7 @@ static void usage(const char *argv0)
>  	printf("-w, --set-control 'ctrl value'	Set control 'ctrl' to 
'value'\n");
>  	printf("    --enum-formats		Enumerate formats\n");
>  	printf("    --enum-inputs		Enumerate inputs\n");
> +	printf("    --fd                        Use a numeric file descriptor
> insted of a device\n");
>  	printf("    --no-query			Don't query capabilities on open\n");
>  	printf("    --offset			User pointer buffer offset from page
> start\n");
>  	printf("    --requeue-last		Requeue the last buffers before
> streamoff\n");
> @@ -1262,6 +1268,7 @@ static void usage(const char *argv0)
>  #define OPT_USERPTR_OFFSET	261
>  #define OPT_REQUEUE_LAST	262
>  #define OPT_STRIDE		263
> +#define OPT_FD			264
> 
>  static struct option opts[] = {
>  	{"capture", 2, 0, 'c'},
> @@ -1269,6 +1276,7 @@ static struct option opts[] = {
>  	{"delay", 1, 0, 'd'},
>  	{"enum-formats", 0, 0, OPT_ENUM_FORMATS},
>  	{"enum-inputs", 0, 0, OPT_ENUM_INPUTS},
> +	{"fd", 1, 0, OPT_FD},
>  	{"file", 2, 0, 'F'},
>  	{"fill-frames", 0, 0, 'I'},
>  	{"format", 1, 0, 'f'},
> @@ -1297,7 +1305,11 @@ static struct option opts[] = {
>  int main(int argc, char *argv[])
>  {
>  	struct sched_param sched;
> -	struct device dev = { 0 };
> +	struct device dev = {
> +		.fd = -1,
> +		.memtype = V4L2_MEMORY_MMAP,
> +		.type = (enum v4l2_buf_type)-1,
> +	};
>  	int ret;
> 
>  	/* Options parsings */
> @@ -1452,6 +1464,14 @@ int main(int argc, char *argv[])
>  		case OPT_ENUM_INPUTS:
>  			do_enum_inputs = 1;
>  			break;
> +		case OPT_FD:
> +			dev.fd = atoi(optarg);
> +			if (dev.fd < 0) {
> +				printf("Bad file descriptor %d\n", dev.fd);
> +				return 1;
> +			}
> +			printf("Using file descriptor %d\n", dev.fd);
> +			break;
>  		case OPT_NO_QUERY:
>  			no_query = 1;
>  			break;
> @@ -1482,18 +1502,21 @@ int main(int argc, char *argv[])
>  		return 1;
>  	}
> 
> -	if (optind >= argc) {
> -		usage(argv[0]);
> -		return 1;
> -	}
> -
>  	if (!do_file)
>  		filename = NULL;
> 
> -	/* Open the video device. If the device type isn't recognized, set the
> -	 * --no-query option to avoid querying V4L2 subdevs.
> -	 */
> -	ret = video_open(&dev, argv[optind], no_query);
> +	if (dev.fd == -1) {
> +		if (optind >= argc) {
> +			usage(argv[0]);
> +			return 1;
> +		} else {
> +			ret = video_open(&dev, argv[optind]);
> +			if (ret < 0)
> +				return 1;
> +		}
> +	}
> +
> +	ret = video_querycap(&dev, no_query);
>  	if (ret < 0)
>  		return 1;

-- 
Regards,

Laurent Pinchart

