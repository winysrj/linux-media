Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48688 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753287Ab2I0UTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 16:19:11 -0400
Message-ID: <5064B4BD.5090604@iki.fi>
Date: Thu, 27 Sep 2012 23:19:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: paul@pwsan.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/2] omap3isp: Configure CSI-2 phy based on platform
 data
References: <20120926215001.GA14107@valkosipuli.retiisi.org.uk> <1348696236-3470-2-git-send-email-sakari.ailus@iki.fi> <1720642.Sh1Cqyo78F@avalon>
In-Reply-To: <1720642.Sh1Cqyo78F@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

Laurent Pinchart wrote:
> On Thursday 27 September 2012 00:50:36 Sakari Ailus wrote:
>> Configure CSI-2 phy based on platform data in the ISP driver. For that, the
>> new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
>> was configured from the board code.
>>
>> This patch is dependent on "omap3: Provide means for changing CSI2 PHY
>> configuration".
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> ---
>>   drivers/media/platform/omap3isp/isp.h       |    3 -
>>   drivers/media/platform/omap3isp/ispcsiphy.c |  161 +++++++++++++-----------
>>   drivers/media/platform/omap3isp/ispcsiphy.h |   10 --
>>   3 files changed, 90 insertions(+), 84 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c
>> b/drivers/media/platform/omap3isp/ispcsiphy.c index 348f67e..1d16e66 100644
>> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
>> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
...
>> @@ -162,10 +120,72 @@ static int csiphy_config(struct isp_csiphy *phy,
>>   	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
>>   		return -EINVAL;
>>
>> -	mutex_lock(&phy->mutex);
>> -	phy->dphy = *dphy;
>> -	phy->lanes = *lanes;
>> -	mutex_unlock(&phy->mutex);
>> +	switch (subdevs->interface) {
>> +	case ISP_INTERFACE_CSI2A_PHY2:
>> +		phy_num = OMAP3_CTRL_CSI2_PHY2_CSI2A;
>> +		break;
>> +	case ISP_INTERFACE_CSI2C_PHY1:
>> +		phy_num = OMAP3_CTRL_CSI2_PHY1_CSI2C;
>> +		break;
>> +	case ISP_INTERFACE_CCP2B_PHY1:
>> +		phy_num = OMAP3_CTRL_CSI2_PHY1_CCP2B;
>> +		break;
>> +	case ISP_INTERFACE_CCP2B_PHY2:
>> +		phy_num = OMAP3_CTRL_CSI2_PHY2_CCP2B;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	omap3_ctrl_csi2_phy_cfg(phy_num, true, 0);
>> +
>> +	/* DPHY timing configuration */
>> +	/* CSI-2 is DDR and we only count used lanes. */
>> +	csi2_ddrclk_khz = pipe->external_rate / 1000
>> +		/ (2 * hweight32(used_lanes)) * pipe->external_width;
>
> Board code previously used op_sys_clk_freq_hz / 1000 / (2 *
> hweight32(used_lanes)). Looking at the SMIA++ PLL code, pipe->external_rate is
> equal to op_sys_clk_freq_hz / bits_per_pixel * lane_op_clock_ratio. Both
> values are identical if lane_op_clock_ratio is set to 1, which is the case if
> the SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE quirk is not set. Have you
> verified that the new CSI2 DDR clock frequency calculation is correct when the
> quirk is set ?

Good point. The presence of that quirk flag means that the bit rate (or 
clock) is per-lane, and not all lanes together as it should be. This is 
why the value is multiplied by the number of lanes. It should have no 
visibility outside the SMIA++ driver itself; if it does, then it's a bug 
in the SMIA++ driver.

>> +	reg = isp_reg_readl(csi2->isp, csi2->phy->phy_regs, ISPCSIPHY_REG0);
>
> Isn't csi2->phy == phy ? You could then just write
>
> 	reg = isp_reg_readl(phy->isp, phy->phy_regs, ISPCSIPHY_REG0);
>
> and similarly below.

Fixed.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
