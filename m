Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55116 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752260AbeBEL75 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 06:59:57 -0500
Date: Mon, 5 Feb 2018 13:59:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: media_device.c question: can this workaround be removed?
Message-ID: <20180205115954.j7e5npbwuyfgl5il@valkosipuli.retiisi.org.uk>
References: <f4e9e722-9c73-e27c-967f-33c7e76de0d5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4e9e722-9c73-e27c-967f-33c7e76de0d5@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Feb 05, 2018 at 11:26:47AM +0100, Hans Verkuil wrote:
> The function media_device_enum_entities() has this workaround:
> 
>         /*
>          * Workaround for a bug at media-ctl <= v1.10 that makes it to
>          * do the wrong thing if the entity function doesn't belong to
>          * either MEDIA_ENT_F_OLD_BASE or MEDIA_ENT_F_OLD_SUBDEV_BASE
>          * Ranges.
>          *
>          * Non-subdevices are expected to be at the MEDIA_ENT_F_OLD_BASE,
>          * or, otherwise, will be silently ignored by media-ctl when
>          * printing the graphviz diagram. So, map them into the devnode
>          * old range.
>          */
>         if (ent->function < MEDIA_ENT_F_OLD_BASE ||
>             ent->function > MEDIA_ENT_F_TUNER) {
>                 if (is_media_entity_v4l2_subdev(ent))
>                         entd->type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
>                 else if (ent->function != MEDIA_ENT_F_IO_V4L)
>                         entd->type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
>         }
> 
> But this means that the entity type returned by ENUM_ENTITIES just overwrites
> perfectly fine types by bogus values and thus the returned value differs
> from that returned by G_TOPOLOGY.
> 
> Can we please, please remove this workaround? I have no idea why a workaround
> for media-ctl of all things ever made it in the kernel.

The entity types were replaced by entity functions back in 2015 with the
big Media controller reshuffle. While I agree functions are better for
describing entities than types (and those types had Linux specific
interfaces in them), the new function-based API still may support a single
value, i.e. a single function per device.

This also created two different name spaces for describing entities: the
old types used by the MC API and the new functions used by MC v2 API.

This doesn't go well with the fact that, as you noticed, the pad
information is not available through MC v2 API. The pad information is
required by the user space so software continues to use the original MC
API.

I don't think there's a way to avoid maintaining two name spaces (types and
functions) without breaking at least one of the APIs.

> 
> I'm adding media support to the vivid driver and because of this media-ctl -p
> gives me this:
> 
> Device topology
> - entity 1: vivid-000-vid-cap (1 pad, 0 link)
>             type Node subtype V4L flags 0
>             device node name /dev/video0
>         pad0: Source
> 
> - entity 5: vivid-000-vid-out (1 pad, 0 link)
>             type Node subtype V4L flags 0
>             device node name /dev/video1
>         pad0: Sink
> 
> - entity 9: vivid-000-vbi-cap (1 pad, 0 link)
>             type Unknown subtype Unknown flags 0
>         pad0: Source
> 
> - entity 13: vivid-000-vbi-out (1 pad, 0 link)
>              type Unknown subtype Unknown flags 0
>         pad0: Sink
> 
> - entity 17: vivid-000-sdr-cap (1 pad, 0 link)
>              type Unknown subtype Unknown flags 0
>         pad0: Source

It may be that there's no corresponding type for certain functions.

> 
> So VBI and SDR report the 'Unknown' type whereas 'v4l2-ctl -D -d /dev/vbi0' (which
> uses G_TOPOLOGY) gives me:
> 
> Interface Info:
>         ID               : 0x0300000b
>         Type             : V4L VBI
> Entity Info:
>         ID               : 0x00000009 (9)
>         Name             : vivid-000-vbi-cap
>         Function         : VBI I/O
>         Pad 0x0100000a   : Source
> 
> That's how it should be.
> 
> <rant mode on>
> 
> Never again should we allow new userspace APIs without:
> 
> 1) Proper compliance tests
> 2) Adding support for the new API to v4l2-ctl (or related v4l-utils apps)
> 3) If the new API replaces old defines with new defines (e.g.
>    #define MEDIA_ENT_T_DEVNODE_V4L MEDIA_ENT_F_IO_V4L) then everything
>    in v4l-utils that uses the old define should be updated to the new
>    define.
> 4) If reasonable add support for the new API to at least one of the
>    virtual drivers (vivid, vimc, vim2m) so this API can be tested without
>    needing specialized hardware.
> 
> The MC API did none of this and how on earth are end-users able to work with
> this if we have horribly inconsistent behavior like this?
> 
> BTW, uapi/linux/media.h is an utter mess. I'll see if I can make a patch to
> make it more understandable. Right now it is extremely hard to tell which
> define is legacy and which isn't.
> 
> <rant mode off>
> 
> Regards,
> 
> 	Hans

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
