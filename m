Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35785 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935308AbdCLUAl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 16:00:41 -0400
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170312194700.GR21222@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3966c32f-62c0-2809-9db3-d0c0b4eadfc8@gmail.com>
Date: Sun, 12 Mar 2017 13:00:36 -0700
MIME-Version: 1.0
In-Reply-To: <20170312194700.GR21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/12/2017 12:47 PM, Russell King - ARM Linux wrote:
> Another issue.
>
> The "reboot and the /dev/video* devices come up in a completely
> different order" problem seems to exist with this version.
>
> The dot graph I supplied previously had "ipu1_csi0 capture" on
> /dev/video4.  I've just rebooted, and now I find it's on
> /dev/video2 instead.

Yes, that's still an issue I haven't had the chance to get to
yet.

It could be as simple as passing a fixed device node # to
video_register_device(), but something tells me it won't be
that easy. But I'll get to this in next version.

Steve

>
> Here's the extract from the .dot file of the old listing:
>
>         n00000018 [label="ipu1_ic_prpenc capture\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
>         n00000021 [label="ipu1_ic_prpvf capture\n/dev/video1", shape=box, style=filled, fillcolor=yellow]
>         n0000002e [label="ipu2_ic_prpenc capture\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
>         n00000037 [label="ipu2_ic_prpvf capture\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
>         n00000048 [label="ipu1_csi0 capture\n/dev/video4", shape=box, style=filled, fillcolor=yellow]
>         n00000052 [label="ipu1_csi1 capture\n/dev/video5", shape=box, style=filled, fillcolor=yellow]
>         n00000062 [label="ipu2_csi0 capture\n/dev/video6", shape=box, style=filled, fillcolor=yellow]
>         n0000006c [label="ipu2_csi1 capture\n/dev/video7", shape=box, style=filled, fillcolor=yellow]
>
> and here's the same after reboot:
>
>         n00000014 [label="ipu1_csi0 capture\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
>         n0000001e [label="ipu1_csi1 capture\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
>         n00000028 [label="ipu2_csi0 capture\n/dev/video4", shape=box, style=filled, fillcolor=yellow]
>         n00000035 [label="ipu1_ic_prpenc capture\n/dev/video5", shape=box, style=filled, fillcolor=yellow]
>         n0000003e [label="ipu1_ic_prpvf capture\n/dev/video6", shape=box, style=filled, fillcolor=yellow]
>         n0000004c [label="ipu2_csi1 capture\n/dev/video7", shape=box, style=filled, fillcolor=yellow]
>         n00000059 [label="ipu2_ic_prpenc capture\n/dev/video8", shape=box, style=filled, fillcolor=yellow]
>         n00000062 [label="ipu2_ic_prpvf capture\n/dev/video9", shape=box, style=filled, fillcolor=yellow]
>
> (/dev/video0 and /dev/video1 are taken up by CODA, since I updated the
> names of the firmware files, and now CODA initialises... seems the
> back-compat filenames don't work, but that's not a problem with imx6
> capture.)
>
