Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41177 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbaHLX1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 19:27:34 -0400
Message-ID: <53EAA2E3.1060206@iki.fi>
Date: Wed, 13 Aug 2014 02:27:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, olli@cabbala.net
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] cx23885: add i2c client handling into dvb_unregister
 and state
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi> <1407787095-2167-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-4-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 08/11/2014 10:58 PM, Olli Salonen wrote:
> Prepare cx23885 driver for handling I2C client that is needed for certain demodulators and tuners (for example Si2168 and Si2157). I2C client for tuner and demod stored in state and unregistering of the I2C devices added into dvb_unregister.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/pci/cx23885/cx23885-dvb.c | 16 ++++++++++++++++
>   drivers/media/pci/cx23885/cx23885.h     |  3 +++
>   2 files changed, 19 insertions(+)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 968fecc..2608155 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -1643,6 +1643,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
>   int cx23885_dvb_unregister(struct cx23885_tsport *port)
>   {
>   	struct videobuf_dvb_frontend *fe0;
> +	struct i2c_client *client;
>
>   	/* FIXME: in an error condition where the we have
>   	 * an expected number of frontends (attach problem)
> @@ -1651,6 +1652,21 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
>   	 * This comment only applies to future boards IF they
>   	 * implement MFE support.
>   	 */
> +
> +	/* remove I2C client for tuner */
> +	client = port->i2c_client_tuner;
> +	if (client) {
> +		module_put(client->dev.driver->owner);
> +		i2c_unregister_device(client);
> +	}
> +
> +	/* remove I2C client for demodulator */
> +	client = port->i2c_client_demod;
> +	if (client) {
> +		module_put(client->dev.driver->owner);
> +		i2c_unregister_device(client);
> +	}
> +
>   	fe0 = videobuf_dvb_get_frontend(&port->frontends, 1);
>   	if (fe0 && fe0->dvb.frontend)
>   		videobuf_dvb_unregister_bus(&port->frontends);
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 0e086c0..1040b3e 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -326,6 +326,9 @@ struct cx23885_tsport {
>   	/* Workaround for a temp dvb_frontend that the tuner can attached to */
>   	struct dvb_frontend analog_fe;
>
> +	struct i2c_client *i2c_client_demod;
> +	struct i2c_client *i2c_client_tuner;
> +
>   	int (*set_frontend)(struct dvb_frontend *fe);
>   };
>
>

-- 
http://palosaari.fi/
