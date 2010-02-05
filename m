Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57345 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933679Ab0BECq0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 21:46:26 -0500
Subject: Re: [PATCH] Fix the risk of an oops at dvb_dmx_release
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4B66D89A.2030207@redhat.com>
References: <4B66D89A.2030207@redhat.com>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 21:46:01 -0500
Message-Id: <1265337962.7784.1.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-02-01 at 11:35 -0200, Mauro Carvalho Chehab wrote:
> dvb_dmx_init tries to allocate virtual memory for 2 pointers: filter and feed.
> 
> If the second vmalloc fails, filter is freed, but the pointer keeps pointing
> to the old place. Later, when dvb_dmx_release() is called, it will try to
> free an already freed memory, causing an OOPS.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Looks good.

Reviewed-by: Andy Walls <awalls@radix.net>

> ---
>  drivers/media/dvb/dvb-core/dvb_demux.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
> index b78cfb7..a78408e 100644
> --- a/drivers/media/dvb/dvb-core/dvb_demux.c
> +++ b/drivers/media/dvb/dvb-core/dvb_demux.c
> @@ -1246,6 +1246,7 @@ int dvb_dmx_init(struct dvb_demux *dvbdemux)
>  	dvbdemux->feed = vmalloc(dvbdemux->feednum * sizeof(struct dvb_demux_feed));
>  	if (!dvbdemux->feed) {
>  		vfree(dvbdemux->filter);
> +		dvbdemux->filter = NULL;
>  		return -ENOMEM;
>  	}
>  	for (i = 0; i < dvbdemux->filternum; i++) {

