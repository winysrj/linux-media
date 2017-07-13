Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:36316 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751180AbdGMHB6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 03:01:58 -0400
Subject: Re: [PATCH v8 1/5] [media] cec.h: Add stub function for
 cec_register_cec_notifier()
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1499701281.git.joabreu@synopsys.com>
 <bcf671fd7de56db2a224394e21766eae01d0ad02.1499701282.git.joabreu@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ff7de557-d023-4ca6-d2f0-df13886ab7fc@xs4all.nl>
Date: Thu, 13 Jul 2017 09:01:51 +0200
MIME-Version: 1.0
In-Reply-To: <bcf671fd7de56db2a224394e21766eae01d0ad02.1499701282.git.joabreu@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/17 17:46, Jose Abreu wrote:
> Add a new stub function for cec_register_cec_notifier() so that
> we can still call this function when CONFIG_CEC_NOTIFIER and
> CONFIG_CEC_CORE are not set.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Carlos Palminha <palminha@synopsys.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/cec.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/media/cec.h b/include/media/cec.h
> index 56643b2..8357f60 100644
> --- a/include/media/cec.h
> +++ b/include/media/cec.h
> @@ -365,6 +365,14 @@ static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
>  	return 0;
>  }
>  
> +#ifndef CONFIG_CEC_NOTIFIER
> +struct cec_notifier;
> +static inline void cec_register_cec_notifier(struct cec_adapter *adap,
> +					     struct cec_notifier *notifier)
> +{
> +}
> +#endif
> +
>  #endif
>  
>  /**
> 

This isn't quite right. This function prototype needs to be moved to cec-notifier.h.

I also saw that it isn't documented. I'll make a patch for this which will also include
documentation.

Regards,

	Hans
