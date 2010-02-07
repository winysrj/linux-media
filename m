Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:55706 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904Ab0BGPPJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 10:15:09 -0500
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux
 filter
From: Andy Walls <awalls@radix.net>
To: Francesco Lavra <francescolavra@interfree.it>
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Chicken Shack <chicken.shack@gmx.de>,
	hermann pitton <hermann-pitton@arcor.de>, obi@linuxtv.org,
	linux-media@vger.kernel.org
In-Reply-To: <1265546998.9356.4.camel@localhost>
References: <1265546998.9356.4.camel@localhost>
Content-Type: text/plain
Date: Sun, 07 Feb 2010 10:13:52 -0500
Message-Id: <1265555632.3063.42.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-02-07 at 13:49 +0100, Francesco Lavra wrote:
> A DVB demultiplexer device can be used to set up either a PES filter or
> a section filter. In the former case, the ts field of the feed union of
> struct dmxdev_filter is used, in the latter case the sec field of the
> same union is used.
> The ts field is a struct list_head, and is currently initialized in the
> open() method of the demux device. When for a given demuxer a section
> filter is set up, the sec field is played with, thus if a PES filter
> needs to be set up after that the ts field will be corrupted, causing a
> kernel oops.
> This fix moves the list head initialization to
> dvb_dmxdev_pes_filter_set(), so that the ts field is properly
> initialized every time a PES filter is set up.
> 
> Signed-off-by: Francesco Lavra <francescolavra@interfree.it>
> Cc: stable <stable@kernel.org>


Reviewed-by: Andy Walls <awalls@radix.net>

This certainly helps.

It catches the case of setting a Section filter with DMX_SET_FILTER and
then a PES filter with DMX_SET_PES_FILTER on the same file descriptor.
This is exactly what alevt does.  See vbi.c:vbi_dvb_open() and
vbi.c:dvb_get_table() in the alevt source code.


Regards,
Andy

> ---
> 
> --- a/drivers/media/dvb/dvb-core/dmxdev.c	2010-02-07 13:19:18.000000000 +0100
> +++ b/drivers/media/dvb/dvb-core/dmxdev.c	2010-02-07 13:23:39.000000000 +0100
> @@ -761,7 +761,6 @@ static int dvb_demux_open(struct inode *
>  	dvb_ringbuffer_init(&dmxdevfilter->buffer, NULL, 8192);
>  	dmxdevfilter->type = DMXDEV_TYPE_NONE;
>  	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_ALLOCATED);
> -	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
>  	init_timer(&dmxdevfilter->timer);
>  
>  	dvbdev->users++;
> @@ -887,6 +886,7 @@ static int dvb_dmxdev_pes_filter_set(str
>  	dmxdevfilter->type = DMXDEV_TYPE_PES;
>  	memcpy(&dmxdevfilter->params, params,
>  	       sizeof(struct dmx_pes_filter_params));
> +	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
>  
>  	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_SET);
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

