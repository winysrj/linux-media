Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E79C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 20:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 056012177B
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 20:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfBHUxQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 15:53:16 -0500
Received: from gofer.mess.org ([88.97.38.141]:55769 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfBHUxQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 15:53:16 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 4C1CA601F7; Fri,  8 Feb 2019 20:53:14 +0000 (GMT)
Date:   Fri, 8 Feb 2019 20:53:13 +0000
From:   Sean Young <sean@mess.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [RFC PATCH 1/8] cec: fix epoll() by calling poll_wait first
Message-ID: <20190208205313.npn4plvylh34zmdg@gofer.mess.org>
References: <20190207114948.37750-1-hverkuil-cisco@xs4all.nl>
 <20190207114948.37750-2-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207114948.37750-2-hverkuil-cisco@xs4all.nl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 07, 2019 at 12:49:41PM +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> The epoll function expects that whenever the poll file op is
> called, the poll_wait function is also called. That didn't
> always happen in cec_poll(). Fix this, otherwise epoll()
> would timeout when it shouldn't.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/cec/cec-api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
> index 391b6fd483e1..156a0d76ab2a 100644
> --- a/drivers/media/cec/cec-api.c
> +++ b/drivers/media/cec/cec-api.c
> @@ -38,6 +38,7 @@ static __poll_t cec_poll(struct file *filp,
>  	struct cec_adapter *adap = fh->adap;
>  	__poll_t res = 0;
>  
> +	poll_wait(filp, &fh->wait, poll);
>  	if (!cec_is_registered(adap))
>  		return EPOLLERR | EPOLLHUP;
>  	mutex_lock(&adap->lock);
> @@ -48,7 +49,6 @@ static __poll_t cec_poll(struct file *filp,
>  		res |= EPOLLIN | EPOLLRDNORM;
>  	if (fh->total_queued_events)
>  		res |= EPOLLPRI;
> -	poll_wait(filp, &fh->wait, poll);
>  	mutex_unlock(&adap->lock);
>  	return res;
>  }
> -- 
> 2.20.1

Reviewed-by: Sean Young <sean@mess.org>


Sean
