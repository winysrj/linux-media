Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40640 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdCQMUL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 08:20:11 -0400
Date: Fri, 17 Mar 2017 12:16:08 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170317121608.GE21222@n2100.armlinux.org.uk>
References: <20170310140124.GV21222@n2100.armlinux.org.uk>
 <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
 <20170310125342.7f047acf@vento.lan>
 <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
 <20170311082549.576531d0@vento.lan>
 <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
 <20170314004533.3b3cd44b@vento.lan>
 <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
 <20170317114203.GZ21222@n2100.armlinux.org.uk>
 <1489752127.2905.49.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489752127.2905.49.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 17, 2017 at 01:02:07PM +0100, Philipp Zabel wrote:
> I think most of the simple, fixed pipeline use cases could be handled by
> libv4l2, by allowing to pass a v4l2 subdevice path to v4l2_open. If that
> function internally would set up the media links to the
> nearest /dev/video interface, propagate format, resolution and frame
> intervals if necessary, and return an fd to the video device, there'd be
> no additional complexity for the users beyond selecting the v4l2_subdev
> instead of the video device.

... which would then require gstreamer to be modified too. The gstreamer
v4l2 plugin looks for /dev/video* or /dev/v4l2/video* devices and monitors
these for changes, so gstreamer applications know which capture devices
are available:

  const gchar *paths[] = { "/dev", "/dev/v4l2", NULL };
  const gchar *names[] = { "video", NULL };

  /* Add some depedency, so the dynamic features get updated upon changes in
   * /dev/video* */
  gst_plugin_add_dependency (plugin,
      NULL, paths, names, GST_PLUGIN_DEPENDENCY_FLAG_FILE_NAME_IS_PREFIX);

I haven't checked yet whether sys/v4l2/gstv4l2deviceprovider.c knows
anything about the v4l2 subdevs.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
