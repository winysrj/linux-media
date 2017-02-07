Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34188 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdBGBww (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 20:52:52 -0500
Subject: Re: [PATCH v3 20/24] media: imx: Add Camera Interface subdev driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-21-git-send-email-steve_longerbeam@mentor.com>
 <20170202223528.GX27312@n2100.armlinux.org.uk>
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b836f8c6-f166-261e-a989-414a5b56af70@gmail.com>
Date: Mon, 6 Feb 2017 17:52:48 -0800
MIME-Version: 1.0
In-Reply-To: <20170202223528.GX27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 02/02/2017 02:35 PM, Russell King - ARM Linux wrote:
> <snip>
> However, "*vfd" contains a struct device, and you _correctly_ set the
> release function for "*vfd" to video_device_release via camif_videodev.
>
> However, if you try to rmmod imx-media, then you end up with a kernel
> warning that you're freeing memory containing a held lock, and later
> chaos ensues because kmalloc has been corrupted.
>
> The root cause of this is embedding the device structure within the
> video_device into the driver's private data.  *Any* structure what so
> ever that contains a kref is reference counted, and that includes
> struct device, and therefore also includes struct video_device.  What
> that means is that its lifetime is _not_ under _your_ control, and
> you may not free it except through its release function (which is
> video_device_release().)  However, that also tries to kfree (with an
> offset of 4) your private data, which results in the warning and the
> corrupted kmalloc free lists.
>
> The solution is simple, make "vfd" a pointer in your private data
> structure and kmalloc() it separately, letting video_device_release()
> kfree() that data when it needs to.

Thanks Russell for tracking this down. I remember doing this
when I was reviewing the code for opportunities to "optimize" :-/,
and carelessly caused this bug by not reviewing how video_device
is freed.

Fixed.

Steve

