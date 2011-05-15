Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57282 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1EOJdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 05:33:21 -0400
Message-ID: <4DCF9DDA.4060600@gmail.com>
Date: Sun, 15 May 2011 11:33:14 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, kgene.kim@samsung.com,
	sungchun.kang@samsung.com, jonghun.han@samsung.com,
	stern@rowland.harvard.edu, rjw@sisk.pl
Subject: Re: [PATCH 3/3 v5] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI
 receivers
References: <1305127030-30162-1-git-send-email-s.nawrocki@samsung.com> <1305127030-30162-4-git-send-email-s.nawrocki@samsung.com> <201105141729.58363.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105141729.58363.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

thanks again for your review.

On 05/14/2011 05:29 PM, Laurent Pinchart wrote:
> On Wednesday 11 May 2011 17:17:10 Sylwester Nawrocki wrote:
>> Add the subdev driver for the MIPI CSIS units available in S5P and
>> Exynos4 SoC series. This driver supports both CSIS0 and CSIS1
>> MIPI-CSI2 receivers.
>> The driver requires Runtime PM to be enabled for proper operation.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> 
> [snip]
> 
>> diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c
>> b/drivers/media/video/s5p-fimc/mipi-csis.c new file mode 100644
>> index 0000000..d50efcb
>> --- /dev/null
>> +++ b/drivers/media/video/s5p-fimc/mipi-csis.c
>> @@ -0,0 +1,722 @@
> 
> [snip]
> 
>> +static void s5pcsis_enable_interrupts(struct csis_state *state, bool on)
>> +{
>> +	u32 val = s5pcsis_read(state, S5PCSIS_INTMSK);
>> +
>> +	val = on ? val | S5PCSIS_INTMSK_EN_ALL :
>> +		   val&  ~S5PCSIS_INTMSK_EN_ALL;
>> +	s5pcsis_write(state, S5PCSIS_INTMSK, val);
> 
> Shouldn't you clear all interrupt flags by writing to S5PCSIS_INTSRC before
> enabling interrupts, just in case ?

In the start streaming sequence the device is first reset, then the receiver
and PHY is enabled and finally interrupts are enabled. 
All interrupt sources are by default disabled after reset. 

Enabling interrupts is the last thing done in the start streaming sequence. 
By writing to S5PCSIS_INTSRC here any raised interrupt could be cleared
and possibly lost before being handled.

> 
>> +}
> 
> [snip]
> 
>> +static void s5pcsis_set_hsync_settle(struct csis_state *state, int settle)
>> +{
>> +	u32 val = s5pcsis_read(state, S5PCSIS_DPHYCTRL);
>> +
>> +	val&= ~S5PCSIS_DPHYCTRL_HSS_MASK | (settle<<  27);
> 
> Do you mean
> 
> val = (val&  ~S5PCSIS_DPHYCTRL_HSS_MASK) | (settle<<  27);
> 
> ?

Huh, naturally, yes, that was my intention.. Thank you for spotting this.
I used to have problems before when the "settle time" parameter wasn't
set properly, looks like the new boards are more tolerant.. 

> 
>> +	s5pcsis_write(state, S5PCSIS_DPHYCTRL, val);
>> +}
> 
> [snip]
> 
>> +static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh
>> *fh, +			   struct v4l2_subdev_format *fmt)
>> +{
>> +	struct csis_state *state = sd_to_csis_state(sd);
>> +	struct csis_pix_format const *csis_fmt;
>> +	struct v4l2_mbus_framefmt *mf;
>> +
>> +	mf = __s5pcsis_get_format(state, fh, fmt->pad, fmt->which);
>> +
>> +	if (fmt->pad == CSIS_PAD_SOURCE) {
>> +		if (mf) {
>> +			mutex_lock(&state->lock);
>> +			fmt->format = *mf;
>> +			mutex_unlock(&state->lock);
>> +		}
>> +		return 0;
>> +	}
>> +	csis_fmt = s5pcsis_try_format(&fmt->format);
>> +	if (mf) {
>> +		mutex_lock(&state->lock);
>> +		*mf = fmt->format;
>> +		if (mf ==&state->format) /* Store the active format */
> 
> I would replace the test by
> 
> if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
> 
> It's more explicit.

I agree, I'll change that.

> 
>> +			state->csis_fmt = csis_fmt;
>> +		mutex_unlock(&state->lock);
>> +	}
>> +	return 0;
>> +}
> 
> [snip]
> 
>> +static int s5pcsis_suspend(struct device *dev)
>> +{
>> +	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
>> +	struct csis_state *state = sd_to_csis_state(sd);
>> +	int ret;
>> +
>> +	v4l2_dbg(1, debug, sd, "%s: flags: 0x%x\n",
>> +		 __func__, state->flags);
>> +
>> +	mutex_lock(&state->lock);
>> +	if (state->flags&  ST_POWERED) {
>> +		s5pcsis_stop_stream(state);
>> +		ret = pdata->phy_enable(state->pdev, false);
>> +		if (ret)
>> +			goto unlock;
>> +
>> +		if (state->supply&&  regulator_disable(state->supply))
>> +			goto unlock;
>> +
>> +		clk_disable(state->clock[CSIS_CLK_GATE]);
>> +		state->flags&= ~ST_POWERED;
>> +	}
>> +	state->flags |= ST_SUSPENDED;
>> + unlock:
>> +	mutex_unlock(&state->lock);
>> +	return ret ? -EAGAIN : 0;
>> +}
>> +
>> +static int s5pcsis_resume(struct device *dev)
>> +{
>> +	struct s5p_platform_mipi_csis *pdata = dev->platform_data;
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
>> +	struct csis_state *state = sd_to_csis_state(sd);
>> +	int ret = 0;
>> +
>> +	v4l2_dbg(1, debug, sd, "%s: flags: 0x%x\n",
>> +		 __func__, state->flags);
>> +
>> +	mutex_lock(&state->lock);
>> +	if (!(state->flags&  ST_SUSPENDED))
>> +		goto unlock;
>> +
>> +	if (!(state->flags&  ST_POWERED)) {
> 
> If the device wasn't powered before being suspended, it should stay powered
> off.

I'm not sure, shortly after system wide resume the device is powered off by
PM runtime core anyway.
There is no other means in this driver to enable power except using pm_runtime_*
calls. The device is being powered on or off only through these runtime PM
helpers, i.e. s5pcsis_resume/s5pcsis_suspend.
(full source can be found here: http://tinyurl.com/6fozx34)

The pm_runtime_resume helper is guaranteed by the PM core to be called only
on device in 'suspended' state.

>From Documentation/power/runtime_pm.txt:
" ...
 * Once the subsystem-level resume callback has completed successfully, the PM
   core regards the device as fully operational, which means that the device
   _must_ be able to complete I/O operations as needed.  The run-time PM status
   of the device is then 'active'.
..."

If s5pcsis_resume would return 0 without really enabling device clocks and the
external voltage regulator then the runtime PM core idea about the device's 
state would be wrong.

I'm not a PM expert but documentation says that it's better to leave
device fully functional after system wide driver's resume() helper returns.

>From Documentation/power/devices.txt:

"...
When resuming from standby or memory sleep, the phases are:
		resume_noirq, resume, complete.
(...)
At the end of these phases, drivers should be as functional as they were before
suspending: I/O can be performed using DMA and IRQs, and the relevant clocks are
gated on.  Even if the device was in a low-power state before the system sleep
because of runtime power management, afterwards it should be back in its
full-power state. There are multiple reasons why it's best to do this; they are
discussed in more detail in Documentation/power/runtime_pm.txt.
..."

Unfortunately there seem to be no standard way to instruct the PM core to
enable power of a few (I2C/client platform) devices forming the video pipeline
in an arbitrary order. The parent devices of my platforms devices are already the
power domain devices. 

So it might be a good idea to forbid enabling sub-device's power when
the host driver is not using it, to have full control of the pipeline devices
power enable sequence at any time.

I perhaps need to isolate functions out from of s5pcsis_resume/suspend and then
call that in s_power op and s5pcsis_resume/suspend. Don't really like this idea
though... It would virtually render pm_runtime_* calls unusable in this sub-device
driver, those would make sense only in the host driver..

I just wanted to put all what is needed to control device's power in the PM
helpers and then use pm_runtime_* calls where required.

 
>> +		if (state->supply)
>> +			ret = regulator_enable(state->supply);
>> +		if (ret)
>> +			goto unlock;
>> +
>> +		ret = pdata->phy_enable(state->pdev, true);
>> +		if (!ret) {
>> +			state->flags |= ST_POWERED;
>> +		} else {
>> +			regulator_disable(state->supply);
>> +			goto unlock;
>> +		}
>> +		clk_enable(state->clock[CSIS_CLK_GATE]);
>> +	}
>> +	if (state->flags&  ST_STREAMING)
>> +		s5pcsis_start_stream(state);
>> +
>> +	state->flags&= ~ST_SUSPENDED;
>> + unlock:
>> +	mutex_unlock(&state->lock);
>> +	return ret ? -EAGAIN : 0;
>> +}

--
Thanks,
Sylwester Nawrocki
