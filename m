Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1F9C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 13:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36BA22146F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 13:20:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="qZ5xticz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfC0NUA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 09:20:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38722 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfC0NUA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 09:20:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so11143413wro.5
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2019 06:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=a1n8pGdR4cdMjnBuPgJeHe7XsTyvG7R3tjxwwyqYIBs=;
        b=qZ5xticz+1QpRi006pswjswCvMbztl/5sF/iI/jL4CzZOU+/vXpV66s8MYufcSwvKC
         nVh9V1p0RhUw11IBbRH0E3oByhF4u4A/BVQxU1knGJuAEyHWkezWigjPGuU8rSCmpnoP
         nKyKmNcn+IVrv9qbEb9a5SVQZJ2KERKottOVGRq9jvQbcFH5DjXcN4l9JNUgxazFHB/t
         jO8Z8dLRMNcZiK3RipYSB2ti69pQLU53nY5SMDfD0PhUM2YoQkD7zQuxEZtpfE2wdMqG
         lUB6krtt3O0PAmO+NjY0uzweRi9j6PCOa0YMtoVhlYdy7uwT+S9ZTo+pGlyShe+A2ykC
         oPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=a1n8pGdR4cdMjnBuPgJeHe7XsTyvG7R3tjxwwyqYIBs=;
        b=bb5NWYJa7xD8A9l+MHmtk75ppQEKkqxpNvMfMTzh8SPLRYWTT/nYYbivYlSmhe99iV
         xUw/ogLAd5vU5Q5+vZHUYaHr3jrQYNpOFmYlI+adeqeVHEZFMNgmH8JkiaB/c5rRlFJZ
         DmK5F7aK+ueC9Fhuhg02irG59Nql7Gv4uOuUuYy8byY13CRe20lGi+4F/k3BSxvTh17z
         9gdNfPfwSEyhxUaygpKstLCLSmXg5ltKErf0xqCsfkhfWlz4je35mZn7DV3CKffqVFNW
         xPfHNE0t0PUq6+IHU7ekFgSDnR5+MSV1YTAr572GS4nOw3+jUq+kG6UxnV5jW4SLgsds
         rX9A==
X-Gm-Message-State: APjAAAWAgsV/wYGaOP/RuobmSxyV8qu9jdVa9TJCztk7Lev+bi5jJZVV
        gkcKf+Dsc/in32RV9/2tJl39CA==
X-Google-Smtp-Source: APXvYqxj/03xX1CI5hEs3Zr8IbZW9BG65Mf92AitZuhUxEQd0Cv2WyELH47kjsGNyqM3kt8la3zHjg==
X-Received: by 2002:adf:fe03:: with SMTP id n3mr11788556wrr.59.1553692797211;
        Wed, 27 Mar 2019 06:19:57 -0700 (PDT)
Received: from [10.1.2.12] (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id v190sm3253022wme.18.2019.03.27.06.19.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 06:19:56 -0700 (PDT)
Subject: Re: [PATCH 2/3] media: platform: meson: Add Amlogic Meson G12A AO CEC
 Controller driver
To:     Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org
Cc:     linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190325173501.22863-1-narmstrong@baylibre.com>
 <20190325173501.22863-3-narmstrong@baylibre.com>
 <7a23915b-0696-d884-7f56-309579f67bdd@xs4all.nl>
From:   Neil Armstrong <narmstrong@baylibre.com>
Openpgp: preference=signencrypt
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <fdd9b2b3-b698-2f95-3807-86ecbe9b1051@baylibre.com>
Date:   Wed, 27 Mar 2019 14:19:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <7a23915b-0696-d884-7f56-309579f67bdd@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 27/03/2019 13:52, Hans Verkuil wrote:
> On 3/25/19 6:35 PM, Neil Armstrong wrote:
>> The Amlogic G12A SoC embeds a second CEC controller with a totally
>> different design.
>>
>> The two controller can work in the same time since the CEC line can
>> be set to two different pins on the two controllers.
>>
>> This second CEC controller is documented as "AO-CEC-B", thus the
>> registers will be named "CECB_" to differenciate with the other
>> AO-CEC driver.
>>
>> Unlike the other AO-CEC controller, this one takes the Oscillator
>> clock as input and embeds a dual-divider to provide a precise
>> 32768Hz clock for communication. This is handled by registering
>> a clock in the driver.
>>
>> Unlike the other AO-CEC controller, this controller supports setting
>> up to 15 logical adresses and supports the signal_free_time settings
>> in the transmit function.
>>
>> Unfortunately, this controller does not support "monitor" mode.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> ---
>>  drivers/media/platform/Kconfig             |  13 +
>>  drivers/media/platform/meson/Makefile      |   1 +
>>  drivers/media/platform/meson/ao-cec-g12a.c | 783 +++++++++++++++++++++
>>  3 files changed, 797 insertions(+)
>>  create mode 100644 drivers/media/platform/meson/ao-cec-g12a.c
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 4acbed189644..92ea07ddc609 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -578,6 +578,19 @@ config VIDEO_MESON_AO_CEC
>>  	  generic CEC framework interface.
>>  	  CEC bus is present in the HDMI connector and enables communication
>>  
>> +config VIDEO_MESON_G12A_AO_CEC
>> +	tristate "Amlogic Meson G12A AO CEC driver"
>> +	depends on ARCH_MESON || COMPILE_TEST
>> +	select CEC_CORE
>> +	select CEC_NOTIFIER
>> +	---help---
>> +	  This is a driver for Amlogic Meson G12A SoCs AO CEC interface.
>> +	  This driver if for the new AO-CEC module found in G12A SoCs,
>> +	  usually named AO_CEC_B in documentation.
>> +	  It uses the generic CEC framework interface.
>> +	  CEC bus is present in the HDMI connector and enables communication
>> +	  between compatible devices.
>> +
>>  config CEC_GPIO
>>  	tristate "Generic GPIO-based CEC driver"
>>  	depends on PREEMPT || COMPILE_TEST
>> diff --git a/drivers/media/platform/meson/Makefile b/drivers/media/platform/meson/Makefile
>> index 597beb8f34d1..f611c23c3718 100644
>> --- a/drivers/media/platform/meson/Makefile
>> +++ b/drivers/media/platform/meson/Makefile
>> @@ -1 +1,2 @@
>>  obj-$(CONFIG_VIDEO_MESON_AO_CEC)	+= ao-cec.o
>> +obj-$(CONFIG_VIDEO_MESON_G12A_AO_CEC)	+= ao-cec-g12a.o
>> diff --git a/drivers/media/platform/meson/ao-cec-g12a.c b/drivers/media/platform/meson/ao-cec-g12a.c
>> new file mode 100644
>> index 000000000000..8977ae994164
>> --- /dev/null
>> +++ b/drivers/media/platform/meson/ao-cec-g12a.c
>> @@ -0,0 +1,783 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +/*
>> + * Driver for Amlogic Meson AO CEC G12A Controller
>> + *
>> + * Copyright (C) 2017 Amlogic, Inc. All rights reserved
>> + * Copyright (C) 2019 BayLibre, SAS
>> + * Author: Neil Armstrong <narmstrong@baylibre.com>
>> + */
>> +

[...]

>> +
>> +static irqreturn_t meson_ao_cec_g12a_irq_thread(int irq, void *data)
>> +{
>> +	struct meson_ao_cec_g12a_device *ao_cec = data;
>> +	u32 stat;
>> +
>> +	regmap_read(ao_cec->regmap, CECB_INTR_STAT_REG, &stat);
>> +	regmap_write(ao_cec->regmap, CECB_INTR_CLR_REG, stat);
>> +
>> +	if (stat & CECB_INTR_DONE)
>> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_OK);
>> +
>> +	if (stat & CECB_INTR_EOM)
>> +		meson_ao_cec_g12a_irq_rx(ao_cec);
>> +
>> +	if (stat & CECB_INTR_NACK)
>> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_NACK);
>> +
>> +	if (stat & CECB_INTR_ARB_LOSS) {
>> +		regmap_write(ao_cec->regmap_cec, CECB_TX_CNT, 0);
>> +		regmap_update_bits(ao_cec->regmap_cec, CECB_CTRL,
>> +				   CECB_CTRL_SEND | CECB_CTRL_TYPE, 0);
>> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_ARB_LOST);
>> +	}
>> +
>> +	if (stat & CECB_INTR_INITIATOR_ERR)
>> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_NACK);
>> +
>> +	if (stat & CECB_INTR_FOLLOWER_ERR) {
>> +		regmap_write(ao_cec->regmap_cec, CECB_LOCK_BUF, 0);
>> +		cec_transmit_attempt_done(ao_cec->adap, CEC_TX_STATUS_NACK);
> 
> Any idea what CECB_INTR_INITIATOR_ERR and CECB_INTR_FOLLOWER_ERR actually
> mean? I.e. is returning NACK right here, or would TX_STATUS_ERROR be a
> better choice? I invented that status precisely for cases where there is
> an error, but we don't know what it means.
> 
> Are you sure that CECB_INTR_FOLLOWER_ERR applies to a transmit and not a
> receive? 'Follower' suggests that some error occurred while receiving
> a message. If I am right, then just ignore it.

Vendor describes it as "Follower Error interrupt flag status", indeed it
would apply to a receive nack. I'll ignore it.

> 
> Regarding CECB_INTR_INITIATOR_ERR: I suspect that this indicates a LOW
> DRIVE error situation, in which case you'd return that transmit status.

Vendor describes it as "Initiator Error interrupt flag status", I suspect it
means a generic bus error, and it should certainly be a low drive situation.

Would CEC_TX_STATUS_ERROR be more appropriate since we don't know exactly ?

> 
>> +	}
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int
>> +meson_ao_cec_g12a_set_log_addr(struct cec_adapter *adap, u8 logical_addr)
>> +{
>> +	struct meson_ao_cec_g12a_device *ao_cec = adap->priv;
>> +	int ret = 0;
>> +
>> +	if (logical_addr == CEC_LOG_ADDR_INVALID) {
>> +		ret = regmap_write(ao_cec->regmap_cec, CECB_LADD_LOW, 0);
>> +		ret = regmap_write(ao_cec->regmap_cec, CECB_LADD_HIGH, 0);
> 
> Just ignore the error codes and return 0 here.
> 
> The CEC core will WARN if this function returns anything other than 0
> when invalidating the logical addresses. It assumes this will always
> succeed.

Ok

> 
>> +	} else if (logical_addr < 8) {
>> +		ret = regmap_update_bits(ao_cec->regmap_cec, CECB_LADD_LOW,
>> +					 BIT(logical_addr),
>> +					 BIT(logical_addr));
>> +	} else {
>> +		ret = regmap_update_bits(ao_cec->regmap_cec, CECB_LADD_HIGH,
>> +					 BIT(logical_addr - 8),
>> +					 BIT(logical_addr - 8));
>> +	}
>> +
>> +	/* Always set Broadcast/Unregistered 15 address */
>> +	ret |= regmap_update_bits(ao_cec->regmap_cec, CECB_LADD_HIGH,
> 
> I'd just do:
> 
> 	if (!ret)
> 		ret = regmap_...
> 
> Error codes are not a bitmask after all.
> 
> I see that elsewhere as well.
> 
> It's OK to use |=, but then when you return from the function you
> would have to do something like:
> 
> 	return ret ? -EIO : 0;

I'll do this when errors can only come from regmap, and check each
calls for other situations.

> 
> Regards,
> 
> 	Hans

Thanks,
Neil

> 
>> +				  BIT(CEC_LOG_ADDR_UNREGISTERED - 8),
>> +				  BIT(CEC_LOG_ADDR_UNREGISTERED - 8));
>> +
>> +	return ret;
>> +}
>> +
>> +static int meson_ao_cec_g12a_transmit(struct cec_adapter *adap, u8 attempts,
>> +				 u32 signal_free_time, struct cec_msg *msg)
>> +{
>> +	struct meson_ao_cec_g12a_device *ao_cec = adap->priv;
>> +	unsigned int type;
>> +	int ret = 0;
>> +	u32 val;
>> +	int i;
>> +
>> +	/* Check if RX is in progress */
>> +	ret = regmap_read(ao_cec->regmap_cec, CECB_LOCK_BUF, &val);
>> +	if (ret)
>> +		return ret;
>> +	if (val & CECB_LOCK_BUF_EN)
>> +		return -EBUSY;
>> +
>> +	/* Check if TX Busy */
>> +	ret = regmap_read(ao_cec->regmap_cec, CECB_CTRL, &val);
>> +	if (ret)
>> +		return ret;
>> +	if (val & CECB_CTRL_SEND)
>> +		return -EBUSY;
>> +
>> +	switch (signal_free_time) {
>> +	case CEC_SIGNAL_FREE_TIME_RETRY:
>> +		type = CECB_CTRL_TYPE_RETRY;
>> +		break;
>> +	case CEC_SIGNAL_FREE_TIME_NEXT_XFER:
>> +		type = CECB_CTRL_TYPE_NEXT;
>> +		break;
>> +	case CEC_SIGNAL_FREE_TIME_NEW_INITIATOR:
>> +	default:
>> +		type = CECB_CTRL_TYPE_NEW;
>> +		break;
>> +	}
>> +
>> +	for (i = 0; i < msg->len; i++)
>> +		ret |= regmap_write(ao_cec->regmap_cec, CECB_TX_DATA00 + i,
>> +				    msg->msg[i]);
>> +
>> +	ret |= regmap_write(ao_cec->regmap_cec, CECB_TX_CNT, msg->len);
>> +	ret = regmap_update_bits(ao_cec->regmap_cec, CECB_CTRL,
>> +				 CECB_CTRL_SEND |
>> +				 CECB_CTRL_TYPE,
>> +				 CECB_CTRL_SEND |
>> +				 FIELD_PREP(CECB_CTRL_TYPE, type));
>> +
>> +	return ret;
>> +}
>> +
>> +static int meson_ao_cec_g12a_adap_enable(struct cec_adapter *adap, bool enable)
>> +{
>> +	struct meson_ao_cec_g12a_device *ao_cec = adap->priv;
>> +
>> +	meson_ao_cec_g12a_irq_setup(ao_cec, false);
>> +
>> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
>> +			   CECB_GEN_CNTL_RESET, CECB_GEN_CNTL_RESET);
>> +
>> +	if (!enable)
>> +		return 0;
>> +
>> +	/* Setup Filter */
>> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
>> +			   CECB_GEN_CNTL_FILTER_TICK_SEL |
>> +			   CECB_GEN_CNTL_FILTER_DEL,
>> +			   FIELD_PREP(CECB_GEN_CNTL_FILTER_TICK_SEL,
>> +				      CECB_GEN_CNTL_FILTER_TICK_1US) |
>> +			   FIELD_PREP(CECB_GEN_CNTL_FILTER_DEL, 7));
>> +
>> +	/* Enable System Clock */
>> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
>> +			   CECB_GEN_CNTL_SYS_CLK_EN,
>> +			   CECB_GEN_CNTL_SYS_CLK_EN);
>> +
>> +	/* Enable gated clock (Normal mode). */
>> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
>> +			   CECB_GEN_CNTL_CLK_CTRL_MASK,
>> +			    FIELD_PREP(CECB_GEN_CNTL_CLK_CTRL_MASK,
>> +				       CECB_GEN_CNTL_CLK_ENABLE));
>> +
>> +	/* Release Reset */
>> +	regmap_update_bits(ao_cec->regmap, CECB_GEN_CNTL_REG,
>> +			   CECB_GEN_CNTL_RESET, 0);
>> +
>> +	meson_ao_cec_g12a_irq_setup(ao_cec, true);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct cec_adap_ops meson_ao_cec_g12a_ops = {
>> +	.adap_enable = meson_ao_cec_g12a_adap_enable,
>> +	.adap_log_addr = meson_ao_cec_g12a_set_log_addr,
>> +	.adap_transmit = meson_ao_cec_g12a_transmit,
>> +};
>> +
>> +static int meson_ao_cec_g12a_probe(struct platform_device *pdev)
>> +{
>> +	struct meson_ao_cec_g12a_device *ao_cec;
>> +	struct platform_device *hdmi_dev;
>> +	struct device_node *np;
>> +	struct resource *res;
>> +	void __iomem *base;
>> +	int ret, irq;
>> +
>> +	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
>> +	if (!np) {
>> +		dev_err(&pdev->dev, "Failed to find hdmi node\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	hdmi_dev = of_find_device_by_node(np);
>> +	of_node_put(np);
>> +	if (hdmi_dev == NULL)
>> +		return -EPROBE_DEFER;
>> +
>> +	put_device(&hdmi_dev->dev);
>> +	ao_cec = devm_kzalloc(&pdev->dev, sizeof(*ao_cec), GFP_KERNEL);
>> +	if (!ao_cec)
>> +		return -ENOMEM;
>> +
>> +	spin_lock_init(&ao_cec->cec_reg_lock);
>> +	ao_cec->pdev = pdev;
>> +
>> +	ao_cec->notify = cec_notifier_get(&hdmi_dev->dev);
>> +	if (!ao_cec->notify)
>> +		return -ENOMEM;
>> +
>> +	ao_cec->adap = cec_allocate_adapter(&meson_ao_cec_g12a_ops, ao_cec,
>> +					    "meson_g12a_ao_cec",
>> +					    CEC_CAP_DEFAULTS,
>> +					    CEC_MAX_LOG_ADDRS);
>> +	if (IS_ERR(ao_cec->adap)) {
>> +		ret = PTR_ERR(ao_cec->adap);
>> +		goto out_probe_notify;
>> +	}
>> +
>> +	ao_cec->adap->owner = THIS_MODULE;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(base)) {
>> +		ret = PTR_ERR(base);
>> +		goto out_probe_adapter;
>> +	}
>> +
>> +	ao_cec->regmap = devm_regmap_init_mmio(&pdev->dev, base,
>> +					       &meson_ao_cec_g12a_regmap_conf);
>> +	if (IS_ERR(ao_cec->regmap)) {
>> +		ret = PTR_ERR(ao_cec->regmap);
>> +		goto out_probe_adapter;
>> +	}
>> +
>> +	ao_cec->regmap_cec = devm_regmap_init(&pdev->dev, NULL, ao_cec,
>> +					   &meson_ao_cec_g12a_cec_regmap_conf);
>> +	if (IS_ERR(ao_cec->regmap_cec)) {
>> +		ret = PTR_ERR(ao_cec->regmap_cec);
>> +		goto out_probe_adapter;
>> +	}
>> +
>> +	irq = platform_get_irq(pdev, 0);
>> +	ret = devm_request_threaded_irq(&pdev->dev, irq,
>> +					meson_ao_cec_g12a_irq,
>> +					meson_ao_cec_g12a_irq_thread,
>> +					0, NULL, ao_cec);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "irq request failed\n");
>> +		goto out_probe_adapter;
>> +	}
>> +
>> +	ao_cec->oscin = devm_clk_get(&pdev->dev, "oscin");
>> +	if (IS_ERR(ao_cec->oscin)) {
>> +		dev_err(&pdev->dev, "oscin clock request failed\n");
>> +		ret = PTR_ERR(ao_cec->oscin);
>> +		goto out_probe_adapter;
>> +	}
>> +
>> +	ret = meson_ao_cec_g12a_setup_clk(ao_cec);
>> +	if (ret)
>> +		goto out_probe_clk;
>> +
>> +	ret = clk_prepare_enable(ao_cec->core);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "core clock enable failed\n");
>> +		goto out_probe_clk;
>> +	}
>> +
>> +	device_reset_optional(&pdev->dev);
>> +
>> +	platform_set_drvdata(pdev, ao_cec);
>> +
>> +	ret = cec_register_adapter(ao_cec->adap, &pdev->dev);
>> +	if (ret < 0) {
>> +		cec_notifier_put(ao_cec->notify);
>> +		goto out_probe_core_clk;
>> +	}
>> +
>> +	/* Setup Hardware */
>> +	regmap_write(ao_cec->regmap, CECB_GEN_CNTL_REG, CECB_GEN_CNTL_RESET);
>> +
>> +	cec_register_cec_notifier(ao_cec->adap, ao_cec->notify);
>> +
>> +	return 0;
>> +
>> +out_probe_core_clk:
>> +	clk_disable_unprepare(ao_cec->core);
>> +
>> +out_probe_clk:
>> +	clk_disable_unprepare(ao_cec->oscin);
>> +
>> +out_probe_adapter:
>> +	cec_delete_adapter(ao_cec->adap);
>> +
>> +out_probe_notify:
>> +	cec_notifier_put(ao_cec->notify);
>> +
>> +	dev_err(&pdev->dev, "CEC controller registration failed\n");
>> +
>> +	return ret;
>> +}
>> +
>> +static int meson_ao_cec_g12a_remove(struct platform_device *pdev)
>> +{
>> +	struct meson_ao_cec_g12a_device *ao_cec = platform_get_drvdata(pdev);
>> +
>> +	clk_disable_unprepare(ao_cec->oscin);
>> +
>> +	cec_unregister_adapter(ao_cec->adap);
>> +
>> +	cec_notifier_put(ao_cec->notify);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id meson_ao_cec_g12a_of_match[] = {
>> +	{ .compatible = "amlogic,meson-g12a-ao-cec-b", },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, meson_ao_cec_g12a_of_match);
>> +
>> +static struct platform_driver meson_ao_cec_g12a_driver = {
>> +	.probe   = meson_ao_cec_g12a_probe,
>> +	.remove  = meson_ao_cec_g12a_remove,
>> +	.driver  = {
>> +		.name = "meson-ao-cec-g12a",
>> +		.of_match_table = of_match_ptr(meson_ao_cec_g12a_of_match),
>> +	},
>> +};
>> +
>> +module_platform_driver(meson_ao_cec_g12a_driver);
>> +
>> +MODULE_DESCRIPTION("Meson AO CEC G12A Controller driver");
>> +MODULE_AUTHOR("Neil Armstrong <narmstrong@baylibre.com>");
>> +MODULE_LICENSE("GPL");
>>
> 
> Regards,
> 
> 	Hans
> 

