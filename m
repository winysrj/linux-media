Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60468 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756722AbdGCOy7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 10:54:59 -0400
Subject: Re: [PATCH v6 2/3] media: i2c: adv748x: add adv748x driver
To: kieran.bingham@ideasonboard.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        hans.verkuil@cisco.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Hyungwoo Yang <hyungwoo.yang@intel.com>
References: <cover.13d48bb2ba66a5e11c962c62b1a7b5832b0a2344.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
 <4c528c1a666f6e9bc8550f70b7c9d84d3c013178.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2b6688cb-3e73-815d-e23f-6c44c2e793af@xs4all.nl>
 <3a8aecf8-fbca-d48e-c6c8-ea5122f32e97@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <43cf18ed-26ee-384d-192b-9c0c672c0c90@xs4all.nl>
Date: Mon, 3 Jul 2017 16:54:52 +0200
MIME-Version: 1.0
In-Reply-To: <3a8aecf8-fbca-d48e-c6c8-ea5122f32e97@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2017 04:45 PM, Kieran Bingham wrote:
>>> +#define ADV748X_HDMI_MAX_PIXELCLOCK    162000000
>>
>> You probably based that on the 1600x1200p60 format?
> 
> No idea I'm afraid - it's the value that was set when I recieved the driver...
> 
>>
>> 162MHz is a bit low for an adv receiver. The adv7604 and adv8742 have a max rate
>> of 225 MHz.
>> This should be documented in the datasheet.
> 
> Hrm ... haven't found it yet - I'll keep digging....

This is often documented in the hardware datasheet, not the programming datasheet.

>>> +static void adv748x_hdmi_fill_format(struct adv748x_hdmi *hdmi,
>>> +                     struct v4l2_mbus_framefmt *fmt)
>>> +{
>>> +    memset(fmt, 0, sizeof(*fmt));
>>> +
>>> +    fmt->code = MEDIA_BUS_FMT_RGB888_1X24;
>>> +    fmt->field = hdmi->timings.bt.interlaced ?
>>> +        V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE;
>>
>> INTERLACED -> ALTERNATE.
> 
> OK.
> 
> OOI: Is this because of the removal of the interlaced cap - or because
> V4L2_FIELD_INTERLACED is deprecated or such?

Unless the adv748x has a deinterlacer you will receive the fields as separate
transfers.

FIELD_INTERLACED means that the two fields are combined into a single frame, but
I doubt that that's what happens. FIELD_ALTERNATE means that the top and bottom
fields are send one after the other.

FIELD_INTERLACED is very common for SDTV, but FIELD_ALTERNATE is almost always
used for HDTV.

That reminds me: in adv748x_afe_fill_format you also set FIELD_INTERLACED, but
is that correct? Shouldn't that also be FIELD_ALTERNATE?

> 
>>> +
>>> +    /* The colorspace depends on the AVI InfoFrame contents */

Missed that in the first review: add a 'TODO:' before this comment.

>>> +    fmt->colorspace = V4L2_COLORSPACE_SRGB;
>>> +
>>> +    fmt->width = hdmi->timings.bt.width;
>>> +    fmt->height = hdmi->timings.bt.height;
>>> +}

Regards,

	Hans
