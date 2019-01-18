Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FCBC43444
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 12:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A545220883
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 12:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Os1kdt9h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfARM05 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 07:26:57 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:50974 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbfARM04 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 07:26:56 -0500
Received: from pendragon.ideasonboard.com (dfj612yyyyyyyyyyyyyby-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00::2])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8188053F;
        Fri, 18 Jan 2019 13:26:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547814414;
        bh=IdaC0GXTOPWM0Ary3cNTIYmsRMiG6+SbGcxZbj1kVBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Os1kdt9hgAevcCl/IGP4FIfnnPfiq/dRYh8FO0ihcahBrQIKnj/Jx1SmprUTWbV3R
         nHftHoftPSi1j4eItg4FlyZmSvEgBs/pSe+7Vzw8cvKYXjGgCdsmzCg0zd3TE36gas
         +Qe/PjcuFFv5gsXJScooVjJtxg7zLaF54YThef44=
Date:   Fri, 18 Jan 2019 14:26:54 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: i2c: adv748x: Convert SW reset routine to
 function
Message-ID: <20190118122654.GA5275@pendragon.ideasonboard.com>
References: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
 <20190111174141.12594-2-kieran.bingham+renesas@ideasonboard.com>
 <3798999.WAIpuUamas@avalon>
 <45f7e234-e79d-05b0-5bd4-54438db869b3@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45f7e234-e79d-05b0-5bd4-54438db869b3@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On Sat, Jan 12, 2019 at 04:50:32PM +0000, Kieran Bingham wrote:
> On 11/01/2019 20:15, Laurent Pinchart wrote:
> > On Friday, 11 January 2019 19:41:40 EET Kieran Bingham wrote:
> >> The ADV748x is currently reset by writting a small table of registers to
> >> the device.
> >>
> >> The table lacks documentation and contains magic values to perform the
> >> actions, including using a fake register address to introduce a delay
> >> loop.
> >>
> >> Remove the table, and convert to code, documenting the purpose of the
> >> specific writes along the way.
> >>
> >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >> ---
> >>  drivers/media/i2c/adv748x/adv748x-core.c | 32 ++++++++++++++++--------
> >>  drivers/media/i2c/adv748x/adv748x.h      | 16 ++++++++++++
> >>  2 files changed, 38 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
> >> b/drivers/media/i2c/adv748x/adv748x-core.c index 02f9c440301c..252bdb28b18b
> >> 100644
> >> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> >> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> >> @@ -389,15 +389,6 @@ static const struct media_entity_operations
> >> adv748x_media_ops = { * HW setup
> >>   */
> >>
> >> -static const struct adv748x_reg_value adv748x_sw_reset[] = {
> >> -
> >> -	{ADV748X_PAGE_IO, 0xff, 0xff},	/* SW reset */
> >> -	{ADV748X_PAGE_WAIT, 0x00, 0x05},/* delay 5 */
> >> -	{ADV748X_PAGE_IO, 0x01, 0x76},	/* ADI Required Write */
> >> -	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
> >> -	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> >> -};
> >> -
> >>  /* Initialize CP Core with RGB888 format. */
> >>  static const struct adv748x_reg_value adv748x_init_hdmi[] = {
> >>  	/* Disable chip powerdown & Enable HDMI Rx block */
> >> @@ -474,12 +465,33 @@ static const struct adv748x_reg_value
> >> adv748x_init_afe[] = { {ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register
> >> table */
> >>  };
> >>
> >> +static int adv748x_sw_reset(struct adv748x_state *state)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = io_write(state, ADV748X_IO_REG_FF, ADV748X_IO_REG_FF_MAIN_RESET);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	usleep_range(5000, 6000);
> >> +
> >> +	/* Disable CEC Wakeup from power-down mode */
> >> +	ret = io_clrset(state, ADV748X_IO_REG_01, ADV748X_IO_REG_01_PWRDN_MASK,
> >> +			ADV748X_IO_REG_01_PWRDNB);
> > 
> > What's the reason for io_clrset() instead of io_write() ?
> > 
> 
> The register is multi-purpose, and controls CEC Wakeup and *part* of the
> prog_xtal_freq clock parameters.
> 
> The original table writes the default value of the clock parameter - but
> that itself is split over two registers I think - so I didn't want to be
> 'half setting' some parameter, which should already be at its default
> anyway.
> 
> I felt it was cleaner to be precise and make this code perform only the
> actual *change* that was required (which is the adjustment of the cec
> powerdown mode control, as described by the comment).

I agree with you in general, but as the write comes just after a reset,
I thought a full register write would be better. Up to you.

> > Apart from this,
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	/* Enable I2C Read Auto-Increment for consecutive reads */
> >> +	return io_write(state, ADV748X_IO_REG_F2,
> >> +			ADV748X_IO_REG_F2_READ_AUTO_INC);
> >> +}
> >> +
> >>  static int adv748x_reset(struct adv748x_state *state)
> >>  {
> >>  	int ret;
> >>  	u8 regval = 0;
> >>
> >> -	ret = adv748x_write_regs(state, adv748x_sw_reset);
> >> +	ret = adv748x_sw_reset(state);
> >>  	if (ret < 0)
> >>  		return ret;
> >>
> >> diff --git a/drivers/media/i2c/adv748x/adv748x.h
> >> b/drivers/media/i2c/adv748x/adv748x.h index b00c1995efb0..2f8d751cfbb0
> >> 100644
> >> --- a/drivers/media/i2c/adv748x/adv748x.h
> >> +++ b/drivers/media/i2c/adv748x/adv748x.h
> >> @@ -211,6 +211,11 @@ struct adv748x_state {
> >>  #define ADV748X_IO_PD			0x00	/* power down controls */
> >>  #define ADV748X_IO_PD_RX_EN		BIT(6)
> >>
> >> +#define ADV748X_IO_REG_01		0x01	/* pwrdn{2}b, prog_xtal_freq */
> >> +#define ADV748X_IO_REG_01_PWRDN_MASK	(BIT(7) | BIT(6))
> >> +#define ADV748X_IO_REG_01_PWRDN2B	BIT(7)	/* CEC Wakeup Support */
> >> +#define ADV748X_IO_REG_01_PWRDNB	BIT(6)	/* CEC Wakeup Support */
> >> +
> >>  #define ADV748X_IO_REG_04		0x04
> >>  #define ADV748X_IO_REG_04_FORCE_FR	BIT(0)	/* Force CP free-run */
> >>
> >> @@ -229,8 +234,19 @@ struct adv748x_state {
> >>  #define ADV748X_IO_CHIP_REV_ID_1	0xdf
> >>  #define ADV748X_IO_CHIP_REV_ID_2	0xe0
> >>
> >> +#define ADV748X_IO_REG_F2		0xf2
> >> +#define ADV748X_IO_REG_F2_READ_AUTO_INC	BIT(0)
> >> +
> >> +/* For PAGE slave address offsets */
> >>  #define ADV748X_IO_SLAVE_ADDR_BASE	0xf2
> >>
> >> +/*
> >> + * The ADV748x_Recommended_Settings_PrA_2014-08-20.pdf details both 0x80
> >> and + * 0xff as examples for performing a software reset.
> >> + */
> >> +#define ADV748X_IO_REG_FF		0xff
> >> +#define ADV748X_IO_REG_FF_MAIN_RESET	0xff
> >> +
> >>  /* HDMI RX Map */
> >>  #define ADV748X_HDMI_LW1		0x07	/* line width_1 */
> >>  #define ADV748X_HDMI_LW1_VERT_FILTER	BIT(7)

-- 
Regards,

Laurent Pinchart
