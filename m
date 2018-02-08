Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:13722 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbeBHP3f (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 10:29:35 -0500
Subject: Re: [PATCH v8 0/7] TDA1997x HDMI video reciver
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
 <c7771c44-a9ff-0207-38f6-28bcc06ccdee@xs4all.nl>
 <CAJ+vNU1oiM0Y0rO-DHi57nVOqnw60A7pn_1=h5b46-BrY7_p2Q@mail.gmail.com>
 <605fd4a8-43ab-c566-57b6-abb1c9f8f0f8@xs4all.nl>
 <7cf38465-7a79-5d81-a995-9acfbacf5023@xs4all.nl>
 <CAJ+vNU014FJZsb44YnidE3fFiqeB6o8A7kvGinJWu7=yq3_dhA@mail.gmail.com>
 <d188a172-fc00-eb46-c6f5-833a86475390@xs4all.nl>
 <1518086816.4359.4.camel@pengutronix.de>
 <3b95357c-e44f-eed9-efd3-e2b0e4ff9eb2@xs4all.nl>
 <e13db87e-761a-b0e5-3802-348c9776674a@xs4all.nl>
 <1518102837.4359.6.camel@pengutronix.de>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <d2d376ef-c74e-3df0-01b3-3ab606664dba@cisco.com>
Date: Thu, 8 Feb 2018 16:29:32 +0100
MIME-Version: 1.0
In-Reply-To: <1518102837.4359.6.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/08/18 16:13, Philipp Zabel wrote:
> On Thu, 2018-02-08 at 13:01 +0100, Hans Verkuil wrote:
>>> These are likely to be filled correctly already. I've just added a commit
>>> to v4l2-compliance to make it easier to see what function is used:
>>>
>>> 	v4l2-compliance -m0 -v
>>
>> Actually, can you run this using the latest v4l-utils version for the imx
>> and post the output?
> 
> I have tried with v4l-utils-1.14.0-111-g542af94c on a platform with a
> Toshiba TC358743 connected via MIPI CSI-2. Apart from a crash [1], I get
> a few:
> - missing G_INPUT on the capture devices - is that really a bug?

Depends who you ask :-)  It's an open issue, we had a patch for this that
was never picked up. Hopefully this will resurrect that patch.

> - cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0,
>   where there is nothing connected that could provide timing information
> - missing enum_mbus_code
> - check_0(reserved) errors on subdev ioctls

Should be fixed by https://patchwork.linuxtv.org/patch/46955/ and
https://patchwork.linuxtv.org/patch/46950/

> - node->enum_frame_interval_pad != (int)pad
> - subscribe event failures
> - g_ext_ctrls does not support count == 0 (which no subdev implements)

Was this patch applied? https://patchwork.linuxtv.org/patch/46958/
That will probably fix this fail.

> 
> [1] https://patchwork.linuxtv.org/patch/46979/
> 
> The CSIs are currently marked as pixel formatters instead of IF bridges,
>   
> the vdics are marked as pixel formatters instead of deinterlacers, and
> the ic_prp is marked as scaler instead of video splitter. The other
> entity functions are initialized correctly.

Thanks for testing this!

	Hans

> Total: 1307, Succeeded: 1089, Failed: 218, Warnings: 4

Total: 1307

Cool!

	Hans
