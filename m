Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34872 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdJAXga (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Oct 2017 19:36:30 -0400
Date: Mon, 2 Oct 2017 00:36:05 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH RFC] media: staging/imx: fix complete handler
Message-ID: <20171001233604.GF20805@n2100.armlinux.org.uk>
References: <E1dy2zX-0003NB-5J@rmk-PC.armlinux.org.uk>
 <9fccea49-c708-325f-bbce-269eecc6f350@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fccea49-c708-325f-bbce-269eecc6f350@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 01, 2017 at 01:16:53PM -0700, Steve Longerbeam wrote:
> Right, imx_media_add_vdev_to_pa() has followed a link to an
> entity that imx is not aware of.
> 
> The only effect of this patch (besides allowing the driver to load
> with smiapp cameras), is that no controls from the unknown entity
> will be inherited to the capture device nodes. That's not a big deal
> since the controls presumably can still be accessed from the subdev
> node.

smiapp is just one example I used to illustrate the problem.  The imx
media implementation must not claim subdevs exclusively for itself if
it's going to be useful, it has to cater for subdevs existing for
other hardware attached to it.

As you know, the camera that interests me is my IMX219 camera, and it's
regressed with your driver because of your insistence that you have sole
ownership over subdevs in the imx media stack - I'm having to carry more
and more hacks to workaround things that end up broken.  The imx-media
stack needs to start playing better with the needs of others, which it
can only do by allowing subdevs to be used by others.  One way to
achieve that change that results in something that works is the patch
that I've posted - and tested.

The reason that the IMX219 driver users subdevs is because it's capable
of image cropping and binning on the camera module - which helps greatly
if you want to achieve higher FPS for high speed capture [*].

It also results in all controls (which are spread over the IMX219's two
subdevs) to be visible via the v4l2 video interface - I have all the
controls attached to the pixel array subdev as well as the controls
attached to the scaling subdev.

> However, I still have some concerns about supporting smiapp cameras
> in imx-media driver, and that is regarding pad indexes. The smiapp device
> that exposes a source pad to the "outside world", which is either the binner
> or the scaler entity, has a pad index of 1. But unless the device tree port
> for the smiapp device is given a reg value of 1 for that port, imx-media
> will assume it is pad 0, not 1.

For IMX219, the source pad on the scaler (which is connected to the CSI
input pad) is pad 0 - always has been.  So I guess this problem is hidden
because of that choice.  Maybe that's a problem for someone who has a
SMIAPP camera to address.

Right now, my patch stack to get the imx219 on v4.14-rc1 working is:

media: staging/imx: fix complete handler
[media] v4l: async: don't bomb out on ->complete failure
media: imx-csi: fix burst size
media: imx: debug power on
ARM: dts: imx6qdl-hummingboard: add IMX219 camera
media: i2c: imx219 camera driver
media: imx: add frame intervals back in
fix lp-11 timeout

The frame interval patch is there because I just don't agree with the
position of the v4l2 folk, and keeping it means I don't have to screw
up my camera configuration scripts with special handling.  The
"fix lp-11 timeout" changes the LP-11 timeout to be a warning rather
than a failure - and contary to what FSL/NXP say, it works every time
on the iMX6 devices without needing to go through their workaround.


* - This is the whole reason I bought the IMX219, and have written the
IMX219 driver.  I want to use it for high speed capture of an arrow
leaving a recurve bow.  Why?  Everyone archer shoots subtly differently,
and I want to see what's happening to the arrows that are leaving my
bow.  However, for that to be achievable, I (a) need a working capture
implementation for imx6, and (b) I need to be able to quickly convert
bayer to an image, and (c) I need to either encode it on the fly, or
write the raw images to SSD.

(a) is thwarted by the breakage I keep stumbling over with the capture
code.

(b) I have using the GC320 GPU and a gstreamer plugin, trivially
converting the bayer data to grayscale.

(c) I've yet to achieve - encoding may be supported by the CODA v4l
driver, but nothing in userspace appears to support it, there's no
gstreamer v4l plugin for encoding, only one for decoding.  I also
suspect at either the 16G I have free on the SSD will get eaten up
rapidly without encoding, or the SSD may not keep up with the data
rate.

Right now, all my testing is around displaying on X:

DISPLAY=:0 gst-launch-1.0 -v v4l2src device=/dev/video9 io-mode=4 ! bayer2rgbgc ! clockoverlay halignment=2 valignment=1 ! xvimagesink

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
