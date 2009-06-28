Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49499 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbZF1RRf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 13:17:35 -0400
Subject: Re: [PATCH 22/62] drivers/media/video/cx18/cx18-fileops.c: Remove
 unnecessary semicolons
From: Andy Walls <awalls@radix.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <7eeefbbba34fc477540566c6b1888cb7c871f4cd.1246173681.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	 <7eeefbbba34fc477540566c6b1888cb7c871f4cd.1246173681.git.joe@perches.com>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 13:17:40 -0400
Message-Id: <1246209460.1550.12.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-06-28 at 09:26 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/video/cx18/cx18-fileops.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-fileops.c b/drivers/media/video/cx18/cx18-fileops.c
> index 29969c1..04d9c25 100644
> --- a/drivers/media/video/cx18/cx18-fileops.c
> +++ b/drivers/media/video/cx18/cx18-fileops.c
> @@ -690,7 +690,7 @@ int cx18_v4l2_open(struct file *filp)
>  	int res;
>  	struct video_device *video_dev = video_devdata(filp);
>  	struct cx18_stream *s = video_get_drvdata(video_dev);
> -	struct cx18 *cx = s->cx;;
> +	struct cx18 *cx = s->cx;
>  
>  	mutex_lock(&cx->serialize_lock);
>  	if (cx18_init_on_first_open(cx)) {

Acked-by: Andy Walls <awalls@radix.net>

This is on topic for the ivtv-devel list, but must we spam the
ivtv-users list with this sort of trivia? 

Perhaps your Maintainers file scraper script could be tweaked a little?

Regards,
Andy

