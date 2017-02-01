Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34990 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdBAB0s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 20:26:48 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1485870854.2932.63.camel@pengutronix.de>
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5586b893-bf5c-6133-0789-ccce60626b86@gmail.com>
Date: Tue, 31 Jan 2017 17:26:45 -0800
MIME-Version: 1.0
In-Reply-To: <1485870854.2932.63.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/31/2017 05:54 AM, Philipp Zabel wrote:
> Hi Steve,
>
> I have just tested the imx-media-staging-md-wip branch on a Nitrogen6X
> with a tc358743 (BD_HDMI_MIPI HDMI to MIPI CSI-2 receiver board). Some
> observations:
>
> # Link pipeline
> media-ctl -l "'tc358743 1-000f':0->'imx6-mipi-csi2':0[1]"
> media-ctl -l "'imx6-mipi-csi2':1->'ipu1_csi0_mux':0[1]"
> media-ctl -l "'ipu1_csi0_mux':2->'ipu1_csi0':0[1]"
> media-ctl -l "'ipu1_csi0':2->'ipu1_csi0 capture':0[1]"
>
> # Provide an EDID to the HDMI source
> v4l2-ctl -d /dev/v4l-subdev2 --set-edid=file=edid-1080p.hex
> # At this point the HDMI source is enabled and sends a 1080p60 signal
> # Configure detected DV timings
> media-ctl --set-dv "'tc358743 1-000f':0"
>
> # Set pad formats
> media-ctl --set-v4l2 "'tc358743 1-000f':0[fmt:UYVY/1920x1080]"
> media-ctl --set-v4l2 "'imx6-mipi-csi2':1[fmt:UYVY2X8/1920x1080]"
> media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY2X8/1920x1080]"
> media-ctl --set-v4l2 "'ipu1_csi0':2[fmt:AYUV32/1920x1080]"
>
> v4l2-ctl -d /dev/video4 -V
> # This still is configured to 640x480, which is inconsistent with
> # the 'ipu1_csi0':2 pad format. The pad set_fmt above should
> # have set this, too.

Because you've only configured the source pads,
and not the sink pads. The ipu_csi source format is
dependent on the sink format - output crop window is
limited by max input sensor frame, and since sink pad is
still at 640x480, output is reduced to that.

Maybe I'm missing something, is it expected behavior that
a source format should be automatically propagated to
the sink?

>
> v4l2-ctl --list-formats -d /dev/video4
> # This lists all the RGB formats, which it shouldn't. There is
> # no CSC in this pipeline, so we should be limited to YUV formats
> # only.

right, need to fix that. Probably by poking the attached
source subdev (csi or prpenc/vf) for its supported formats.


>
> # Set capture format
> v4l2-ctl -d /dev/video4 -v width=1920,height=1080,pixelformat=UYVY
>
> v4l2-ctl -d /dev/video4 -V
> # Now the capture format is correctly configured to 1920x1080.
>
> v4l2-ctl -d 4 --list-frameintervals=width=1920,height=1080,pixelformat=UYVY
> # This lists nothing. We should at least provide the 'ipu1_csi0':2 pad
> # frame interval. In the future this should list fractions achievable
> # via frame skipping.

yes, need to implement g_frame_interval.

> v4l2-compliance -d /dev/video4
> # This fails two tests:
> # fail: v4l2-test-input-output.cpp(383): std == 0
> # fail: v4l2-test-input-output.cpp(449): invalid attributes for input 0
> # test VIDIOC_G/S/ENUMINPUT: FAIL
> # and
> # fail: v4l2-test-controls.cpp(782): subscribe event for control 'User Controls' failed
> # test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
>
> # (Slowly) stream JPEG images to a display host:
> gst-launch-1.0 -v v4l2src device=/dev/video4 ! jpegenc ! rtpjpegpay ! udpsink
>
> I've done this a few times, and sometimes I only get a "ipu1_csi0: EOF
> timeout" message when starting streaming.

It's hard to say what is going on there, it would be great if I could get my
hands on a Nitrogen6X with the tc35874 to help you debug.

Steve

