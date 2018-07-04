Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752158AbeGDRab (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 13:30:31 -0400
Date: Wed, 4 Jul 2018 14:30:26 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: helene: add I2C device probe function
Message-ID: <20180704143026.036df3c4@coco.lan>
In-Reply-To: <20180702051211.21942-1-suzuki.katsuhiro@socionext.com>
References: <20180702051211.21942-1-suzuki.katsuhiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Katsushiro-san,

Em Mon,  2 Jul 2018 14:12:11 +0900
Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com> escreveu:

> This patch adds I2C probe function to use dvb_module_probe()
> with this driver.
> 
> Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> 
> ---
> 
> Changes since v3:
>   - Drop wrong patch 2/2 from v3 series, no changes in this patch
> 
> Changes since v2:
>   - Nothing
> 
> Changes since v1:
>   - Add documents for dvb_frontend member of helene_config
> ---
>  drivers/media/dvb-frontends/helene.c | 88 ++++++++++++++++++++++++++--
>  drivers/media/dvb-frontends/helene.h |  3 +
>  2 files changed, 87 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
> index a0d0b53c91d7..04033f0c278b 100644
> --- a/drivers/media/dvb-frontends/helene.c
> +++ b/drivers/media/dvb-frontends/helene.c
> @@ -666,7 +666,7 @@ static int helene_set_params_s(struct dvb_frontend *fe)
>  	return 0;
>  }
>  
> -static int helene_set_params(struct dvb_frontend *fe)
> +static int helene_set_params_t(struct dvb_frontend *fe)
>  {
>  	u8 data[MAX_WRITE_REGSIZE];
>  	u32 frequency;
> @@ -835,6 +835,19 @@ static int helene_set_params(struct dvb_frontend *fe)
>  	return 0;
>  }
>  
> +static int helene_set_params(struct dvb_frontend *fe)
> +{
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +
> +	if (p->delivery_system == SYS_DVBT ||
> +	    p->delivery_system == SYS_DVBT2 ||
> +	    p->delivery_system == SYS_ISDBT ||
> +	    p->delivery_system == SYS_DVBC_ANNEX_A)
> +		return helene_set_params_t(fe);
> +
> +	return helene_set_params_s(fe);
> +}
> +
>  static int helene_get_frequency(struct dvb_frontend *fe, u32 *frequency)
>  {
>  	struct helene_priv *priv = fe->tuner_priv;
> @@ -843,7 +856,7 @@ static int helene_get_frequency(struct dvb_frontend *fe, u32 *frequency)
>  	return 0;
>  }
>  
> -static const struct dvb_tuner_ops helene_tuner_ops = {
> +static const struct dvb_tuner_ops helene_tuner_ops_t = {
>  	.info = {
>  		.name = "Sony HELENE Ter tuner",
>  		.frequency_min = 1000000,
> @@ -853,7 +866,7 @@ static const struct dvb_tuner_ops helene_tuner_ops = {
>  	.init = helene_init,
>  	.release = helene_release,
>  	.sleep = helene_sleep,
> -	.set_params = helene_set_params,
> +	.set_params = helene_set_params_t,
>  	.get_frequency = helene_get_frequency,
>  };
>  
> @@ -871,6 +884,20 @@ static const struct dvb_tuner_ops helene_tuner_ops_s = {
>  	.get_frequency = helene_get_frequency,
>  };
>  
> +static const struct dvb_tuner_ops helene_tuner_ops = {
> +	.info = {
> +		.name = "Sony HELENE Sat/Ter tuner",
> +		.frequency_min = 500000,
> +		.frequency_max = 1200000000,
> +		.frequency_step = 1000,
> +	},
> +	.init = helene_init,
> +	.release = helene_release,
> +	.sleep = helene_sleep,
> +	.set_params = helene_set_params,
> +	.get_frequency = helene_get_frequency,
> +};

About the same issue as I commented on your driver: this is
wrong.

See, for ISDB-T, frequencies are interpreted in Hz. The above
says that this device would be able to range frequencies
between 500 kHz to 1.2 MHz. I doubt that this silicon would be
a frequency of 500 kHz!

For ISDB-S, that would mean a range from 500 MHz to 1.2 GHz.
Again, that's wrong.

The frequency step will also be interpreted wrong (either
for ISDB-T or ISDB-S).

I see two possible fixes for it:

1) Consider all frequencies in Hz for the .info field. That will
require touching all satellite drivers to multiply frequencies
by 1000. It will also require fixing a DVBv3 backward code for
FE_GET_INFO, as userspace expect those values in kHZ.

The change at the core should be simple, but it will require touching
all satellite drivers, in order to consider the frequency in Hz.

Also, it will be hacky, as it will be abusing the DVBv3 uAPI
struct.

2) Apply the enclosed patch at the headers, and adjust everything to work
with frequencies in Hz.

The changes will be large, as all frontend drivers will require changes,
but it will provide a better long term solution.

Perhaps we could do a mid-term approach, adding the new fields in
order to be used by new drivers.

Regards,
Mauro

diff --git a/include/media/dvb_frontend.h b/include/media/dvb_frontend.h
index 331c8269c00e..6c5b919552db 100644
--- a/include/media/dvb_frontend.h
+++ b/include/media/dvb_frontend.h
@@ -73,22 +73,19 @@ struct dvb_frontend;
  * struct dvb_tuner_info - Frontend name and min/max ranges/bandwidths
  *
  * @name:		name of the Frontend
- * @frequency_min:	minimal frequency supported
- * @frequency_max:	maximum frequency supported
- * @frequency_step:	frequency step
+ * @frequency_min_hz:	minimal frequency supported in Hz
+ * @frequency_max_hz:	maximum frequency supported in Hz
+ * @frequency_step_hz:	frequency step in Hz
  * @bandwidth_min:	minimal frontend bandwidth supported
  * @bandwidth_max:	maximum frontend bandwidth supported
  * @bandwidth_step:	frontend bandwidth step
- *
- * NOTE: frequency parameters are in Hz, for terrestrial/cable or kHz for
- * satellite.
  */
 struct dvb_tuner_info {
 	char name[128];
 
-	u32 frequency_min;
-	u32 frequency_max;
-	u32 frequency_step;
+	u32 frequency_min_hz;
+	u32 frequency_max_hz;
+	u32 frequency_step_hz;
 
 	u32 bandwidth_min;
 	u32 bandwidth_max;
@@ -403,7 +400,15 @@ struct dtv_frontend_properties;
  * @analog_ops:		pointer to &struct analog_demod_ops
  */
 struct dvb_frontend_ops {
-	struct dvb_frontend_info info;
+	char       name[128];
+	__u32      frequency_min_hz;
+	__u32      frequency_max_hz;
+	__u32      frequency_stepsize_hz;
+	__u32      frequency_tolerance_hz;
+	__u32      symbol_rate_min;
+	__u32      symbol_rate_max;
+	__u32      symbol_rate_tolerance;
+	enum fe_caps caps;
 
 	u8 delsys[MAX_DELSYS];

Thanks,
Mauro
