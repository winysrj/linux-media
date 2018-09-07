Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:45916 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbeIGSdJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 14:33:09 -0400
Subject: Re: [PATCH v9 5/9] media: platform: Add Cedrus VPU decoder driver
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Paul Kocialkowski <contact@paulk.fr>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180906222442.14825-1-contact@paulk.fr>
 <20180906222442.14825-6-contact@paulk.fr>
 <4b30c0bf-e525-1868-f625-569d4a104aa0@xs4all.nl>
 <20180907132620.lmsvlwpa3rzioj2h@flea>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2c9689b2-c5a6-58b7-b467-fc53208ecd2d@xs4all.nl>
Date: Fri, 7 Sep 2018 15:52:00 +0200
MIME-Version: 1.0
In-Reply-To: <20180907132620.lmsvlwpa3rzioj2h@flea>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/2018 03:26 PM, Maxime Ripard wrote:
> Hi Hans,
> 
> On Fri, Sep 07, 2018 at 03:13:19PM +0200, Hans Verkuil wrote:
>> On 09/07/2018 12:24 AM, Paul Kocialkowski wrote:
>>> From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>>
>>> This introduces the Cedrus VPU driver that supports the VPU found in
>>> Allwinner SoCs, also known as Video Engine. It is implemented through
>>> a V4L2 M2M decoder device and a media device (used for media requests).
>>> So far, it only supports MPEG-2 decoding.
>>>
>>> Since this VPU is stateless, synchronization with media requests is
>>> required in order to ensure consistency between frame headers that
>>> contain metadata about the frame to process and the raw slice data that
>>> is used to generate the frame.
>>>
>>> This driver was made possible thanks to the long-standing effort
>>> carried out by the linux-sunxi community in the interest of reverse
>>> engineering, documenting and implementing support for the Allwinner VPU.
>>>
>>> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
>>
>> One high-level comment:
>>
>> Can you add a TODO file for this staging driver? This can be done in
>> a follow-up patch.
>>
>> It should contain what needs to be done to get this out of staging:
>>
>> - Request API needs to stabilize
>> - Userspace support for stateless codecs must be created
> 
> On that particular note, as part of the effort to develop the driver,
> we've also developped two userspace components:
> 
>   - v4l2-request-test, that has a bunch of sample frames for various
>     codecs and will rely solely on the kernel request api (and DRM for
>     the display part) to test and bringup a particular driver
>     https://github.com/bootlin/v4l2-request-test
> 
>   - libva-v4l2-request, that is a libva implementation using the
>     request API
>     https://github.com/bootlin/libva-v4l2-request
> 
> Did you have something else in mind?

Reviewing this will be the next step. I haven't looked at the userspace components
at all yet, so I don't know yet whether it is what we expect/want/need.

I think this might be a very good topic for the media summit in October if we
can get all the stakeholders together.

Regards,

	Hans
