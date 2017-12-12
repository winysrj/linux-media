Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59261 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752126AbdLLMSm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 07:18:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/5] media: i2c: Add TDA1997x HDMI receiver driver
To: Rob Herring <robh@kernel.org>, Tim Harvey <tharvey@gateworks.com>
References: <1510253136-14153-1-git-send-email-tharvey@gateworks.com>
 <1510253136-14153-4-git-send-email-tharvey@gateworks.com>
 <20171115155204.yhqjocdm32qunllx@rob-hp-laptop>
 <CAJ+vNU0NuNjZePQBaxWHT4HtYGxZJ_DUSvuHvb6wAFDGA_xX9A@mail.gmail.com>
 <20171116043059.azaqjfbjeo4rlaon@rob-hp-laptop>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Message-ID: <f1d607e2-3d21-ac05-c815-a5f28b860b1e@xs4all.nl>
Date: Tue, 12 Dec 2017 13:18:37 +0100
MIME-Version: 1.0
In-Reply-To: <20171116043059.azaqjfbjeo4rlaon@rob-hp-laptop>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

Sorry for the delay, I needed to find some time to think about this.

On 11/16/17 05:30, Rob Herring wrote:
> On Wed, Nov 15, 2017 at 10:31:14AM -0800, Tim Harvey wrote:
>> On Wed, Nov 15, 2017 at 7:52 AM, Rob Herring <robh@kernel.org> wrote:
>>> On Thu, Nov 09, 2017 at 10:45:34AM -0800, Tim Harvey wrote:
>>>> Add support for the TDA1997x HDMI receivers.
>>>>
>>>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>>>> ---
>>>> v3:
>>>>  - use V4L2_DV_BT_FRAME_WIDTH/HEIGHT macros
>>>>  - fixed missing break
>>>>  - use only hdmi_infoframe_log for infoframe logging
>>>>  - simplify tda1997x_s_stream error handling
>>>>  - add delayed work proc to handle hotplug enable/disable
>>>>  - fix set_edid (disable HPD before writing, enable after)
>>>>  - remove enabling edid by default
>>>>  - initialize timings
>>>>  - take quant range into account in colorspace conversion
>>>>  - remove vendor/product tracking (we provide this in log_status via infoframes)
>>>>  - add v4l_controls
>>>>  - add more detail to log_status
>>>>  - calculate vhref generator timings
>>>>  - timing detection fixes (rounding errors, hswidth errors)
>>>>  - rename configure_input/configure_conv functions
>>>>
>>>> v2:
>>>>  - implement dv timings enum/cap
>>>>  - remove deprecated g_mbus_config op
>>>>  - fix dv_query_timings
>>>>  - add EDID get/set handling
>>>>  - remove max-pixel-rate support
>>>>  - add audio codec DAI support
>>>>  - change audio bindings
>>>> ---
>>>>  drivers/media/i2c/Kconfig            |    9 +
>>>>  drivers/media/i2c/Makefile           |    1 +
>>>>  drivers/media/i2c/tda1997x.c         | 3485 ++++++++++++++++++++++++++++++++++
>>>>  include/dt-bindings/media/tda1997x.h |   78 +
>>>
>>> This belongs with the binding documentation patch.
>>>
>>
>> Rob,
>>
>> Thanks - missed that. I will move it for v4.
>>
>> Regarding your previous comment to the v2 series:
>>> The rest of the binding looks fine, but I have some reservations about
>>> this. I think this should be common probably. There's been a few
>>> bindings for display recently that deal with the interface format. Maybe
>>> some vendor property is needed here to map a standard interface format
>>> back to pin configuration.
>>
>> I take it this is not an 'Ack' for the bindings?
>>
>> Which did you feel should be made common? I admit I was surprised
>> there wasn't a common binding for audio bus format (i2s|spdif) but if
>> you were referring to the video data that would probably be much more
>> complicated.
> 
> The video data. Either you have to try to come up with some way to map 
> color components to signals/pins (and even cycles) or you just enumerate 
> the formats and keep adding to them when new ones appear. There's h/w 
> that allows the former, but in the end you have to interoperate, so 
> enumerating the formats is probably enough.
> 
>> I was hoping one of the media/driver maintainers would respond to your
>> comment with thoughts as I'm not familiar with a very wide variety of
>> receivers.
> 
> I am hoping, too.

I don't think it is right to store this in the DT. How you map the output pins
is a driver thing. So when you are requested to enumerate the mediabus formats
(include/uapi/linux/media-bus-format.h) you support, you do so based on the
capabilities of the hardware, and when a format is requested you program the
hardware accordingly.

The device tree should describe the physical characteristics like the number
of pins that are hooked up (i.e. are there 24, 30 or 36 pins connected).

These vidout-portcfg mappings do not appear to describe physical properties
but really register settings.

Apologies if I misunderstood any of this.

Regards,

	Hans
