Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B08EAC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8750D205F4
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfCLPkp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:40:45 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42763 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfCLPko (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 11:40:44 -0400
X-Originating-IP: 90.88.22.102
Received: from aptenodytes (aaubervilliers-681-1-80-102.w90-88.abo.wanadoo.fr [90.88.22.102])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id DAF7AE0014;
        Tue, 12 Mar 2019 15:40:41 +0000 (UTC)
Message-ID: <06782938ee3f062c34c8b5daabcf6fb421f34453.camel@bootlin.com>
Subject: Re: [PATCH v5 06/23] media: v4l2-ctrl: v4l2_ctrl_request_setup
 returns with error upon failure
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Maxime Ripard <maxime.ripard@bootlin.com>
Date:   Tue, 12 Mar 2019 16:40:41 +0100
In-Reply-To: <20190306211343.15302-7-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
         <20190306211343.15302-7-dafna3@gmail.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dafna,

On Wed, 2019-03-06 at 13:13 -0800, Dafna Hirschfeld wrote:
> If one of the controls fails to set,
> then 'v4l2_ctrl_request_setup'
> immediately returns with the error code.

Very neat idea, the error should definitely be propagated!

We should update the cedrus driver to take this into account, marking
both src/dst buffers as error (as suggested by Hans on IRC).

> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 18 +++++++++++-------
>  include/media/v4l2-ctrls.h           |  2 +-
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b79d3bbd8350..54d66dbc2a31 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3899,18 +3899,19 @@ void v4l2_ctrl_request_complete(struct media_request *req,
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_request_complete);
>  
> -void v4l2_ctrl_request_setup(struct media_request *req,
> +int v4l2_ctrl_request_setup(struct media_request *req,
>  			     struct v4l2_ctrl_handler *main_hdl)
>  {
>  	struct media_request_object *obj;
>  	struct v4l2_ctrl_handler *hdl;
>  	struct v4l2_ctrl_ref *ref;
> +	int ret = 0;
>  
>  	if (!req || !main_hdl)
> -		return;
> +		return 0;
>  
>  	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
> -		return;
> +		return -EBUSY;
>  
>  	/*
>  	 * Note that it is valid if nothing was found. It means
> @@ -3919,10 +3920,10 @@ void v4l2_ctrl_request_setup(struct media_request *req,
>  	 */
>  	obj = media_request_object_find(req, &req_ops, main_hdl);
>  	if (!obj)
> -		return;
> +		return 0;
>  	if (obj->completed) {
>  		media_request_object_put(obj);
> -		return;
> +		return -EBUSY;
>  	}
>  	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
>  
> @@ -3990,12 +3991,15 @@ void v4l2_ctrl_request_setup(struct media_request *req,
>  				update_from_auto_cluster(master);
>  		}
>  
> -		try_or_set_cluster(NULL, master, true, 0);
> -
> +		ret = try_or_set_cluster(NULL, master, true, 0);
>  		v4l2_ctrl_unlock(master);
> +
> +		if (ret)
> +			break;
>  	}
>  
>  	media_request_object_put(obj);
> +	return ret;
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_request_setup);
>  
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index e5cae37ced2d..200f8a66ecaa 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -1127,7 +1127,7 @@ __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
>   * applying control values in a request is only applicable to memory-to-memory
>   * devices.
>   */
> -void v4l2_ctrl_request_setup(struct media_request *req,
> +int v4l2_ctrl_request_setup(struct media_request *req,
>  			     struct v4l2_ctrl_handler *parent);
>  
>  /**
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

