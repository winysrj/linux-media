Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:36986 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbeKFVPH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 16:15:07 -0500
Subject: Re: [PATCH] media: dm365_ipipeif: better annotate a fall though
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org
References: <6d03257da95f7d8db273496733a9e9871936bcff.1541501746.git.mchehab+samsung@kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <e36fca8c-5c1c-3046-6ef4-a52e893ec093@cisco.com>
Date: Tue, 6 Nov 2018 12:50:15 +0100
MIME-Version: 1.0
In-Reply-To: <6d03257da95f7d8db273496733a9e9871936bcff.1541501746.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/18 11:55, Mauro Carvalho Chehab wrote:
> Shut up this warning:
> 
> 	drivers/staging/media/davinci_vpfe/dm365_ipipeif.c: In function 'ipipeif_hw_setup':
> 	drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:298:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
> 	   switch (isif_port_if) {
> 	   ^~~~~~
> 	drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:314:2: note: here
> 	  case IPIPEIF_SDRAM_YUV:
> 	  ^~~~
> 
> By annotating a fall though case at the right place.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> index a53231b08d30..e3425bf082ae 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> @@ -310,6 +310,7 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
>  			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
>  			break;
>  		}
> +		/* fall through */
>  
>  	case IPIPEIF_SDRAM_YUV:
>  		/* Set clock divider */
> 
