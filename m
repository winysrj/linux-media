Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40470 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0F1XeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 19:34:12 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 28 Jun 2010 18:34:01 -0500
Subject: [media-ctl] [omap3camera:devel] How to use the app?
Message-ID: <A24693684029E5489D1D202277BE8944562E8B71@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent/Sakari,

I have been attempting to migrate my IMX046 sensor driver, that I had working
on my Zoom3(OMAP3630 ES1.1) with older codebase, to work with the latest
omap3camera tree, 'devel' branch:

http://gitorious.org/omap3camera/mainline/commits/devel

And for that, I'm trying to also understand how to use your test tool:
"media-ctl":

http://git.ideasonboard.org/?p=media-ctl.git;a=summary

Now, the thing is that, I don't see any guide to learn how to write the
Proper format for some of the parameters, like to build links in interactive
mode (-i), or to set formats (-f).

Can you please detail about a typical usage for this tool? (example on how to
build a link, set link format, etc.)

So far, my progress is pushed into this branch:

http://dev.omapzoom.org/?p=saaguirre/linux-omap-camera.git;a=shortlog;h=refs/heads/mc_migration_wip

And with that, after I boot, I get the following topology:

# /media-ctl -d /dev/media0 -p
Opening media device /dev/media0
Enumerating entities
Found 18 entities
Enumerating pads and links
Device topology
- entity 1: imx046 2-001a (1 pad, 1 link)
            type V4L2 subdev subtype Unknown
            device node name /dev/subdev0
        pad0: Output [SGRBG10 3280x2464]
                -> 'OMAP3 ISP CSI2a':pad0 [IMMUTABLE,ACTIVE]

- entity 2: lv8093 2-0072 (0 pad, 0 link)
            type V4L2 subdev subtype Unknown
            device node name /dev/subdev1

- entity 3: omap3/imx046 2-001a/lv8093 2-00 (1 pad, 0 link)
            type Node subtype V4L
            device node name /dev/video0
        pad0: Input

- entity 4: OMAP3 ISP CCP2 (2 pads, 1 link)
            type V4L2 subdev subtype Unknown
            device node name /dev/subdev2
        pad0: Input [unknown 0x0]
        pad1: Output [unknown 0x0]
                -> 'OMAP3 ISP CCDC':pad0 []

- entity 5: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video1
        pad0: Output
                -> 'OMAP3 ISP CCP2':pad0 []

- entity 6: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/subdev3
        pad0: Input [SGRBG10 0x0]
        pad1: Output [SGRBG10 0x0]
                -> 'OMAP3 ISP CSI2a output':pad0 []
                -> 'OMAP3 ISP CCDC':pad0 []

- entity 7: OMAP3 ISP CSI2a output (1 pad, 0 link)
            type Node subtype V4L
            device node name /dev/video2
        pad0: Input

- entity 8: OMAP3 ISP CCDC (3 pads, 7 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/subdev4
        pad0: Input [unknown 0x0]
        pad1: Output [unknown 0x0]
                -> 'OMAP3 ISP CCDC output':pad0 []
                -> 'OMAP3 ISP resizer':pad0 []
                -> 'omap3/imx046 2-001a/lv8093 2-00':pad0 []
        pad2: Output [unknown 0x0]
                -> 'OMAP3 ISP preview':pad0 []
                -> 'OMAP3 ISP AEWB':pad0 []
                -> 'OMAP3 ISP AF':pad0 []
                -> 'OMAP3 ISP histogram':pad0 []

- entity 9: OMAP3 ISP CCDC output (1 pad, 0 link)
            type Node subtype V4L
            device node name /dev/video3
        pad0: Input

- entity 10: OMAP3 ISP preview (2 pads, 2 links)
             type V4L2 subdev subtype Unknown
             device node name /dev/subdev5
        pad0: Input [unknown 0x0]
        pad1: Output [unknown 0x0]
                -> 'OMAP3 ISP preview output':pad0 []
                -> 'OMAP3 ISP resizer':pad0 []

- entity 11: OMAP3 ISP preview input (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video4
        pad0: Output
                -> 'OMAP3 ISP preview':pad0 []

- entity 12: OMAP3 ISP preview output (1 pad, 0 link)
             type Node subtype V4L
             device node name /dev/video5
        pad0: Input

- entity 13: OMAP3 ISP resizer (2 pads, 2 links)
             type V4L2 subdev subtype Unknown
             device node name /dev/subdev6
        pad0: Input [unknown 0x0]
        pad1: Output [unknown 0x0]
                -> 'OMAP3 ISP resizer output':pad0 []
                -> 'omap3/imx046 2-001a/lv8093 2-00':pad0 []

- entity 14: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video6
        pad0: Output
                -> 'OMAP3 ISP resizer':pad0 []

- entity 15: OMAP3 ISP resizer output (1 pad, 0 link)
             type Node subtype V4L
             device node name /dev/video7
        pad0: Input

- entity 16: OMAP3 ISP AEWB (1 pad, 0 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/subdev7
        pad0: Input

- entity 17: OMAP3 ISP AF (1 pad, 0 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/subdev8
        pad0: Input

- entity 18: OMAP3 ISP histogram (1 pad, 0 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/subdev9
        pad0: Input

Can you help me understand how to configure all this?

Thanks in advance!

Regards,
Sergio

