Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651E4C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 20:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2353C2173C
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 20:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="DzGIBl0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfBQUis (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 15:38:48 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59082 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBQUir (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 15:38:47 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 82FDC49;
        Sun, 17 Feb 2019 21:38:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550435925;
        bh=GnKiVrBVFMrnJzV1zy/HEoGeRA9SuKGACFx6yPWzCjg=;
        h=Reply-To:Subject:To:References:From:Date:In-Reply-To:From;
        b=DzGIBl0akOqoh+PkGbOBNJG7IwQDj24gUGl+HHZMgtsP5vXZ4fJuWNCbvKnZ5YPH7
         AdKegAZarAR4P4lQpOMNPt+pboCUANiy03lybh9UCrVnjzwOpKzUn/Sf18SUdVbFac
         1cjVMw3q+egM+Mvsa/o5B1Ip57WbgZC55wHWa3kw=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v4 6/7] media: vsp1: Replace the display list internal
 flag with a flags field
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190217024852.23328-7-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 mQINBFYE/WYBEACs1PwjMD9rgCu1hlIiUA1AXR4rv2v+BCLUq//vrX5S5bjzxKAryRf0uHat
 V/zwz6hiDrZuHUACDB7X8OaQcwhLaVlq6byfoBr25+hbZG7G3+5EUl9cQ7dQEdvNj6V6y/SC
 rRanWfelwQThCHckbobWiQJfK9n7rYNcPMq9B8e9F020LFH7Kj6YmO95ewJGgLm+idg1Kb3C
 potzWkXc1xmPzcQ1fvQMOfMwdS+4SNw4rY9f07Xb2K99rjMwZVDgESKIzhsDB5GY465sCsiQ
 cSAZRxqE49RTBq2+EQsbrQpIc8XiffAB8qexh5/QPzCmR4kJgCGeHIXBtgRj+nIkCJPZvZtf
 Kr2EAbc6tgg6DkAEHJb+1okosV09+0+TXywYvtEop/WUOWQ+zo+Y/OBd+8Ptgt1pDRyOBzL8
 RXa8ZqRf0Mwg75D+dKntZeJHzPRJyrlfQokngAAs4PaFt6UfS+ypMAF37T6CeDArQC41V3ko
 lPn1yMsVD0p+6i3DPvA/GPIksDC4owjnzVX9kM8Zc5Cx+XoAN0w5Eqo4t6qEVbuettxx55gq
 8K8FieAjgjMSxngo/HST8TpFeqI5nVeq0/lqtBRQKumuIqDg+Bkr4L1V/PSB6XgQcOdhtd36
 Oe9X9dXB8YSNt7VjOcO7BTmFn/Z8r92mSAfHXpb07YJWJosQOQARAQABtDBLaWVyYW4gQmlu
 Z2hhbSA8a2llcmFuLmJpbmdoYW1AaWRlYXNvbmJvYXJkLmNvbT6JAkAEEwEKACoCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4ACGQEFAlnDk/gFCQeA/YsACgkQoR5GchCkYf3X5w/9EaZ7
 cnUcT6dxjxrcmmMnfFPoQA1iQXr/MXQJBjFWfxRUWYzjvUJb2D/FpA8FY7y+vksoJP7pWDL7
 QTbksdwzagUEk7CU45iLWL/CZ/knYhj1I/+5LSLFmvZ/5Gf5xn2ZCsmg7C0MdW/GbJ8IjWA8
 /LKJSEYH8tefoiG6+9xSNp1p0Gesu3vhje/GdGX4wDsfAxx1rIYDYVoX4bDM+uBUQh7sQox/
 R1bS0AaVJzPNcjeC14MS226mQRUaUPc9250aj44WmDfcg44/kMsoLFEmQo2II9aOlxUDJ+x1
 xohGbh9mgBoVawMO3RMBihcEjo/8ytW6v7xSF+xP4Oc+HOn7qebAkxhSWcRxQVaQYw3S9iZz
 2iA09AXAkbvPKuMSXi4uau5daXStfBnmOfalG0j+9Y6hOFjz5j0XzaoF6Pln0jisDtWltYhP
 X9LjFVhhLkTzPZB/xOeWGmsG4gv2V2ExbU3uAmb7t1VSD9+IO3Km4FtnYOKBWlxwEd8qOFpS
 jEqMXURKOiJvnw3OXe9MqG19XdeENA1KyhK5rqjpwdvPGfSn2V+SlsdJA0DFsobUScD9qXQw
 OvhapHe3XboK2+Rd7L+g/9Ud7ZKLQHAsMBXOVJbufA1AT+IaOt0ugMcFkAR5UbBg5+dZUYJj
 1QbPQcGmM3wfvuaWV5+SlJ+WeKIb8ta5Ag0EVgT9ZgEQAM4o5G/kmruIQJ3K9SYzmPishRHV
 DcUcvoakyXSX2mIoccmo9BHtD9MxIt+QmxOpYFNFM7YofX4lG0ld8H7FqoNVLd/+a0yru5Cx
 adeZBe3qr1eLns10Q90LuMo7/6zJhCW2w+HE7xgmCHejAwuNe3+7yt4QmwlSGUqdxl8cgtS1
 PlEK93xXDsgsJj/bw1EfSVdAUqhx8UQ3aVFxNug5OpoX9FdWJLKROUrfNeBE16RLrNrq2ROc
 iSFETpVjyC/oZtzRFnwD9Or7EFMi76/xrWzk+/b15RJ9WrpXGMrttHUUcYZEOoiC2lEXMSAF
 SSSj4vHbKDJ0vKQdEFtdgB1roqzxdIOg4rlHz5qwOTynueiBpaZI3PHDudZSMR5Fk6QjFooE
 XTw3sSl/km/lvUFiv9CYyHOLdygWohvDuMkV/Jpdkfq8XwFSjOle+vT/4VqERnYFDIGBxaRx
 koBLfNDiiuR3lD8tnJ4A1F88K6ojOUs+jndKsOaQpDZV6iNFv8IaNIklTPvPkZsmNDhJMRHH
 Iu60S7BpzNeQeT4yyY4dX9lC2JL/LOEpw8DGf5BNOP1KgjCvyp1/KcFxDAo89IeqljaRsCdP
 7WCIECWYem6pLwaw6IAL7oX+tEqIMPph/G/jwZcdS6Hkyt/esHPuHNwX4guqTbVEuRqbDzDI
 2DJO5FbxABEBAAGJAiUEGAEKAA8CGwwFAlnDlGsFCQeA/gIACgkQoR5GchCkYf1yYRAAq+Yo
 nbf9DGdK1kTAm2RTFg+w9oOp2Xjqfhds2PAhFFvrHQg1XfQR/UF/SjeUmaOmLSczM0s6XMeO
 VcE77UFtJ/+hLo4PRFKm5X1Pcar6g5m4xGqa+Xfzi9tRkwC29KMCoQOag1BhHChgqYaUH3yo
 UzaPwT/fY75iVI+yD0ih/e6j8qYvP8pvGwMQfrmN9YB0zB39YzCSdaUaNrWGD3iCBxg6lwSO
 LKeRhxxfiXCIYEf3vwOsP3YMx2JkD5doseXmWBGW1U0T/oJF+DVfKB6mv5UfsTzpVhJRgee7
 4jkjqFq4qsUGxcvF2xtRkfHFpZDbRgRlVmiWkqDkT4qMA+4q1y/dWwshSKi/uwVZNycuLsz+
 +OD8xPNCsMTqeUkAKfbD8xW4LCay3r/dD2ckoxRxtMD9eOAyu5wYzo/ydIPTh1QEj9SYyvp8
 O0g6CpxEwyHUQtF5oh15O018z3ZLztFJKR3RD42VKVsrnNDKnoY0f4U0z7eJv2NeF8xHMuiU
 RCIzqxX1GVYaNkKTnb/Qja8hnYnkUzY1Lc+OtwiGmXTwYsPZjjAaDX35J/RSKAoy5wGo/YFA
 JxB1gWThL4kOTbsqqXj9GLcyOImkW0lJGGR3o/fV91Zh63S5TKnf2YGGGzxki+ADdxVQAm+Q
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <17749313-a4bc-fa85-3434-2b1848e943db@ideasonboard.com>
Date:   Sun, 17 Feb 2019 20:38:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190217024852.23328-7-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 17/02/2019 02:48, Laurent Pinchart wrote:
> To prepare for addition of more flags to the display list, replace the
> 'internal' flag field by a bitmask 'flags' field.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_dl.c    | 31 +++++++++++++-----------
>  drivers/media/platform/vsp1/vsp1_dl.h    |  2 +-
>  drivers/media/platform/vsp1/vsp1_drm.c   |  6 ++++-
>  drivers/media/platform/vsp1/vsp1_video.c |  2 +-
>  4 files changed, 24 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index 64af449791b0..886b3a69d329 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -178,7 +178,7 @@ struct vsp1_dl_cmd_pool {
>   * @post_cmd: post command to be issued through extended dl header
>   * @has_chain: if true, indicates that there's a partition chain
>   * @chain: entry in the display list partition chain
> - * @internal: whether the display list is used for internal purpose
> + * @flags: display list flags, a combination of VSP1_DL_FRAME_END_*
>   */
>  struct vsp1_dl_list {
>  	struct list_head list;
> @@ -197,7 +197,7 @@ struct vsp1_dl_list {
>  	bool has_chain;
>  	struct list_head chain;
>  
> -	bool internal;
> +	unsigned int flags;
>  };
>  
>  /**
> @@ -861,13 +861,15 @@ static void vsp1_dl_list_commit_continuous(struct vsp1_dl_list *dl)
>  	 *
>  	 * If a display list is already pending we simply drop it as the new
>  	 * display list is assumed to contain a more recent configuration. It is
> -	 * an error if the already pending list has the internal flag set, as
> -	 * there is then a process waiting for that list to complete. This
> -	 * shouldn't happen as the waiting process should perform proper
> -	 * locking, but warn just in case.
> +	 * an error if the already pending list has the
> +	 * VSP1_DL_FRAME_END_INTERNAL flag set, as there is then a process
> +	 * waiting for that list to complete. This shouldn't happen as the
> +	 * waiting process should perform proper locking, but warn just in
> +	 * case.
>  	 */
>  	if (vsp1_dl_list_hw_update_pending(dlm)) {
> -		WARN_ON(dlm->pending && dlm->pending->internal);
> +		WARN_ON(dlm->pending &&
> +			(dlm->pending->flags & VSP1_DL_FRAME_END_INTERNAL));
>  		__vsp1_dl_list_put(dlm->pending);
>  		dlm->pending = dl;
>  		return;
> @@ -897,7 +899,7 @@ static void vsp1_dl_list_commit_singleshot(struct vsp1_dl_list *dl)
>  	dlm->active = dl;
>  }
>  
> -void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
> +void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags)
>  {
>  	struct vsp1_dl_manager *dlm = dl->dlm;
>  	struct vsp1_dl_list *dl_next;
> @@ -912,7 +914,7 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
>  		vsp1_dl_list_fill_header(dl_next, last);
>  	}
>  
> -	dl->internal = internal;
> +	dl->flags = dl_flags & ~VSP1_DL_FRAME_END_COMPLETED;
>  
>  	spin_lock_irqsave(&dlm->lock, flags);
>  
> @@ -941,9 +943,10 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
>   * set in single-shot mode as display list processing is then not continuous and
>   * races never occur.
>   *
> - * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the previous display list
> - * has completed and had been queued with the internal notification flag.
> - * Internal notification is only supported for continuous mode.
> + * The following flags are only supported for continuous mode.
> + *
> + * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the display list that just
> + * became active had been queued with the internal notification flag.
>   */
>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  {
> @@ -986,9 +989,9 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  	 * frame end interrupt. The display list thus becomes active.
>  	 */
>  	if (dlm->queued) {
> -		if (dlm->queued->internal)
> +		if (dlm->queued->flags & VSP1_DL_FRAME_END_INTERNAL)
>  			flags |= VSP1_DL_FRAME_END_INTERNAL;
> -		dlm->queued->internal = false;
> +		dlm->queued->flags &= ~VSP1_DL_FRAME_END_INTERNAL;
>  
>  		__vsp1_dl_list_put(dlm->active);
>  		dlm->active = dlm->queued;
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
> index 125750dc8b5c..e0fdb145e6ed 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -61,7 +61,7 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
>  void vsp1_dl_list_put(struct vsp1_dl_list *dl);
>  struct vsp1_dl_body *vsp1_dl_list_get_body0(struct vsp1_dl_list *dl);
>  struct vsp1_dl_ext_cmd *vsp1_dl_get_pre_cmd(struct vsp1_dl_list *dl);
> -void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal);
> +void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags);
>  
>  struct vsp1_dl_body_pool *
>  vsp1_dl_body_pool_create(struct vsp1_device *vsp1, unsigned int num_bodies,
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 048190fd3a2d..9d20ef5cd5f8 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -537,6 +537,10 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  	struct vsp1_entity *next;
>  	struct vsp1_dl_list *dl;
>  	struct vsp1_dl_body *dlb;
> +	unsigned int dl_flags = 0;
> +
> +	if (drm_pipe->force_brx_release)
> +		dl_flags |= VSP1_DL_FRAME_END_INTERNAL;
>  
>  	dl = vsp1_dl_list_get(pipe->output->dlm);
>  	dlb = vsp1_dl_list_get_body0(dl);
> @@ -559,7 +563,7 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  		vsp1_entity_configure_partition(entity, pipe, dl, dlb);
>  	}
>  
> -	vsp1_dl_list_commit(dl, drm_pipe->force_brx_release);
> +	vsp1_dl_list_commit(dl, dl_flags);
>  }
>  
>  /* -----------------------------------------------------------------------------
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index cfbab16c4820..8feaa8d89fe8 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -426,7 +426,7 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
>  	}
>  
>  	/* Complete, and commit the head display list. */
> -	vsp1_dl_list_commit(dl, false);
> +	vsp1_dl_list_commit(dl, 0);
>  	pipe->configured = true;
>  
>  	vsp1_pipeline_run(pipe);
> 

-- 
Regards
--
Kieran
