Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34986 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934217AbdC3QMe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 12:12:34 -0400
Subject: Re: [PATCH v6 00/39] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <20170330110249.GF7909@n2100.armlinux.org.uk>
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
Message-ID: <d715bcdf-b2df-8080-6ab4-854aeace31a8@gmail.com>
Date: Thu, 30 Mar 2017 09:12:29 -0700
MIME-Version: 1.0
In-Reply-To: <20170330110249.GF7909@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/30/2017 04:02 AM, Russell King - ARM Linux wrote:
> This fails at step 1.  The removal of the frame interval support now
> means my setup script fails when trying to set the frame interval on
> the camera:
>
> Enumerating pads and links
> Setting up format SRGGB8_1X8 816x616 on pad imx219 0-0010/0
> Format set: SRGGB8_1X8 816x616
> Setting up frame interval 1/25 on pad imx219 0-0010/0
> Frame interval set: 1/25
> Setting up format SRGGB8_1X8 816x616 on pad imx6-mipi-csi2/0
> Format set: SRGGB8_1X8 816x616
> Setting up frame interval 1/25 on pad imx6-mipi-csi2/0
> Unable to set frame interval: Inappropriate ioctl for device (-25)Unable to setup formats: Inappropriate ioctl for device (25)
>
> This is because media-ctl tries to propagate it from the imx219 source
> pad to the csi2 sink pad, and the csi2 now fails that ioctl.

I assume you're using Philipp's frame interval patches to media-ctl.
Can you make the frame interval propagation optional in those patches?
I.e. don't error-out with a failure code if the ioctl returns ENOTTY.

Steve

>
> This makes media-ctl return a failure code, which means that it's not
> possible for a script to determine whether the failure was due to the
> camera setup or something else.  So, we have to assume that the
> whole command failed.
>
> This is completely broken, and I'm even more convinced that those
> arguing for this behaviour really have not thought it through well
> enough before demanding that this code was removed.
>
> As far as I'm concerned, the end result is completely broken and
> unusable.  I'm going to be merging the frame interval support back
> into my test tree, because that's the only sane thing to do.
>
> If v4l2 people want to object to having frame interval support present
> for all subdevs, then _they_ need to make sure that the rest of their
> software conforms to what they're telling people to do.
>
