Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:58197 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751191AbbANKgC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2015 05:36:02 -0500
Message-ID: <54B6468B.2040308@atmel.com>
Date: Wed, 14 Jan 2015 18:35:55 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] V4L: remove clock name from v4l2_clk API
References: <Pine.LNX.4.64.1501021244580.30761@axis700.grange> <10297396.jglheYyvzx@avalon> <54B39079.9030408@atmel.com> <5428436.9dTJhp8MF4@avalon>
In-Reply-To: <5428436.9dTJhp8MF4@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/12/2015 6:38 PM, Laurent Pinchart wrote:
> Hi Josh,
>
> On Monday 12 January 2015 17:14:33 Josh Wu wrote:
>> On 1/9/2015 6:47 AM, Laurent Pinchart wrote:
>>> On Thursday 08 January 2015 23:37:58 Guennadi Liakhovetski wrote:
>>>> On Wed, 7 Jan 2015, Josh Wu wrote:
>>>>> On 1/7/2015 6:17 AM, Guennadi Liakhovetski wrote:
>>>>>> On Tue, 6 Jan 2015, Josh Wu wrote:
>>>>>>> Hi, Guennadi
>>>>>>>
>>>>>>> After look deep into this patch, I found you miss one line that should
>>>>>>> be changed as well.
>>>>>>> It's In function v4l2_clk_get(), there still has one line code called
>>>>>>> v4l2_clk_find(dev_id, id).
>>>>>>> You need to change it to v4l2_clk_find(dev_id, NULL) as well.
>>>>>>> Otherwise the code that many sensor used: v4l2_clk_get(&client->dev,
>>>>>>> "mclk") cannot acquired the "mclk" clock.
>>>>>>>
>>>>>>> After above changes, this patch works for me.
>>>>>> I think you're right, in fact, since we now don't store CCF-based
>>>>>> v4l2_clk wrappers on the list, this can be simplified even further,
>>>>>> I'll update the patch. Did you only test this patch or both?
>>>>> I tested both patches with Atmel-isi driver. For the 2/2 patch I applied
>>>>> the modification Laurent suggested.
>>>>> Those patches works for me.
>>>>>
>>>>> The only concern is in ov2640 I still need to acquired two v4l2 clocks:
>>>>>      "xvclk"  that will get the xvclk CCF clock directly.
>>>>>      "mclk"  that make ISI driver call his clock_start()/stop() to
>>>>>      enable/disable ISI's peripheral clock.
>>>>>
>>>>> If I only get xvclk clock, then the camera capture will be failed with a
>>>>> ISI timeout error.
>>>> No, this doesn't look right to me. The camera sensor has only one clock
>>>> input, so, it should only request one clock. Where does the clock signal
>>>> to the camera come from on your system?
>>> That's correct, the sensor driver only has one clock input, so it should
>>> just request the xvclk clock.
>>>
>>>> If it comes from the ISI itself, you don't need to specify the clock in
>>>> the DT, since the ISI doesn't produce a clock from DT. If you do want to
>>>> have your clock consumer (ov2640) and the supplier (ISI) properly
>>>> described in DT, you'll have to teach the ISI to register a CCF clock
>>>> source, which then will be connected to from the ov2640. If you choose
>>>> not to show your clock in the DT, you can just use v4l2_clk_get(dev,
>>>> "xvclk") and it will be handled by v4l2_clk / soc-camera / isi-atmel.
>>>>
>>>> If the closk to ov2640 is supplied by a separate clock source, then you
>>>> v4l2_clk_get() will connect ov2640 to it directly and soc-camera will
>>>> enable and disable it on power-on / -off as required.
>>> The ISI has no way to supply a sensor clock, the clock is supplied by a
>>> separate clock source.
>>>
>>>>  From your above description it looks like the clock to ov2640 is
>>>> supplied by a separate source, but atmel-isi's .clock_start() /
>>>> .clock_stop() functions still need to be called? By looking at those
>>>> functions it looks like they turn on and off clocks, supplying the ISI
>>>> itself... Instead of only turning on and off clocks, provided by the ISI
>>>> to a camera sensor. If my understanding is right, then this is a bug in
>>>> atmel-isi and it has to be fixed.
>>> That's correct as well, the ISI driver needs to be fixed.
>> Thanks both of you for the details. Now I got it.
>> Indeed, I need fix this in atmel-isi driver not in ov2640 driver.
>> So I will send a new patch for this, which should move the ISI
>> peripheral clock enable/disable() from clock_start/stop() to
>> isi_camera_add_device/remove_device().
> Shouldn't you move it to the start_streaming() and stop_streaming() functions
> instead ? An even better solution would be to use runtime PM to enable/disable
> the ISI clock in the runtime PM resume and suspend handlers, and call
> pm_runtime_get_sync() and pm_runtime_put() when you need the ISI to be
> operational.

Okay, I'll try to add the PM functions for atmel-isi in the meantime.

Best Regards,
Josh Wu
>

