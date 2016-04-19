Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:37423 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcDSJXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2016 05:23:13 -0400
Subject: Re: [PATCH 1/2] [media] atmel-isc: add the Image Sensor Controller
 code
To: "Wu, Songjun" <songjun.wu@atmel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1460533460-32336-1-git-send-email-songjun.wu@atmel.com>
 <1460533460-32336-2-git-send-email-songjun.wu@atmel.com>
 <81160604.beJHM8QlLS@avalon> <5715E24F.8040906@atmel.com>
CC: <g.liakhovetski@gmx.de>, <linux-arm-kernel@lists.infradead.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	"Benoit Parrot" <bparrot@ti.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?Q?Richard_R=c3=b6jfors?= <richard@puffinpack.se>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <5715F90F.2000008@atmel.com>
Date: Tue, 19 Apr 2016 11:23:27 +0200
MIME-Version: 1.0
In-Reply-To: <5715E24F.8040906@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 19/04/2016 09:46, Wu, Songjun a écrit :
> 
> 
> On 4/15/2016 00:21, Laurent Pinchart wrote:
>> Hello Songjun,
>>
>> Thank you for the patch.
>>
>> On Wednesday 13 Apr 2016 15:44:19 Songjun Wu wrote:
>>> Add driver for the Image Sensor Controller. It manages
>>> incoming data from a parallel based CMOS/CCD sensor.
>>> It has an internal image processor, also integrates a
>>> triple channel direct memory access controller master
>>> interface.
>>>
>>> Signed-off-by: Songjun Wu <songjun.wu@atmel.com>

I add some tiny comments above...


>>> ---
>>>
>>>   drivers/media/platform/Kconfig                |    1 +
>>>   drivers/media/platform/Makefile               |    2 +
>>>   drivers/media/platform/atmel/Kconfig          |    9 +
>>>   drivers/media/platform/atmel/Makefile         |    3 +
>>>   drivers/media/platform/atmel/atmel-isc-regs.h |  280 +++++
>>>   drivers/media/platform/atmel/atmel-isc.c      | 1537 ++++++++++++++++++++++
>>>   6 files changed, 1832 insertions(+)
>>>   create mode 100644 drivers/media/platform/atmel/Kconfig
>>>   create mode 100644 drivers/media/platform/atmel/Makefile
>>>   create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
>>>   create mode 100644 drivers/media/platform/atmel/atmel-isc.c

[..]

>>> +static int isc_clk_enable(struct clk_hw *hw)
>>> +{
>>> +	struct isc_clk *isc_clk = to_isc_clk(hw);
>>> +	u32 id = isc_clk->id;
>>> +	struct regmap *regmap = isc_clk->regmap;
>>> +	unsigned long flags;
>>> +	u32 sr_val;
>>> +
>>> +	pr_debug("ISC CLK: %s, div = %d, parent id = %d\n",
>>> +		 __func__, isc_clk->div, isc_clk->parent_id);
>>
>> Please use dev_dbg() instead of pr_debug(). Same comment for all the other
>> pr_*() calls below.
>>
> Accept, thank you.
> 
>>> +	spin_lock_irqsave(isc_clk->lock, flags);
>>> +
>>> +	regmap_update_bits(regmap, ISC_CLKCFG,
>>> +			   ISC_CLKCFG_DIV_MASK(id) | ISC_CLKCFG_SEL_MASK(id),
>>> +			   (isc_clk->div << ISC_CLKCFG_DIV_SHIFT(id)) |
>>> +			   (isc_clk->parent_id << ISC_CLKCFG_SEL_SHIFT(id)));
>>> +
>>> +	regmap_read(regmap, ISC_CLKSR, &sr_val);
>>> +	while (sr_val & ISC_CLKSR_SIP_PROGRESS) {
>>> +		cpu_relax();
>>> +		regmap_read(regmap, ISC_CLKSR, &sr_val);
>>> +	}
>>
>> A busy loop while holding a spinlock ? Ouch... You should at least set a
>> higher bound on the number of iterations.
>>
> Accept, after the clock register is written, we need wait the SIP flag 
> before the clock register is written again, the time is very short.
> I think the number of iterations will be added when the loop is under 
> spinlock.
> Thank you.

Yes, I have the same feeling as Laurent, busy loop must be avoided while
holding a spinlock. Even outside a critical section, a way-out must
always be added (timeout, number of iterations, etc.).

There is a nice conference summary by Wolfram about that here:

http://elinux.org/Session:_Developer's_Diary:_It's_About_Time_ELCE_2011

Slides here:
http://elinux.org/images/5/54/Elce11_sang.pdf
The slide named "timeout #4" gives a comprehensive timeout function with
all the needed tricks to make it rock solid. You can also check my use
of this code template here:

http://lxr.free-electrons.com/source/drivers/net/ethernet/cadence/macb.c#L503


>>> +	regmap_update_bits(regmap, ISC_CLKEN,
>>> +			   ISC_CLKEN_EN_MASK(id),
>>> +			   ISC_CLKEN_EN << ISC_CLKEN_EN_SHIFT(id));
>>> +
>>> +	spin_unlock_irqrestore(isc_clk->lock, flags);
>>> +
>>> +	return 0;
>>> +}

[..]

>>> +static void isc_stop_streaming(struct vb2_queue *vq)
>>> +{
>>> +	struct isc_device *isc = vb2_get_drv_priv(vq);
>>> +	struct regmap *regmap = isc->regmap;
>>> +	unsigned long flags;
>>> +	struct isc_buffer *buf, *tmp;
>>> +	int ret;
>>> +	u32 val;
>>> +
>>> +	isc->stop = true;
>>> +
>>> +	/* Wait until the end of the current frame */
>>> +	regmap_read(regmap, ISC_CTRLSR, &val);
>>> +	while (val & ISC_CTRLSR_CAPTURE) {
>>> +		usleep_range(1000, 2000);
>>> +		regmap_read(regmap, ISC_CTRLSR, &val);
>>> +	}
>>
>> Can't you synchronize with the frame end interrupt  instead of using a busy
>> loop ? The code here doesn't guarantee that your frame end interrupt won't
>> race you.
>>
> The capture will be disabled automatically when a frame capture is 
> completed. When 'isc->stop' is set to true, the new frame capture will 
> not be enabled in the frame end interrupt, then the capture is disabled 
> automatically, we can synchronize the capture status by loop reading the 
> capture status register in stop_streaming function. If the frame list is 
> empty, the frame end interrupt will not be triggered, if we want to 
> synchronize with the frame end interrupt, it will not be synchronized 
> forever.
> 
> Maybe my understanding is not correct. What's your opinion?

Without having an opinion on this precise case, still, here again, no
busy loop without way-out.

>>> +	/* Disable DMA interrupt */
>>> +	regmap_update_bits(regmap, ISC_INTDIS,
>>> +			   ISC_INTDIS_DDONE_MASK, ISC_INTDIS_DDONE);

[..]


>>> +static int isc_open(struct file *file)
>>> +{
>>> +	struct isc_device *isc = video_drvdata(file);
>>> +	struct v4l2_subdev *sd = isc->current_subdev->sd;
>>> +	int ret;
>>> +	u32 val;
>>> +
>>> +	if (mutex_lock_interruptible(&isc->lock))
>>> +		return -ERESTARTSYS;
>>> +
>>> +	ret = v4l2_fh_open(file);
>>> +	if (ret < 0)
>>> +		goto unlock;
>>> +
>>> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
>>> +	if ((ret < 0) && (ret != -ENOIOCTLCMD))
>>
>> No need for inner parentheses.
>>
> Acceopt, thank you.
> 
>>> +		goto unlock;
>>> +	else
>>> +		ret = 0;
>>> +
>>> +	/* Clean the interrupt status register */
>>> +	regmap_read(isc->regmap, ISC_INTSR, &val);
>>> +
>>> +	clk_prepare_enable(isc->hclock);
>>> +	clk_prepare_enable(isc->ispck);
>>
>> You need to check the return value of those two functions (which would remove
>> the need to set ret to 0 above). A possibly good option would be to implement
>> runtime PM support and move clock enable/disable (and possible the s_power
>> call) to the runtime PM resume/suspend handlers.
>>
> Accept. Runtime PM feature will be added.
> Thank you.

Songjun, here I understand better the discussion that we had on the
phone this morning ;-)

So, Laurent I advised Songjun to not move to runtime PM right now that
the driver is under discussion and review. I said that I wouldn't add
some new feature/enhancement now while the first version of the driver
is being corrected for its first inclusion toward mainline...

Do you think that it makes sense to keep like this for now or, as you
suggested Songjun can move to runtime PM right now at the risk of
puzzling a little people who expected this driver to keep the same
feature set between reviews?

>>> +
>>> +unlock:
>>> +	mutex_unlock(&isc->lock);
>>> +	return ret;
>>> +}

[..]

>>> +static void isc_set_format(struct isc_device *isc)
>>> +{
>>> +	struct regmap *regmap = isc->regmap;
>>> +	const struct isc_format *current_fmt = isc->current_fmt;
>>> +	struct isc_subdev_entity *subdev = isc->current_subdev;
>>> +	u32 pipeline, val, mask;
>>> +
>>> +	if (sensor_is_preferred(current_fmt)) {
>>> +		val = current_fmt->reg_sd_bps;
>>> +		pipeline = 0x0;
>>> +	} else {
>>> +		val = current_fmt->reg_isc_bps;
>>> +		pipeline = current_fmt->pipeline;
>>> +
>>> +		regmap_update_bits(regmap, ISC_WB_CFG, ISC_WB_CFG_BAYCFG_MASK,
>>> +				   current_fmt->reg_wb_cfg);
>>> +		regmap_update_bits(regmap, ISC_CFA_CFG, ISC_CFA_CFG_BAY_MASK,
>>> +				   current_fmt->reg_cfa_cfg);
>>> +	}
>>> +
>>> +	val |= subdev->hsync_active | subdev->vsync_active |
>>> +	       subdev->pclk_sample | ISC_PFE_CFG0_MODE_PROGRESSIVE;
>>> +	mask = ISC_PFE_CFG0_BPS_MASK | ISC_PFE_CFG0_HPOL_MASK |
>>> +	       ISC_PFE_CFG0_VPOL_MASK | ISC_PFE_CFG0_PPOL_MASK |
>>> +	       ISC_PFE_CFG0_MODE_MASK;
>>> +
>>> +	regmap_update_bits(regmap, ISC_PFE_CFG0, mask, val);
>>> +
>>> +	regmap_update_bits(regmap, ISC_RLP_CFG, ISC_RLP_CFG_MODE_MASK,
>>> +			   current_fmt->reg_rlp_mode);
>>> +
>>> +	regmap_update_bits(regmap, ISC_DCFG, ISC_DCFG_IMODE_MASK,
>>> +			   current_fmt->reg_dcfg_imode);
>>> +
>>> +	isc_set_pipeline(regmap, pipeline);
>>> +
>>> +	/* Update profile */
>>> +	regmap_update_bits(regmap, ISC_CTRLEN,
>>> +			   ISC_CTRLEN_UPPRO_MASK, ISC_CTRLEN_UPPRO);
>>> +
>>> +	regmap_read(regmap, ISC_CTRLSR, &val);
>>> +	while (val & ISC_CTRLSR_UPPRO) {
>>> +		cpu_relax();
>>> +		regmap_read(regmap, ISC_CTRLSR, &val);
>>> +	}
>>
>> You need an exit condition here too in case the hardware gets stuck for some
>> reason. It shouldn't happen in theory, and always does in practice :-)

Absolutely.

> Accept, I will add the number of iterations or a timer. Do you think 
> which is better?

Is there any hints in the datasheet? Is the checking of CTRLSR is
advised in the datasheet as well?

Otherwise, you can contact the ISC designer to ask him what makes more
sense to him.

Laurent, thanks a lot for your valuable review!

Bye,
-- 
Nicolas Ferre
