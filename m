Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37176 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaJAUCS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 16:02:18 -0400
Message-ID: <542C5DC7.80908@iki.fi>
Date: Wed, 01 Oct 2014 23:02:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] cx23885: add I2C client for CI into state and handle
 unregistering
References: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi> <1411976660-19329-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411976660-19329-4-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

I was looking where is the CI I2C client pointer stored to that, but 
realized it was upcoming patch which will use that...

regards
Antti

On 09/29/2014 10:44 AM, Olli Salonen wrote:
> If the CI chip has an I2C driver, we need to store I2C client into state.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/pci/cx23885/cx23885-dvb.c | 7 +++++++
>   drivers/media/pci/cx23885/cx23885.h     | 1 +
>   2 files changed, 8 insertions(+)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index d327459..cc88997 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -1923,6 +1923,13 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
>   	 * implement MFE support.
>   	 */
>
> +	/* remove I2C client for CI */
> +	client = port->i2c_client_ci;
> +	if (client) {
> +		module_put(client->dev.driver->owner);
> +		i2c_unregister_device(client);
> +	}
> +
>   	/* remove I2C client for tuner */
>   	client = port->i2c_client_tuner;
>   	if (client) {
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 1792d1a..c35ba2d 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -297,6 +297,7 @@ struct cx23885_tsport {
>
>   	struct i2c_client *i2c_client_demod;
>   	struct i2c_client *i2c_client_tuner;
> +	struct i2c_client *i2c_client_ci;
>
>   	int (*set_frontend)(struct dvb_frontend *fe);
>   	int (*fe_set_voltage)(struct dvb_frontend *fe,
>

-- 
http://palosaari.fi/
