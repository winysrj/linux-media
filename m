Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58509 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1EOVJD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 17:09:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [PATCH 3/3 v5] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers
Date: Sun, 15 May 2011 23:10:06 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, kgene.kim@samsung.com,
	sungchun.kang@samsung.com, jonghun.han@samsung.com,
	stern@rowland.harvard.edu, rjw@sisk.pl
References: <1305127030-30162-1-git-send-email-s.nawrocki@samsung.com> <201105141729.58363.laurent.pinchart@ideasonboard.com> <4DCF9DDA.4060600@gmail.com>
In-Reply-To: <4DCF9DDA.4060600@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105152310.07178.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

On Sunday 15 May 2011 11:33:14 Sylwester Nawrocki wrote:
> On 05/14/2011 05:29 PM, Laurent Pinchart wrote:
> > On Wednesday 11 May 2011 17:17:10 Sylwester Nawrocki wrote:

[snip]

> >> +static int s5pcsis_suspend(struct device *dev)
> >> +{
> >> +	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
> >> +	struct platform_device *pdev = to_platform_device(dev);
> >> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
> >> +	struct csis_state *state = sd_to_csis_state(sd);
> >> +	int ret;
> >> +
> >> +	v4l2_dbg(1, debug, sd, "%s: flags: 0x%x\n",
> >> +		 __func__, state->flags);
> >> +
> >> +	mutex_lock(&state->lock);
> >> +	if (state->flags&  ST_POWERED) {
> >> +		s5pcsis_stop_stream(state);
> >> +		ret = pdata->phy_enable(state->pdev, false);
> >> +		if (ret)
> >> +			goto unlock;
> >> +
> >> +		if (state->supply&&  regulator_disable(state->supply))
> >> +			goto unlock;
> >> +
> >> +		clk_disable(state->clock[CSIS_CLK_GATE]);
> >> +		state->flags&= ~ST_POWERED;
> >> +	}
> >> +	state->flags |= ST_SUSPENDED;
> >> + unlock:
> >> +	mutex_unlock(&state->lock);
> >> +	return ret ? -EAGAIN : 0;
> >> +}
> >> +
> >> +static int s5pcsis_resume(struct device *dev)
> >> +{
> >> +	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
> >> +	struct platform_device *pdev = to_platform_device(dev);
> >> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
> >> +	struct csis_state *state = sd_to_csis_state(sd);
> >> +	int ret = 0;
> >> +
> >> +	v4l2_dbg(1, debug, sd, "%s: flags: 0x%x\n",
> >> +		 __func__, state->flags);
> >> +
> >> +	mutex_lock(&state->lock);
> >> +	if (!(state->flags&  ST_SUSPENDED))
> >> +		goto unlock;
> >> +
> >> +	if (!(state->flags&  ST_POWERED)) {
> > 
> > If the device wasn't powered before being suspended, it should stay
> > powered off.
> 
> I'm not sure, shortly after system wide resume the device is powered off by
> PM runtime core anyway.
> There is no other means in this driver to enable power except using
> pm_runtime_* calls. The device is being powered on or off only through
> these runtime PM helpers, i.e. s5pcsis_resume/s5pcsis_suspend.
> (full source can be found here: http://tinyurl.com/6fozx34)

OK, it should be fine then.

> The pm_runtime_resume helper is guaranteed by the PM core to be called only
> on device in 'suspended' state.
> 
> From Documentation/power/runtime_pm.txt:
> " ...
>  * Once the subsystem-level resume callback has completed successfully, the
> PM core regards the device as fully operational, which means that the
> device _must_ be able to complete I/O operations as needed.  The run-time
> PM status of the device is then 'active'.
> ..."
> 
> If s5pcsis_resume would return 0 without really enabling device clocks and
> the external voltage regulator then the runtime PM core idea about the
> device's state would be wrong.
> 
> I'm not a PM expert but documentation says that it's better to leave
> device fully functional after system wide driver's resume() helper returns.
> 
> From Documentation/power/devices.txt:
> 
> "...
> When resuming from standby or memory sleep, the phases are:
> 		resume_noirq, resume, complete.
> (...)
> At the end of these phases, drivers should be as functional as they were
> before suspending: I/O can be performed using DMA and IRQs, and the
> relevant clocks are gated on.  Even if the device was in a low-power state
> before the system sleep because of runtime power management, afterwards it
> should be back in its full-power state. There are multiple reasons why
> it's best to do this; they are discussed in more detail in
> Documentation/power/runtime_pm.txt.
> ..."
> 
> Unfortunately there seem to be no standard way to instruct the PM core to
> enable power of a few (I2C/client platform) devices forming the video
> pipeline in an arbitrary order. The parent devices of my platforms devices
> are already the power domain devices.
> 
> So it might be a good idea to forbid enabling sub-device's power when
> the host driver is not using it, to have full control of the pipeline
> devices power enable sequence at any time.
> 
> I perhaps need to isolate functions out from of s5pcsis_resume/suspend and
> then call that in s_power op and s5pcsis_resume/suspend. Don't really like
> this idea though... It would virtually render pm_runtime_* calls unusable
> in this sub-device driver, those would make sense only in the host driver..

I think using the pm_runtime_* calls make sense, they could replace the subdev 
s_power operation in the long term. We'll need to evaluate that (I'm not sure 
if runtime PM is available on all platforms targetted by V4L2 for instance).

> I just wanted to put all what is needed to control device's power in the PM
> helpers and then use pm_runtime_* calls where required.

-- 
Regards,

Laurent Pinchart
