Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:34383 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752128AbeC0XzK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 19:55:10 -0400
Subject: Re: [PATCH v3 1/5] dvb-frontends/dvb-pll: add i2c driver support
To: tskd08@gmail.com, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180326180652.5385-1-tskd08@gmail.com>
 <20180326180652.5385-2-tskd08@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <9c9e52d5-b796-d2bc-602e-5ef325769e9f@iki.fi>
Date: Wed, 28 Mar 2018 02:55:08 +0300
MIME-Version: 1.0
In-Reply-To: <20180326180652.5385-2-tskd08@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2018 09:06 PM, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> registers the module as an i2c driver,
> but keeps dvb_pll_attach() untouched for compatibility.
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>   drivers/media/dvb-frontends/dvb-pll.c | 49 +++++++++++++++++++++++++++++++++++
>   drivers/media/dvb-frontends/dvb-pll.h |  6 +++++
>   2 files changed, 55 insertions(+)
> 
> diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
> index 5553b89b804..614a5ea3b00 100644
> --- a/drivers/media/dvb-frontends/dvb-pll.c
> +++ b/drivers/media/dvb-frontends/dvb-pll.c
> @@ -827,6 +827,55 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
>   }
>   EXPORT_SYMBOL(dvb_pll_attach);
>   
> +
> +static int
> +dvb_pll_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +	struct dvb_pll_config *cfg;
> +	struct dvb_frontend *fe;
> +	unsigned int desc_id;
> +
> +	cfg = client->dev.platform_data;
> +	fe = cfg->fe;
> +	i2c_set_clientdata(client, fe);
> +	desc_id = cfg->desc_id;
> +
> +	if (!dvb_pll_attach(fe, client->addr, client->adapter, desc_id))
> +		return -ENOMEM;
> +
> +	dev_info(&client->dev, "DVB Simple Tuner attached.\n");
> +	return 0;
> +}
> +
> +static int dvb_pll_remove(struct i2c_client *client)
> +{
> +	struct dvb_frontend *fe;
> +
> +	fe = i2c_get_clientdata(client);
> +	dvb_pll_release(fe);
> +	return 0;
> +}
> +
> +
> +static const struct i2c_device_id dvb_pll_id[] = {
> +	{"dvb_pll", 0},
> +	{}
> +};
> +
> +
> +MODULE_DEVICE_TABLE(i2c, dvb_pll_id);
> +
> +static struct i2c_driver dvb_pll_driver = {
> +	.driver = {
> +		.name = "dvb_pll",
> +	},
> +	.probe    = dvb_pll_probe,
> +	.remove   = dvb_pll_remove,
> +	.id_table = dvb_pll_id,
> +};
> +
> +module_i2c_driver(dvb_pll_driver);
> +
>   MODULE_DESCRIPTION("dvb pll library");
>   MODULE_AUTHOR("Gerd Knorr");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
> index ca885e71d2f..15bda0d0c15 100644
> --- a/drivers/media/dvb-frontends/dvb-pll.h
> +++ b/drivers/media/dvb-frontends/dvb-pll.h
> @@ -30,6 +30,12 @@
>   #define DVB_PLL_TDEE4		       18
>   #define DVB_PLL_THOMSON_DTT7520X       19
>   
> +struct dvb_pll_config {
> +	struct dvb_frontend *fe;
> +
> +	unsigned int desc_id;
> +};
> +
>   #if IS_REACHABLE(CONFIG_DVB_PLL)
>   /**
>    * Attach a dvb-pll to the supplied frontend structure.
> 

Hello
Idea is correct, but I would use pll chip names for passing correct pll 
type for driver - that field is just for that.

Like that:
static const struct i2c_device_id dvb_pll_id[] = {
	{"PLL-NAME1", 0},
	{"PLL-NAME2", 1},
	{"PLL-NAME3", 2},
	{}
};

See si2157 for example.

regards
Antti


-- 
http://palosaari.fi/
