Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:48608 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751094AbdDDMlZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 08:41:25 -0400
Subject: Re: [PATCH 2/2] [media] cec: Fix runtime BUG when (CONFIG_RC_CORE &&
 !CEC_CAP_RC)
To: Lee Jones <lee.jones@linaro.org>, hans.verkuil@cisco.com,
        mchehab@kernel.org
References: <20170404123219.22040-1-lee.jones@linaro.org>
 <20170404123219.22040-2-lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <998c967a-6cac-8d01-6339-2b58f7651c54@xs4all.nl>
Date: Tue, 4 Apr 2017 14:41:19 +0200
MIME-Version: 1.0
In-Reply-To: <20170404123219.22040-2-lee.jones@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/2017 02:32 PM, Lee Jones wrote:
> Currently when the RC Core is enabled (reachable) core code located
> in cec_register_adapter() attempts to populate the RC structure with
> a pointer to the 'parent' passed in by the caller.
> 
> Unfortunately if the caller did not specify RC capibility when calling
> cec_allocate_adapter(), then there will be no RC structure to populate.
> 
> This causes a "NULL pointer dereference" error.
> 
> Fixes: f51e80804f0 ("[media] cec: pass parent device in register(), not allocate()")
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Oops! Thanks for the report. I'll take this for 4.12.

Regards,

	Hans

> ---
>  drivers/media/cec/cec-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> index 06a312c..d64937b 100644
> --- a/drivers/media/cec/cec-core.c
> +++ b/drivers/media/cec/cec-core.c
> @@ -286,8 +286,8 @@ int cec_register_adapter(struct cec_adapter *adap,
>  	adap->devnode.dev.parent = parent;
>  
>  #if IS_REACHABLE(CONFIG_RC_CORE)
> -	adap->rc->dev.parent = parent;
>  	if (adap->capabilities & CEC_CAP_RC) {
> +		adap->rc->dev.parent = parent;
>  		res = rc_register_device(adap->rc);
>  
>  		if (res) {
> 
