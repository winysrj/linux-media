Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59002 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaHLX3C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 19:29:02 -0400
Message-ID: <53EAA339.9000007@iki.fi>
Date: Wed, 13 Aug 2014 02:28:57 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, olli@cabbala.net
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/6] cx23855: add frontend set voltage function into state
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi> <1407787095-2167-5-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-5-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 08/11/2014 10:58 PM, Olli Salonen wrote:
> Setting the LNB voltage requires setting some GPIOs on the cx23885 with some boards before calling the actual set_voltage function in the demod driver. Add a function pointer into state for that case.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/pci/cx23885/cx23885.h | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 1040b3e..e60ff7f 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -330,6 +330,8 @@ struct cx23885_tsport {
>   	struct i2c_client *i2c_client_tuner;
>
>   	int (*set_frontend)(struct dvb_frontend *fe);
> +	int (*fe_set_voltage)(struct dvb_frontend *fe,
> +				fe_sec_voltage_t voltage);
>   };
>
>   struct cx23885_kernel_ir {
>

-- 
http://palosaari.fi/
