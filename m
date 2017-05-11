Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:43466 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756925AbdEKPvc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 11:51:32 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4BFcOhp024302
        for <linux-media@vger.kernel.org>; Thu, 11 May 2017 16:51:31 +0100
Received: from mail-pf0-f199.google.com (mail-pf0-f199.google.com [209.85.192.199])
        by mx07-00252a01.pphosted.com with ESMTP id 2a93w0avky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Thu, 11 May 2017 16:51:30 +0100
Received: by mail-pf0-f199.google.com with SMTP id a23so22683338pfe.1
        for <linux-media@vger.kernel.org>; Thu, 11 May 2017 08:51:30 -0700 (PDT)
MIME-Version: 1.0
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Thu, 11 May 2017 16:51:27 +0100
Message-ID: <CAAoAYcPtX4hrCYrMNuucEpm37asKZkspMmRE_siJHY+u5ge11A@mail.gmail.com>
Subject: Sensor sub-device - what are the mandatory ops?
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

As previously discussed, I'm working on a V4L2 driver for the
CSI-2/CCP2 receiver on BCM283x, as used on Raspberry Pi.
It's a relatively simple hardware block that writes received data into
SDRAM, and only accepts connection from one "sensor" sub device, so no
need to involve the media controller API. (The peripheral can do
cropping and format conversion between the CSI-2 Bayer formats too,
but I'm ignoring those for now, and even so they don't really need
media controller).
I was previously advised by Hans to take am437x as a base, and that
seems to have worked pretty well when combined with some of the ti-vpe
driver too. It's up and running, although with some rough edges. I'm
hoping to sort an RFC in a week or so.

My main issue is determining what calls are mandatory to be supported
by the sensor sub-device drivers that attach to the CSI-2 receiver.
I'm either taking the wrong approach, or there seem to be missing ops
in the drivers I'm trying to use. The set of devices I have available
are Omnivision OV5647, Toshiba TC358743 HDMI to CSI2 bridge, and
ADV7282-M analogue video to CSI-2 decoder.

The TC358743 driver doesn't support:
- enum_mbus_code to report the supported formats
(MEDIA_BUS_FMT_RGB888_1X24 and MEDIA_BUS_FMT_UYVY8_1X16)
- s_power. The docs [1] say the device must be powered up before
calling v4l2_subdev_video_ops->s_stream, but is s_power optional so
ENOIOCTLCMD is not to be considered a failure?
- enum_frame_size
and doesn't set the state->mbus_fmt_code until after
v4l2_async_register_subdev. A connected subdevice calling get_fmt
during the notifier.complete callback gets a code of 0.

The OV5647 driver doesn't support:
- set_fmt or get_fmt. I can't see any code that returns the 640x480
sensor resolution that is listed in the commit text.
- g_mbus_config, so no information on the number of CSI-2 lanes in use
beyond that in DT. Do we just assume all lines specified in DT are in
use in this situation? In which case should the driver be checking
that the configured number of lanes matches the register set it will
request over I2C, as a mismatch will result in it not working?
- enum_frame_size

ADV7180/7282-M
- enum_frame_size

I've listed enum_frame_size as that is what TI VPE driver uses in
cal_try_fmt_vid_cap. It seems more sensible to pass the request in to
set_fmt with which = V4L2_SUBDEV_FORMAT_TRY, so is this actually an
issue with the TI driver doing the wrong thing? (FORMAT_TRY seems to
work reasonably).

Those are the issues I've hit on those 3 drivers. Is there a defintive
list of what must be supported by drivers, and any checklist for
drivers during review?

I have patches for the TC358743 and OV5647 which I can post to the
list if it is agreed that the above are issues rather than me doing
the wrong thing.


Follow-up question on g_mbus_format. The V4L2_MBUS_CSI2_x_LANE defines
appear to have been specfied though they should be used as a bitmask,
but based on existing drivers (mainly TC358743) only one is allowed to
be set to denote the actual number of lanes used. Is that the correct
interpretation? If so I guess we need error checking on the flags
passed in.


One last question. Putting a user's hat on, what is the expected
mapping of vidioc_s_input to s_routing?
Looking at my use case, the CSI-2 receiver driver is the code that
creates /dev/videoN, but it otherwise is just a proxy for the sensor
device. It therefore makes the user's life easy if calls such as
input, EDID, dv_timings, and std functions are just passed straight
through to the sensor, so the user can ignore the subdev API.
For input there appears to be no way to produce an implementation of
vidioc_enum_input. Looking at the ADV7282-M (uses ADV7180 driver), I
can't see any way of reading out the valid input numbers as would be
needed for enum_input.
vidioc_g_input can be done by the CSI-2 receiver driver
assuming/setting to input 0 during probe, and then caching the last
set value, but that feels a little nasty. Have I missed something
there?

Thanks in advance.
  Dave

[1] https://linuxtv.org/downloads/v4l-dvb-apis-new/kapi/csi2.html#receiver-drivers
