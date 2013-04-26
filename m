Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59445 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3DZUqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 16:46:50 -0400
Message-ID: <517AE7B5.4010108@gmail.com>
Date: Fri, 26 Apr 2013 22:46:45 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v9 02/20] V4L2: support asynchronous subdevice registration
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de> <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de> <516BEB1D.80105@samsung.com> <1489465.QAtJQiYEWC@avalon> <Pine.LNX.4.64.1304231435540.1422@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1304231435540.1422@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 04/23/2013 03:01 PM, Guennadi Liakhovetski wrote:
> On Mon, 22 Apr 2013, Laurent Pinchart wrote:
>> On Monday 15 April 2013 13:57:17 Sylwester Nawrocki wrote:
>>> On 04/12/2013 05:40 PM, Guennadi Liakhovetski wrote:
>>>> +
>>>> +		if (notifier->unbind)
>>>> +			notifier->unbind(notifier, asdl);
>>>> +	}
>>>> +
>>>> +	mutex_unlock(&list_lock);
>>>> +
>>>> +	if (dev) {
>>>> +		while (i--) {
>>>> +			if (dev[i]&&  device_attach(dev[i])<  0)
>>
>> This is my last major pain point.
>>
>> To avoid race conditions we need circular references (see
>>http://www.mail-archive.com/linux-media@vger.kernel.org/msg61092.html).
>>We will thus need a
>> way to break the circle by explictly requesting the subdev to release its
>> resources. I'm afraid I have no well-designed solution for that at the moment.
>
> I think we really can design the framework to allow a _safe_ unloading of
> the bridge driver. An rmmod run is not an immediate death - we have time
> to clean up and release all resources properly. As an example, I just had
> a network interface running, but rmmod-ing of one of hardware drivers just
> safely destroyed the interface. In our case, rmmod<bridge>  should just
> signal the subdevice to release the clock reference. Whether we have the
> required - is a separate question.

It sounds like a reasonable requirements.

> Currently a call to v4l2_clk_get() increments the clock owner use-count.
> This isn't a problem for soc-camera, since there the soc-camera core owns
> the clock. For other bridge drivers they would probably own the clock
> themselves, so, incrementing their use-count would block their modules in
> memory. To avoid that we have to remove that use-count incrementing.
>
> The crash, described in the referenced mail can happen if the subdevice
> driver calls (typically) v4l2_clk_enable() on a clock, that's already been
> freed. Wouldn't a locked look-up in the global clock list in v4l2-clk.c
> prevent such a crash? E.g.
>
> int v4l2_clk_enable(struct v4l2_clk *clk)
> {
> 	struct v4l2_clk *tmp;
> 	int ret = -ENODEV;
>
> 	mutex_lock(&clk_lock);
> 	list_for_each_entry(tmp,&clk_list, list)
> 		if (tmp == clk) {
> 			ret = !try_module_get(clk->ops->owner);
> 			if (ret)
> 				ret = -EFAULT;
> 			break;
> 		}
> 	mutex_unlock(&clk_lock);
>
> 	if (ret<  0)
> 		return ret;
>
> 	...
> }
>
> We'd have to do a similar locked look-up in v4l2_clk_put().

Sounds good. This way it will not be possible to unload modules when 
clock is
enabled, which is expected. And it seems straightforward to ensure 
clk_prepare/
clk_unprepare, clk_enable/clk_disable are properly balanced. If module 
is gone
before subdev driver calls v4l2_clk_put() the clock provider module will 
have
to ensure any source clocks it uses are properly released 
(clk_unprepare/clk_put).

I'm looking forward to try your v10. :-)

Regards,
Sylwester
