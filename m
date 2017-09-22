Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38245 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbdIVUA4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 16:00:56 -0400
Received: by mail-pf0-f194.google.com with SMTP id a7so851624pfj.5
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 13:00:56 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] [media] imx: ask source subdevice for number of
 active data lanes
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>
References: <20170921153055.16206-2-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1e29bdb1-380d-858d-7da8-c791667002bd@gmail.com>
Date: Fri, 22 Sep 2017 13:00:53 -0700
MIME-Version: 1.0
In-Reply-To: <20170921153055.16206-2-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/21/2017 08:30 AM, Philipp Zabel wrote:
> Temporarily use g_mbus_config() to determine the number of active data
> lanes used by the transmitter. If g_mbus_config is not supported or
> does not return the number of active lines, default to using all
> connected data lines.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

> ---
> New in v2:
>   - Use the active lanes reported via g_mbus_config(), if available, to
>     configure the CSI2_N_LANES register correctly.
> ---
>   drivers/staging/media/imx/imx6-mipi-csi2.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
> index 5061f3f524fd5..cd19730d0159c 100644
> --- a/drivers/staging/media/imx/imx6-mipi-csi2.c
> +++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
> @@ -135,10 +135,8 @@ static void csi2_enable(struct csi2_dev *csi2, bool enable)
>   	}
>   }
>   
> -static void csi2_set_lanes(struct csi2_dev *csi2)
> +static void csi2_set_lanes(struct csi2_dev *csi2, int lanes)
>   {
> -	int lanes = csi2->bus.num_data_lanes;
> -
>   	writel(lanes - 1, csi2->base + CSI2_N_LANES);
>   }
>   
> @@ -301,6 +299,9 @@ static void csi2ipu_gasket_init(struct csi2_dev *csi2)
>   
>   static int csi2_start(struct csi2_dev *csi2)
>   {
> +	const u32 mask = V4L2_MBUS_CSI2_LANE_MASK;
> +	struct v4l2_mbus_config cfg;
> +	int lanes = 0;
>   	int ret;
>   
>   	ret = clk_prepare_enable(csi2->pix_clk);
> @@ -316,7 +317,10 @@ static int csi2_start(struct csi2_dev *csi2)
>   		goto err_disable_clk;
>   
>   	/* Step 4 */
> -	csi2_set_lanes(csi2);
> +	ret = v4l2_subdev_call(csi2->src_sd, video, g_mbus_config, &cfg);
> +	if (ret == 0)
> +		lanes = (cfg.flags & mask) >> __ffs(mask);
> +	csi2_set_lanes(csi2, lanes ?: csi2->bus.num_data_lanes);
>   	csi2_enable(csi2, true);
>   
>   	/* Step 5 */
