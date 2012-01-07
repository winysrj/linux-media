Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:44579 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab2AGXj6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 18:39:58 -0500
Message-ID: <4F08D7C2.3030203@maxwell.research.nokia.com>
Date: Sun, 08 Jan 2012 01:39:46 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 12/17] omap3isp: Add lane configuration to platform data
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-12-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201061106.04553.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201061106.04553.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Tuesday 20 December 2011 21:28:04 Sakari Ailus wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Add lane configuration (order of clock and data lane) to platform data on
>> both CCP2 and CSI-2.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/omap3isp/ispcsiphy.h |   15 ++-------------
>>  include/media/omap3isp.h                 |   15 +++++++++++++++
>>  2 files changed, 17 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/media/video/omap3isp/ispcsiphy.h
>> b/drivers/media/video/omap3isp/ispcsiphy.h index 9596dc6..e93a661 100644
>> --- a/drivers/media/video/omap3isp/ispcsiphy.h
>> +++ b/drivers/media/video/omap3isp/ispcsiphy.h
>> @@ -27,22 +27,11 @@
>>  #ifndef OMAP3_ISP_CSI_PHY_H
>>  #define OMAP3_ISP_CSI_PHY_H
>>
>> +#include <media/omap3isp.h>
>> +
>>  struct isp_csi2_device;
>>  struct regulator;
>>
>> -struct csiphy_lane {
>> -	u8 pos;
>> -	u8 pol;
>> -};
>> -
>> -#define ISP_CSIPHY2_NUM_DATA_LANES	2
>> -#define ISP_CSIPHY1_NUM_DATA_LANES	1
>> -
>> -struct isp_csiphy_lanes_cfg {
>> -	struct csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
>> -	struct csiphy_lane clk;
>> -};
>> -
>>  struct isp_csiphy_dphy_cfg {
>>  	u8 ths_term;
>>  	u8 ths_settle;
>> diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
>> index e917b1d..8fe0bdf 100644
>> --- a/include/media/omap3isp.h
>> +++ b/include/media/omap3isp.h
>> @@ -86,6 +86,19 @@ enum {
>>  	ISP_CCP2_MODE_CCP2 = 1,
>>  };
>>
>> +struct csiphy_lane {
>> +	u8 pos;
>> +	u8 pol;
>> +};
>> +
>> +#define ISP_CSIPHY2_NUM_DATA_LANES	2
>> +#define ISP_CSIPHY1_NUM_DATA_LANES	1
>> +
>> +struct isp_csiphy_lanes_cfg {
>> +	struct csiphy_lane data[ISP_CSIPHY2_NUM_DATA_LANES];
>> +	struct csiphy_lane clk;
>> +};
> 
> Could you please document the two structures using kerneldoc ?

Done.

>> +
>>  /**
>>   * struct isp_ccp2_platform_data - CCP2 interface platform data
>>   * @strobe_clk_pol: Strobe/clock polarity
>> @@ -105,6 +118,7 @@ struct isp_ccp2_platform_data {
>>  	unsigned int ccp2_mode:1;
>>  	unsigned int phy_layer:1;
>>  	unsigned int vpclk_div:2;
>> +	struct isp_csiphy_lanes_cfg *lanecfg;
> 
> Lane configuration is mandatory, what about embedding struct 
> isp_csiphy_lanes_cfg inside struct isp_ccp2_platform instead of having a 
> pointer ?

Done.

>>  };
>>
>>  /**
>> @@ -115,6 +129,7 @@ struct isp_ccp2_platform_data {
>>  struct isp_csi2_platform_data {
>>  	unsigned crc:1;
>>  	unsigned vpclk_div:2;
>> +	struct isp_csiphy_lanes_cfg *lanecfg;
> 
> Same here.

Ditto.

>>  };
>>
>>  struct isp_subdev_i2c_board_info {
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
