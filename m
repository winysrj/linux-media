Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB58C43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 12:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2478720874
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 12:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="OoJKekkD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbfAKMvz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 07:51:55 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:54712 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731404AbfAKMvz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 07:51:55 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 71730513;
        Fri, 11 Jan 2019 13:51:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547211111;
        bh=I1KVxI/pNf3p3u8tn03qGTM4O8qtsdSkTZqzESVrik4=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OoJKekkDJ+/5QfA2M4i4FqdHsBdU+eYq1EdV6I1c56EX1BxwZponbGYK4UGwnasTY
         I2ka06/VCsTNyk8Ni/VJ2bDHFEf7f4ThusP7jQyTozBHSdKwwhKIAlO8MzflkrmAuI
         Qt3MSm959dcIHFwPm1H1+zYMg7KdgGWc92nIzC7E=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v4 4/4] i2c: adv748x: configure number of lanes used for
 TXA CSI-2 transmitter
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org
References: <20181129020147.22115-1-niklas.soderlund+renesas@ragnatech.se>
 <20181129020147.22115-5-niklas.soderlund+renesas@ragnatech.se>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <0e22368f-2736-3a34-f50c-1b57b5c2bf15@ideasonboard.com>
Date:   Fri, 11 Jan 2019 12:51:48 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181129020147.22115-5-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On 29/11/2018 02:01, Niklas Söderlund wrote:
> The driver fixed the TXA CSI-2 transmitter in 4-lane mode while it could
> operate using 1-, 2- and 4-lanes. Update the driver to support all
> available modes.
> 
> The driver makes use of large tables of static register/value writes
> when powering up/down the TXA and TXB transmitters which include the
> write to the NUM_LANES register. By converting the tables into functions
> and using parameters the power up/down functions for TXA and TXB power
> up/down can be merged and used for both transmitters.
> 

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Tested-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> ---
> * Changes since v3
> - Fix spelling in commit message, thanks Laurent!
> * Changes since v2
> - Fix typos in comments.
> - Remove unneeded boiler plait code in adv748x_tx_power() as suggested
>   by Jacopo and Laurent.
> - Take into account the two different register used when powering up TXA
>   and TXB due to an earlier patch in this series aligns the power
>   sequence with the manual.
> 
> * Changes since v1
> - Convert tables of register/value writes into functions instead of
>   intercepting and modifying the writes to the NUM_LANES register.
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 157 ++++++++++++-----------
>  1 file changed, 79 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 9d80d7f3062b16bc..d94c63cb6a2efdba 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -125,6 +125,16 @@ int adv748x_write(struct adv748x_state *state, u8 page, u8 reg, u8 value)
>  	return regmap_write(state->regmap[page], reg, value);
>  }
>  
> +static int adv748x_write_check(struct adv748x_state *state, u8 page, u8 reg,
> +			       u8 value, int *error)
> +{
> +	if (*error)
> +		return *error;
> +
> +	*error = adv748x_write(state, page, reg, value);
> +	return *error;
> +}
> +
>  /* adv748x_write_block(): Write raw data with a maximum of I2C_SMBUS_BLOCK_MAX
>   * size to one or more registers.
>   *
> @@ -231,79 +241,77 @@ static int adv748x_write_regs(struct adv748x_state *state,
>   * TXA and TXB
>   */
>  
> -static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] = {
> -
> -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> -	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> -	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x71, 0x33},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> -
> -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> -	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXA, 0x31, 0x80},	/* ADI Required Write */
> -
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> -
> -static const struct adv748x_reg_value adv748x_power_down_txa_4lane[] = {
> -
> -	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> -	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
> -
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> -
> -static const struct adv748x_reg_value adv748x_power_up_txb_1lane[] = {
> -
> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> -	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> -	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> -
> -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> -	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
> -	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> -	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
> -
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> -
> -static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
> -
> -	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> -	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> -	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
> -
> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> -};
> +static int adv748x_power_up_tx(struct adv748x_csi2 *tx)
> +{
> +	struct adv748x_state *state = tx->state;
> +	u8 page = is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> +	int ret = 0;
> +
> +	/* Enable n-lane MIPI */
> +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> +
> +	/* Set Auto DPHY Timing */
> +	adv748x_write_check(state, page, 0x00, 0xa0 | tx->num_lanes, &ret);
> +
> +	/* ADI Required Write */
> +	if (is_txa(tx)) {
> +		adv748x_write_check(state, page, 0xdb, 0x10, &ret);
> +		adv748x_write_check(state, page, 0xd6, 0x07, &ret);
> +	} else {
> +		adv748x_write_check(state, page, 0xd2, 0x40, &ret);
> +	}
> +
> +	adv748x_write_check(state, page, 0xc4, 0x0a, &ret);
> +	adv748x_write_check(state, page, 0x71, 0x33, &ret);
> +	adv748x_write_check(state, page, 0x72, 0x11, &ret);
> +
> +	/* i2c_dphy_pwdn - 1'b0 */
> +	adv748x_write_check(state, page, 0xf0, 0x00, &ret);
> +
> +	/* ADI Required Writes*/
> +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> +	adv748x_write_check(state, page, 0x1e, 0x40, &ret);
> +
> +	/* i2c_mipi_pll_en - 1'b1 */
> +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> +	usleep_range(2000, 2500);
> +
> +	/* Power-up CSI-TX */
> +	adv748x_write_check(state, page, 0x00, 0x20 | tx->num_lanes, &ret);
> +	usleep_range(1000, 1500);
> +
> +	/* ADI Required Writes */
> +	adv748x_write_check(state, page, 0xc1, 0x2b, &ret);
> +	usleep_range(1000, 1500);
> +	adv748x_write_check(state, page, 0x31, 0x80, &ret);
> +
> +	return ret;
> +}
> +
> +static int adv748x_power_down_tx(struct adv748x_csi2 *tx)
> +{
> +	struct adv748x_state *state = tx->state;
> +	u8 page = is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> +	int ret = 0;
> +
> +	/* ADI Required Writes */
> +	adv748x_write_check(state, page, 0x31, 0x82, &ret);
> +	adv748x_write_check(state, page, 0x1e, 0x00, &ret);
> +
> +	/* Enable n-lane MIPI */
> +	adv748x_write_check(state, page, 0x00, 0x80 | tx->num_lanes, &ret);
> +
> +	/* i2c_mipi_pll_en - 1'b1 */
> +	adv748x_write_check(state, page, 0xda, 0x01, &ret);
> +
> +	/* ADI Required Write */
> +	adv748x_write_check(state, page, 0xc1, 0x3b, &ret);
> +
> +	return ret;
> +}
>  
>  int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
>  {
> -	struct adv748x_state *state = tx->state;
> -	const struct adv748x_reg_value *reglist;
>  	int val;
>  
>  	if (!is_tx_enabled(tx))
> @@ -321,14 +329,7 @@ int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
>  	WARN_ONCE((on && val & ADV748X_CSI_FS_AS_LS_UNKNOWN),
>  			"Enabling with unknown bit set");
>  
> -	if (on)
> -		reglist = is_txa(tx) ? adv748x_power_up_txa_4lane :
> -				       adv748x_power_up_txb_1lane;
> -	else
> -		reglist = is_txa(tx) ? adv748x_power_down_txa_4lane :
> -				       adv748x_power_down_txb_1lane;
> -
> -	return adv748x_write_regs(state, reglist);
> +	return on ? adv748x_power_up_tx(tx) : adv748x_power_down_tx(tx);
>  }
>  
>  /* -----------------------------------------------------------------------------
> 

-- 
Regards
--
Kieran
