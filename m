Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:51567 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdHGOsq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 10:48:46 -0400
Subject: Re: [PATCH] media: i2c: OV5647: gate clock lane before stream on
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Jacob Chen <jacobchen110@gmail.com>
CC: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <roliveir@synopsys.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <vladimir_zapolskiy@mentor.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <sakari.ailus@linux.intel.com>, <slongerbeam@gmail.com>,
        <robh+dt@kernel.org>, <Luis.Oliveira@synopsys.com>
References: <1500950041-5449-1-git-send-email-jacob-chen@iotwrt.com>
 <CAFLEztQHYWAk39+gQCD0XkKPVqmUY5kPZydWgw8+zu53+D2_pA@mail.gmail.com>
 <1502093851.2490.4.camel@pengutronix.de>
 <CAFLEztQcCijnmkp_r3-gy2ptM0b+WFEw4Sf1MeiatJbvnKqA8A@mail.gmail.com>
 <1502108760.2490.28.camel@pengutronix.de>
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
Message-ID: <5121da6b-a37d-270b-2587-b2ee77635546@synopsys.com>
Date: Mon, 7 Aug 2017 15:48:41 +0100
MIME-Version: 1.0
In-Reply-To: <1502108760.2490.28.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm new here, I got to be Maintainer of this driver by the old Maintainer
recommendation. Still getting the hang of it :)

On 07-Aug-17 13:26, Philipp Zabel wrote:
> Hi Jacob,
> 
> On Mon, 2017-08-07 at 19:06 +0800, Jacob Chen wrote:
> [...]
>>>>> --- a/drivers/media/i2c/ov5647.c
>>>>> +++ b/drivers/media/i2c/ov5647.c
>>>>> @@ -253,6 +253,10 @@ static int ov5647_stream_on(struct v4l2_subdev *sd)
>>>>>  {
>>>>>         int ret;
>>>>>
>>>>> +       ret = ov5647_write(sd, 0x4800, 0x04);
>>>>> +       if (ret < 0)
>>>>> +               return ret;
>>>>> +
> 
> So this clears BIT(1) (force clock lane to low power mode) and BIT(5)
> (gate clock lane while idle) that were set by ov5647_stream_off() during
> __sensor_init() due to the change below.
> 
> Is there a reason, btw, that this driver is full of magic register
> addresses and values? A few #defines would make this a lot more
> readable.
> 

For what I can see I agree that a few register name setting could be done.

>>>>>         ret = ov5647_write(sd, 0x4202, 0x00);
>>>>>         if (ret < 0)
>>>>>                 return ret;
>>>>> @@ -264,6 +268,10 @@ static int ov5647_stream_off(struct v4l2_subdev *sd)
>>>>>  {
>>>>>         int ret;
>>>>>
>>>>> +       ret = ov5647_write(sd, 0x4800, 0x25);
>>>>> +       if (ret < 0)
>>>>> +               return ret;
>>>>> +
>>>>>         ret = ov5647_write(sd, 0x4202, 0x0f);
>>>>>         if (ret < 0)
>>>>>                 return ret;
>>>>> @@ -320,7 +328,7 @@ static int __sensor_init(struct v4l2_subdev *sd)
>>>>>                         return ret;
>>>>>         }
>>>>>
>>>>> -       return ov5647_write(sd, 0x4800, 0x04);
>>>>> +       return ov5647_stream_off(sd);
> 
> I see now that BIT(2) (keep bus in LP-11 while idle) is and was always
> set. So the change is that initially, additionally to LP-11 mode, the
> clock lane is gated and forced into low power mode, as well?
> 

This is my interpretation as well.

>>>>>  }
>>>>>
>>>>>  static int ov5647_sensor_power(struct v4l2_subdev *sd, int on)
>>>>> --
>>>>> 2.7.4
>>>>>
>>>>
>>>> Can anyone comment on it?
>>>>
>>>> I saw there is a same discussion in  https://urldefense.proofpoint.com/v2/url?u=https-3A__patchwork.kernel.org_patch_9569031_&d=DwICaQ&c=DPL6_X_6JkXFx7AXWqB0tg&r=eMn12aiiNuIDjtRi5xEzC7tWJkpra2vl_XYFVvfxIGE&m=eortcRXje2uLyZNI_-Uw3Ur_z24tb-e4pZfom7WhdE0&s=6sLc76bhjR0IdaA3ArZ7F7slgtcyGz8pDTzAF_CBLno&e= 
>>>> There is a comment in i.MX CSI2 driver.
>>>> "
>>>> Configure MIPI Camera Sensor to put all Tx lanes in LP-11 state.
>>>> This must be carried out by the MIPI sensor's s_power(ON) subdev
>>>> op.
>>>> "
>>>> That's what this patch do, sensor driver should make sure that clock
>>>> lanes are in stop state while not streaming.
>>>
>>> This is not the same, as far as I can tell. BIT(5) is just clock lane
>>> gating, as you describe above. To put the bus into LP-11 state, BIT(2)
>>> needs to be set.
>>>
>>
>> Yeah, but i double that clock lane is not in LP11 when continue clock
>> mode is enabled.

I think by spec it shouldn't got to stopstate in continuous clock.

> 
> If indeed LP-11 state is not achieved while the sensor is idle, as long
> as BIT(5) is cleared, I think this patch is correct.
> 
> regards
> Philipp
> 

As far as I understand, bit[5] set to 1 will force clock lane to be gated (in
other words it will be forced to be in LP-11 if there are no packets to
transmit). But also LP-11 must not be achieved with the BIT(5) cleared (free
running mode)?

Sorry if I misunderstood something.

regards,
Luis
