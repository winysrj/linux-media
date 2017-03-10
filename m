Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40234 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755172AbdCJRHq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 12:07:46 -0500
Date: Fri, 10 Mar 2017 17:06:52 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        jean-christophe.trotin@st.com, p.zabel@pengutronix.de,
        fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170310170652.GY21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310130733.GU21222@n2100.armlinux.org.uk>
 <20170310122634.0ffda7c6@vento.lan>
 <20170310155708.GX21222@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170310155708.GX21222@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 10, 2017 at 03:57:09PM +0000, Russell King - ARM Linux wrote:
> Enabling debug output in gstreamer's v4l2src plugin confirms that
> the kernel's bayer format are totally hidden from gstreamer when
> linked with libv4l2, but are present when it isn't linked with
> libv4l2.

Here's the information to back up my claims:

root@hbi2ex:~# v4l2-ctl -d 6 --list-formats-ext
ioctl: VIDIOC_ENUM_FMT
        Index       : 0
        Type        : Video Capture
        Pixel Format: 'RGGB'
        Name        : 8-bit Bayer RGRG/GBGB

root@hbi2ex:~# DISPLAY=:0 GST_DEBUG_NO_COLOR=1 GST_DEBUG=v4l2:9 gst-launch-1.0 v4l2src device=/dev/video6 ! bayer2rgbneon ! xvimagesink > gst-v4l2-1.log 2>&1
root@hbi2ex:~# cut -b65- gst-v4l2-1.log|less
v4l2_calls.c:519:gst_v4l2_open:<v4l2src0> Trying to open device /dev/video6
v4l2_calls.c:69:gst_v4l2_get_capabilities:<v4l2src0> getting capabilities
v4l2_calls.c:77:gst_v4l2_get_capabilities:<v4l2src0> driver:      'imx-media-camif'
v4l2_calls.c:78:gst_v4l2_get_capabilities:<v4l2src0> card:        'imx-media-camif'
v4l2_calls.c:79:gst_v4l2_get_capabilities:<v4l2src0> bus_info:    ''
v4l2_calls.c:80:gst_v4l2_get_capabilities:<v4l2src0> version:     00040a00
v4l2_calls.c:81:gst_v4l2_get_capabilities:<v4l2src0> capabilites: 85200001
...
v4l2_calls.c:258:gst_v4l2_fill_lists:<v4l2src0>   controls+menus
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 00000000
v4l2_calls.c:319:gst_v4l2_fill_lists:<v4l2src0> starting control class 'User Controls'
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 00980001
v4l2_calls.c:389:gst_v4l2_fill_lists:<v4l2src0> Adding ControlID white_balance_automatic (98090c)
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 0098090c
v4l2_calls.c:389:gst_v4l2_fill_lists:<v4l2src0> Adding ControlID gamma (980910)
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 00980910
v4l2_calls.c:389:gst_v4l2_fill_lists:<v4l2src0> Adding ControlID gain (980913)
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 00980913
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 00980914
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 00980915
v4l2_calls.c:319:gst_v4l2_fill_lists:<v4l2src0> starting control class 'Camera Controls'
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009a0001
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID exposure_time_absolute (9a0902) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009a0902
v4l2_calls.c:319:gst_v4l2_fill_lists:<v4l2src0> starting control class 'Image Source Controls'
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009e0001
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID vertical_blanking (9e0901) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009e0901
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID horizontal_blanking (9e0902) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009e0902
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID analogue_gain (9e0903) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009e0903
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID red_pixel_value (9e0904) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009e0904
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID green_red_pixel_value (9e0905) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009e0905
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID blue_pixel_value (9e0906) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009e0906
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID green_blue_pixel_value (9e0907) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009e0907
v4l2_calls.c:319:gst_v4l2_fill_lists:<v4l2src0> starting control class 'Image Processing Controls'
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009f0001
v4l2_calls.c:340:gst_v4l2_fill_lists:<v4l2src0> Control type for 'Pixel Rate' not suppored for extra controls.
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID Pixel Rate (9f0902) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009f0902
v4l2_calls.c:382:gst_v4l2_fill_lists:<v4l2src0> ControlID test_pattern (9f0903) unhandled, FIXME
v4l2_calls.c:278:gst_v4l2_fill_lists:<v4l2src0> checking control 009f0903
v4l2_calls.c:284:gst_v4l2_fill_lists:<v4l2src0> controls finished
v4l2_calls.c:451:gst_v4l2_fill_lists:<v4l2src0> done
v4l2_calls.c:587:gst_v4l2_open:<v4l2src0> Opened device 'imx-media-camif' (/dev/video6) successfully
gstv4l2object.c:804:gst_v4l2_set_defaults:<v4l2src0> tv_norm=0x0, norm=(nil)
v4l2_calls.c:734:gst_v4l2_get_norm:<v4l2src0> getting norm
v4l2_calls.c:1021:gst_v4l2_get_input:<v4l2src0> trying to get input
v4l2_calls.c:1031:gst_v4l2_get_input:<v4l2src0> input: 0

gstv4l2object.c:1106:gst_v4l2_object_fill_format_list:<v4l2src0> getting src format enumerations
gstv4l2object.c:1124:gst_v4l2_object_fill_format_list:<v4l2src0> index:       0
gstv4l2object.c:1125:gst_v4l2_object_fill_format_list:<v4l2src0> type:        1
gstv4l2object.c:1126:gst_v4l2_object_fill_format_list:<v4l2src0> flags:       00000002
gstv4l2object.c:1128:gst_v4l2_object_fill_format_list:<v4l2src0> description: 'RGB3'
gstv4l2object.c:1130:gst_v4l2_object_fill_format_list:<v4l2src0> pixelformat: RGB3
gstv4l2object.c:1124:gst_v4l2_object_fill_format_list:<v4l2src0> index:       1
gstv4l2object.c:1125:gst_v4l2_object_fill_format_list:<v4l2src0> type:        1
gstv4l2object.c:1126:gst_v4l2_object_fill_format_list:<v4l2src0> flags:       00000002
gstv4l2object.c:1128:gst_v4l2_object_fill_format_list:<v4l2src0> description: 'BGR3'
gstv4l2object.c:1130:gst_v4l2_object_fill_format_list:<v4l2src0> pixelformat: BGR3
gstv4l2object.c:1124:gst_v4l2_object_fill_format_list:<v4l2src0> index:       2
gstv4l2object.c:1125:gst_v4l2_object_fill_format_list:<v4l2src0> type:        1
gstv4l2object.c:1126:gst_v4l2_object_fill_format_list:<v4l2src0> flags:       00000002
gstv4l2object.c:1128:gst_v4l2_object_fill_format_list:<v4l2src0> description: 'YU12'
gstv4l2object.c:1130:gst_v4l2_object_fill_format_list:<v4l2src0> pixelformat: YU12
gstv4l2object.c:1124:gst_v4l2_object_fill_format_list:<v4l2src0> index:       3
gstv4l2object.c:1125:gst_v4l2_object_fill_format_list:<v4l2src0> type:        1
gstv4l2object.c:1126:gst_v4l2_object_fill_format_list:<v4l2src0> flags:       00000002
gstv4l2object.c:1128:gst_v4l2_object_fill_format_list:<v4l2src0> description: 'YV12'

gstv4l2object.c:1130:gst_v4l2_object_fill_format_list:<v4l2src0> pixelformat: YV12
gstv4l2object.c:1143:gst_v4l2_object_fill_format_list:<v4l2src0> got 4 format(s):
gstv4l2object.c:1149:gst_v4l2_object_fill_format_list:<v4l2src0>   YU12 (emulated)
gstv4l2object.c:1149:gst_v4l2_object_fill_format_list:<v4l2src0>   YV12 (emulated)
gstv4l2object.c:1149:gst_v4l2_object_fill_format_list:<v4l2src0>   BGR3 (emulated)
gstv4l2object.c:1149:gst_v4l2_object_fill_format_list:<v4l2src0>   RGB3 (emulated)

As you can see from this, the RGGB bayer format advertised from the
kernel is not listed - only the four emulated formats provided by
v4lconvert are listed, so the application has _no_ choice but to use
v4lconvert's RGGB conversion.

The result is that the above pipeline fails:

0:00:00.345739030  2794   0x3ade60 DEBUG                   v4l2 gstv4l2object.c:3812:gst_v4l2_object_get_caps:<v4l2src0> ret: video/x-raw, format=(string)I420, framerate=(fraction)[ 0/1, 2147483647/1 ], width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)YV12, framerate=(fraction)[ 0/1, 2147483647/1 ], width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)BGR, framerate=(fraction)[ 0/1, 2147483647/1 ], width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1; video/x-raw, format=(string)RGB, framerate=(fraction)[ 0/1, 2147483647/1 ], width=(int)816, height=(int)616, interlace-mode=(string)progressive, pixel-aspect-ratio=(fraction)1/1
ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Internal data flow error.
Additional debug info:
gstbasesrc.c(2948): gst_base_src_loop (): /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
streaming task paused, reason not-negotiated (-4)

as the v4l2src element is offering an I420-formatted buffer to the
gstreamer bayer converter, which obviously objects.

Rebuilding without libv4l2 linked results in gstreamer working.
Using a kernel driver which exposes some formats that libv4lconvert
_doesn't_ need to convert in addition to bayer _also_ works.

The only case where this fails is where the kernel device only
advertises formats where libv4lconvert is in "we must always convert"
mode, where upon the unconverted formats are completely hidden from
the application.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
