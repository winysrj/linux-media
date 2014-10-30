Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54662 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760211AbaJ3OtN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 10:49:13 -0400
Message-ID: <54524FE7.6040701@iki.fi>
Date: Thu, 30 Oct 2014 16:49:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] si2157: add support for SYS_DVBC_ANNEX_B
References: <1414665796-22123-1-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1414665796-22123-1-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 10/30/2014 12:43 PM, Olli Salonen wrote:
> Set the property for delivery system also in case of SYS_DVBC_ANNEX_B. This behaviour is observed in the sniffs taken with Hauppauge HVR-955Q Windows driver.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/tuners/si2157.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index cf97142..b086b87 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -250,6 +250,9 @@ static int si2157_set_params(struct dvb_frontend *fe)
>   	case SYS_ATSC:
>   			delivery_system = 0x00;
>   			break;
> +	case SYS_DVBC_ANNEX_B:
> +			delivery_system = 0x10;
> +			break;
>   	case SYS_DVBT:
>   	case SYS_DVBT2: /* it seems DVB-T and DVB-T2 both are 0x20 here */
>   			delivery_system = 0x20;
>

-- 
http://palosaari.fi/
