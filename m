Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41792 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3H2NH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 09:07:58 -0400
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
	m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
	swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
	mturquette@linaro.org, tomasz.figa@gmail.com,
	kgene.kim@samsung.com, thomas.abraham@linaro.org,
	s.nawrocki@samsung.com, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux@arm.linux.org.uk,
	ben-linux@fluff.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/6] media: s5p-tv: Restore vpll clock rate
Date: Thu, 29 Aug 2013 15:07:52 +0200
Message-id: <6294819.7vFezjQcVy@amdc1227>
In-reply-to: <1377706384-3697-3-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377706384-3697-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377706384-3697-3-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mateusz,

Generally this patch looks good, but I have some minor nitpicks, that I 
would like to be fixed.

On Wednesday 28 of August 2013 18:13:00 Mateusz Krawczuk wrote:
> Restore vpll clock rate if start stream fail or stream is off.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  drivers/media/platform/s5p-tv/sdo_drv.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c
> b/drivers/media/platform/s5p-tv/sdo_drv.c index 0afa90f..9dbdfe6 100644
> --- a/drivers/media/platform/s5p-tv/sdo_drv.c
> +++ b/drivers/media/platform/s5p-tv/sdo_drv.c
> @@ -55,6 +55,8 @@ struct sdo_device {
>  	struct clk *dacphy;
>  	/** clock for control of VPLL */
>  	struct clk *fout_vpll;
> +	/** vpll rate before sdo stream was on */
> +	int vpll_rate;

Clock frequency should be stored in an unsigned long. (See the return type 
of clk_get_rate().)

>  	/** regulator for SDO IP power */
>  	struct regulator *vdac;
>  	/** regulator for SDO plug detection */
> @@ -193,17 +195,34 @@ static int sdo_s_power(struct v4l2_subdev *sd, int
> on)
> 
>  static int sdo_streamon(struct sdo_device *sdev)
>  {
> +	int ret;
> +
>  	/* set proper clock for Timing Generator */
> -	clk_set_rate(sdev->fout_vpll, 54000000);
> +	sdev->vpll_rate = clk_get_rate(sdev->fout_vpll);
> +	ret = clk_set_rate(sdev->fout_vpll, 54000000);
> +	if (ret < 0) {
> +		dev_err(sdev->dev,
> +			"Failed to set vpll rate!\n");
> +		return ret;
> +	}
>  	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
>  	clk_get_rate(sdev->fout_vpll));
>  	/* enable clock in SDO */
>  	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
> -	clk_enable(sdev->dacphy);
> +	ret = clk_enable(sdev->dacphy);
> +	if (ret < 0) {
> +		dev_err(sdev->dev,
> +			"clk_enable(dacphy) failed !\n");
> +		goto fail;
> +	}
>  	/* enable DAC */
>  	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
>  	sdo_reg_debug(sdev);
>  	return 0;

nit: Please insert a blank line here.

Best regards,
Tomasz

> +fail:
> +	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
> +	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
> +	return ret;
>  }
> 
>  static int sdo_streamoff(struct sdo_device *sdev)
> @@ -220,6 +239,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
>  	}
>  	if (tries == 0)
>  		dev_err(sdev->dev, "failed to stop streaming\n");
> +	clk_set_rate(sdev->fout_vpll, sdev->vpll_rate);
>  	return tries ? 0 : -EIO;
>  }

