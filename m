Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:14853 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbeJAO4P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 10:56:15 -0400
Subject: Re: [PATCH] MAINTAINERS: fix reference to STI CEC driver
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        gregkh@linuxfoundation.org, mchehab+samsung@kernel.org,
        akpm@linux-foundation.org, hans.verkuil@cisco.com, joe@perches.com
Cc: linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20181001074640.16342-1-benjamin.gaignard@st.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <0980c4e8-f2f6-c480-66f0-9638b624b0b0@cisco.com>
Date: Mon, 1 Oct 2018 10:19:19 +0200
MIME-Version: 1.0
In-Reply-To: <20181001074640.16342-1-benjamin.gaignard@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/18 09:46, Benjamin Gaignard wrote:
> STI CEC driver has move from staging directory to media/platform/sti/cec/
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>

Added CC to linux-media so it's picked up by patchwork.

	Hans

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b22e7fdfd2ea..8aa973410e2f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13870,7 +13870,7 @@ F:	sound/soc/sti/
>  STI CEC DRIVER
>  M:	Benjamin Gaignard <benjamin.gaignard@linaro.org>
>  S:	Maintained
> -F:	drivers/staging/media/st-cec/
> +F:	drivers/media/platform/sti/cec/
>  F:	Documentation/devicetree/bindings/media/stih-cec.txt
>  
>  STK1160 USB VIDEO CAPTURE DRIVER
> 
