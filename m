Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D7DC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 12:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D48520883
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 12:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfARMJE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 07:09:04 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51427 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727343AbfARMJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 07:09:04 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kSxIgkeYgNR5ykSxJgWKvX; Fri, 18 Jan 2019 13:09:02 +0100
Subject: Re: [PATCH 1/2] media: i2c: adv748x: Convert SW reset routine to
 function
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
 <20190111174141.12594-2-kieran.bingham+renesas@ideasonboard.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9d32186f-1024-d014-0123-d8e6a944ee12@xs4all.nl>
Date:   Fri, 18 Jan 2019 13:09:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190111174141.12594-2-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNSD6YazJc5O88HVnHXbdvnV0senHvu7dHaupa0uaMRT20LJAFcYfyCokx5CJdlBWgmnoQmVq6aZAUsnZIPsgYsb0QPGka2SNXCB+W5j59Jw3hBp3S7y
 fDECmsMauBvkjsQj85DrjqoH1O+og5riWjz8bwwN542YWryABQjQvZO5UlK/0+dimPwQhQiJ+tuoBRDb0Xr2Ywt49IE6aO3MQByyQgxUO+E2XiBZys5gzple
 cZbvlFQfNdKDEPFbELjM9FtGI3tBsJs3WgKSmadDtw8uYj8N5MkDV095ZpbQYvbYFDPflorGRBV73ezbOVTZvubu1k6G3EqwxxXtsAq5iwUC56oEIRb/AzUu
 /vjXxkwmV7FLlyz5ydoSBU/g5WrEvoE0ftAuiON1lIDMh1Qd0mDrvGk3/Hh30Jc+hxn3XD6wqA/aMefEWieytRy19V2HZ76utm+eGXpT1MbhDsHIPEwMvItz
 5zIGppFnKaz1VrjEv92zzfabwveVBXwBJbPubLlvc93wLmIuXOTNcDOSRChvmOvh5u1qmz+SX7itsqyKmoCCPW+8BJtzKGPbWoGzxmZyMwvpSuEyr9QojeB+
 nqk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/11/19 6:41 PM, Kieran Bingham wrote:
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

Hmm, this patch doesn't apply to the master branch.

Does it depend on other patches being merged first, or it is just out-of-date?

Regards,

	Hans

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
> 

