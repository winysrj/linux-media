Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:41685 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752082AbdJTH3B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 03:29:01 -0400
Subject: Re: [PATCH] pinctrl: rockchip: Add iomux-route switching support for
 rk3288
To: Heiko Stuebner <heiko@sntech.de>, Pierre-Hugues Husson <phh@phh.me>
References: <20171013225337.5196-1-phh@phh.me>
 <CAJ-oXjQ3e1UHVGq=uV=yAK9Bu=ZoiNZaEbnHyvNtyc15RQQSKg@mail.gmail.com>
 <2009704.s5LEIeT6xV@phil> <13020229.tRmotBUImn@phil>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <52d1a9ee-a6c6-5c7f-330f-9b672be9c2c6@xs4all.nl>
Date: Fri, 20 Oct 2017 09:28:58 +0200
MIME-Version: 1.0
In-Reply-To: <13020229.tRmotBUImn@phil>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/10/17 17:39, Heiko Stuebner wrote:
> So far only the hdmi cec supports using one of two different pins
> as source, so add the route switching for it.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Just tested this on my firefly reload and it works great!

Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

I'll post some dts patches later today to fully bring up the first HDMI
output on the Firefly Reload.

Will you process this patch further to get it mainlined?

Regards,

	Hans

> ---
> If I didn't mess up any numbering, the pinctrl change should look like
> the following patch.
> 
> Hope that helps
> Heiko
> 
>  drivers/pinctrl/pinctrl-rockchip.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
> index b5cb7858ffdc..8dd49e2e144b 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -884,6 +884,24 @@ static struct rockchip_mux_route_data rk3228_mux_route_data[] = {
>  	},
>  };
>  
> +static struct rockchip_mux_route_data rk3288_mux_route_data[] = {
> +	{
> +		/* edphdmi_cecinoutt1 */
> +		.bank_num = 7,
> +		.pin = 16,
> +		.func = 2,
> +		.route_offset = 0x264,
> +		.route_val = BIT(16 + 12) | BIT(12),
> +	}, {
> +		/* edphdmi_cecinout */
> +		.bank_num = 7,
> +		.pin = 23,
> +		.func = 4,
> +		.route_offset = 0x264,
> +		.route_val = BIT(16 + 12),
> +	},
> +};
> +
>  static struct rockchip_mux_route_data rk3328_mux_route_data[] = {
>  	{
>  		/* uart2dbg_rxm0 */
> @@ -3391,6 +3409,8 @@ static struct rockchip_pin_ctrl rk3288_pin_ctrl = {
>  		.type			= RK3288,
>  		.grf_mux_offset		= 0x0,
>  		.pmu_mux_offset		= 0x84,
> +		.iomux_routes		= rk3288_mux_route_data,
> +		.niomux_routes		= ARRAY_SIZE(rk3288_mux_route_data),
>  		.pull_calc_reg		= rk3288_calc_pull_reg_and_bit,
>  		.drv_calc_reg		= rk3288_calc_drv_reg_and_bit,
>  };
> 
