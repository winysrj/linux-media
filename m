Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:28375 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750860AbdGNEgb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 00:36:31 -0400
From: "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>
CC: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: RE: [PATCH v4 1/1] i2c: Add Omnivision OV5670 5M sensor support
Date: Fri, 14 Jul 2017 04:36:27 +0000
Message-ID: <8408A4B5C50F354EA5F62D9FC805153D2C451AA6@ORSMSX115.amr.corp.intel.com>
References: <1497404348-16255-1-git-send-email-chiranjeevi.rapolu@intel.com>
 <4720ac4f89b26f2509ee3788c63f65adf093871a.1498941658.git.chiranjeevi.rapolu@intel.com>
 <6F87890CF0F5204F892DEA1EF0D77A59725D6C3C@FMSMSX114.amr.corp.intel.com>
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A59725D6C3C@FMSMSX114.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Raj,

Removed duplicate const.

Thanks,
Chiran
-----Original Message-----
From: Mani, Rajmohan 
Sent: Friday, July 7, 2017 3:49 PM
To: Rapolu, Chiranjeevi <chiranjeevi.rapolu@intel.com>; linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; tfiga@chromium.org
Cc: Zheng, Jian Xu <jian.xu.zheng@intel.com>; Yang, Hyungwoo <hyungwoo.yang@intel.com>
Subject: RE: [PATCH v4 1/1] i2c: Add Omnivision OV5670 5M sensor support

Hi Chiran,

> +
> +/* Supported link frequencies */
> +#define OV5670_LINK_FREQ_840MBPS	840000000
> +#define OV5670_LINK_FREQ_840MBPS_INDEX	0
> +static const struct ov5670_link_freq_config link_freq_configs[] = {
> +	{
> +		.pixel_rate = 336000000,
> +		.reg_list = {
> +			.num_of_regs =
> ARRAY_SIZE(mipi_data_rate_840mbps),
> +			.regs = mipi_data_rate_840mbps,
> +		}
> +	}
> +};
> +
> +static const const s64 link_freq_menu_items[] = {

	 ^ duplicated const declaration

> +	OV5670_LINK_FREQ_840MBPS
> +};
> +
