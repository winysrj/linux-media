Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:54297 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2A2K2t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jan 2012 05:28:49 -0500
Message-ID: <4F251F40.1030808@iki.fi>
Date: Sun, 29 Jan 2012 12:28:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [RFC] Format and frame rate configuration in subdev video and pad
 ops
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We have now two type of subdev drivers, those which use the Media
controller framework and those which do not. The former group implements
v4l2_subdev_pad_ops for the purpose whereas the latter uses
v4l2_subdev_video_ops. In practice the two implement essentially the
same feature set.

Same goes for simple bus receiver drivers (also called bridge) whereas
all the more complex ISP drivers rightly use the pad ops.

The two groups of drivers are currently mostly not mixable, and the
reason is mostly the above, as far as I understand.

To improve interoperability, it would be relatively easy to provide
wrapper functions for either groups of the ISP / bus receiver drivers so
they do need not to be changed to support both.

More complex sensor drivers, for example the SMIA++ exports more than
one subdev for the configuration of sensor's image processing --- there
is functionality which is present in ISPs only: cropping in three
different locations and scaling in two. Many of the decisions in the
configuration are policy decisions and thus belong to user space. This
kind of drivers cannot be utilised without Media controller support, and
thus I believe it is right for even simple bus receiver drivers to
implement Media controller support to allow all bridge / ISP drivers to
use them.

While not all the user space is not yet in place to support such drivers
I have not forgotten work on this library --- it just takes time.

There are two sets of wrappers that can be implemented to improve the
current situation. After the full transition to pad ops (should it ever
happen is to be decided, I guess) these wrappers could be removed.

Wrappers for sensor drivers to implement pad ops using video ops.
There's one pad on such subdevs and a few other restrictions: try
formats cannot be supported since there is no v4l2_fh support in video ops.

How should the try operations requiring v4l2_fh behave in this case?
Should they just return the current ACTIVE format (or crop) or should
they behave as ACTIVE version of the same op does? I might pick the
first option as it's less wrong. Complete support is not possible due to
lack of functionality in the interface.

Wrappers for sensor drivers to implement video ops using pad ops. This
is trivial: all the information is available through the pad ops,  with
v4l2_subdev_format fields which == V4L2_SUBDEV_FORMAT_ACTIVE and pad == 0.

The same mostly goes for crop: v4l2_crop contains a subset of
information in v4l2_subdev_crop.

Conclusion: to achieve maximum compatibility with bridge / ISP drivers
using the two sets of ops, sensor / tuner etc. drivers should use pad
ops to implement format, crop and frame rate configuration and
enumeration. What is missing is a set of wrappers for sensor drivers to
allow bridge and ISP drivers using either set of ops to use these sensor
drivers.

Comments, questions?

relevant video ops:

int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
                     enum v4l2_mbus_pixelcode *code);
int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
                     struct v4l2_frmsizeenum *fsize);
int (*g_mbus_fmt)(struct v4l2_subdev *sd,
                  struct v4l2_mbus_framefmt *fmt);
int (*try_mbus_fmt)(struct v4l2_subdev *sd,
                    struct v4l2_mbus_framefmt *fmt);
int (*s_mbus_fmt)(struct v4l2_subdev *sd,
                  struct v4l2_mbus_framefmt *fmt);

relevant pad ops:

int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh
                      struct v4l2_subdev_mbus_code_enum *code);
int (*enum_frame_size)(struct v4l2_subdev *sd,
                       struct v4l2_subdev_fh *fh,
                       struct v4l2_subdev_frame_size_enum *fse);
int (*enum_frame_interval)(struct v4l2_subdev *sd,
                           struct v4l2_subdev_fh *fh,
                           struct v4l2_subdev_frame_interval_enum *fie)
int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
               struct v4l2_subdev_format *format);
int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
               struct v4l2_subdev_format *format);

/**
 * struct v4l2_mbus_framefmt - frame format on the media bus
 * @width:      frame width
 * @height:     frame height
 * @code:       data format code (from enum v4l2_mbus_pixelcode)
 * @field:      used interlacing type (from enum v4l2_field)
 * @colorspace: colorspace of the data (from enum v4l2_colorspace)
 */
struct v4l2_mbus_framefmt {
        __u32                   width;
        __u32                   height;
        __u32                   code;
        __u32                   field;
        __u32                   colorspace;
        __u32                   reserved[7];
};

/**
 * struct v4l2_subdev_format - Pad-level media bus format
 * @which: format type (from enum v4l2_subdev_format_whence)
 * @pad: pad number, as reported by the media API
 * @format: media bus format (format code and frame size)
 */
struct v4l2_subdev_format {
        __u32 which;
        __u32 pad;
        struct v4l2_mbus_framefmt format;
        __u32 reserved[8];
};

struct v4l2_crop {
        enum v4l2_buf_type      type;
        struct v4l2_rect        c;
};

/**
 * struct v4l2_subdev_crop - Pad-level crop settings
 * @which: format type (from enum v4l2_subdev_format_whence)
 * @pad: pad number, as reported by the media API
 * @rect: pad crop rectangle boundaries
 */
struct v4l2_subdev_crop {
        __u32 which;
        __u32 pad;
        struct v4l2_rect rect;
        __u32 reserved[8];
};

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
