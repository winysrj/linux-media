Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D132C10F03
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 155F3214AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="oYRe2hNz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfCMLqF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:46:05 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51836 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfCMLqF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 07:46:05 -0400
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4285A5AA;
        Wed, 13 Mar 2019 12:46:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552477561;
        bh=sWStaSBf/gJk5mtdCar0wbZXukXK3kuUNZTDigYRzRE=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oYRe2hNzpDTnW27zTAH6aPpxOuViCGYGMXRqIoO4ZOjn9nbrEFy2uqbRfJyDKNFLj
         pJV0/ntyLbMOFgvJyNifj2/kZpZ0d4nljyf/SPF934lmitrezwHiEtp817utEK7446
         uHKMy5/iUoDpIjvTcrGuLte3HzqekkVdAsFmrftc=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v6 12/18] drm: writeback: Cleanup job ownership handling
 when queuing job
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-13-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <f452a3bb-2732-5dae-bf78-98a884bd54b0@ideasonboard.com>
Date:   Wed, 13 Mar 2019 11:45:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313000532.7087-13-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 13/03/2019 00:05, Laurent Pinchart wrote:
> The drm_writeback_queue_job() function takes ownership of the passed job
> and requires the caller to manually set the connector state
> writeback_job pointer to NULL. To simplify drivers and avoid errors
> (such as the missing NULL set in the vc4 driver), pass the connector
> state pointer to the function instead of the job pointer, and set the
> writeback_job pointer to NULL internally.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Reviewed-by: Brian Starkey <brian.starkey@arm.com>
> Acked-by: Eric Anholt <eric@anholt.net>
> Acked-by: Liviu Dudau <liviu.dudau@arm.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/gpu/drm/arm/malidp_mw.c |  3 +--
>  drivers/gpu/drm/drm_writeback.c | 15 ++++++++++-----
>  drivers/gpu/drm/vc4/vc4_txp.c   |  2 +-
>  include/drm/drm_writeback.h     |  2 +-
>  4 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
> index 041a64dc7167..87627219ce3b 100644
> --- a/drivers/gpu/drm/arm/malidp_mw.c
> +++ b/drivers/gpu/drm/arm/malidp_mw.c
> @@ -252,8 +252,7 @@ void malidp_mw_atomic_commit(struct drm_device *drm,
>  				     &mw_state->addrs[0],
>  				     mw_state->format);
>  
> -		drm_writeback_queue_job(mw_conn, conn_state->writeback_job);
> -		conn_state->writeback_job = NULL;
> +		drm_writeback_queue_job(mw_conn, conn_state);
>  		hwdev->hw->enable_memwrite(hwdev, mw_state->addrs,
>  					   mw_state->pitches, mw_state->n_planes,
>  					   fb->width, fb->height, mw_state->format,
> diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
> index c20e6fe00cb3..338b993d7c9f 100644
> --- a/drivers/gpu/drm/drm_writeback.c
> +++ b/drivers/gpu/drm/drm_writeback.c
> @@ -242,11 +242,12 @@ EXPORT_SYMBOL(drm_writeback_connector_init);
>  /**
>   * drm_writeback_queue_job - Queue a writeback job for later signalling
>   * @wb_connector: The writeback connector to queue a job on
> - * @job: The job to queue
> + * @conn_state: The connector state containing the job to queue
>   *
> - * This function adds a job to the job_queue for a writeback connector. It
> - * should be considered to take ownership of the writeback job, and so any other
> - * references to the job must be cleared after calling this function.
> + * This function adds the job contained in @conn_state to the job_queue for a
> + * writeback connector. It takes ownership of the writeback job and sets the
> + * @conn_state->writeback_job to NULL, and so no access to the job may be
> + * performed by the caller after this function returns.
>   *
>   * Drivers must ensure that for a given writeback connector, jobs are queued in
>   * exactly the same order as they will be completed by the hardware (and
> @@ -258,10 +259,14 @@ EXPORT_SYMBOL(drm_writeback_connector_init);
>   * See also: drm_writeback_signal_completion()
>   */
>  void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
> -			     struct drm_writeback_job *job)
> +			     struct drm_connector_state *conn_state)
>  {
> +	struct drm_writeback_job *job;
>  	unsigned long flags;
>  
> +	job = conn_state->writeback_job;
> +	conn_state->writeback_job = NULL;
> +
>  	spin_lock_irqsave(&wb_connector->job_lock, flags);
>  	list_add_tail(&job->list_entry, &wb_connector->job_queue);
>  	spin_unlock_irqrestore(&wb_connector->job_lock, flags);
> diff --git a/drivers/gpu/drm/vc4/vc4_txp.c b/drivers/gpu/drm/vc4/vc4_txp.c
> index aa279b5b0de7..5dabd91f2d7e 100644
> --- a/drivers/gpu/drm/vc4/vc4_txp.c
> +++ b/drivers/gpu/drm/vc4/vc4_txp.c
> @@ -327,7 +327,7 @@ static void vc4_txp_connector_atomic_commit(struct drm_connector *conn,
>  
>  	TXP_WRITE(TXP_DST_CTRL, ctrl);
>  
> -	drm_writeback_queue_job(&txp->connector, conn_state->writeback_job);
> +	drm_writeback_queue_job(&txp->connector, conn_state);
>  }
>  
>  static const struct drm_connector_helper_funcs vc4_txp_connector_helper_funcs = {
> diff --git a/include/drm/drm_writeback.h b/include/drm/drm_writeback.h
> index 23df9d463003..47662c362743 100644
> --- a/include/drm/drm_writeback.h
> +++ b/include/drm/drm_writeback.h
> @@ -123,7 +123,7 @@ int drm_writeback_connector_init(struct drm_device *dev,
>  				 const u32 *formats, int n_formats);
>  
>  void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
> -			     struct drm_writeback_job *job);
> +			     struct drm_connector_state *conn_state);
>  
>  void drm_writeback_cleanup_job(struct drm_writeback_job *job);
>  
> 

-- 
Regards
--
Kieran
