Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52959 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932262AbdCIPkU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 10:40:20 -0500
Subject: Re: [PATCH] [media] v4l2-dv-timings: Introduce v4l2_calc_fps()
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org
References: <94397052765d1f6d84dc7edac65f906b09890871.1488905139.git.joabreu@synopsys.com>
 <4f598aba-3002-eeb5-1cad-d4dff4553644@xs4all.nl>
 <8bc4a61a-5b5d-2233-741a-bbf44fc5f009@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <908807fd-5b1c-4fb1-d24a-a8d7bd06a3b9@xs4all.nl>
Date: Thu, 9 Mar 2017 16:40:14 +0100
MIME-Version: 1.0
In-Reply-To: <8bc4a61a-5b5d-2233-741a-bbf44fc5f009@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/17 16:15, Jose Abreu wrote:
> Hi Hans,
> 
> 
> Thanks for the review!
> 
> 
> On 09-03-2017 12:29, Hans Verkuil wrote:
>> On 07/03/17 17:48, Jose Abreu wrote:
>>> HDMI Receivers receive video modes which, according to
>>> CEA specification, can have different frames per second
>>> (fps) values.
>>>
>>> This patch introduces a helper function in the media core
>>> which can calculate the expected video mode fps given the
>>> pixel clock value and the horizontal/vertical values. HDMI
>>> video receiver drivers are expected to use this helper so
>>> that they can correctly fill the v4l2_streamparm structure
>>> which is requested by vidioc_g_parm callback.
>>>
>>> We could also use a lookup table for this but it wouldn't
>>> correctly handle 60Hz vs 59.94Hz situations as this all
>>> depends on the pixel clock value.
>>>
>>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>>> Cc: Carlos Palminha <palminha@synopsys.com>
>>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
>>> Cc: linux-media@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>  drivers/media/v4l2-core/v4l2-dv-timings.c | 29 +++++++++++++++++++++++++++++
>>>  include/media/v4l2-dv-timings.h           |  8 ++++++++
>>>  2 files changed, 37 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
>>> index 5c8c49d..19946c6 100644
>>> --- a/drivers/media/v4l2-core/v4l2-dv-timings.c
>>> +++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
>>> @@ -814,3 +814,32 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
>>>  	return aspect;
>>>  }
>>>  EXPORT_SYMBOL_GPL(v4l2_calc_aspect_ratio);
>>> +
>>> +struct v4l2_fract v4l2_calc_fps(const struct v4l2_dv_timings *t)
>>> +{
>>> +	const struct v4l2_bt_timings *bt = &t->bt;
>>> +	struct v4l2_fract fps_fract = { 1, 1 };
>>> +	unsigned long n, d;
>>> +	unsigned long mask = GENMASK(BITS_PER_LONG - 1, 0);
>> This is wrong since v4l2_fract uses u32, and LONG can be 64 bits.
> 
> Yes, its wrong. I will remove the variable and just use fps, 100
> instead of mask, mask.
> 
>>
>>> +	u32 htot, vtot, fps;
>>> +	u64 pclk;
>>> +
>>> +	if (t->type != V4L2_DV_BT_656_1120)
>>> +		return fps_fract;
>>> +
>>> +	htot = V4L2_DV_BT_FRAME_WIDTH(bt);
>>> +	vtot = V4L2_DV_BT_FRAME_HEIGHT(bt);
>>> +	pclk = bt->pixelclock;
>>> +	if (bt->interlaced)
>>> +		htot /= 2;
>> This can be dropped. This is the timeperframe, not timeperfield. So for interleaved
>> formats the time is that of two fields (aka one frame).
> 
> Ok, but then there is something not correct in
> v4l2_dv_timings_presets structure field values because I get
> wrong results in double clocked modes. I checked the definition
> and the modes that are double clocked are defined with half the
> clock, i.e., V4L2_DV_BT_CEA_720X480I59_94 is defined with a pixel
> clock of 13.5MHz but in CEA spec this mode is defined with pixel
> clock of 27MHz.

It's defined in the CEA spec as 1440x480 which is the double clocked
version of 720x480.

The presets are defined without any pixel repeating. In fact, no driver
that is in the kernel today supports pixel repeating. Mostly because there was
never any need since almost nobody uses resolutions that require this.

If you decide to add support for this, then it would not surprise me if
some of the core dv-timings support needs to be adjusted.

To be honest, I never spent time digging into the pixel repeating details,
so I am not an expert on this at all.

> 
>>
>>> +
>>> +	fps = (htot * vtot) > 0 ? div_u64((100 * pclk), (htot * vtot)) : 0;
>>> +
>>> +	rational_best_approximation(fps, 100, mask, mask, &n, &d);
>> I think you can just use fps, 100 instead of mask, mask.
>>
>> What is returned if fps == 0?
> 
> I will add a check for this.
> 
>>
>> I don't have a problem as such with this function, but just be aware that the
>> pixelclock is never precise: there are HDMI receivers that are unable to report
>> the pixelclock with enough precision to even detect if it is 60 vs 59.94 Hz.
>>
>> And even for those that can, it is often not reliable.
> 
> My initial intention for this function was that it should be used
> with v4l2_find_dv_timings_cea861_vic, when possible. That is,
> HDMI receivers have access to AVI infoframe contents. Then they
> should get the vic, call v4l2_find_dv_timings_cea861_vic, get
> timings and then call v4l2_calc_fps to get fps. If no AVI
> infoframe is available then it should resort to pixel clock and
> H/V measures as last resort.

Right, but there are no separate VIC codes for 60 vs 59.94 Hz. Any vertical
refresh rate that can be divided by 6 can also support these slightly lower
refresh rates. The timings returned by v4l2_find_dv_timings_cea861_vic just
report if that is possible, but the pixelclock is set for 24, 30 or 60 fps.

Perhaps I should see the driver code...

> 
>>
>> In order for me to merge this it also should be used in a driver. Actually the
>> cobalt and vivid drivers would be suitable: you can test the vivid driver yourself,
>> and if you have a patch for the cobalt driver, then I can test that for you.
>>
>> Would be nice for the cobalt driver, since g_parm always returns 60 fps :-)
> 
> Ok, I will check what I can do :)
> 
> Best regards,
> Jose Miguel Abreu

Regards,

	Hans
