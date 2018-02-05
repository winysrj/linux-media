Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54878 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752498AbeBEK0w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 05:26:52 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: media_device.c question: can this workaround be removed?
Message-ID: <f4e9e722-9c73-e27c-967f-33c7e76de0d5@xs4all.nl>
Date: Mon, 5 Feb 2018 11:26:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function media_device_enum_entities() has this workaround:

        /*
         * Workaround for a bug at media-ctl <= v1.10 that makes it to
         * do the wrong thing if the entity function doesn't belong to
         * either MEDIA_ENT_F_OLD_BASE or MEDIA_ENT_F_OLD_SUBDEV_BASE
         * Ranges.
         *
         * Non-subdevices are expected to be at the MEDIA_ENT_F_OLD_BASE,
         * or, otherwise, will be silently ignored by media-ctl when
         * printing the graphviz diagram. So, map them into the devnode
         * old range.
         */
        if (ent->function < MEDIA_ENT_F_OLD_BASE ||
            ent->function > MEDIA_ENT_F_TUNER) {
                if (is_media_entity_v4l2_subdev(ent))
                        entd->type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
                else if (ent->function != MEDIA_ENT_F_IO_V4L)
                        entd->type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
        }

But this means that the entity type returned by ENUM_ENTITIES just overwrites
perfectly fine types by bogus values and thus the returned value differs
from that returned by G_TOPOLOGY.

Can we please, please remove this workaround? I have no idea why a workaround
for media-ctl of all things ever made it in the kernel.

I'm adding media support to the vivid driver and because of this media-ctl -p
gives me this:

Device topology
- entity 1: vivid-000-vid-cap (1 pad, 0 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0: Source

- entity 5: vivid-000-vid-out (1 pad, 0 link)
            type Node subtype V4L flags 0
            device node name /dev/video1
        pad0: Sink

- entity 9: vivid-000-vbi-cap (1 pad, 0 link)
            type Unknown subtype Unknown flags 0
        pad0: Source

- entity 13: vivid-000-vbi-out (1 pad, 0 link)
             type Unknown subtype Unknown flags 0
        pad0: Sink

- entity 17: vivid-000-sdr-cap (1 pad, 0 link)
             type Unknown subtype Unknown flags 0
        pad0: Source

So VBI and SDR report the 'Unknown' type whereas 'v4l2-ctl -D -d /dev/vbi0' (which
uses G_TOPOLOGY) gives me:

Interface Info:
        ID               : 0x0300000b
        Type             : V4L VBI
Entity Info:
        ID               : 0x00000009 (9)
        Name             : vivid-000-vbi-cap
        Function         : VBI I/O
        Pad 0x0100000a   : Source

That's how it should be.

<rant mode on>

Never again should we allow new userspace APIs without:

1) Proper compliance tests
2) Adding support for the new API to v4l2-ctl (or related v4l-utils apps)
3) If the new API replaces old defines with new defines (e.g.
   #define MEDIA_ENT_T_DEVNODE_V4L MEDIA_ENT_F_IO_V4L) then everything
   in v4l-utils that uses the old define should be updated to the new
   define.
4) If reasonable add support for the new API to at least one of the
   virtual drivers (vivid, vimc, vim2m) so this API can be tested without
   needing specialized hardware.

The MC API did none of this and how on earth are end-users able to work with
this if we have horribly inconsistent behavior like this?

BTW, uapi/linux/media.h is an utter mess. I'll see if I can make a patch to
make it more understandable. Right now it is extremely hard to tell which
define is legacy and which isn't.

<rant mode off>

Regards,

	Hans
