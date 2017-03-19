Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42366 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdCSJ5J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 05:57:09 -0400
Date: Sun, 19 Mar 2017 09:55:58 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
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
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170319095558.GP21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170318204324.GM21222@n2100.armlinux.org.uk>
 <1489884074.21659.7.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1489884074.21659.7.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 18, 2017 at 08:41:14PM -0400, Nicolas Dufresne wrote:
> Along with the norm fallback, GStreamer could could also consider the
> currently set framerate as returned by VIDIOC_G_PARM. At the same time,
> implementing that enumeration shall be straightforward, and will make a
> large amount of existing userspace work.

Since, according to v4l2-compliance, providing the enumeration ioctls
appears to be optional:

1) should v4l2-compliance be checking whether other frame sizes/frame
   intervals are possible, and failing if the enumeration ioctls are
   not supported?

2) would it also make sense to allow gstreamer's v4l2src to try setting
   a these parameters, and only fail if it's unable to set it?  IOW, if
   I use:

gst-launch-1.0 v4l2src device=/dev/video10 ! \
	video/x-bayer,format=RGGB,framerate=20/1 ! ...

   where G_PARM says its currently configured for 25fps, but a S_PARM
   with 20fps would actually succeed.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
