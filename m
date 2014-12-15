Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47429 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaLOUIF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 15:08:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH v3 1/3] yavta: Implement data_offset support for multi plane buffers
Date: Mon, 15 Dec 2014 22:08:06 +0200
Message-ID: <1740776.Ehot8Atsrx@avalon>
In-Reply-To: <1418673520-31439-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1418673520-31439-1-git-send-email-sakari.ailus@linux.intel.com> <1418673520-31439-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 15 December 2014 21:58:38 Sakari Ailus wrote:
> Support data_offset for multi plane buffers. Also add an option to write the
> data in the buffer before data offset (--buffer-prefix).
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  yavta.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index 77e5a41..cf8239b 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -80,6 +80,8 @@ struct device
> 
>  	void *pattern[VIDEO_MAX_PLANES];
>  	unsigned int patternsize[VIDEO_MAX_PLANES];
> +
> +	bool write_buffer_prefix;
>  };
> 
>  static bool video_is_mplane(struct device *dev)
> @@ -1545,14 +1547,21 @@ static void video_save_image(struct device *dev,
> struct v4l2_buffer *buf, return;
> 
>  	for (i = 0; i < dev->num_planes; i++) {
> +		void *data = dev->buffers[buf->index].mem[i];
>  		unsigned int length;
> 
> -		if (video_is_mplane(dev))
> +		if (video_is_mplane(dev)) {
>  			length = buf->m.planes[i].bytesused;
> -		else
> +
> +			if (!dev->write_buffer_prefix) {
> +				data += buf->m.planes[i].data_offset;
> +				length -= buf->m.planes[i].data_offset;
> +			}
> +		} else {
>  			length = buf->bytesused;
> +		}
> 
> -		ret = write(fd, dev->buffers[buf->index].mem[i], length);
> +		ret = write(fd, data, length);
>  		if (ret < 0) {
>  			printf("write error: %s (%d)\n", strerror(errno), errno);
>  			break;
> @@ -1717,6 +1726,7 @@ static void usage(const char *argv0)
>  	printf("-t, --time-per-frame num/denom	Set the time per frame (eg. 1/25 
=
> 25 fps)\n"); printf("-u, --userptr			Use the user pointers streaming
> method\n"); printf("-w, --set-control 'ctrl value'	Set control 'ctrl' to
> 'value'\n"); +	printf("    --buffer-prefix		Write portions of buffer 
before
> data_offset\n"); printf("    --buffer-size		Buffer size in bytes\n");
>  	printf("    --enum-formats		Enumerate formats\n");
>  	printf("    --enum-inputs		Enumerate inputs\n");
> @@ -1749,10 +1759,12 @@ static void usage(const char *argv0)
>  #define OPT_BUFFER_SIZE		268
>  #define OPT_PREMULTIPLIED	269
>  #define OPT_QUEUE_LATE		270
> +#define OPT_BUFFER_PREFIX	271
> 
>  static struct option opts[] = {
>  	{"buffer-size", 1, 0, OPT_BUFFER_SIZE},
>  	{"buffer-type", 1, 0, 'B'},
> +	{"buffer-prefix", 1, 0, OPT_BUFFER_PREFIX},
>  	{"capture", 2, 0, 'c'},
>  	{"check-overrun", 0, 0, 'C'},
>  	{"delay", 1, 0, 'd'},
> @@ -2016,6 +2028,8 @@ int main(int argc, char *argv[])
>  		case OPT_USERPTR_OFFSET:
>  			userptr_offset = atoi(optarg);
>  			break;
> +		case OPT_BUFFER_PREFIX:
> +			dev.write_buffer_prefix = true;
>  		default:
>  			printf("Invalid option -%c\n", c);
>  			printf("Run %s -h for help.\n", argv[0]);

-- 
Regards,

Laurent Pinchart

