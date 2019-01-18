Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766F0C43612
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C6A22087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:34:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MByDRdW+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfARNeG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 08:34:06 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:51808 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfARNeF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 08:34:05 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A4A2653E;
        Fri, 18 Jan 2019 14:34:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547818444;
        bh=UO2eqxSRVpdDlcgerXyVi6c7BVe/342jsk020ti3yQQ=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=MByDRdW+jOpaVsAcvIGysI1q0wyvV+1mzVPq1CTB1WhbQWWPr1l+zNdn48UhntOX+
         Andu4AFi6KbZY5Jm2Yf5Ixq+yLjD5M49osn4inA+Aka44J1ingDGk8lNT1UHUcVyEc
         g5iEOeF4Ai9gV+EBnupw5jKngL1aO+kMftZ9JKtE=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 1/2] media: i2c: adv748x: Convert SW reset routine to
 function
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
 <20190111174141.12594-2-kieran.bingham+renesas@ideasonboard.com>
 <9d32186f-1024-d014-0123-d8e6a944ee12@xs4all.nl>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <12e24971-e5e7-dc80-ebfc-8e789d114ddb@ideasonboard.com>
Date:   Fri, 18 Jan 2019 13:34:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <9d32186f-1024-d014-0123-d8e6a944ee12@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 18/01/2019 12:09, Hans Verkuil wrote:
> On 1/11/19 6:41 PM, Kieran Bingham wrote:
>> The ADV748x is currently reset by writting a small table of registers to
>> the device.

s/writting/writing/

>>
>> The table lacks documentation and contains magic values to perform the
>> actions, including using a fake register address to introduce a delay
>> loop.
>>
>> Remove the table, and convert to code, documenting the purpose of the
>> specific writes along the way.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Hmm, this patch doesn't apply to the master branch.
> 
> Does it depend on other patches being merged first, or it is just out-of-date?


Hi Hans,

Sorry - I should have specified - They are dependant upon Jacopo's series.

--
Kieran

> 
> Regards,
> 
> 	Hans
> 
>> ---
>>  drivers/media/i2c/adv748x/adv748x-core.c | 32 ++++++++++++++++--------
>>  drivers/media/i2c/adv748x/adv748x.h      | 16 ++++++++++++
>>  2 files changed, 38 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>> index 02f9c440301c..252bdb28b18b 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>> @@ -389,15 +389,6 @@ static const struct media_entity_operations adv748x_media_ops = {
>>   * HW setup
>>   */
>>  
>> -static const struct adv748x_reg_value adv748x_sw_reset[] = {
>> -
>> -	{ADV748X_PAGE_IO, 0xff, 0xff},	/* SW reset */
>> -	{ADV748X_PAGE_WAIT, 0x00, 0x05},/* delay 5 */
>> -	{ADV748X_PAGE_IO, 0x01, 0x76},	/* ADI Required Write */
>> -	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
>> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>> -};
>> -
>>  /* Initialize CP Core with RGB888 format. */
>>  static const struct adv748x_reg_value adv748x_init_hdmi[] = {
>>  	/* Disable chip powerdown & Enable HDMI Rx block */
>> @@ -474,12 +465,33 @@ static const struct adv748x_reg_value adv748x_init_afe[] = {
>>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>>  };
>>  
>> +static int adv748x_sw_reset(struct adv748x_state *state)
>> +{
>> +	int ret;
>> +
>> +	ret = io_write(state, ADV748X_IO_REG_FF, ADV748X_IO_REG_FF_MAIN_RESET);
>> +	if (ret)
>> +		return ret;
>> +
>> +	usleep_range(5000, 6000);
>> +
>> +	/* Disable CEC Wakeup from power-down mode */
>> +	ret = io_clrset(state, ADV748X_IO_REG_01, ADV748X_IO_REG_01_PWRDN_MASK,
>> +			ADV748X_IO_REG_01_PWRDNB);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Enable I2C Read Auto-Increment for consecutive reads */
>> +	return io_write(state, ADV748X_IO_REG_F2,
>> +			ADV748X_IO_REG_F2_READ_AUTO_INC);
>> +}
>> +
>>  static int adv748x_reset(struct adv748x_state *state)
>>  {
>>  	int ret;
>>  	u8 regval = 0;
>>  
>> -	ret = adv748x_write_regs(state, adv748x_sw_reset);
>> +	ret = adv748x_sw_reset(state);
>>  	if (ret < 0)
>>  		return ret;
>>  
>> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
>> index b00c1995efb0..2f8d751cfbb0 100644
>> --- a/drivers/media/i2c/adv748x/adv748x.h
>> +++ b/drivers/media/i2c/adv748x/adv748x.h
>> @@ -211,6 +211,11 @@ struct adv748x_state {
>>  #define ADV748X_IO_PD			0x00	/* power down controls */
>>  #define ADV748X_IO_PD_RX_EN		BIT(6)
>>  
>> +#define ADV748X_IO_REG_01		0x01	/* pwrdn{2}b, prog_xtal_freq */
>> +#define ADV748X_IO_REG_01_PWRDN_MASK	(BIT(7) | BIT(6))
>> +#define ADV748X_IO_REG_01_PWRDN2B	BIT(7)	/* CEC Wakeup Support */
>> +#define ADV748X_IO_REG_01_PWRDNB	BIT(6)	/* CEC Wakeup Support */
>> +
>>  #define ADV748X_IO_REG_04		0x04
>>  #define ADV748X_IO_REG_04_FORCE_FR	BIT(0)	/* Force CP free-run */
>>  
>> @@ -229,8 +234,19 @@ struct adv748x_state {
>>  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
>>  #define ADV748X_IO_CHIP_REV_ID_2	0xe0
>>  
>> +#define ADV748X_IO_REG_F2		0xf2
>> +#define ADV748X_IO_REG_F2_READ_AUTO_INC	BIT(0)
>> +
>> +/* For PAGE slave address offsets */
>>  #define ADV748X_IO_SLAVE_ADDR_BASE	0xf2
>>  
>> +/*
>> + * The ADV748x_Recommended_Settings_PrA_2014-08-20.pdf details both 0x80 and
>> + * 0xff as examples for performing a software reset.
>> + */
>> +#define ADV748X_IO_REG_FF		0xff
>> +#define ADV748X_IO_REG_FF_MAIN_RESET	0xff
>> +
>>  /* HDMI RX Map */
>>  #define ADV748X_HDMI_LW1		0x07	/* line width_1 */
>>  #define ADV748X_HDMI_LW1_VERT_FILTER	BIT(7)
>>
> 

