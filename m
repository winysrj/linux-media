Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:32938 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753335AbdGCQWU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 12:22:20 -0400
Subject: Re: [PATCH v6 2/3] media: i2c: adv748x: add adv748x driver
To: kieran.bingham@ideasonboard.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        hans.verkuil@cisco.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
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
 <99be887a-678a-c899-09ea-e9fe83a8efb2@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <af794be1-e87e-fff2-267a-cede00e0b55f@xs4all.nl>
Date: Mon, 3 Jul 2017 18:22:00 +0200
MIME-Version: 1.0
In-Reply-To: <99be887a-678a-c899-09ea-e9fe83a8efb2@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2017 05:00 PM, Kieran Bingham wrote:
> Hi Hans,
> 
> On 03/07/17 15:45, Kieran Bingham wrote:
>> Hi Hans,
>>
>> Thanks for your review,
>>
>> On 03/07/17 14:51, Hans Verkuil wrote:
>>> On 06/27/2017 05:03 PM, Kieran Bingham wrote:
>>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>>
>>>> Provide support for the ADV7481 and ADV7482.
> 
> ...
> 
>>>> +/* -----------------------------------------------------------------------------
>>>> + * HDMI and CP
>>>> + */
>>>> +
>>>> +#define ADV748X_HDMI_MIN_WIDTH        640
>>>> +#define ADV748X_HDMI_MAX_WIDTH        1920
>>>> +#define ADV748X_HDMI_MIN_HEIGHT        480
>>>> +#define ADV748X_HDMI_MAX_HEIGHT        1200
>>>> +#define ADV748X_HDMI_MIN_PIXELCLOCK    0        /* unknown */
>>>
>>> 0 makes no sense. Something like 13000000 would work better (pixelclock rate for
>>> V4L2_DV_BT_CEA_720X480I59_94 is 13500000).
>>
>> This is another one that must have got lost somehow - you'd already told me this
>> and I'm really sure I changed it to the value you suggested ...
>>
>> /me is confused at code loss - Must have been a rebase gone bad. :-(
>>
>>
>>>> +#define ADV748X_HDMI_MAX_PIXELCLOCK    162000000
>>>
>>> You probably based that on the 1600x1200p60 format?
>>
>> No idea I'm afraid - it's the value that was set when I recieved the driver...
>>
>>>
>>> 162MHz is a bit low for an adv receiver. The adv7604 and adv8742 have a max rate
>>> of 225 MHz.
>>> This should be documented in the datasheet.
>>
>> Hrm ... haven't found it yet - I'll keep digging....
> 
> 
> I've found this as the most relevant reference:
> 
> ================================================================================
> The ADV7481 HDMI capable receiver supports a maximum pixel clock frequency of
> 162 MHz, allowing HDTV formats up to 1080p, and display resolutions up to UXGA
> (1600 × 1200 at 60 Hz). The device integrates a consumer electronics control
> (CEC) controller that supports the capability discovery and control (CDC)
> feature. The HDMI input port has dedicated 5 V detect and Hot PlugTM assert pins.
> ================================================================================
> 
> So that certainly looks like 162 MHz is the correct value.
> 
>>> Besides, you need a bit of margin since detected pixelclock rates can be a bit off.
> 
> Does that mean you would you recommend adding 0.5 MHz to the 162 MHz in a
> similar way as the minimum, or keep at 162 MHz ?
> 
> (I'm assuming stay at 162 MHz, as the 7604 is set at 225MHz)

If the datasheet states that 162 MHz is max, then it should stay that way.

It's a bit peculiar: the HDMI spec allows for some variation (0.5%?) in pixelclock
rates. So a source may actually use a pixelclock rate up to 1.005 * 162 MHz. So I have
my doubts about whether 162 MHz is really the hard limit. It's hard to test, though.

And from the point of view of the API I don't think it matters.

Regards,

	Hans
