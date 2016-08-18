Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34112 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1950173AbcHROhB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 10:37:01 -0400
Received: by mail-lf0-f48.google.com with SMTP id l89so13184902lfi.1
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2016 07:36:59 -0700 (PDT)
Date: Thu, 18 Aug 2016 16:36:57 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Geert Uytterhoeven <geert@glider.be>
Subject: Re: [PATCH] v4l: rcar-fcp: Don't force users to check for disabled
 FCP support
Message-ID: <20160818143657.GF7992@bigcity.dyn.berto.se>
References: <1471440728-16931-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1471440728-16931-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-08-17 16:32:08 +0300, Laurent Pinchart wrote:
> The rcar_fcp_enable() function immediately returns successfully when the
> FCP device pointer is NULL to avoid forcing the users to check the FCP
> device manually before every call. However, the stub version of the
> function used when the FCP driver is disabled returns -ENOSYS
> unconditionally, resulting in a different API contract for the two
> versions of the function.
> 
> As a user that requires FCP support will fail at probe time when calling
> rcar_fcp_get() if the FCP driver is disabled, the stub version of the
> rcar_fcp_enable() function will only be called with a NULL FCP device.
> We can thus return 0 unconditionally to align the behaviour with the
> normal version of the function.
> 
> Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Works on Koelsch with shmobile_defconfig.

Tested-by: Niklas Söderlund <niklas.soderlund@ragnatech.se>

> ---
>  include/media/rcar-fcp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/media/rcar-fcp.h b/include/media/rcar-fcp.h
> index 4c7fc77eaf29..8723f05c6321 100644
> --- a/include/media/rcar-fcp.h
> +++ b/include/media/rcar-fcp.h
> @@ -29,7 +29,7 @@ static inline struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np)
>  static inline void rcar_fcp_put(struct rcar_fcp_device *fcp) { }
>  static inline int rcar_fcp_enable(struct rcar_fcp_device *fcp)
>  {
> -	return -ENOSYS;
> +	return 0;
>  }
>  static inline void rcar_fcp_disable(struct rcar_fcp_device *fcp) { }
>  #endif
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
