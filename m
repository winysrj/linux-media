Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:60872 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753146AbdLMOAS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 09:00:18 -0500
Subject: Re: [PATCH v10 4/4] [media] platform: Add Synopsys DesignWare HDMI RX
 Controller Driver
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <cover.1513013948.git.joabreu@synopsys.com>
 <5f9eedfd6f91ed73ef0bb6d3977588d01478909f.1513013948.git.joabreu@synopsys.com>
 <108e2c3c-243f-cd67-2df7-57541b28ca39@xs4all.nl>
 <635e7d70-0edb-7506-c268-9ebbae1eb39e@synopsys.com>
 <ca5b3cf7-c7d0-36d4-08ac-32a7a00afd7d@xs4all.nl>
CC: Joao Pinto <Joao.Pinto@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sylwester Nawrocki" <snawrocki@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Philippe Ombredanne <pombredanne@nexb.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <f5341c4b-43e2-12f6-9c9f-2385d47bb2fd@synopsys.com>
Date: Wed, 13 Dec 2017 14:00:08 +0000
MIME-Version: 1.0
In-Reply-To: <ca5b3cf7-c7d0-36d4-08ac-32a7a00afd7d@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 13-12-2017 10:00, Hans Verkuil wrote:
> On 12/12/17 17:02, Jose Abreu wrote:
>>
>>>> +static int dw_hdmi_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
>>>> +		u32 config)
>>>> +{
>>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>>> +
>>>> +	if (!has_signal(dw_dev, input))
>>>> +		return -EINVAL;
>>> Why would this be a reason to reject this? There may be no signal now, but a signal
>>> might appear later.
>> I would expect s_routing to only be called if there is an input
>> connected, otherwise we are just wasting resources by trying to
>> equalize an input that is not present ... I can remove the "if"
>> as there are other safe guards for this though (for example g_fmt
>> will return an error) ...
> No, s_routing is typically called as a result of a VIDIOC_S_INPUT
> call, and that can come whether or not there is a signal on an
> input. In fact, initially the first input is always selected anyway,
> whether or not there is a signal.
>
> g_fmt will just return the current configured format, this is unrelated
> to whether or not there is a signal.
>
> The only times the driver checks whether or not there is a signal (and
> what that is) are:
>
> 1) g_input_status
> 2) query_dv_timings
> 3) when the irq detects a signal change and sends V4L2_EVENT_SOURCE_CHANGE

Ok, I will remove the checks then.

>
>>>> +	msleep(50); /* Wait for 1 field */
>>> How do you know this waits for 1 field? Or is this: "Wait for at least 1 field"?
>> Its wait at least for 1 field. This is over-generous because its
>> assuming the frame rate is 20fps (which in HDMI does not happen).
> With custom timings it can happen (i.e. a 15 fps stream). Admittedly, it's not
> common, but people sometimes use it.
>
>>> I don't know exactly how the IP does this, but it looks fishy to me. If it is
>>> correct, then it could use a few comments about what is going on here as it is
>>> not obvious.
>> The IP updates the values at each field but I need to change this
>> register to populate all values in the bt struct.
> How do you know which field (top or bottom) you've captured? How do you know you
> didn't miss e.g. the bottom field and instead end up with two top field measurements?
>
> The top and bottom field are almost, but not quite the same. Typically the vertical
> backporch of the fields differs by 1 where the second field's backporch is larger by 1 line.
>
>>> And what happens if the framerate is even slower? You know the pixelclock and
>>> total width+height, so you can calculate the framerate from that.
>> Hmm, but then I have to consider pixelclk error, msleep error, ...
> But you have that now as well.
>
> An alternative is to measure a single field and deduce the backporch values from that.
>
> At least for all the common HDMI interlaced formats il_vbackporch is an even value and
> vbackporch is il_vbackporch - 1.
>
> So if you get an even backporch, then you found il_vbackporch, and if it is odd, then
> you found vbackporch.
>
>>>> +	bt->vsync = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>>> +
>>>> +	hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
>>>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>>>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>>>> +	msleep(50); /* Wait for 1 field */
>>>> +	bt->vbackporch = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>>> +	bt->vfrontporch = vtot - bt->height - bt->vsync - bt->vbackporch;
>>>> +
>>>> +	if (bt->interlaced == V4L2_DV_INTERLACED) {
>>>> +		hdmi_mask_writel(dw_dev, 0x1, HDMI_MD_VCTRL,
>>>> +				HDMI_MD_VCTRL_V_MODE_OFFSET,
>>>> +				HDMI_MD_VCTRL_V_MODE_MASK);
>>>> +		msleep(100); /* Wait for 2 fields */
>>>> +
>>>> +		vtot = hdmi_readl(dw_dev, HDMI_MD_VTL);
>>>> +		hdmi_mask_writel(dw_dev, 0x1, HDMI_MD_VCTRL,
>>>> +				HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>>>> +				HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>>>> +		msleep(50); /* Wait for 1 field */
>>>> +		bt->il_vsync = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>>> +
>>>> +		hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
>>>> +				HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>>>> +				HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>>>> +		msleep(50);
>>>> +		bt->il_vbackporch = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>>> +		bt->il_vfrontporch = vtot - bt->height - bt->il_vsync -
>>>> +			bt->il_vbackporch;
>>>> +
>>>> +		hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
>>>> +				HDMI_MD_VCTRL_V_MODE_OFFSET,
>>>> +				HDMI_MD_VCTRL_V_MODE_MASK);
>>> Same here, I'm not sure this is correct. What is the output of
>>> 'v4l2-ctl --query-dv-timings' when you feed it a standard interlaced format?
>> I used v4l2-ctl --log-status with interlaced format and
>> everything seemed correct ...
> Can you show a few examples? Is vbackport odd? And is il_vbackporch equal to vbackporch + 1?
>
> Interlaced is tricky :-)

Indeed. I compared the values with the spec and they are not
correct. Even hsync is wrong. I already corrected in the code the
hsync but regarding interlace I'm not seeing an easy way to do
this without using interrupts in each vsync because the register
I was toggling does not behave as I expected (I misunderstood the
databook). Maybe we should not detect interlaced modes for now?
Or not fill the il_ fields?

Best Regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
>
