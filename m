Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58023 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753396AbdDDMjN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 08:39:13 -0400
Subject: Re: [PATCH 1/2] [media] cec: Move capability check inside #if
To: Lee Jones <lee.jones@linaro.org>, hans.verkuil@cisco.com,
        mchehab@kernel.org
References: <20170404123219.22040-1-lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4920d83a-8983-36cc-936d-9e0989e833ce@xs4all.nl>
Date: Tue, 4 Apr 2017 14:39:05 +0200
MIME-Version: 1.0
In-Reply-To: <20170404123219.22040-1-lee.jones@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/2017 02:32 PM, Lee Jones wrote:
> If CONFIG_RC_CORE is not enabled then none of the RC code will be
> executed anyway, so we're placing the capability check inside the
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/media/cec/cec-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> index 37217e2..06a312c 100644
> --- a/drivers/media/cec/cec-core.c
> +++ b/drivers/media/cec/cec-core.c
> @@ -234,10 +234,10 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
>  		return ERR_PTR(res);
>  	}
>  
> +#if IS_REACHABLE(CONFIG_RC_CORE)
>  	if (!(caps & CEC_CAP_RC))
>  		return adap;
>  
> -#if IS_REACHABLE(CONFIG_RC_CORE)
>  	/* Prepare the RC input device */
>  	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
>  	if (!adap->rc) {
> 

Not true, there is an #else further down.

That said, this code is clearly a bit confusing.

It would be better if at the beginning of the function we'd have this:

#if !IS_REACHABLE(CONFIG_RC_CORE)
	caps &= ~CEC_CAP_RC;
#endif

and then drop the #else bit and (as you do in this patch) move the #if up.

Can you make a new patch for this?

Thanks!

	Hans
