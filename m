Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41053 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752925AbeBEPTe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 10:19:34 -0500
Subject: Re: media_device.c question: can this workaround be removed?
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <f4e9e722-9c73-e27c-967f-33c7e76de0d5@xs4all.nl>
 <20180205115954.j7e5npbwuyfgl5il@valkosipuli.retiisi.org.uk>
 <2291cc25-50fd-90cc-8948-6def4acc73a3@xs4all.nl>
 <20180205143039.uhlxala2vc4diysp@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <10d299e0-4edf-75dc-56f1-3acfb6ed719b@xs4all.nl>
Date: Mon, 5 Feb 2018 16:19:28 +0100
MIME-Version: 1.0
In-Reply-To: <20180205143039.uhlxala2vc4diysp@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 03:30 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Feb 05, 2018 at 01:30:04PM +0100, Hans Verkuil wrote:
>> On 02/05/2018 12:59 PM, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Mon, Feb 05, 2018 at 11:26:47AM +0100, Hans Verkuil wrote:
>>>> The function media_device_enum_entities() has this workaround:
>>>>
>>>>         /*
>>>>          * Workaround for a bug at media-ctl <= v1.10 that makes it to
>>>>          * do the wrong thing if the entity function doesn't belong to
>>>>          * either MEDIA_ENT_F_OLD_BASE or MEDIA_ENT_F_OLD_SUBDEV_BASE
>>>>          * Ranges.
>>>>          *
>>>>          * Non-subdevices are expected to be at the MEDIA_ENT_F_OLD_BASE,
>>>>          * or, otherwise, will be silently ignored by media-ctl when
>>>>          * printing the graphviz diagram. So, map them into the devnode
>>>>          * old range.
>>>>          */
>>>>         if (ent->function < MEDIA_ENT_F_OLD_BASE ||
>>>>             ent->function > MEDIA_ENT_F_TUNER) {
>>>>                 if (is_media_entity_v4l2_subdev(ent))
>>>>                         entd->type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
>>>>                 else if (ent->function != MEDIA_ENT_F_IO_V4L)
>>>>                         entd->type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
>>>>         }
>>>>
>>>> But this means that the entity type returned by ENUM_ENTITIES just overwrites
>>>> perfectly fine types by bogus values and thus the returned value differs
>>>> from that returned by G_TOPOLOGY.
>>>>
>>>> Can we please, please remove this workaround? I have no idea why a workaround
>>>> for media-ctl of all things ever made it in the kernel.
>>>
>>> The entity types were replaced by entity functions back in 2015 with the
>>> big Media controller reshuffle. While I agree functions are better for
>>> describing entities than types (and those types had Linux specific
>>> interfaces in them), the new function-based API still may support a single
>>> value, i.e. a single function per device.
>>>
>>> This also created two different name spaces for describing entities: the
>>> old types used by the MC API and the new functions used by MC v2 API.
>>>
>>> This doesn't go well with the fact that, as you noticed, the pad
>>> information is not available through MC v2 API. The pad information is
>>> required by the user space so software continues to use the original MC
>>> API.
>>>
>>> I don't think there's a way to avoid maintaining two name spaces (types and
>>> functions) without breaking at least one of the APIs.
>>
>> The comment specifically claims that this workaround is for media-ctl and
>> it suggests that it is fixed after v1.10. Is that comment bogus? I can't
>> really tell which commit fixed media-ctl. Does anyone know?
>>
>> As far as I can tell the function defines have been chosen in such a way that
>> they will equally well work with the old name space. There should be no
>> problem there whatsoever and media-ctl should switch to use the new defines.
> 
> The old interface (type) was centered around the uAPI for the entity.
> That's no longer the case for functions. The entity type
> (MEDIA_ENT_TYPE_MASK) tells the uAPI which affects the interpretation of
> the dev union in struct media_entity_struct as well as the interface that
> device node implements. With the new function field that's no longer the
> case.
> 
> Also, the new MC v2 API makes a separation between the entity function and
> the uAPI (interface) which was lacking in the old API.
> 
>>
>> We now have a broken ENUM_ENTITIES ioctl (it rudely overwrites VBI/DVB/etc types)
>> and a broken G_TOPOLOGY ioctl (no pad index).
>>
>> This sucks. Let's fix both so that they at least report consistent information.
> 
> The existing user space may assume that the type field of the entity
> conveys that the entity does provide a V4L2 sub-device interface if that's
> the case actually.
> 
> This is what media-ctl does and I presume if existing user space checks for
> the type field, it may well have similar checks: it was how the API was
> defined. Therefore it's not entirely accurate to say that only media-ctl
> has this "bug", I'd generally assume programs that use MC (v1) API do this.
> 
> You could argue about the merits (or lack of them) of the old API, no
> disagrement there.

The old API is already broken. E.g. using MEDIA_ENT_F_PROC_VIDEO_SCALER in
vimc/vimc-scaler.c (instead of the current - and bogus - MEDIA_ENT_F_ATV_DECODER)
gives me this with media-ctl:

- entity 21: Scaler (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
        pad0: Sink
                [fmt:RGB888_1X24/640x480 field:none]
                <- "Debayer A":1 [ENABLED]
                <- "Debayer B":1 []
                <- "RGB/YUV Input":0 []
        pad1: Source
                [fmt:RGB888_1X24/1920x1440 field:none]
                -> "RGB/YUV Capture":0 [ENABLED,IMMUTABLE]

Useless. We now have an old API that gives us pad indices but not the
function, and a new API that gives us the function but not the pad index.

How about adding a 'function' field to struct media_entity_desc
and fill that? Keep the type for backwards compatibility.

Then have a define like this:

#define MEDIA_ENT_HAS_FUNCTION(media_version) ((media_version) >= KERNEL_VERSION(a, b, c))

that can be used to detect if the MC has function support.

Regards,

	Hans
