Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36544 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbeK3KrX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 05:47:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 1/1] Zero dev in main()
Date: Fri, 30 Nov 2018 01:40:36 +0200
Message-ID: <140339834.WYT3G2bIM6@avalon>
In-Reply-To: <20181122152956.23649-1-sakari.ailus@linux.intel.com>
References: <20181122152956.23649-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday, 22 November 2018 17:29:56 EET Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> This is necessary since video_open() may not be always called soon

Do you mean video_init() ? Isn't it called at the very first line of main() ?

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  yavta.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index c7986bd..de5376d 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -342,7 +342,6 @@ static bool video_has_valid_buf_type(struct device *dev)
> 
>  static void video_init(struct device *dev)
>  {
> -	memset(dev, 0, sizeof *dev);
>  	dev->fd = -1;
>  	dev->memtype = V4L2_MEMORY_MMAP;
>  	dev->buffers = NULL;
> @@ -1903,7 +1902,7 @@ static struct option opts[] = {
>  int main(int argc, char *argv[])
>  {
>  	struct sched_param sched;
> -	struct device dev;
> +	struct device dev = { 0 };
>  	int ret;
> 
>  	/* Options parsings */

-- 
Regards,

Laurent Pinchart
