Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40635 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751285AbdBOJfE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 04:35:04 -0500
Message-ID: <1487151211.2433.21.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 15 Feb 2017 10:33:31 +0100
In-Reply-To: <a581a944-9bee-e5ce-d7d7-24bf749a38e2@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1485870854.2932.63.camel@pengutronix.de>
         <a581a944-9bee-e5ce-d7d7-24bf749a38e2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Tue, 2017-02-14 at 18:27 -0800, Steve Longerbeam wrote:
[...]
> >
> > # Provide an EDID to the HDMI source
> > v4l2-ctl -d /dev/v4l-subdev2 --set-edid=file=edid-1080p.hex
> 
> I can probably generate this Intel hex file myself from sysfs
> edid outputs, but for convenience do you mind sending me this
> file? I have a 1080p HDMI source I can plug into the tc358743.

I copied the EDID off of some random 1080p HDMI monitor,
probably using something like:

    xxd -g1 /sys/class/drm/card0-HDMI-A-1/edid | cut -c 9-56

----------8<----------
 00 ff ff ff ff ff ff 00 09 d1 89 78 45 54 00 00
 2a 14 01 03 80 35 1e 78 2e b8 45 a1 59 55 9f 28
 0d 50 54 a5 6b 80 81 c0 81 00 81 80 a9 c0 b3 00
 d1 c0 01 01 01 01 02 3a 80 18 71 38 2d 40 58 2c
 45 00 13 2a 21 00 00 1e 00 00 00 ff 00 4e 41 41
 30 36 32 39 36 53 4c 30 0a 20 00 00 00 fd 00 32
 4c 1e 53 11 00 0a 20 20 20 20 20 20 00 00 00 fc
 00 42 65 6e 51 20 47 4c 32 34 34 30 48 0a 01 18
 02 03 22 f1 4f 90 05 04 03 02 01 11 12 13 14 06
 07 15 16 1f 23 09 07 07 65 03 0c 00 10 00 83 01
 00 00 02 3a 80 18 71 38 2d 40 58 2c 45 00 13 2a
 21 00 00 1f 01 1d 80 18 71 1c 16 20 58 2c 25 00
 13 2a 21 00 00 9f 01 1d 00 72 51 d0 1e 20 6e 28
 55 00 13 2a 21 00 00 1e 8c 0a d0 8a 20 e0 2d 10
 10 3e 96 00 13 2a 21 00 00 18 00 00 00 00 00 00
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 eb
---------->8----------

> The other problem here is that my version of v4l2-ctl, built from
> master branch of git@github.com:gjasny/v4l-utils.git, does not
> support taking a subdev node:
> 
> root@mx6q:~# v4l2-ctl -d /dev/v4l-subdev15 --get-edid=format=hex
> VIDIOC_QUERYCAP: failed: Inappropriate ioctl for device
> /dev/v4l-subdev15: not a v4l2 node
> 
> Is this something you added yourself, or where can I find this version
> of v4l2-ctrl?

Ah right, I still have no proper fix for that. v4l-ctl bails out if it
can't VIDIOC_QUERYCAP, which is an ioctl not supported on subdevices.
I have just patched it out locally:

----------8<----------
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 886a91d093ae..fa15a49375ae 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -1214,10 +1214,7 @@ int main(int argc, char **argv)
 	}
 
 	verbose = options[OptVerbose];
-	if (doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
-		fprintf(stderr, "%s: not a v4l2 node\n", device);
-		exit(1);
-	}
+	doioctl(fd, VIDIOC_QUERYCAP, &vcap);
 	capabilities = vcap.capabilities;
 	if (capabilities & V4L2_CAP_DEVICE_CAPS)
 		capabilities = vcap.device_caps;
---------->8----------

Note that setting the EDID is not necessary if you can force the mode on
your HDMI source.

regards
Philipp
