Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:22731 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387404AbeKFT5d (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 14:57:33 -0500
Subject: Re: [PATCH] davinci_vpfe: add a missing break
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devel@driverdev.osuosl.org
References: <a08b85a2263d742edcd50d371712eaf11fbccd64.1541499323.git.mchehab+samsung@kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <7128a7e6-6b4e-9304-e0f5-92bb9ef415e2@cisco.com>
Date: Tue, 6 Nov 2018 11:32:57 +0100
MIME-Version: 1.0
In-Reply-To: <a08b85a2263d742edcd50d371712eaf11fbccd64.1541499323.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/18 11:15, Mauro Carvalho Chehab wrote:
> As warned by gcc:
> 
> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c: In function 'ipipeif_hw_setup':
> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:298:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    switch (isif_port_if) {
>    ^~~~~~
> drivers/staging/media/davinci_vpfe/dm365_ipipeif.c:314:2: note: here
>   case IPIPEIF_SDRAM_YUV:
>   ^~~~
> 
> There is a missing break for the raw format.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

It really should fall through: see this comment:

                /* fall through for SDRAM YUV mode */
                /* configure CFG2 */
                val = ipipeif_read(ipipeif_base_addr, IPIPEIF_CFG2);
                switch (isif_port_if) {
                case MEDIA_BUS_FMT_YUYV8_1X16:
                case MEDIA_BUS_FMT_UYVY8_2X8:
                case MEDIA_BUS_FMT_Y8_1X8:
                        RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
                        SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
                        ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
                        break;

                default:
                        RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
                        RESETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
                        ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
                        break;
                }

        case IPIPEIF_SDRAM_YUV:

So we need a proper /* fall through */ comment instead of a break.

In the SDRAM_YUV case the SDRAM clock divider is configured, and that needs
to be done for both SDRAM_* cases.

Regards,

	Hans


> ---
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> index a53231b08d30..975272bcf8ca 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> @@ -310,6 +310,7 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
>  			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
>  			break;
>  		}
> +		break;
>  
>  	case IPIPEIF_SDRAM_YUV:
>  		/* Set clock divider */
> 
