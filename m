Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49578 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754595Ab0BAPCO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 10:02:14 -0500
Subject: Re: [PATCH] Fix the risk of an oops at dvb_dmx_release
From: Chicken Shack <chicken.shack@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4B66D89A.2030207@redhat.com>
References: <4B66D89A.2030207@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 16:00:36 +0100
Message-ID: <1265036436.1727.11.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 01.02.2010, 11:35 -0200 schrieb Mauro Carvalho Chehab:
> dvb_dmx_init tries to allocate virtual memory for 2 pointers: filter and feed.
> 
> If the second vmalloc fails, filter is freed, but the pointer keeps pointing
> to the old place. Later, when dvb_dmx_release() is called, it will try to
> free an already freed memory, causing an OOPS.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
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

Hi Mauro,

I tested this one.
It does not help the problem with alevt-dvb described by me, but the
horrible crash behaviour where nothing goes without hard reset after the
second start of alevt-dvb is gone. One step - well done!

Can you explain in some words what specific problems the other patch
resolves?

Thanks

CS


