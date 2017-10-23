Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:56234 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbdJWRGB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 13:06:01 -0400
Received: by mail-wm0-f45.google.com with SMTP id u138so11199951wmu.4
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 10:06:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5c68003a-380d-d339-718f-47bce64cdae8@xs4all.nl>
References: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
 <1507783506-3884-4-git-send-email-tharvey@gateworks.com> <230ceb18-1d69-7fa8-acb0-c810094f8e50@xs4all.nl>
 <CAJ+vNU0Z988G+wTfpiSXXOM9QsPj-eRvH=F1b9__8kJ+18xk4g@mail.gmail.com>
 <a5bd27c9-10e4-b9f5-f0ac-293528fa570e@xs4all.nl> <CAJ+vNU2yHKDf5tCVyj6iw83z0sDuV0ZsZ-=sLfa+fTFbtjVo0A@mail.gmail.com>
 <5c68003a-380d-d339-718f-47bce64cdae8@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 23 Oct 2017 10:05:59 -0700
Message-ID: <CAJ+vNU2a8qtL4hbg5FQamF3WanQG1610QsJv=2cCxpD8OsiQ6w@mail.gmail.com>
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

On Fri, Oct 20, 2017 at 9:23 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

>>
>> I see the AVI infoframe has hdmi_quantization_range and
>> hdmi_ycc_quantization_range along with vid_code.
>>
>> I'm not at all clear what to do with this information. Is there
>> anything you see in the datasheet [1] that points to something I need
>> to be doing?
>
> You can ignore hdmi_ycc_quantization_range, it is the hdmi_quantization_range
> that you need to read out.
>
> The TDA can receive the following formats:
>
> RGB Full Range
> RGB Limited Range
> YUV Bt.601 (aka SMPTE 170M)
> YUV Rec.709
>
> The YUV formats are always limited range.
>
> The TDA can transmit RGB and YUV to the SoC. You want RGB to be full range and
> YUV to be limited range. YUV can be either 601 or 709.
>
> So if the TDA transmits RGB then you need to support the following conversions:
>
> RGB Full -> RGB Full
> RGB Limited -> RGB Full
> YUV 601 -> RGB Full
> YUV 709 -> RGB Full
>
> And if the TDA transmits YUV then you need these conversions:
>
> RGB Full -> YUV601 or YUV709
> RGB Limited -> YUV601 or YUV709
> YUV601 -> YUV601
> YUV709 -> YUV709
>
> For the RGB to YUV conversion you have a choice of converting to YUV601 or 709.
> I recommend to either always convert to YUV601 or to let it depend on the resolution
> (SDTV YUV601, HDTV YUV709).
>

Ok - this is a good explanation that I should be able to follow. I
will make sure to take into account hdmi_quantization_range when I
setup the colorspace conversion matrix for v3.

> Ideally the application should specify what it wants, but we don't have any API
> support for that.
>
<snip>
>>
>> The TDA1997x provides only the vertical/horizontal periods and the
>> horizontal pulse
>> width (section 8.3.4 of datasheet [1]).
>>
>> Can you point me to a good primer on the relationship between these
>> values and the h/v back/front porch?
>
> The blanking consists of a front porch width, a sync width and a back porch width.
> 'Width' is normally measured in pixels. Vertical blanking is the same, except that
> is measured in lines. All these values are defined in the standards that define these
> timings (e.g. VESA DMT, CTA-861).
>
> So for 1080p60 the active video is 1920x1080. After each line of 1920 pixels you
> have 88 'pixels' of front porch, a sync pulse of 44 'pixels' and a back porch of
> 148 pixels. Total frame width is 2200. Similar for the vertical.
>
> A good HDMI receiver will give you the exact values for these blanking sizes.
> Especially the sync width/height is important since that can provide additional
> format information when receiving VESA formats.
>
> It looks as if the TDA does not measure in exact pixels but in 27 MHz clock
> periods. Which is an approximation only.
>
> So it appears that what you do is the best you can do.
>
> Although I wonder about the hsper: the datasheet suggests that this is the width,
> not a period. What is the value you read out when you receive 1080p60? If that
> would be an exact width, then that would help a lot since you can compare that
> against bt->hsync.

Here's a list of source modes and the vertical/horizontal period and
horizontal pulse width returned from the TDA:
00: VESA640x480P_60HZ 450427 856 101
01: VESA800x600P_60HZ 447620 711 85
02: VESA1024x768P_60HZ 449952 557 55
03: VESA1280x768P_60HZ 450021 568 11
04: VESA1360x768P_60HZ 449867 564 34
05: VESA1280x960P_60HZ 449981 448 55
06: VESA1280x1024P_60HZ 449833 420 27
07: VESA1400x1050P_60HZ 450372 416 7
08: VESA1600x1200P_60HZ 449981 358 27
09: VESA1920x1200P_60HZ 450355 363 4
10: CEAVIC1440x480I_60HZ 450430 1714 123
11: CEAVIC720x480P_60HZ 450430 856 61
12: CEAVIC1280x720P_60HZ 449981 598 13
13: CEAVIC1280x720P_59.94 450431 599 13
14: CEAVIC1920x1080I_60HZ 449981 798 15
15: CEAVIC1920x1080I_59.95HZ 450431 799 15
16: CEAVIC1920x1080P_30HZ 899962 798 15
17: CEAVIC1920x1080P_29.95HZ 900862 799 15
18: CEAVIC1920x1080P_24HZ 1124953 998 15
19: CEAVIC1920x1080P_23.976HZ 1126077 999 15
20: CEAVIC1920x1080P_60HZ 449981 398 7
21: CEAVIC1920x1080P_59.94HZ 450431 399 7
22: CEAVIC1440x576I_50HZ 539976 1726 127
23: CEAVIC720x576P_50HZ 539976 862 63
24: CEAVIC1280x720P_50HZ 539977 718 13
25: CEAVIC1920x1080I_50HZ 539977 958 15
26: CEAVIC1920x1080P_25HZ 1079954 958 15
27: CEAVIC1920x1080P_50HZ 539977 478 7

so 1080p60 gives a hswidth=7

Tim
