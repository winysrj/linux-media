Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58273 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLZJA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Dec 2014 04:00:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org, s.nawrocki@samsung.com,
	festevam@gmail.com
Subject: Re: [PATCH v4 2/5] media: ov2640: add async probe function
Date: Fri, 26 Dec 2014 11:01 +0200
Message-ID: <7803041.cyoUKFJAdh@avalon>
In-Reply-To: <549D021A.7030307@atmel.com>
References: <1418869646-17071-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1412241626510.28885@axis700.grange> <549D021A.7030307@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Friday 26 December 2014 14:37:14 Josh Wu wrote:
> On 12/25/2014 6:39 AM, Guennadi Liakhovetski wrote:
> > On Mon, 22 Dec 2014, Josh Wu wrote:
> >> On 12/20/2014 6:16 AM, Guennadi Liakhovetski wrote:
> >>> On Fri, 19 Dec 2014, Josh Wu wrote:
> >>>> On 12/19/2014 5:59 AM, Guennadi Liakhovetski wrote:
> >>>>> On Thu, 18 Dec 2014, Josh Wu wrote:
> >>>>>> To support async probe for ov2640, we need remove the code to get
> >>>>>> 'mclk' in ov2640_probe() function. oterwise, if soc_camera host is
> >>>>>> not probed in the moment, then we will fail to get 'mclk' and quit
> >>>>>> the ov2640_probe() function.
> >>>>>> 
> >>>>>> So in this patch, we move such 'mclk' getting code to
> >>>>>> ov2640_s_power() function. That make ov2640 survive, as we can pass a
> >>>>>> NULL (priv-clk) to soc_camera_set_power() function.
> >>>>>> 
> >>>>>> And if soc_camera host is probed, the when ov2640_s_power() is
> >>>>>> called, then we can get the 'mclk' and that make us enable/disable
> >>>>>> soc_camera host's clock as well.
> >>>>>> 
> >>>>>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> >>>>>> ---
> >>>>>> v3 -> v4:
> >>>>>> v2 -> v3:
> >>>>>> v1 -> v2:
> >>>>>>      no changes.
> >>>>>>     
> >>>>>>  drivers/media/i2c/soc_camera/ov2640.c | 31 +++++++++++++++++--------
> >>>>>>  1 file changed, 21 insertions(+), 10 deletions(-)
> >>>>>> 
> >>>>>> diff --git a/drivers/media/i2c/soc_camera/ov2640.c
> >>>>>> b/drivers/media/i2c/soc_camera/ov2640.c
> >>>>>> index 1fdce2f..9ee910d 100644
> >>>>>> --- a/drivers/media/i2c/soc_camera/ov2640.c
> >>>>>> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> >>>>>> @@ -739,6 +739,15 @@ static int ov2640_s_power(struct v4l2_subdev
> >>>>>> *sd, int on)
> >>>>>>     	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >>>>>>     	struct soc_camera_subdev_desc *ssdd =
> >>>>>> soc_camera_i2c_to_desc(client);
> >>>>>>     	struct ov2640_priv *priv = to_ov2640(client);
> >>>>>> 
> >>>>>> +	struct v4l2_clk *clk;
> >>>>>> +
> >>>>>> +	if (!priv->clk) {
> >>>>>> +		clk = v4l2_clk_get(&client->dev, "mclk");
> >>>>>> +		if (IS_ERR(clk))
> >>>>>> +			dev_warn(&client->dev, "Cannot get the mclk.
> >>>>>> maybe
> >>>>>> soc-camera host is not probed yet.\n");
> >>>>>> +		else
> >>>>>> +			priv->clk = clk;
> >>>>>> +	}
> >>>>>>       	return soc_camera_set_power(&client->dev, ssdd, priv->clk,
> >>>>>> on);
> >>>>>>     }
> >> 
> >> Just let me explained a little more details at first:
> >> 
> >> As my understanding, current the priv->clk is a v4l2_clk: mclk, which is
> >> a wrapper clock in soc_camera.c.
> >> it can make soc_camera to call camera host's clock_start() clock_stop().
> >> As in ov2640, the real mck (pck1) is in ov2640 dt node (xvclk). So the
> >> camera host's clock_start()/stop() only need to enable/disable his
> >> peripheral clock.
> >
> > I'm looking at the ov2640 datasheet. In the block diagram I only see one
> > input clock - the xvclk. Yes, it can be supplied by the camera host
> > controller, in which case it is natural for the camera host driver to own
> > and control it, or it can be a separate clock device - either static or
> > configurable. This is just a note to myself to clarify, that it's one and
> > the same clock pin we're talking about.
> > 
> > Now, from the hardware / DT PoV, I think, the DT should look like:
> > 
> > a) in the ov2640 I2C DT node we should have a clock consumer entry,
> > linking to a board-specific source.
> 
> That's what this patch series do right now.
> In my patch 5/5 DT document said, ov2640 need a clock consumer which
> refer to the xvclk input clock.
> And it is a required property.
> 
> > b) if the ov2640 clock is supplied by a camera host, its DT entry should
> > have a clock source subnode, to which ov2640 clock consumer entry should
> > link. The respective camera host driver should then parse that clock
> > subnode and register the respective clock with the V4L2 framework, by
> > calling v4l2_clk_register().
> 
> Ok, So in this case, I need to wait for the "mclk" in probe of ov2640
> driver. So that I can be compatible for the camera host which provide
> the clock source.

Talking about mclk and xvclk is quite confusing. There's no mclk from an 
ov2640 point of view. The ov2640 driver should call v4l2_clk_get("xvclk").

> > c) if the ov2640 clock is supplied by a different clock source, the
> > respective driver should parse it and also eventually call
> > v4l2_clk_register().
> > 
> > Implementing case (b) above is so far up to each individual (soc-camera)
> > camera host driver. In soc-camera host drivers don't register V4L2 clocks
> > themselves, as you correctly noticed, they just provide a .clock_start()
> > and a .clock_stop() callbacks. The registration is done by the soc-camera
> > core.
> > 
> > If I understand correctly you have case (c). Unfortunately, this case
> > isn't supported atm. I think, a suitable way to do this would be:
> > 
> > (1) modify soc-camera to not register a V4L2 clock if the host doesn't
> > provide the required callbacks.
> > 
> > (2) hosts should recognise configurations, in which they don't supply the
> > master clock to clients and not provide the callbacks then.
> > 
> > (3) a separate driver should register a suitable V4L2 clock.
> > 
> > Whereas I don't think we need to modify camera drivers. Their requesting
> > of a V4L2 clock is correct as is.
> > 
> > Some more fine-print: if the clock is supplied by a generic device, it
> > would be wrong for it to register a V4L2 clock. It should register a
> > normal CCF clock, and a separate V4L2 driver should create a V4L2 clock
> > from it. This isn't implemented either and we've been talking about it for
> > a while now...

v4l2_clk_get() should try to get the clock from CCF with a call to clk_get() 
first, and then look at the list of v4l2-specific clocks. That's at least how 
I had envisioned it when v4l2_clk_get() was introduced. Let's remember that 
v4l2_clk was designed as a temporary workaround for platforms not implementing 
CCF yet. Is that still needed, or could be instead just get rid of it now ?

> I think I understand your point now.
> 
> >> That is the motivation I want ov2640 be probed even without "mclk".
> > 
> > ov2640 can be used with other boards and camera hosts, not only your
> > specific board. In other configurations your change will break the driver.
> > 
> >>> Ok, think about this: you check whether priv->clk is set on each
> >>> .s_power() call, which is already a bit awkward.
> >> 
> >> yes, it is.
> >> 
> >>> Such approach can be used when there's no other way to perform a one-
> >>> time action, but here we have one. But never mind, that's not the main
> >>> problem. If priv->clk isn't set, you try to acquire it. But during
> >>> probing, when this function is called for the first time clock isn't
> >>> available yet, but you still want to succeed probing. So, you just issue
> >>> a warning and continue. But then later an application opens the camera,
> >>> .s_power() is called again, but for some reason the clock might still be
> >>> not available, and this time you should fail. But you don't, you succeed
> >>> and then you'll fail somewhere later, presumably, with a timeout waiting
> >>> for frames. Am I right?
> >> 
> >> if the clock (v4l2 clock: mclk) is not available, then, there is no
> >> camera host available.
> > 
> > This isn't true - from the hardware perspective. The clock can be supplied
> > by a different source.
> > 
> >> So the system should have no v4l2 device found.
> >> I think in this case the application cannot call the camera sensor
> >> .s_power() via v4l2 ioctl.
> >> So the timeout case should not happened.
> > 
> > No, sorry, I meant a physical clock, not aclock object. You can register
> > the complete framework and try to use it, but if the physical clock isn't
> > enabled, the camera sensor won't function correctly.
> > 
> >>>>>> @@ -1078,21 +1087,21 @@ static int ov2640_probe(struct i2c_client
> >>>>>> *client,
> >>>>>>     	if (priv->hdl.error)
> >>>>>>     		return priv->hdl.error;
> >>>>>>     
> >>>>>> -	priv->clk = v4l2_clk_get(&client->dev, "mclk");
> >>>>>> -	if (IS_ERR(priv->clk)) {
> >>>>>> -		ret = PTR_ERR(priv->clk);
> >>>>>> -		goto eclkget;
> >>>>>> -	}
> >>>>>> -
> >>>>>>     	ret = ov2640_video_probe(client);
> >>>>> 
> >>>>> The first thing the above ov2640_video_probe() function will do is
> >>>>> call ov2640_s_power(), which will request the clock. So, by moving
> >>>>> requesting the clock from ov2640_probe() to ov2640_s_power() doesn't
> >>>>> change how probing will be performed, am I right?
> >>>> 
> >>>> yes, you are right. In this patch, the "mclk" will requested by
> >>>> ov2640_s_power().
> >>>> 
> >>>> The reason why I put the getting "mclk" code from ov2640_probe() to
> >>>> ov2640_s_power() is : as the "mclk" here is camera host's peripheral
> >>>> clock. That means ov2640 still can be probed properly (read ov2640 id)
> >>>> even no "mclk". So when I move this code to ov2640_s_power(), otherwise
> >>>> the ov2640_probe() will be failed or DEFER_PROBE.
> >>>> 
> >>>> Is this true for all camera host? If it's not true, then I think use
> >>>> -EPROBE_DEFER would be a proper way.
> >>> 
> >>> Sorry, not sure what your question is.
> >> 
> >> Sorry, I don't make me clear here.
> >> My question should be: Are all the camera host's clock_start()/stop()
> >> only operate their peripheral clock?
> > 
> > Yes, that's all camera hosts have. They cannot operate other unrelated
> > clock sources.
> > 
> >>> And I'm not sure ov2640's registers
> >>> can be accessed with no running clock.
> >> 
> >> No, it seems there is a misunderstanding here.
> >> 
> >> I didn't mean ov2640 can be probed without xvclk.
> >> What I try to say is the ov2640 can be probed without camera host's
> >> peripheral clock.
> > 
> > Ok, then your patch will break the driver even earlier - when trying to
> > access ov2640 registers without enabling the clock.
> > 
> >>> I think some camera sensors can do this, but I have no idea about this
> >>> one. How did you verify? Is it mentioned in a datasheet? Or did you
> >>> really disconnected (grounded) the sensor clock input and tried to
> >>> access its reqisters? If you just verified, that it's working without
> >>> requesting the clock, are you sure your clock output isn't running
> >>> permanently all the time anyway?
> >> 
> >> I didn't verify the those method as I only probed the ov2640 without ISI
> >> enabled. ISI peripheral clock is disabled and etc.
> > 
> > Right, this means a separate (probably always-on) clock source is used on
> > your specific board, but this doesn't have to be the case on all other
> > boards, where ov2640 is used.
> > 
> >>>>> Or are there any other patched, that change that, that I'm overseeing?
> >>>>> 
> >>>>> If I'm right, then I would propose an approach, already used in other
> >>>>> drivers instead of this one: return -EPROBE_DEFER if the clock isn't
> >>>>> available during probing. See ef6672ea35b5bb64ab42e18c1a1ffc717c31588a
> >>>>> for an example. Or did I misunderstand anything?

That commit introduced the following code block in the mt9m111 driver.

       mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
       if (IS_ERR(mt9m111->clk))
               return -EPROBE_DEFER;

The right thing to do is to return PTR_ERR(mt9m111->clk), not a hardcoded -
EPROBE_DEFER. v4l2_clk_get() should return -EPROBE_DEFER if the clock is not 
found, and possibly other error codes to indicate different errors.

> >> I can implement with your method. like in probe() function, request the
> >> v4l2_clk "mclk", if failed then return -EPROBE_DEFER.
> > 
> > Yes, please, I think this would be a correct solution.
> 
> According to my understanding, if I implement this way I can be
> compatible with the camera host which provide the xvclk for ov2640.
> 
> So I will prepare the next version with this way.
> BTW: do you have any comment for the 1/5 patches?
> 
> Best Regards,
> Josh Wu
> 
> >> But I remember you mentioned that you will remove the v4l2 clock in
> >> future.
> >> See ff5430de commit message.
> >> So I just want to not so depends on the v4l2_clk "mclk".
> > 
> > This might or might not happen. We so far depend on it. And we might also
> > keep it, just adding a CCF V4L2 clock driver to handle generic clock
> > sources like in case (c) above.
> > 
> > Thanks
> > Guennadi
> > 
> >> Best Regards,
> >> Josh Wu
> >> 
> >>>> Actually months ago I already done a version of ov2640 patch which use
> >>>> -EPROBE_DEFER way.
> >>>> 
> >>>> But now I think the ov2640 can be probed correctly without "mclk", so
> >>>> it is no need to return -EPROBE_DEFER. And the v4l2 asyn API can handle
> >>>> the synchronization of host. So I prefer to use this way.
> >>>> What do you think about this?
> >>>> 
> >>>> Best Regards,
> >>>> Josh Wu
> >>>> 
> >>>>> Thanks
> >>>>> Guennadi
> >>>>> 
> >>>>>>     	if (ret) {
> >>>>>> 
> >>>>>> -		v4l2_clk_put(priv->clk);
> >>>>>> -eclkget:
> >>>>>> -		v4l2_ctrl_handler_free(&priv->hdl);
> >>>>>> +		goto evideoprobe;
> >>>>>> 
> >>>>>>     	} else {
> >>>>>>     	
> >>>>>>     		dev_info(&adapter->dev, "OV2640 Probed\n");
> >>>>>>     	
> >>>>>>     	}
> >>>>>>     
> >>>>>>     +	ret = v4l2_async_register_subdev(&priv->subdev);
> >>>>>> 
> >>>>>> +	if (ret < 0)
> >>>>>> +		goto evideoprobe;
> >>>>>> +
> >>>>>> +	return 0;
> >>>>>> +
> >>>>>> +evideoprobe:
> >>>>>> +	v4l2_ctrl_handler_free(&priv->hdl);
> >>>>>> 
> >>>>>>     	return ret;
> >>>>>>     
> >>>>>>     }
> >>>>>>     @@ -1100,7 +1109,9 @@ static int ov2640_remove(struct i2c_client
> >>>>>> 
> >>>>>> *client)
> >>>>>> 
> >>>>>>     {
> >>>>>>     
> >>>>>>     	struct ov2640_priv       *priv = to_ov2640(client);
> >>>>>>     
> >>>>>>     -	v4l2_clk_put(priv->clk);
> >>>>>> 
> >>>>>> +	v4l2_async_unregister_subdev(&priv->subdev);
> >>>>>> +	if (priv->clk)
> >>>>>> +		v4l2_clk_put(priv->clk);
> >>>>>> 
> >>>>>>     	v4l2_device_unregister_subdev(&priv->subdev);
> >>>>>>     	v4l2_ctrl_handler_free(&priv->hdl);
> >>>>>>     	return 0;

-- 
Regards,

Laurent Pinchart

