Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39319 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752494AbeBEMaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 07:30:09 -0500
Subject: Re: media_device.c question: can this workaround be removed?
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <f4e9e722-9c73-e27c-967f-33c7e76de0d5@xs4all.nl>
 <20180205115954.j7e5npbwuyfgl5il@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2291cc25-50fd-90cc-8948-6def4acc73a3@xs4all.nl>
Date: Mon, 5 Feb 2018 13:30:04 +0100
MIME-Version: 1.0
In-Reply-To: <20180205115954.j7e5npbwuyfgl5il@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 12:59 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Feb 05, 2018 at 11:26:47AM +0100, Hans Verkuil wrote:
>> The function media_device_enum_entities() has this workaround:
>>
>>         /*
>>          * Workaround for a bug at media-ctl <= v1.10 that makes it to
>>          * do the wrong thing if the entity function doesn't belong to
>>          * either MEDIA_ENT_F_OLD_BASE or MEDIA_ENT_F_OLD_SUBDEV_BASE
>>          * Ranges.
>>          *
>>          * Non-subdevices are expected to be at the MEDIA_ENT_F_OLD_BASE,
>>          * or, otherwise, will be silently ignored by media-ctl when
>>          * printing the graphviz diagram. So, map them into the devnode
>>          * old range.
>>          */
>>         if (ent->function < MEDIA_ENT_F_OLD_BASE ||
>>             ent->function > MEDIA_ENT_F_TUNER) {
>>                 if (is_media_entity_v4l2_subdev(ent))
>>                         entd->type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
>>                 else if (ent->function != MEDIA_ENT_F_IO_V4L)
>>                         entd->type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
>>         }
>>
>> But this means that the entity type returned by ENUM_ENTITIES just overwrites
>> perfectly fine types by bogus values and thus the returned value differs
>> from that returned by G_TOPOLOGY.
>>
>> Can we please, please remove this workaround? I have no idea why a workaround
>> for media-ctl of all things ever made it in the kernel.
> 
> The entity types were replaced by entity functions back in 2015 with the
> big Media controller reshuffle. While I agree functions are better for
> describing entities than types (and those types had Linux specific
> interfaces in them), the new function-based API still may support a single
> value, i.e. a single function per device.
> 
> This also created two different name spaces for describing entities: the
> old types used by the MC API and the new functions used by MC v2 API.
> 
> This doesn't go well with the fact that, as you noticed, the pad
> information is not available through MC v2 API. The pad information is
> required by the user space so software continues to use the original MC
> API.
> 
> I don't think there's a way to avoid maintaining two name spaces (types and
> functions) without breaking at least one of the APIs.

The comment specifically claims that this workaround is for media-ctl and
it suggests that it is fixed after v1.10. Is that comment bogus? I can't
really tell which commit fixed media-ctl. Does anyone know?

As far as I can tell the function defines have been chosen in such a way that
they will equally well work with the old name space. There should be no
problem there whatsoever and media-ctl should switch to use the new defines.

We now have a broken ENUM_ENTITIES ioctl (it rudely overwrites VBI/DVB/etc types)
and a broken G_TOPOLOGY ioctl (no pad index).

This sucks. Let's fix both so that they at least report consistent information.

> 
>>
>> I'm adding media support to the vivid driver and because of this media-ctl -p
>> gives me this:
>>
>> Device topology
>> - entity 1: vivid-000-vid-cap (1 pad, 0 link)
>>             type Node subtype V4L flags 0
>>             device node name /dev/video0
>>         pad0: Source
>>
>> - entity 5: vivid-000-vid-out (1 pad, 0 link)
>>             type Node subtype V4L flags 0
>>             device node name /dev/video1
>>         pad0: Sink
>>
>> - entity 9: vivid-000-vbi-cap (1 pad, 0 link)
>>             type Unknown subtype Unknown flags 0
>>         pad0: Source
>>
>> - entity 13: vivid-000-vbi-out (1 pad, 0 link)
>>              type Unknown subtype Unknown flags 0
>>         pad0: Sink
>>
>> - entity 17: vivid-000-sdr-cap (1 pad, 0 link)
>>              type Unknown subtype Unknown flags 0
>>         pad0: Source
> 
> It may be that there's no corresponding type for certain functions.

'type' can be interpreted as 'function'. All possible legacy type/subtype
combinations map to a unique function. It's how the spec defines this as well.
But it is subverted by this awful workaround.

Regards,

	Hans
