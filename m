Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:49357 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752634AbeC1VlM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 17:41:12 -0400
Subject: Re: [PATCH v4 1/5] dvb-frontends/dvb-pll: add i2c driver support
To: tskd08@gmail.com, linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180328170101.29385-1-tskd08@gmail.com>
 <20180328170101.29385-2-tskd08@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <39b9f659-7300-53e5-b1a4-7cc9d8a9d11a@iki.fi>
Date: Thu, 29 Mar 2018 00:41:09 +0300
MIME-Version: 1.0
In-Reply-To: <20180328170101.29385-2-tskd08@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2018 08:00 PM, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> registers the module as an i2c driver,
> but keeps dvb_pll_attach() untouched for compatibility.
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
> Changes since v3:
> - use standard i2c_device_id instead of dvb_pll_config
> 
>   drivers/media/dvb-frontends/dvb-pll.c | 67 +++++++++++++++++++++++++++++++++++
>   drivers/media/dvb-frontends/dvb-pll.h | 24 +++++++++++++
>   2 files changed, 91 insertions(+)
> 
> diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
> index 5553b89b804..e2a93aae04f 100644
> --- a/drivers/media/dvb-frontends/dvb-pll.c
> +++ b/drivers/media/dvb-frontends/dvb-pll.c
> @@ -827,6 +827,73 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
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
> +	desc_id = (unsigned int) id->driver_data;
> +
> +	if (!dvb_pll_attach(fe, client->addr, client->adapter, desc_id))
> +		return -ENOMEM;
> +
> +	dev_info(&client->dev, "DVB Simple Tuner attached.\n");

Print used pll chip name here

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
> +	{DVB_PLL_THOMSON_DTT7579_NAME,        DVB_PLL_THOMSON_DTT7579},
> +	{DVB_PLL_THOMSON_DTT759X_NAME,        DVB_PLL_THOMSON_DTT759X},
> +	{DVB_PLL_LG_Z201_NAME,                DVB_PLL_LG_Z201},
> +	{DVB_PLL_UNKNOWN_1_NAME,              DVB_PLL_UNKNOWN_1},
> +	{DVB_PLL_TUA6010XS_NAME,              DVB_PLL_TUA6010XS},
> +	{DVB_PLL_ENV57H1XD5_NAME,             DVB_PLL_ENV57H1XD5},
> +	{DVB_PLL_TUA6034_NAME,                DVB_PLL_TUA6034},
> +	{DVB_PLL_TDA665X_NAME,                DVB_PLL_TDA665X},
> +	{DVB_PLL_TDED4_NAME,                  DVB_PLL_TDED4},
> +	{DVB_PLL_TDHU2_NAME,                  DVB_PLL_TDHU2},
> +	{DVB_PLL_SAMSUNG_TBMV_NAME,           DVB_PLL_SAMSUNG_TBMV},
> +	{DVB_PLL_PHILIPS_SD1878_TDA8261_NAME, DVB_PLL_PHILIPS_SD1878_TDA8261},
> +	{DVB_PLL_OPERA1_NAME,                 DVB_PLL_OPERA1},
> +	{DVB_PLL_SAMSUNG_DTOS403IH102A_NAME,  DVB_PLL_SAMSUNG_DTOS403IH102A},
> +	{DVB_PLL_SAMSUNG_TDTC9251DH0_NAME,    DVB_PLL_SAMSUNG_TDTC9251DH0},
> +	{DVB_PLL_SAMSUNG_TBDU18132_NAME,      DVB_PLL_SAMSUNG_TBDU18132},
> +	{DVB_PLL_SAMSUNG_TBMU24112_NAME,      DVB_PLL_SAMSUNG_TBMU24112},
> +	{DVB_PLL_TDEE4_NAME,                  DVB_PLL_TDEE4},
> +	{DVB_PLL_THOMSON_DTT7520X_NAME,       DVB_PLL_THOMSON_DTT7520X},
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
> index ca885e71d2f..e96994bf668 100644
> --- a/drivers/media/dvb-frontends/dvb-pll.h
> +++ b/drivers/media/dvb-frontends/dvb-pll.h
> @@ -30,6 +30,30 @@
>   #define DVB_PLL_TDEE4		       18
>   #define DVB_PLL_THOMSON_DTT7520X       19
>   
> +#define DVB_PLL_THOMSON_DTT7579_NAME	    "dtt7579"
> +#define DVB_PLL_THOMSON_DTT759X_NAME        "dtt759x"
> +#define DVB_PLL_LG_Z201_NAME                "z201"
> +#define DVB_PLL_UNKNOWN_1_NAME              "unknown_1"
> +#define DVB_PLL_TUA6010XS_NAME              "tua6010xs"
> +#define DVB_PLL_ENV57H1XD5_NAME             "env57h1xd5"
> +#define DVB_PLL_TUA6034_NAME                "tua6034"
> +#define DVB_PLL_TDA665X_NAME                "tda665x"
> +#define DVB_PLL_TDED4_NAME                  "tded4"
> +#define DVB_PLL_TDHU2_NAME                  "tdhu2"
> +#define DVB_PLL_SAMSUNG_TBMV_NAME           "tbmv"
> +#define DVB_PLL_PHILIPS_SD1878_TDA8261_NAME "sd1878_tda8261"
> +#define DVB_PLL_OPERA1_NAME                 "opera1"
> +#define DVB_PLL_SAMSUNG_DTOS403IH102A_NAME  "dtos403ih102a"
> +#define DVB_PLL_SAMSUNG_TDTC9251DH0_NAME    "tdtc9251dh0"
> +#define DVB_PLL_SAMSUNG_TBDU18132_NAME      "tbdu18132"
> +#define DVB_PLL_SAMSUNG_TBMU24112_NAME      "tbmu24112"
> +#define DVB_PLL_TDEE4_NAME                  "tdee4"
> +#define DVB_PLL_THOMSON_DTT7520X_NAME       "dtt7520x"

Defining these names like that does not give any value. IMHO better to 
just add those chip names directly to chip id table.

> +
> +struct dvb_pll_config {
> +	struct dvb_frontend *fe;
> +};
> +
>   #if IS_REACHABLE(CONFIG_DVB_PLL)
>   /**
>    * Attach a dvb-pll to the supplied frontend structure.
> 

-- 
http://palosaari.fi/
