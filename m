Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:42764 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752322AbdJTQXg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 12:23:36 -0400
Subject: Re: [PATCH v2 3/4] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>
References: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
 <1507783506-3884-4-git-send-email-tharvey@gateworks.com>
 <230ceb18-1d69-7fa8-acb0-c810094f8e50@xs4all.nl>
 <CAJ+vNU0Z988G+wTfpiSXXOM9QsPj-eRvH=F1b9__8kJ+18xk4g@mail.gmail.com>
 <a5bd27c9-10e4-b9f5-f0ac-293528fa570e@xs4all.nl>
 <CAJ+vNU2yHKDf5tCVyj6iw83z0sDuV0ZsZ-=sLfa+fTFbtjVo0A@mail.gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c68003a-380d-d339-718f-47bce64cdae8@xs4all.nl>
Date: Fri, 20 Oct 2017 18:23:33 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2yHKDf5tCVyj6iw83z0sDuV0ZsZ-=sLfa+fTFbtjVo0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/10/17 16:00, Tim Harvey wrote:
> On Thu, Oct 19, 2017 at 12:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> <snip>
>>>> What I am missing here is handling of the RGB quantization range.
>>>> An HDMI receiver will typically send full range RGB or limited range YUV
>>>> to the SoC. The HDMI source can however send full or limited range RGB
>>>> or limited range YUV (full range YUV is theoretically possible, but nobody
>>>> does that).
>>>>
>>>
>>> isn't this quantization range a function of the colorspace and
>>> colorimetry dictated by the AVI infoframe? I'm taking these into
>>> consideration when setting up the conversion matrix in
>>> tda1997x_configure_conv().
>>
>> No, it's independent of that.
> 
> and from another reply:
>> A small correction here: while ideally you should indeed check if the current
>> EDID supports selectable RGB Quantization Range, in practice you don't need
>> to. If the source explicitly sets the RGB quantization range, then just use
>> that.
>>
>> Note: some hardware can do this automatically (adv7604) by detecting what is
>> transmitted in the AVI InfoFrame. That's probably not the case here since you
>> have to provide a conversion matrix.
> 
> I see the AVI infoframe has hdmi_quantization_range and
> hdmi_ycc_quantization_range along with vid_code.
> 
> I'm not at all clear what to do with this information. Is there
> anything you see in the datasheet [1] that points to something I need
> to be doing?

You can ignore hdmi_ycc_quantization_range, it is the hdmi_quantization_range
that you need to read out.

The TDA can receive the following formats:

RGB Full Range
RGB Limited Range
YUV Bt.601 (aka SMPTE 170M)
YUV Rec.709

The YUV formats are always limited range.

The TDA can transmit RGB and YUV to the SoC. You want RGB to be full range and
YUV to be limited range. YUV can be either 601 or 709.

So if the TDA transmits RGB then you need to support the following conversions:

RGB Full -> RGB Full
RGB Limited -> RGB Full
YUV 601 -> RGB Full
YUV 709 -> RGB Full

And if the TDA transmits YUV then you need these conversions:

RGB Full -> YUV601 or YUV709
RGB Limited -> YUV601 or YUV709
YUV601 -> YUV601
YUV709 -> YUV709

For the RGB to YUV conversion you have a choice of converting to YUV601 or 709.
I recommend to either always convert to YUV601 or to let it depend on the resolution
(SDTV YUV601, HDTV YUV709).

Ideally the application should specify what it wants, but we don't have any API
support for that.

> 
>>
>>>
>>>> For a Full HD receiver the rules when receiving RGB video are as follows:
>>>>
>>>> If the EDID supports selectable RGB Quantization Range, then check if the
>>>> source explicitly sets the RGB quantization range in the AVI InfoFrame and
>>>> use that value.
>>>>
>>>> Otherwise fall back to the default rules:
>>>>
>>>> if VIC == 0, then expect full range RGB, otherwise expect limited range RGB.
>>>
>>> Are you referring to the video_code field of the AVI infoframe or vic
>>> from a vendor infoframe?
>>
>> AVI InfoFrame.
>>
>> The HDMI VIC codes in the vendor InfoFrame are only valid for 4k formats. And
>> that's not supported by this device, right?
> 
> Right, the TDA1997x supports 1080p only.
> 
>>
>>>
>>>>
>>>> It gets even more complicated with 4k video, but this is full HD only.
>>>>
>>>> In addition, you may also want to implement the V4L2_CID_DV_RX_RGB_RANGE control
>>>> to let userspace override the autodetection.
>>>
>>> I'll add that as an additional patch. Are there other V4L2_CID's that
>>> I should be adding here?
>>
>> V4L2_CID_DV_RX_POWER_PRESENT (if possible) and optionally V4L2_CID_DV_RX_IT_CONTENT_TYPE.
>>
> 
> It looks like there is a register for 5V_HPD detect.
> 
> I assume the content type to return is the value reported from the AVI frame?

Correct.

> 
> <snip>
>>>
>>> Regarding video standard detection where this chip provides me with
>>> vertical-period, horizontal-period, and horizontal-pulse-width I
>>> should be able to detect the standard simply based off of
>>> vertical-period (framerate) and horizontal-period (line width
>>> including blanking) right? I wasn't sure if my method of matching
>>> these within 14% tolerance made sense. I will be removing the hsmatch
>>> logic from that as it seems the horizontal-pulse-width should be
>>> irrelevant.
>>
>> For proper video detection you ideally need:
>>
>> h/v sync size
>> h/v back/front porch size
>> h/v polarity
>> pixelclock (usually an approximation)
>>
>> The v4l2_find_dv_timings_cap() helper can help you find the corresponding
>> timings, allowing for pixelclock variation.
>>
>> That function assumes that the sync/back/frontporch values are all known.
>> But not all devices can actually discover those values. What can your
>> hardware detect? Can it tell front and backporch apart? Can it determine
>> the sync size?
>>
>> I've been considering for some time to improve that helper function to be
>> able to handle hardware that isn't able separate sync/back/frontporch values.
>>
> 
> The TDA1997x provides only the vertical/horizontal periods and the
> horizontal pulse
> width (section 8.3.4 of datasheet [1]).
> 
> Can you point me to a good primer on the relationship between these
> values and the h/v back/front porch?

The blanking consists of a front porch width, a sync width and a back porch width.
'Width' is normally measured in pixels. Vertical blanking is the same, except that
is measured in lines. All these values are defined in the standards that define these
timings (e.g. VESA DMT, CTA-861).

So for 1080p60 the active video is 1920x1080. After each line of 1920 pixels you
have 88 'pixels' of front porch, a sync pulse of 44 'pixels' and a back porch of
148 pixels. Total frame width is 2200. Similar for the vertical.

A good HDMI receiver will give you the exact values for these blanking sizes.
Especially the sync width/height is important since that can provide additional
format information when receiving VESA formats.

It looks as if the TDA does not measure in exact pixels but in 27 MHz clock
periods. Which is an approximation only.

So it appears that what you do is the best you can do.

Although I wonder about the hsper: the datasheet suggests that this is the width,
not a period. What is the value you read out when you receive 1080p60? If that
would be an exact width, then that would help a lot since you can compare that
against bt->hsync.

> 
> Currently I iterate over the list of known formats calculating hper
> (bt->pixelclock / V4L2_DV_BT_FRAME_WIDTH(bt)) and vper (hper /
> V4L2_DV_BT_FRAME_HEIGHT(bt)) (framerate) and find the closest match
> within +/- 7% tolerance. The list of supported formats is sorted by
> framerate then width.
> 
>         /* look for matching timings */
>         for (i = 0; i < ARRAY_SIZE(tda1997x_hdmi_modes); i++) {
>                 const struct tda1997x_video_std *std = &tda1997x_hdmi_modes[i];
>                 const struct v4l2_bt_timings *bt = &std->timings.bt;
>                 int _hper, _vper, _hsper;
>                 int vmin, vmax, hmin, hmax, hsmin, hsmax;
>                 int vmatch, hsmatch;
> 
>                 width = V4L2_DV_BT_FRAME_WIDTH(bt);
>                 lines = V4L2_DV_BT_FRAME_HEIGHT(bt);
> 
>                 _hper = (int)bt->pixelclock / (int)width;
>                 _vper = _hper / lines;
>                 _hsper = (int)bt->pixelclock / (int)bt->hsync;
>                 if (bt->interlaced)
>                         _vper *= 2;
>                 /* vper +/- 0.7% */
>                 vmin = 993 * (27000000 / _vper) / 1000;
>                 vmax = 1007 * (27000000 / _vper) / 1000;
>                 _hsper = (int)bt->pixelclock / (int)bt->hsync;
>                 if (bt->interlaced)
>                         _vper *= 2;
>                 /* vper +/- 0.7% */
>                 vmin = 993 * (27000000 / _vper) / 1000;
>                 vmax = 1007 * (27000000 / _vper) / 1000;
>                 /* hper +/- 0.7% */
>                 hmin = 993 * (27000000 / _hper) / 1000;
>                 hmax = 1007 * (27000000 / _hper) / 1000;
> 
>                 /* vmatch matches the framerate */
>                 vmatch = ((vper <= vmax) && (vper >= vmin)) ? 1 : 0;
>                 /* hmatch matches the width */
>                 hmatch = ((hper <= hmax) && (hper >= hmin)) ? 1 : 0;
>                 if (vmatch && hsmatch) {
>                         v4l_info(state->client,
>                                  "resolution: %dx%d%c@%d (%d/%d/%d) %dMHz %d\n",
>                                  bt->width, bt->height, bt->interlaced?'i':'p',
>                                  _vper, vper, hper, hsper, pixrate, hsmatch);
>                         state->fps = (int)bt->pixelclock / (width * lines);
>                         state->std = std;
>                         return 0;
>                 }
>         }
> 
> Note that I've thrown out any comparisons based on horizontal pulse
> width from my first patch as that didn't appear to fit well. So far
> the above works well however I do fail to recognize the following
> modes (using a Marshall SG4K HDMI test generator):
> 
> VESA640x480P_60HZ v4l2 defines this as 4L2_DV_BT_CEA_640X480P59_94
> which fails vmatch
> VESA1400x1050P_60HZ should match V4L2_DV_BT_DMT_1400X1050P60_RB but it
> calculates 59Hz and fails vmatch
> VESA1920x1200P_60HZ should match V4L2_DV_BT_DMT_1920X1200P60_RB but it
> calculates 59Hz and fails vmatch
> CEAVIC1440x480I_60HZ not in v4l2-dv-timings.h

This is a pixel-repeat format. They aren't defined in v4l2-dv-timings. I
never came across them in real life, so that's why I never bothered.

> CEAVIC720x480P_60HZ not in v4l2-dv-timings.h (there's a 720x480p59)

They are the same.

> CEAVIC1440x576I_50HZ not in v4l2-dv-timings.h
> 
> I should have mentioned in my cover letter that I only have a
> datasheet for this device and some fairly obfuscated vendor example
> code - I don't have proper register set documentation.
> 
> Regards,
> 
> Tim
> 
> [1] http://dev.gateworks.com/datasheets/TDA19971-datasheet-rev3.pdf
> 

Regards,

	Hans
