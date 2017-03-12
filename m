Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60590
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755761AbdCLWKR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 18:10:17 -0400
Date: Sun, 12 Mar 2017 19:10:02 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
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
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170312191002.5f0a2cff@vento.lan>
In-Reply-To: <20170312211324.GW21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
        <20170312194700.GR21222@n2100.armlinux.org.uk>
        <20170312175923.6ad86dff@vento.lan>
        <20170312211324.GW21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 12 Mar 2017 21:13:24 +0000
Russell King - ARM Linux <linux@armlinux.org.uk> escreveu:

> On Sun, Mar 12, 2017 at 05:59:28PM -0300, Mauro Carvalho Chehab wrote:
> > Yet, udev/systemd has some rules that provide an unique name for V4L
> > devices at /lib/udev/rules.d/60-persistent-v4l.rules. Basically, it
> > runs a small application (v4l_id) with creates a persistent symling
> > using rules like this:
> > 
> > 	KERNEL=="video*", ENV{ID_SERIAL}=="?*", SYMLINK+="v4l/by-id/$env{ID_BUS}-$env{ID_SERIAL}-video-index$attr{index}"
> > 
> > Those names are stored at /dev/v4l/by-path.  
> 
> This doesn't help:
> 
> $ ls -Al /dev/v4l/by-id/
> total 0
> lrwxrwxrwx 1 root root 13 Mar 12 19:54 usb-Sonix_Technology_Co.__Ltd._USB_2.0_Camera-video-index0 -> ../../video10
> $ ls -Al /dev/v4l/by-path/
> total 0
> lrwxrwxrwx 1 root root 12 Mar 12 19:54 platform-2040000.vpu-video-index0 -> ../../video0
> lrwxrwxrwx 1 root root 12 Mar 12 19:54 platform-2040000.vpu-video-index1 -> ../../video1
> lrwxrwxrwx 1 root root 12 Mar 12 20:53 platform-capture-subsystem-video-index0 -> ../../video2
> lrwxrwxrwx 1 root root 12 Mar 12 20:53 platform-capture-subsystem-video-index1 -> ../../video3
> lrwxrwxrwx 1 root root 12 Mar 12 20:53 platform-capture-subsystem-video-index2 -> ../../video4
> lrwxrwxrwx 1 root root 12 Mar 12 20:53 platform-capture-subsystem-video-index3 -> ../../video5
> lrwxrwxrwx 1 root root 12 Mar 12 20:53 platform-capture-subsystem-video-index4 -> ../../video6
> lrwxrwxrwx 1 root root 12 Mar 12 20:53 platform-capture-subsystem-video-index5 -> ../../video7
> lrwxrwxrwx 1 root root 12 Mar 12 20:53 platform-capture-subsystem-video-index6 -> ../../video8
> lrwxrwxrwx 1 root root 12 Mar 12 20:53 platform-capture-subsystem-video-index7 -> ../../video9
> lrwxrwxrwx 1 root root 13 Mar 12 19:54 platform-ci_hdrc.0-usb-0:1:1.0-video-index0 -> ../../video10
> 
> The problem is the "platform-capture-subsystem-video-index" entries.
> These themselves change order.  For instance, I now have:
> 
> - entity 72: ipu1_csi0 capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video6
> 
> which means it's platform-capture-subsystem-video-index4.  Before, it
> was platform-capture-subsystem-video-index2.

That's a driver problem. v4l_id gets information to build the persistent
name from the result of VIDIOC_QUERYCAP.

In the case of Exynos gsc driver, for example, the information is here:

static int gsc_m2m_querycap(struct file *file, void *fh,
			   struct v4l2_capability *cap)
{
	struct gsc_ctx *ctx = fh_to_ctx(fh);
	struct gsc_dev *gsc = ctx->gsc_dev;

	strlcpy(cap->driver, GSC_MODULE_NAME, sizeof(cap->driver));
	strlcpy(cap->card, GSC_MODULE_NAME " gscaler", sizeof(cap->card));
	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
		 dev_name(&gsc->pdev->dev));
	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
		V4L2_CAP_VIDEO_CAPTURE_MPLANE |	V4L2_CAP_VIDEO_OUTPUT_MPLANE;

	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
	return 0;
}

See that the bus_info there is filled with:

	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s", dev_name(&gsc->pdev->dev));

>From the output you printed, it seems that the i.MX6 is just doing:
	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:");
for some devices.

If you change the i.MX6 driver to do the same, you'll likely be able to
have unique names there too.

Regards,
Mauro
