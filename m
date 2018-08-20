Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:45459 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbeHTWID (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 18:08:03 -0400
Received: by mail-qt0-f196.google.com with SMTP id y5-v6so17368157qti.12
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 11:51:16 -0700 (PDT)
Message-ID: <875a995712d0de615f47f200863376ee617ec533.camel@redhat.com>
Subject: Re: [PATCH (repost) 1/5] drm_dp_cec: check that aux has a transfer
 function
From: Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Date: Mon, 20 Aug 2018 14:51:14 -0400
In-Reply-To: <20180817141122.9541-2-hverkuil@xs4all.nl>
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
         <20180817141122.9541-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-08-17 at 16:11 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If aux->transfer == NULL, then just return without doing
> anything. In that case the function is likely called for
> a non-(e)DP connector.
> 
> This never happened for the i915 driver, but the nouveau and amdgpu
> drivers need this check.
Could you give a backtrace from where you're hitting this issue with nouveau and
amdgpu? It doesn't make a whole ton of sense to have connectors registering DP
aux busses if they aren't actually DP, that should probably just be fixed...

> 
> The alternative would be to add this check in those drivers before
> every drm_dp_cec call, but it makes sense to check it in the
> drm_dp_cec functions to prevent a kernel oops.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/drm_dp_cec.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
> index 988513346e9c..1407b13a8d5d 100644
> --- a/drivers/gpu/drm/drm_dp_cec.c
> +++ b/drivers/gpu/drm/drm_dp_cec.c
> @@ -238,6 +238,10 @@ void drm_dp_cec_irq(struct drm_dp_aux *aux)
>  	u8 cec_irq;
>  	int ret;
>  
> +	/* No transfer function was set, so not a DP connector */
> +	if (!aux->transfer)
> +		return;
> +
>  	mutex_lock(&aux->cec.lock);
>  	if (!aux->cec.adap)
>  		goto unlock;
> @@ -293,6 +297,10 @@ void drm_dp_cec_set_edid(struct drm_dp_aux *aux, const
> struct edid *edid)
>  	unsigned int num_las = 1;
>  	u8 cap;
>  
> +	/* No transfer function was set, so not a DP connector */
> +	if (!aux->transfer)
> +		return;
> +
>  #ifndef CONFIG_MEDIA_CEC_RC
>  	/*
>  	 * CEC_CAP_RC is part of CEC_CAP_DEFAULTS, but it is stripped by
> @@ -361,6 +369,10 @@ EXPORT_SYMBOL(drm_dp_cec_set_edid);
>   */
>  void drm_dp_cec_unset_edid(struct drm_dp_aux *aux)
>  {
> +	/* No transfer function was set, so not a DP connector */
> +	if (!aux->transfer)
> +		return;
> +
>  	cancel_delayed_work_sync(&aux->cec.unregister_work);
>  
>  	mutex_lock(&aux->cec.lock);
> @@ -404,6 +416,8 @@ void drm_dp_cec_register_connector(struct drm_dp_aux *aux,
> const char *name,
>  				   struct device *parent)
>  {
>  	WARN_ON(aux->cec.adap);
> +	if (WARN_ON(!aux->transfer))
> +		return;
>  	aux->cec.name = name;
>  	aux->cec.parent = parent;
>  	INIT_DELAYED_WORK(&aux->cec.unregister_work,
