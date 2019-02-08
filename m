Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DDCC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 21:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8984420855
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 21:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfBHVMc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 16:12:32 -0500
Received: from gofer.mess.org ([88.97.38.141]:60581 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfBHVMc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 16:12:32 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 22C42601F7; Fri,  8 Feb 2019 21:12:31 +0000 (GMT)
Date:   Fri, 8 Feb 2019 21:12:30 +0000
From:   Sean Young <sean@mess.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [RFC PATCH 8/8] dvb-core: fix epoll() by calling poll_wait first
Message-ID: <20190208211230.xznkkm7ucw7jn3h4@gofer.mess.org>
References: <20190207114948.37750-1-hverkuil-cisco@xs4all.nl>
 <20190207114948.37750-9-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207114948.37750-9-hverkuil-cisco@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 07, 2019 at 12:49:48PM +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> The epoll function expects that whenever the poll file op is
> called, the poll_wait function is also called. That didn't
> always happen in dvb_demux_poll(), dvb_dvr_poll() and
> dvb_ca_en50221_io_poll(). Fix this, otherwise epoll()
> can timeout when it shouldn't.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Sean Young <sean@mess.org>

> ---
>  drivers/media/dvb-core/dmxdev.c         | 8 ++++----
>  drivers/media/dvb-core/dvb_ca_en50221.c | 5 ++---
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index 1544e8cef564..f14a872d1268 100644
> --- a/drivers/media/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb-core/dmxdev.c
> @@ -1195,13 +1195,13 @@ static __poll_t dvb_demux_poll(struct file *file, poll_table *wait)
>  	struct dmxdev_filter *dmxdevfilter = file->private_data;
>  	__poll_t mask = 0;
>  
> +	poll_wait(file, &dmxdevfilter->buffer.queue, wait);
> +
>  	if ((!dmxdevfilter) || dmxdevfilter->dev->exit)
>  		return EPOLLERR;
>  	if (dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx))
>  		return dvb_vb2_poll(&dmxdevfilter->vb2_ctx, file, wait);
>  
> -	poll_wait(file, &dmxdevfilter->buffer.queue, wait);
> -
>  	if (dmxdevfilter->state != DMXDEV_STATE_GO &&
>  	    dmxdevfilter->state != DMXDEV_STATE_DONE &&
>  	    dmxdevfilter->state != DMXDEV_STATE_TIMEDOUT)
> @@ -1346,13 +1346,13 @@ static __poll_t dvb_dvr_poll(struct file *file, poll_table *wait)
>  
>  	dprintk("%s\n", __func__);
>  
> +	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
> +
>  	if (dmxdev->exit)
>  		return EPOLLERR;
>  	if (dvb_vb2_is_streaming(&dmxdev->dvr_vb2_ctx))
>  		return dvb_vb2_poll(&dmxdev->dvr_vb2_ctx, file, wait);
>  
> -	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
> -
>  	if (((file->f_flags & O_ACCMODE) == O_RDONLY) ||
>  	    dmxdev->may_do_mmap) {
>  		if (dmxdev->dvr_buffer.error)
> diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
> index 4d371cea0d5d..ebf1e3b03819 100644
> --- a/drivers/media/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb-core/dvb_ca_en50221.c
> @@ -1797,6 +1797,8 @@ static __poll_t dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
>  
>  	dprintk("%s\n", __func__);
>  
> +	poll_wait(file, &ca->wait_queue, wait);
> +
>  	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1)
>  		mask |= EPOLLIN;
>  
> @@ -1804,9 +1806,6 @@ static __poll_t dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
>  	if (mask)
>  		return mask;
>  
> -	/* wait for something to happen */
> -	poll_wait(file, &ca->wait_queue, wait);
> -
>  	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1)
>  		mask |= EPOLLIN;
>  
> -- 
> 2.20.1
