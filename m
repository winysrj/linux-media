Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55725 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab1ENP3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 11:29:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 3/3 v5] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers
Date: Sat, 14 May 2011 17:29:57 +0200
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, kgene.kim@samsung.com,
	sungchun.kang@samsung.com, jonghun.han@samsung.com
References: <1305127030-30162-1-git-send-email-s.nawrocki@samsung.com> <1305127030-30162-4-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1305127030-30162-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105141729.58363.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sylwester,

On Wednesday 11 May 2011 17:17:10 Sylwester Nawrocki wrote:
> Add the subdev driver for the MIPI CSIS units available in S5P and
> Exynos4 SoC series. This driver supports both CSIS0 and CSIS1
> MIPI-CSI2 receivers.
> The driver requires Runtime PM to be enabled for proper operation.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

[snip]

> diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c
> b/drivers/media/video/s5p-fimc/mipi-csis.c new file mode 100644
> index 0000000..d50efcb
> --- /dev/null
> +++ b/drivers/media/video/s5p-fimc/mipi-csis.c
> @@ -0,0 +1,722 @@

[snip]

> +static void s5pcsis_enable_interrupts(struct csis_state *state, bool on)
> +{
> +	u32 val = s5pcsis_read(state, S5PCSIS_INTMSK);
> +
> +	val = on ? val | S5PCSIS_INTMSK_EN_ALL :
> +		   val & ~S5PCSIS_INTMSK_EN_ALL;
> +	s5pcsis_write(state, S5PCSIS_INTMSK, val);

Shouldn't you clear all interrupt flags by writing to S5PCSIS_INTSRC before 
enabling interrupts, just in case ?

> +}

[snip]

> +static void s5pcsis_set_hsync_settle(struct csis_state *state, int settle)
> +{
> +	u32 val = s5pcsis_read(state, S5PCSIS_DPHYCTRL);
> +
> +	val &= ~S5PCSIS_DPHYCTRL_HSS_MASK | (settle << 27);

Do you mean

val = (val & ~S5PCSIS_DPHYCTRL_HSS_MASK) | (settle << 27);

?

> +	s5pcsis_write(state, S5PCSIS_DPHYCTRL, val);
> +}

[snip]

> +static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> *fh, +			   struct v4l2_subdev_format *fmt)
> +{
> +	struct csis_state *state = sd_to_csis_state(sd);
> +	struct csis_pix_format const *csis_fmt;
> +	struct v4l2_mbus_framefmt *mf;
> +
> +	mf = __s5pcsis_get_format(state, fh, fmt->pad, fmt->which);
> +
> +	if (fmt->pad == CSIS_PAD_SOURCE) {
> +		if (mf) {
> +			mutex_lock(&state->lock);
> +			fmt->format = *mf;
> +			mutex_unlock(&state->lock);
> +		}
> +		return 0;
> +	}
> +	csis_fmt = s5pcsis_try_format(&fmt->format);
> +	if (mf) {
> +		mutex_lock(&state->lock);
> +		*mf = fmt->format;
> +		if (mf == &state->format) /* Store the active format */

I would replace the test by

if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)

It's more explicit.

> +			state->csis_fmt = csis_fmt;
> +		mutex_unlock(&state->lock);
> +	}
> +	return 0;
> +}

[snip]

> +static int s5pcsis_suspend(struct device *dev)
> +{
> +	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
> +	struct csis_state *state = sd_to_csis_state(sd);
> +	int ret;
> +
> +	v4l2_dbg(1, debug, sd, "%s: flags: 0x%x\n",
> +		 __func__, state->flags);
> +
> +	mutex_lock(&state->lock);
> +	if (state->flags & ST_POWERED) {
> +		s5pcsis_stop_stream(state);
> +		ret = pdata->phy_enable(state->pdev, false);
> +		if (ret)
> +			goto unlock;
> +
> +		if (state->supply && regulator_disable(state->supply))
> +			goto unlock;
> +
> +		clk_disable(state->clock[CSIS_CLK_GATE]);
> +		state->flags &= ~ST_POWERED;
> +	}
> +	state->flags |= ST_SUSPENDED;
> + unlock:
> +	mutex_unlock(&state->lock);
> +	return ret ? -EAGAIN : 0;
> +}
> +
> +static int s5pcsis_resume(struct device *dev)
> +{
> +	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
> +	struct csis_state *state = sd_to_csis_state(sd);
> +	int ret = 0;
> +
> +	v4l2_dbg(1, debug, sd, "%s: flags: 0x%x\n",
> +		 __func__, state->flags);
> +
> +	mutex_lock(&state->lock);
> +	if (!(state->flags & ST_SUSPENDED))
> +		goto unlock;
> +
> +	if (!(state->flags & ST_POWERED)) {

If the device wasn't powered before being suspended, it should stay powered 
off.

> +		if (state->supply)
> +			ret = regulator_enable(state->supply);
> +		if (ret)
> +			goto unlock;
> +
> +		ret = pdata->phy_enable(state->pdev, true);
> +		if (!ret) {
> +			state->flags |= ST_POWERED;
> +		} else {
> +			regulator_disable(state->supply);
> +			goto unlock;
> +		}
> +		clk_enable(state->clock[CSIS_CLK_GATE]);
> +	}
> +	if (state->flags & ST_STREAMING)
> +		s5pcsis_start_stream(state);
> +
> +	state->flags &= ~ST_SUSPENDED;
> + unlock:
> +	mutex_unlock(&state->lock);
> +	return ret ? -EAGAIN : 0;
> +}

[snip]

-- 
Regards,

Laurent Pinchart
