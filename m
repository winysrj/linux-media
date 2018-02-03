Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58143 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751972AbeBCP4w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Feb 2018 10:56:52 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Please help test the new v4l-subdev support in v4l2-compliance
Message-ID: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
Date: Sat, 3 Feb 2018 16:56:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim, Jacopo,

I have now finished writing the v4l2-compliance tests for the various v4l-subdev
ioctls. I managed to test some with the vimc driver, but that doesn't implement all
ioctls, so I could use some help testing my test code :-)

To test you first need to apply these patches to your kernel:

https://patchwork.linuxtv.org/patch/46817/
https://patchwork.linuxtv.org/patch/46822/

Otherwise the compliance test will fail a lot.

Now run v4l2-compliance -u /dev/v4l-subdevX (or -uX as a shortcut) and see what
happens.

I have tested the following ioctls with vimc, so they are likely to be correct:

#define VIDIOC_SUBDEV_G_FMT                     _IOWR('V',  4, struct v4l2_subdev_format)
#define VIDIOC_SUBDEV_S_FMT                     _IOWR('V',  5, struct v4l2_subdev_format)
#define VIDIOC_SUBDEV_ENUM_MBUS_CODE            _IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE           _IOWR('V', 74, struct v4l2_subdev_frame_size_enum)

All others are untested:

#define VIDIOC_SUBDEV_G_FRAME_INTERVAL          _IOWR('V', 21, struct v4l2_subdev_frame_interval)
#define VIDIOC_SUBDEV_S_FRAME_INTERVAL          _IOWR('V', 22, struct v4l2_subdev_frame_interval)
#define VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL       _IOWR('V', 75, struct v4l2_subdev_frame_interval_enum)
#define VIDIOC_SUBDEV_G_CROP                    _IOWR('V', 59, struct v4l2_subdev_crop)
#define VIDIOC_SUBDEV_S_CROP                    _IOWR('V', 60, struct v4l2_subdev_crop)
#define VIDIOC_SUBDEV_G_SELECTION               _IOWR('V', 61, struct v4l2_subdev_selection)
#define VIDIOC_SUBDEV_S_SELECTION               _IOWR('V', 62, struct v4l2_subdev_selection)
#define VIDIOC_SUBDEV_G_EDID                    _IOWR('V', 40, struct v4l2_edid)
#define VIDIOC_SUBDEV_S_EDID                    _IOWR('V', 41, struct v4l2_edid)
#define VIDIOC_SUBDEV_S_DV_TIMINGS              _IOWR('V', 87, struct v4l2_dv_timings)
#define VIDIOC_SUBDEV_G_DV_TIMINGS              _IOWR('V', 88, struct v4l2_dv_timings)
#define VIDIOC_SUBDEV_ENUM_DV_TIMINGS           _IOWR('V', 98, struct v4l2_enum_dv_timings)
#define VIDIOC_SUBDEV_QUERY_DV_TIMINGS          _IOR('V', 99, struct v4l2_dv_timings)
#define VIDIOC_SUBDEV_DV_TIMINGS_CAP            _IOWR('V', 100, struct v4l2_dv_timings_cap)

I did the best I could, but there may very well be bugs in the test code.

I will also test the timings and edid ioctls myself later next week at work.

The v4l2-compliance utility can now also test media devices (-m option), although that's
early days yet. Eventually I want to be able to walk the graph and test each device in
turn.

I have this idea of making v4l2-compliance, cec-compliance and media-compliance
frontends that can all share the actual test code. And perhaps that can include a new
dvb-compliance as well.

However, that's future music, for now I just want to get proper ioctl test coverage
so driver authors can at least have some confidence in their code by running these
tests.

Regards,

	Hans
