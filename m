Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:55359 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaL2I3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Dec 2014 03:29:06 -0500
Message-ID: <54A11092.7090905@atmel.com>
Date: Mon, 29 Dec 2014 16:28:02 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>, <s.nawrocki@samsung.com>,
	<festevam@gmail.com>
Subject: Re: [PATCH v4 2/5] media: ov2640: add async probe function
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <7803041.cyoUKFJAdh@avalon> <Pine.LNX.4.64.1412261006290.9254@axis700.grange> <1492726.KPKGvtrvz4@avalon>
In-Reply-To: <1492726.KPKGvtrvz4@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent and Guennadi

On 12/26/2014 6:06 PM, Laurent Pinchart wrote:
> Hi Guennadi,
>
> On Friday 26 December 2014 10:14:26 Guennadi Liakhovetski wrote:
>> On Fri, 26 Dec 2014, Laurent Pinchart wrote:
>>> On Friday 26 December 2014 14:37:14 Josh Wu wrote:
>>>> On 12/25/2014 6:39 AM, Guennadi Liakhovetski wrote:
>>>>> On Mon, 22 Dec 2014, Josh Wu wrote:
>>>>>> On 12/20/2014 6:16 AM, Guennadi Liakhovetski wrote:
>>>>>>> On Fri, 19 Dec 2014, Josh Wu wrote:
>>>>>>>> On 12/19/2014 5:59 AM, Guennadi Liakhovetski wrote:
>>>>>>>>> On Thu, 18 Dec 2014, Josh Wu wrote:
>>>>>>>>>> To support async probe for ov2640, we need remove the code to get
>>>>>>>>>> 'mclk' in ov2640_probe() function. oterwise, if soc_camera host
>>>>>>>>>> is not probed in the moment, then we will fail to get 'mclk' and
>>>>>>>>>> quit the ov2640_probe() function.
>>>>>>>>>>
>>>>>>>>>> So in this patch, we move such 'mclk' getting code to
>>>>>>>>>> ov2640_s_power() function. That make ov2640 survive, as we can
>>>>>>>>>> pass a NULL (priv-clk) to soc_camera_set_power() function.
>>>>>>>>>>
>>>>>>>>>> And if soc_camera host is probed, the when ov2640_s_power() is
>>>>>>>>>> called, then we can get the 'mclk' and that make us
>>>>>>>>>> enable/disable soc_camera host's clock as well.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>>>>>>>>>> ---
>>>>>>>>>> v3 -> v4:
>>>>>>>>>> v2 -> v3:
>>>>>>>>>> v1 -> v2:
>>>>>>>>>>       no changes.
>>>>>>>>>>   
>>>>>>>>>>   drivers/media/i2c/soc_camera/ov2640.c | 31 ++++++++++++++-------
>>>>>>>>>>   1 file changed, 21 insertions(+), 10 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/drivers/media/i2c/soc_camera/ov2640.c
>>>>>>>>>> b/drivers/media/i2c/soc_camera/ov2640.c
>>>>>>>>>> index 1fdce2f..9ee910d 100644
>>>>>>>>>> --- a/drivers/media/i2c/soc_camera/ov2640.c
>>>>>>>>>> +++ b/drivers/media/i2c/soc_camera/ov2640.c
>>>>>>>>>> @@ -739,6 +739,15 @@ static int ov2640_s_power(struct v4l2_subdev
>>>>>>>>>> *sd, int on)
>>>>>>>>>>      	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>>>>>>>>>      	struct soc_camera_subdev_desc *ssdd =
>>>>>>>>>> soc_camera_i2c_to_desc(client);
>>>>>>>>>>      	struct ov2640_priv *priv = to_ov2640(client);
>>>>>>>>>> +	struct v4l2_clk *clk;
>>>>>>>>>> +
>>>>>>>>>> +	if (!priv->clk) {
>>>>>>>>>> +		clk = v4l2_clk_get(&client->dev, "mclk");
>>>>>>>>>> +		if (IS_ERR(clk))
>>>>>>>>>> +			dev_warn(&client->dev, "Cannot get the mclk.
>>>>>>>>>> maybe soc-camera host is not probed yet.\n");
>>>>>>>>>> +		else
>>>>>>>>>> +			priv->clk = clk;
>>>>>>>>>> +	}
>>>>>>>>>>        	return soc_camera_set_power(&client->dev, ssdd, priv
>>>>>>>>>> ->clk, on);
>>>>>>>>>>      }
>>>>>> Just let me explained a little more details at first:
>>>>>>
>>>>>> As my understanding, current the priv->clk is a v4l2_clk: mclk, which
>>>>>> is a wrapper clock in soc_camera.c. it can make soc_camera to call
>>>>>> camera host's clock_start() clock_stop(). As in ov2640, the real mck
>>>>>> (pck1) is in ov2640 dt node (xvclk). So the camera host's
>>>>>> clock_start()/stop() only need to enable/disable his peripheral
>>>>>> clock.
>>>>> I'm looking at the ov2640 datasheet. In the block diagram I only see
>>>>> one input clock - the xvclk. Yes, it can be supplied by the camera
>>>>> host controller, in which case it is natural for the camera host
>>>>> driver to own and control it, or it can be a separate clock device -
>>>>> either static or configurable. This is just a note to myself to
>>>>> clarify, that it's one and the same clock pin we're talking about.
>>>>>
>>>>> Now, from the hardware / DT PoV, I think, the DT should look like:
>>>>>
>>>>> a) in the ov2640 I2C DT node we should have a clock consumer entry,
>>>>> linking to a board-specific source.
>>>> That's what this patch series do right now.
>>>> In my patch 5/5 DT document said, ov2640 need a clock consumer which
>>>> refer to the xvclk input clock.
>>>> And it is a required property.
>>>>
>>>>> b) if the ov2640 clock is supplied by a camera host, its DT entry
>>>>> should have a clock source subnode, to which ov2640 clock consumer
>>>>> entry should link. The respective camera host driver should then parse
>>>>> that clock subnode and register the respective clock with the V4L2
>>>>> framework, by calling v4l2_clk_register().
>>>> Ok, So in this case, I need to wait for the "mclk" in probe of ov2640
>>>> driver. So that I can be compatible for the camera host which provide
>>>> the clock source.
>>> Talking about mclk and xvclk is quite confusing. There's no mclk from an
>>> ov2640 point of view. The ov2640 driver should call v4l2_clk_get("xvclk").
>> Yes, I also was thinking about this, and yes, requesting a "xvclk" clock
>> would be more logical. But then, as you write below, if we let the
>> v4l2_clk wrapper first check for a CCF "xvclk" clock, say, none is found.
>> How do we then find the exported "mclk" V4L2 clock? Maybe v4l2_clk_get()
>> should use two names?..
> Given that v4l2_clk_get() is only used by soc-camera drivers and that they all
> call it with the clock name set to "mclk", I wonder whether we couldn't just
> get rid of struct v4l2_clk.id and ignore the id argument to v4l2_clk_get()
> when CCF isn't available. Maybe we've overdesigned v4l2_clk :-)

Sorry, I'm not clear about how to implement what you discussed here.

Do you mean, In the ov2640 driver:
1. need to remove the patch 4/5, "add a master clock for sensor"
2. need to register a "xvclk" v4l2 clock which is a CCF clock. Or this 
part can put in soc_camera.c
3. So in ov2640_probe(), need to call v4l2_clk_get("xvclk"), which will do
      a. Get CCF clock "xvclk" by call devm_clk_get("xvclk"), and if 
failed then return the error code.
      b. Get the v4l2 clock "mclk", if failed then return the error code.
4. In ov2640_s_power(), we'll call soc_camera_set_power(..., priv->clk, 
...) to enable "xvclk" and "mclk" clock.

Please correct me if I misunderstand your meaning?

Best Regards,
Josh Wu

>
>>>>> c) if the ov2640 clock is supplied by a different clock source, the
>>>>> respective driver should parse it and also eventually call
>>>>> v4l2_clk_register().
>>>>>
>>>>> Implementing case (b) above is so far up to each individual
>>>>> (soc-camera) camera host driver. In soc-camera host drivers don't
>>>>> register V4L2 clocks themselves, as you correctly noticed, they just
>>>>> provide a .clock_start() and a .clock_stop() callbacks. The
>>>>> registration is done by the soc-camera core.
>>>>>
>>>>> If I understand correctly you have case (c). Unfortunately, this case
>>>>> isn't supported atm. I think, a suitable way to do this would be:
>>>>>
>>>>> (1) modify soc-camera to not register a V4L2 clock if the host doesn't
>>>>> provide the required callbacks.
>>>>>
>>>>> (2) hosts should recognise configurations, in which they don't supply
>>>>> the master clock to clients and not provide the callbacks then.
>>>>>
>>>>> (3) a separate driver should register a suitable V4L2 clock.
>>>>>
>>>>> Whereas I don't think we need to modify camera drivers. Their
>>>>> requesting of a V4L2 clock is correct as is.
>>>>>
>>>>> Some more fine-print: if the clock is supplied by a generic device, it
>>>>> would be wrong for it to register a V4L2 clock. It should register a
>>>>> normal CCF clock, and a separate V4L2 driver should create a V4L2
>>>>> clock from it. This isn't implemented either and we've been talking
>>>>> about it for a while now...
>>> v4l2_clk_get() should try to get the clock from CCF with a call to
>>> clk_get() first, and then look at the list of v4l2-specific clocks.
>> Yes, how will it find the "mclk" when "xvclk" (or any other name) is
>> requested? We did discuss this in the beginning and agreed to use a fixed
>> clock name for the time being...
> Please see above.
>
>>> That's at least how I had envisioned it when v4l2_clk_get() was
>>> introduced. Let's remember that v4l2_clk was designed as a temporary
>>> workaround for platforms not implementing CCF yet. Is that still needed,
>>> or could be instead just get rid of it now ?
>> I didn't check, but I don't think all platforms, handled by soc-camera,
>> support CCF yet.
> After a quick check it looks like only OMAP1 and SH Mobile are missing. Atmel,
> MX2, MX3 and R-Car all support CCF. PXA27x has CCF support but doesn't enable
> it yet for an unknown (to me) reason.
>
> The CEU driver is used on both arch/sh and arch/arm/mach-shmobile. The former
> will most likely never receive CCF support, and the latter is getting fixed.
> As arch/sh isn't maintained anymore I would be fine with dropping CEU support
> for it.
>
> OMAP1 is thus the only long-term show-stopper. What should we do with it ?
>

