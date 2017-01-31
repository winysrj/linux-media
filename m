Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33427 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdAaCHa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 21:07:30 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170131004510.GQ27312@n2100.armlinux.org.uk>
 <20170131010653.GR27312@n2100.armlinux.org.uk>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <396ef27c-4de2-a412-4369-9c33bf199826@gmail.com>
Date: Mon, 30 Jan 2017 18:06:33 -0800
MIME-Version: 1.0
In-Reply-To: <20170131010653.GR27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/30/2017 05:06 PM, Russell King - ARM Linux wrote:
> On Tue, Jan 31, 2017 at 12:45:11AM +0000, Russell King - ARM Linux wrote:
>> Trying this driver with an imx219 camera (which works with Philipp's
>> driver) results in not much happening... no /dev/media* node for it,
>> no subdevs, no nothing.  No clues as to what's missing either.  Only
>> messages from imx-media are from registering the various subdevs.
> Another issue:
>
> imx_csi                 5491  4
> imx_camif              11654  4
> imx_ic                 23961  8
> imx_smfc                6639  4
> imx_media              23308  1 imx_csi
> imx_mipi_csi2           5544  1
> imx_media_common       12701  6 imx_csi,imx_smfc,imx_media,imx_mipi_csi2,imx_camif,imx_ic
> imx219                 21205  2
>
> So how does one remove any of these modules, say, while developing a
> camera driver?  Having to reboot to test an update makes it painfully
> slow for testing.

Unload is not working yet, it's on the TODO list.

But FWIW, here's how it currently looks in version 4
(on the SabreSD):

imx_media_csi           9663  4
imx_media_ic           12688  6
imx_media_capture      10201  2 imx_media_ic,imx_media_csi
imx_media_vdic          6909  2
imx_mipi_csi2           6293  1
ov5640_mipi            25988  1
imx_media              15532  0
imx_media_common       16093  6 
imx_media_ic,imx_media,imx_media_csi,imx_mipi_cs
i2,imx_media_capture,imx_media_vdic


Steve


>
> Philipp's driver can do this (once the unload bugs are fixed, which I
> have patches for).
>

