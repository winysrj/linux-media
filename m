Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F058AC43612
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6D8820657
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:43:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="A6QqoHbX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfANOnt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:43:49 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33742 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfANOnt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:43:49 -0500
Received: by mail-lj1-f195.google.com with SMTP id v1-v6so19257588ljd.0
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 06:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=DSfZhg2rq7MMxTWVSEw2Mx7X2i3kJ7HnZ9GxiE/7ou0=;
        b=A6QqoHbX0sF/3C5X35USoWP09glE1+YmkAQ6GwjjF2cozdsVbMCEur6LsJq1U/jiH/
         zgMSQ6pmR3XT7oleD5T6woRpm1H6O5f/micP6WXechz1exIFyHnKsr0O0+TM/NHDoPjI
         mxUkzIpbMO7N/4X4AAK6Q2NbaBpC12gEPdxoWNnSOHxJYQKVO5TdsJM0Opo8+DL5lMaK
         Fjww6VUaZ5ZZUidU1sX8YsznVAbpATEbk88mQXRX0hRsdlEhnDv0cRP+hQ+NsghaTOvP
         tkCIxQzye+RSRgboMCOsrxW9RYVu1sVr7QR96pC2GCmWMNCKVEmS8RLA1ZQWg/LpitcB
         7gNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=DSfZhg2rq7MMxTWVSEw2Mx7X2i3kJ7HnZ9GxiE/7ou0=;
        b=hvrvID/NdIr/T+u9K/1xe/+7MAazLNoYU5KeF1XLtVEOlYSZUq2by22Wq5JpwKkqr/
         V3RgZCS7P/5RxlDp0xRSCJFEO6deBdHql4DMUjlEvJLlvYCtMrQFZFzyAaWhFNQhpF0F
         BsqP85ix186V2Q5b/jDSBhIvc+DFmnz8WbgLMWeUp8s68/d2XAFmlfqH9sYRjtWgRe73
         dvQuszH1XPEdexA9oKK6/06ptaqLJcFTi9u/fSEk/orDpTdVJ3AyrPzPIfQ3sdXFIp4I
         quDAAMIrQ71sa8h78GFj5jJ4aSHF+ZLGi4nx6W+nagglnNAcyoDBaCQHZUB/F5KTIatd
         uJzQ==
X-Gm-Message-State: AJcUukfVBafTWdaNqx57uqnKqSGIvVrlQlGy4JOgZEZgAC059vHPfCXF
        WCe/c5xezTKA5WMYrfqMAJiajQ==
X-Google-Smtp-Source: ALg8bN5Wq59Rvb7BWmsuzm7xy2pu19ugLpKUn+DWQq0EaUQMowtjKJbH5M02azslxxdEeZmLVoZ5tQ==
X-Received: by 2002:a2e:6f11:: with SMTP id k17-v6mr14326100ljc.94.1547477026759;
        Mon, 14 Jan 2019 06:43:46 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id h203sm111897lfe.44.2019.01.14.06.43.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 06:43:45 -0800 (PST)
Date:   Mon, 14 Jan 2019 15:43:45 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: i2c: adv748x: Convert SW reset routine to
 function
Message-ID: <20190114144345.GG30160@bigcity.dyn.berto.se>
References: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
 <20190111174141.12594-2-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190111174141.12594-2-kieran.bingham+renesas@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

Thanks for your work.

On 2019-01-11 17:41:40 +0000, Kieran Bingham wrote:
> The ADV748x is currently reset by writting a small table of registers to
> the device.
> 
> The table lacks documentation and contains magic values to perform the
> actions, including using a fake register address to introduce a delay
> loop.
> 
> Remove the table, and convert to code, documenting the purpose of the
> specific writes along the way.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 32 ++++++++++++++++--------
>  drivers/media/i2c/adv748x/adv748x.h      | 16 ++++++++++++
>  2 files changed, 38 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 02f9c440301c..252bdb28b18b 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -389,15 +389,6 @@ static const struct media_entity_operations adv748x_media_ops = {
>   * HW setup
>   */
>  
> -static const struct adv748x_reg_value adv748x_sw_reset[] = {
> -
> -	{ADV748X_PAGE_IO, 0xff, 0xff},	/* SW reset */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x05},/* delay 5 */
> -	{ADV748X_PAGE_IO, 0x01, 0x76},	/* ADI Required Write */
> -	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> -
>  /* Initialize CP Core with RGB888 format. */
>  static const struct adv748x_reg_value adv748x_init_hdmi[] = {
>  	/* Disable chip powerdown & Enable HDMI Rx block */
> @@ -474,12 +465,33 @@ static const struct adv748x_reg_value adv748x_init_afe[] = {
>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>  };
>  
> +static int adv748x_sw_reset(struct adv748x_state *state)
> +{
> +	int ret;
> +
> +	ret = io_write(state, ADV748X_IO_REG_FF, ADV748X_IO_REG_FF_MAIN_RESET);
> +	if (ret)
> +		return ret;
> +
> +	usleep_range(5000, 6000);
> +
> +	/* Disable CEC Wakeup from power-down mode */
> +	ret = io_clrset(state, ADV748X_IO_REG_01, ADV748X_IO_REG_01_PWRDN_MASK,
> +			ADV748X_IO_REG_01_PWRDNB);
> +	if (ret)
> +		return ret;
> +
> +	/* Enable I2C Read Auto-Increment for consecutive reads */
> +	return io_write(state, ADV748X_IO_REG_F2,
> +			ADV748X_IO_REG_F2_READ_AUTO_INC);
> +}
> +
>  static int adv748x_reset(struct adv748x_state *state)
>  {
>  	int ret;
>  	u8 regval = 0;
>  
> -	ret = adv748x_write_regs(state, adv748x_sw_reset);
> +	ret = adv748x_sw_reset(state);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index b00c1995efb0..2f8d751cfbb0 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -211,6 +211,11 @@ struct adv748x_state {
>  #define ADV748X_IO_PD			0x00	/* power down controls */
>  #define ADV748X_IO_PD_RX_EN		BIT(6)
>  
> +#define ADV748X_IO_REG_01		0x01	/* pwrdn{2}b, prog_xtal_freq */
> +#define ADV748X_IO_REG_01_PWRDN_MASK	(BIT(7) | BIT(6))
> +#define ADV748X_IO_REG_01_PWRDN2B	BIT(7)	/* CEC Wakeup Support */
> +#define ADV748X_IO_REG_01_PWRDNB	BIT(6)	/* CEC Wakeup Support */
> +
>  #define ADV748X_IO_REG_04		0x04
>  #define ADV748X_IO_REG_04_FORCE_FR	BIT(0)	/* Force CP free-run */
>  
> @@ -229,8 +234,19 @@ struct adv748x_state {
>  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
>  #define ADV748X_IO_CHIP_REV_ID_2	0xe0
>  
> +#define ADV748X_IO_REG_F2		0xf2
> +#define ADV748X_IO_REG_F2_READ_AUTO_INC	BIT(0)
> +
> +/* For PAGE slave address offsets */
>  #define ADV748X_IO_SLAVE_ADDR_BASE	0xf2
>  
> +/*
> + * The ADV748x_Recommended_Settings_PrA_2014-08-20.pdf details both 0x80 and
> + * 0xff as examples for performing a software reset.
> + */
> +#define ADV748X_IO_REG_FF		0xff
> +#define ADV748X_IO_REG_FF_MAIN_RESET	0xff
> +
>  /* HDMI RX Map */
>  #define ADV748X_HDMI_LW1		0x07	/* line width_1 */
>  #define ADV748X_HDMI_LW1_VERT_FILTER	BIT(7)
> -- 
> 2.17.1
> 

-- 
Regards,
Niklas Söderlund
