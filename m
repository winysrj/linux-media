Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:49802 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756169AbdKGWMS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Nov 2017 17:12:18 -0500
Received: by mail-wr0-f177.google.com with SMTP id o88so646069wrb.6
        for <linux-media@vger.kernel.org>; Tue, 07 Nov 2017 14:12:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <82454b04-1664-423b-2b9e-36b3ae76e83a@xs4all.nl>
References: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
 <1507783506-3884-4-git-send-email-tharvey@gateworks.com> <230ceb18-1d69-7fa8-acb0-c810094f8e50@xs4all.nl>
 <CAJ+vNU0Z988G+wTfpiSXXOM9QsPj-eRvH=F1b9__8kJ+18xk4g@mail.gmail.com>
 <a5bd27c9-10e4-b9f5-f0ac-293528fa570e@xs4all.nl> <CAJ+vNU2yHKDf5tCVyj6iw83z0sDuV0ZsZ-=sLfa+fTFbtjVo0A@mail.gmail.com>
 <CAJ+vNU267VyOiq+fyv0dRm4Mui3YfK-ybqeOSENGMX6LmzZdcQ@mail.gmail.com> <82454b04-1664-423b-2b9e-36b3ae76e83a@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 7 Nov 2017 14:12:16 -0800
Message-ID: <CAJ+vNU1E__TWE=FjUOhGoQdGmZiTDuyfoXhCjYiy3HZ8aqqGOA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 6, 2017 at 11:47 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 11/07/2017 07:04 AM, Tim Harvey wrote:
>> On Fri, Oct 20, 2017 at 7:00 AM, Tim Harvey <tharvey@gateworks.com> wrote:
>>> On Thu, Oct 19, 2017 at 12:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> <snip>
>>>>>
>>>>> Regarding video standard detection where this chip provides me with
>>>>> vertical-period, horizontal-period, and horizontal-pulse-width I
>>>>> should be able to detect the standard simply based off of
>>>>> vertical-period (framerate) and horizontal-period (line width
>>>>> including blanking) right? I wasn't sure if my method of matching
>>>>> these within 14% tolerance made sense. I will be removing the hsmatch
>>>>> logic from that as it seems the horizontal-pulse-width should be
>>>>> irrelevant.
>>>>
>>>> For proper video detection you ideally need:
>>>>
>>>> h/v sync size
>>>> h/v back/front porch size
>>>> h/v polarity
>>>> pixelclock (usually an approximation)
>>>>
>>>> The v4l2_find_dv_timings_cap() helper can help you find the corresponding
>>>> timings, allowing for pixelclock variation.
>>>>
>>>> That function assumes that the sync/back/frontporch values are all known.
>>>> But not all devices can actually discover those values. What can your
>>>> hardware detect? Can it tell front and backporch apart? Can it determine
>>>> the sync size?
>>>>
>>>> I've been considering for some time to improve that helper function to be
>>>> able to handle hardware that isn't able separate sync/back/frontporch values.
>>>>
>>>
>>> The TDA1997x provides only the vertical/horizontal periods and the
>>> horizontal pulse
>>> width (section 8.3.4 of datasheet [1]).
>>>
>>> Can you point me to a good primer on the relationship between these
>>> values and the h/v back/front porch?
>>>
>>> Currently I iterate over the list of known formats calculating hper
>>> (bt->pixelclock / V4L2_DV_BT_FRAME_WIDTH(bt)) and vper (hper /
>>> V4L2_DV_BT_FRAME_HEIGHT(bt)) (framerate) and find the closest match
>>> within +/- 7% tolerance. The list of supported formats is sorted by
>>> framerate then width.
>>>
>>>         /* look for matching timings */
>>>         for (i = 0; i < ARRAY_SIZE(tda1997x_hdmi_modes); i++) {
>>>                 const struct tda1997x_video_std *std = &tda1997x_hdmi_modes[i];
>>>                 const struct v4l2_bt_timings *bt = &std->timings.bt;
>>>                 int _hper, _vper, _hsper;
>>>                 int vmin, vmax, hmin, hmax, hsmin, hsmax;
>>>                 int vmatch, hsmatch;
>>>
>>>                 width = V4L2_DV_BT_FRAME_WIDTH(bt);
>>>                 lines = V4L2_DV_BT_FRAME_HEIGHT(bt);
>>>
>>>                 _hper = (int)bt->pixelclock / (int)width;
>>>                 _vper = _hper / lines;
>>>                 _hsper = (int)bt->pixelclock / (int)bt->hsync;
>>>                 if (bt->interlaced)
>>>                         _vper *= 2;
>>>                 /* vper +/- 0.7% */
>>>                 vmin = 993 * (27000000 / _vper) / 1000;
>>>                 vmax = 1007 * (27000000 / _vper) / 1000;
>>>                 _hsper = (int)bt->pixelclock / (int)bt->hsync;
>>>                 if (bt->interlaced)
>>>                         _vper *= 2;
>>>                 /* vper +/- 0.7% */
>>>                 vmin = 993 * (27000000 / _vper) / 1000;
>>>                 vmax = 1007 * (27000000 / _vper) / 1000;
>>>                 /* hper +/- 0.7% */
>>>                 hmin = 993 * (27000000 / _hper) / 1000;
>>>                 hmax = 1007 * (27000000 / _hper) / 1000;
>>>
>>>                 /* vmatch matches the framerate */
>>>                 vmatch = ((vper <= vmax) && (vper >= vmin)) ? 1 : 0;
>>>                 /* hmatch matches the width */
>>>                 hmatch = ((hper <= hmax) && (hper >= hmin)) ? 1 : 0;
>>>                 if (vmatch && hsmatch) {
>>>                         v4l_info(state->client,
>>>                                  "resolution: %dx%d%c@%d (%d/%d/%d) %dMHz %d\n",
>>>                                  bt->width, bt->height, bt->interlaced?'i':'p',
>>>                                  _vper, vper, hper, hsper, pixrate, hsmatch);
>>>                         state->fps = (int)bt->pixelclock / (width * lines);
>>>                         state->std = std;
>>>                         return 0;
>>>                 }
>>>         }
>>>
>>> Note that I've thrown out any comparisons based on horizontal pulse
>>> width from my first patch as that didn't appear to fit well. So far
>>> the above works well however I do fail to recognize the following
>>> modes (using a Marshall SG4K HDMI test generator):
>>>
>>
>> Hans,
>>
>> I've found that I do indeed need to look at the 'hsper' that the TDA
>> provides above along with the vper/hper as there are several timings
>> that match a given vper/hper. However I haven't figured out how to
>> make sense of the hsper value that is returned.
>>
>> Here are some example timings and the vper/hper/hsper returned from the TDA:
>> V4L2_DV_BT_DMT_1280X960P60 449981/448/55
>> V4L2_DV_BT_DMT_1280X1024P60 449833/420/27
>> V4L2_DV_BT_DMT_1280X768P60 450021/568/11
>> V4L2_DV_BT_DMT_1360X768P60 449867/564/34
>>
>> Do you know what the hsper could be here? It doesn't appear to match
>> v4l2_bt_timings hsync ((27MHz/bt->pixelclock)*bt->hsync).
>
> Actually, all numbers except for the first match (assuming V4L2_DV_BT_DMT_1280X768P60
> is really V4L2_DV_BT_DMT_1280X768P60_RB).

Hans,

These are actual timings that I'm feeding the TDA input from a
Marshall V-SG4K-HDI HDMI test generator so they really are different
timings and those are the vper/hper/hsper the TDA reports for them.
Also, when I look at the original vendor code which had pre-calculated
min/max numbers for vper/hper/hsper it matches the numbers above so I
don't think the HDMI test generator is in error.

Tim

>
> Are you sure about the first one?
>
> Unfortunately, due to rounding errors the hsper is simply not accurate enough to
> use reliably. Furthermore, what is really needed if you want to add support for
> GTF and CVT standards is the vsync value, and that's not reported at all.
>
> I'd just give up on this and use your original code.
>
> Very poor hardware design :-(
>
> Regards,
>
>         Hans
