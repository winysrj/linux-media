Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49774 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbbAMSyw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 13:54:52 -0500
Message-ID: <54B569F9.2050105@iki.fi>
Date: Tue, 13 Jan 2015 20:54:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [RFC/PATCH] dvb-core: add template code for i2c binding model
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
In-Reply-To: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2014 12:49 PM, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
>
> Define a standard interface for demod/tuner i2c driver modules.
> A module client calls dvb_i2c_attach_{fe,tuner}(),
> and a module driver defines struct dvb_i2c_module_param and
> calls DEFINE_DVB_I2C_MODULE() macro.
>
> This template provides implicit module requests and ref-counting,
> alloc/free's private data structures,
> fixes the usage of clientdata of i2c devices,
> and defines the platformdata structures for passing around
> device specific config/output parameters between drivers and clients.
> These kinds of code are common to (almost) all dvb i2c drivers/client,
> but they were scattered over adapter modules and demod/tuner modules.
>
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>   drivers/media/dvb-core/Makefile       |   4 +
>   drivers/media/dvb-core/dvb_frontend.h |   1 +
>   drivers/media/dvb-core/dvb_i2c.c      | 219 ++++++++++++++++++++++++++++++++++
>   drivers/media/dvb-core/dvb_i2c.h      | 110 +++++++++++++++++
>   4 files changed, 334 insertions(+)
>   create mode 100644 drivers/media/dvb-core/dvb_i2c.c
>   create mode 100644 drivers/media/dvb-core/dvb_i2c.h
>
> diff --git a/drivers/media/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
> index 8f22bcd..271648d 100644
> --- a/drivers/media/dvb-core/Makefile
> +++ b/drivers/media/dvb-core/Makefile
> @@ -8,4 +8,8 @@ dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o 	\
>   		 dvb_ca_en50221.o dvb_frontend.o 		\
>   		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
>
> +ifneq ($(CONFIG_I2C)$(CONFIG_I2C_MODULE),)
> +dvb-core-objs += dvb_i2c.o
> +endif
> +
>   obj-$(CONFIG_DVB_CORE) += dvb-core.o
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
> index 816269e..41aae1b 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -415,6 +415,7 @@ struct dtv_frontend_properties {
>   struct dvb_frontend {
>   	struct dvb_frontend_ops ops;
>   	struct dvb_adapter *dvb;
> +	struct i2c_client *fe_cl;

IMHO that is ugly as hell. You should not add any hardware/driver things 
to DVB frontend, even more bad this adds I2C dependency to DVB frontend, 
how about some other busses... DVB frontend is *logical* entity 
representing the DVB device to system. All hardware specific things 
belongs to drivers - not the frontend at all.


>   	void *demodulator_priv;
>   	void *tuner_priv;
>   	void *frontend_priv;

regards
Antti

-- 
http://palosaari.fi/
