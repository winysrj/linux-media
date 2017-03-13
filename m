Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58000 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdCMMgG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:36:06 -0400
Date: Mon, 13 Mar 2017 12:35:14 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>, mark.rutland@arm.com,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        nick@shmanahar.org, songjun.wu@microchip.com, pavel@ucw.cz,
        shuah@kernel.org, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, robert.jarzmik@free.fr,
        geert@linux-m68k.org, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, tiffany.lin@mediatek.com,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        jean-christophe.trotin@st.com, sakari.ailus@linux.intel.com,
        fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170313123514.GH21222@n2100.armlinux.org.uk>
References: <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
 <20170311184551.GD21222@n2100.armlinux.org.uk>
 <1f1b350a-5523-34bc-07b7-f3cd2d1fd4c1@gmail.com>
 <20170311185959.GF21222@n2100.armlinux.org.uk>
 <4917d7fb-2f48-17cd-aa2f-d54b0f19ed6e@gmail.com>
 <20170312073745.GI21222@n2100.armlinux.org.uk>
 <fba73c10-4b95-f0d2-e681-0b14ef1fbc1c@gmail.com>
 <734a1731-3fb6-b8cd-6806-5405bd21bf83@xs4all.nl>
 <20170313105842.GG21222@n2100.armlinux.org.uk>
 <20170313084215.7eb6a054@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313084215.7eb6a054@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 13, 2017 at 08:42:15AM -0300, Mauro Carvalho Chehab wrote:
> I don't have myself any hardware with i.MX6. Yet, I believe that
> a low cost board like SolidRun Hummingboard - with comes with a 
> CSI interface compatible with RPi camera modules - will likely
> attract users who need to run generic applications on their
> devices.

As you've previously mentioned about camorama, I've installed it (I
run Ubuntu 16.04 with "gnome-flashback-metacity" on the HB) and I'm
able to use camorama to view the IMX219 camera sensor.

There's some gotcha's though:

* you need to start it on the command line, manually specifying
  which /dev/video device to use, as it always wants to use
  /dev/video0.  With the CODA mem2mem driver loaded, this may not
  be a camera device:

$ v4l2-ctl -d 0 --all
Driver Info (not using libv4l2):
        Driver name   : coda
        Card type     : CODA960
        Bus info      : platform:coda
        Driver version: 4.11.0

* camorama seems to use the v4lconvert library, and looking at the
  resulting image quality, is rather pixelated - my guess is that
  v4lconvert is using a basic algorithm to de-bayer the data.  It
  also appears to only manage 7fps at best.  The gstreamer neon
  debayer plugin appears to be faster and higher quality.

* it provides five controls - brightness/contrast/color/hue/white
  balance, each of which are not supported by the hardware (IMX219
  supports gain and analogue gain only.)  These controls appear to
  have no effect on the resulting image.

However, using qv4l2 (with the segfault bug in
GeneralTab::updateFrameSize() fixed - m_frameSize, m_frameWidth and
m_frameHeight can be NULL) provides access to all controls.  This
can happen if GeneralTab::inputSection() is not called.

The USB uvcvideo camera achieves around 24fps with functional controls
in camorama (mainly because it provides those exact controls to
userspace.)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
