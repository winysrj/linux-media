Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52200 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752912AbdEPNJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 09:09:30 -0400
Subject: Re: [PATCH v2 2/2] cec: add STM32 cec driver
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        yannick.fertre@st.com, alexandre.torgue@st.com,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        robh@kernel.org, hans.verkuil@cisco.com
References: <1494939383-18937-1-git-send-email-benjamin.gaignard@linaro.org>
 <1494939383-18937-3-git-send-email-benjamin.gaignard@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c1b7a339-7746-76ec-a1f4-e1bcd01fbdd0@xs4all.nl>
Date: Tue, 16 May 2017 15:09:25 +0200
MIME-Version: 1.0
In-Reply-To: <1494939383-18937-3-git-send-email-benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good, except for the logical address handling that I think is wrong:

On 16/05/17 14:56, Benjamin Gaignard wrote:
> This patch add cec driver for STM32 platforms.
> cec hardware block isn't not always used with hdmi so
> cec notifier is not implemented. That will be done later
> when STM32 DSI driver will be available.
> 
> Driver compliance has been tested with cec-ctl and cec-compliance
> tools.
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> ---
>  drivers/media/platform/Kconfig           |  11 +
>  drivers/media/platform/Makefile          |   2 +
>  drivers/media/platform/stm32/Makefile    |   1 +
>  drivers/media/platform/stm32/stm32-cec.c | 384 +++++++++++++++++++++++++++++++
>  4 files changed, 398 insertions(+)
>  create mode 100644 drivers/media/platform/stm32/Makefile
>  create mode 100644 drivers/media/platform/stm32/stm32-cec.c
> 

<snip>

> +static int stm32_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
> +{
> +	struct stm32_cec *cec = adap->priv;
> +
> +	regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
> +
> +	if (logical_addr == CEC_LOG_ADDR_INVALID)
> +		regmap_update_bits(cec->regmap, CEC_CFGR, OAR, 0);
> +	else
> +		regmap_update_bits(cec->regmap, CEC_CFGR, OAR,
> +				   (1 << logical_addr) << 16);
> +
> +	regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
> +
> +	return 0;
> +}
> +

If you allocate more than one logical address, then stm32_cec_adap_log_addr()
is called once for each LA. But right now the second call would overwrite
the first LA. Right?

Try 'cec-ctl --audio --playback' to allocate two logical addresses.

<snip>

> +static int stm32_cec_monitor_all(struct cec_adapter *adap, bool enable)
> +{
> +	struct stm32_cec *cec = adap->priv;
> +
> +	regmap_update_bits(cec->regmap, CEC_CR, CECEN, 0);
> +
> +	if (enable) {
> +		regmap_update_bits(cec->regmap, CEC_CFGR, OAR, OAR)

You shouldn't have to change the OAR mask. This would have the adapter
Ack all logical addresses.

> +		regmap_update_bits(cec->regmap, CEC_CFGR, LSTN, 0);
> +	} else {
> +		regmap_update_bits(cec->regmap, CEC_CFGR, OAR, 0);

And this would disable all logical addresses.

I would expect that only the LSTN bit was changed.

In monitoring mode it should still Ack any messages directed to us.

> +		regmap_update_bits(cec->regmap, CEC_CFGR, LSTN, LSTN);
> +	}
> +
> +	regmap_update_bits(cec->regmap, CEC_CR, CECEN, CECEN);
> +
> +	return 0;
> +}

<snip>

Regards,

	Hans
