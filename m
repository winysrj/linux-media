Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37171 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbeITWad (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 18:30:33 -0400
Subject: Re: [RFC PATCH v4 1/2] drm: Add generic colorkey properties for
 display planes
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-tegra@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-media@vger.kernel.org
References: <20180807172202.1961-1-digetx@gmail.com>
 <20180807172202.1961-2-digetx@gmail.com> <7041537.TPdt8DIvGD@avalon>
 <20180814103833.GN21634@phenom.ffwll.local>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <38a5e2cd-83a5-816d-9ad7-3119dc294af0@gmail.com>
Date: Thu, 20 Sep 2018 19:46:06 +0300
MIME-Version: 1.0
In-Reply-To: <20180814103833.GN21634@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8/14/18 1:38 PM, Daniel Vetter wrote:
> On Tue, Aug 14, 2018 at 12:48:08PM +0300, Laurent Pinchart wrote:
>> Hi Dmitry,
>>
>> Thank you for the patch.
>>
>> On Tuesday, 7 August 2018 20:22:01 EEST Dmitry Osipenko wrote:
>>> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>>
>>> Color keying is the action of replacing pixels matching a given color
>>> (or range of colors) with transparent pixels in an overlay when
>>> performing blitting. Depending on the hardware capabilities, the
>>> matching pixel can either become fully transparent or gain adjustment
>>> of the pixels component values.
>>>
>>> Color keying is found in a large number of devices whose capabilities
>>> often differ, but they still have enough common features in range to
>>> standardize color key properties. This commit adds new generic DRM plane
>>> properties related to the color keying, providing initial color keying
>>> support.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>>> ---
>>>   drivers/gpu/drm/drm_atomic.c |  20 +++++
>>>   drivers/gpu/drm/drm_blend.c  | 150 +++++++++++++++++++++++++++++++++++
>>>   include/drm/drm_blend.h      |   3 +
>>>   include/drm/drm_plane.h      |  91 +++++++++++++++++++++
>>>   4 files changed, 264 insertions(+)
>>
>> [snip]
>>
>>> diff --git a/drivers/gpu/drm/drm_blend.c b/drivers/gpu/drm/drm_blend.c
>>> index a16a74d7e15e..13c61dd0d9b7 100644
>>> --- a/drivers/gpu/drm/drm_blend.c
>>> +++ b/drivers/gpu/drm/drm_blend.c
>>> @@ -107,6 +107,11 @@
>>>    *	planes. Without this property the primary plane is always below the
>>> cursor *	plane, and ordering between all other planes is undefined.
>>>    *
>>> + * colorkey:
>>> + *	Color keying is set up with drm_plane_create_colorkey_properties().
>>> + *	It adds support for actions like replacing a range of colors with a
>>> + *	transparent color in the plane. Color keying is disabled by default.
>>> + *
>>>    * Note that all the property extensions described here apply either to the
>>> * plane or the CRTC (e.g. for the background color, which currently is not
>>> * exposed and assumed to be black).
>>> @@ -448,3 +453,148 @@ int drm_atomic_normalize_zpos(struct drm_device *dev,
>>>   	return 0;
>>>   }
>>>   EXPORT_SYMBOL(drm_atomic_normalize_zpos);
>>> +
>>> +static const char * const plane_colorkey_mode_name[] = {
>>> +	[DRM_PLANE_COLORKEY_MODE_DISABLED] = "disabled",
>>> +	[DRM_PLANE_COLORKEY_MODE_TRANSPARENT] = "transparent",
>>> +};
>>> +
>>> +/**
>>> + * drm_plane_create_colorkey_properties - create colorkey properties
>>> + * @plane: drm plane
>>> + * @supported_modes: bitmask of supported color keying modes
>>> + *
>>> + * This function creates the generic color keying properties and attaches
>>> them
>>> + * to the @plane to enable color keying control for blending operations.
>>> + *
>>> + * Glossary:
>>> + *
>>> + * Destination plane:
>>> + *	Plane to which color keying properties are applied, this planes takes
>>> + *	the effect of color keying operation. The effect is determined by a
>>> + *	given color keying mode.
>>> + *
>>> + * Source plane:
>>> + *	Pixels of this plane are the source for color key matching operation.
>>> + *
>>> + * Color keying is controlled by these properties:
>>> + *
>>> + * colorkey.plane_mask:
>>> + *	The mask property specifies which planes participate in color key
>>> + *	matching process, these planes are the color key sources.
>>> + *
>>> + *	Drivers return an error from their plane atomic check if plane can't be
>>> + *	handled.
>>
>> This seems fragile to me. We don't document how userspace determines which
>> planes need to be specified here, and we don't document what happens if a
>> plane underneath the destination plane is not specified in the mask. More
>> precise documentation is needed if we want to use such a property.
>>
>> It also seems quite complex. Is an explicit plane mask really the best option
>> ? What's the reason why planes couldn't be handled ? How do drivers determine
>> that ?
> 
> General comment: This is why we need the reference userspace. I also
> think that any feature throwing up so many tricky questions should come
> with a full set of igt testcases.

At best I can write couple simple tests, simply because Tegra can't do more than 
that.

  Since the reference userspace cannot
> answer how the new uapi should work in all corner-cases (failures and
> stuff like that).

Okay.
