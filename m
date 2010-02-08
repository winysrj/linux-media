Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab0BHCMA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 21:12:00 -0500
Message-ID: <4B6F72E5.3040905@redhat.com>
Date: Mon, 08 Feb 2010 00:11:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Francesco Lavra <francescolavra@interfree.it>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb-core: fix initialization of feeds list in demux filter
References: <1265546998.9356.4.camel@localhost>
In-Reply-To: <1265546998.9356.4.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Francesco Lavra wrote:
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

Good catch, but it seems better to initialize both the mutex and the list head
at dvb_dmx_dev_init. Please test if the following patch fixes the issue. If so, please
sign.

Cheers,
Mauro

diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index c37790a..be9bef1 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -755,13 +755,11 @@ static int dvb_demux_open(struct inode *inode, struct file *file)
 	}
 
 	dmxdevfilter = &dmxdev->filter[i];
-	mutex_init(&dmxdevfilter->mutex);
 	file->private_data = dmxdevfilter;
 
 	dvb_ringbuffer_init(&dmxdevfilter->buffer, NULL, 8192);
 	dmxdevfilter->type = DMXDEV_TYPE_NONE;
 	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_ALLOCATED);
-	INIT_LIST_HEAD(&dmxdevfilter->feed.ts);
 	init_timer(&dmxdevfilter->timer);
 
 	dvbdev->users++;
@@ -1239,6 +1237,8 @@ int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 		dmxdev->filter[i].buffer.data = NULL;
 		dvb_dmxdev_filter_state_set(&dmxdev->filter[i],
 					    DMXDEV_STATE_FREE);
+		mutex_init(&dmxdev->filter[i].mutex);
+		INIT_LIST_HEAD(&dmxdev->filter[i].feed.ts);
 	}
 
 	dvb_register_device(dvb_adapter, &dmxdev->dvbdev, &dvbdev_demux, dmxdev,



Cheers,
Mauro
