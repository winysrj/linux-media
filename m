Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43726 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab0GWP4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 11:56:12 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Fri, 23 Jul 2010 10:56:02 -0500
Subject: RE: [SAMPLE v2 04/12] v4l-subdev: Add pads operations
Message-ID: <A69FA2915331DC488A831521EAE36FE4016B84FDFD@dlee06.ent.ti.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1279723318-28943-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279723318-28943-5-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

Could you explain the probe and active usage using an example such as
below?

            Link1    Link2 
input sensor -> ccdc -> video node.

Assume Link2 we can have either format 1 or format 2 for capture.

Thanks.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Laurent Pinchart
>Sent: Wednesday, July 21, 2010 10:42 AM
>To: linux-media@vger.kernel.org
>Cc: sakari.ailus@maxwell.research.nokia.com
>Subject: [SAMPLE v2 04/12] v4l-subdev: Add pads operations
>
>Add a v4l2_subdev_pad_ops structure for the operations that need to be
>performed at the pad level such as format-related operations.
>
>The format at the output of a subdev usually depends on the format at
>its input(s). The try format operation is thus not suitable for probing
>format at individual pads, as it can't modify the device state and thus
>can't remember the format probed at the input to compute the output
>format.
>
>To fix the problem, pass an extra argument to the get/set format
>operations to select the 'probe' or 'active' format.
>
>The probe format is used when probing the subdev. Setting the probe
>format must not change the device configuration but can store data for
>later reuse. Data storage is provided at the file-handle level so
>applications probing the subdev concurently won't interfere with each
>other.
>
>The active format is used when configuring the subdev. It's identical to
>the format handled by the usual get/set operations.
>
>Pad format-related operations use v4l2_mbus_framefmt instead of
>v4l2_format.
>
>Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>---
> include/media/v4l2-subdev.h |   21 +++++++++++++++++++++
> 1 files changed, 21 insertions(+), 0 deletions(-)
>
>diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>index 01b4135..684ab60 100644
>--- a/include/media/v4l2-subdev.h
>+++ b/include/media/v4l2-subdev.h
>@@ -41,6 +41,7 @@ struct v4l2_device;
> struct v4l2_event_subscription;
> struct v4l2_fh;
> struct v4l2_subdev;
>+struct v4l2_subdev_fh;
> struct tuner_setup;
>
> /* decode_vbi_line */
>@@ -398,6 +399,25 @@ struct v4l2_subdev_ir_ops {
> 				struct v4l2_subdev_ir_parameters *params);
> };
>
>+enum v4l2_subdev_format {
>+	V4L2_SUBDEV_FORMAT_PROBE = 0,
>+	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
>+};
>+
>+struct v4l2_subdev_pad_ops {
>+	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh
>*fh,
>+			      struct v4l2_subdev_pad_mbus_code_enum *code);
>+	int (*enum_frame_size)(struct v4l2_subdev *sd,
>+			       struct v4l2_subdev_fh *fh,
>+			       struct v4l2_subdev_frame_size_enum *fse);
>+	int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>+		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,
>+		       enum v4l2_subdev_format which);
>+	int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>+		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,
>+		       enum v4l2_subdev_format which);
>+};
>+
> struct v4l2_subdev_ops {
> 	const struct v4l2_subdev_core_ops	*core;
> 	const struct v4l2_subdev_tuner_ops	*tuner;
>@@ -406,6 +426,7 @@ struct v4l2_subdev_ops {
> 	const struct v4l2_subdev_vbi_ops	*vbi;
> 	const struct v4l2_subdev_ir_ops		*ir;
> 	const struct v4l2_subdev_sensor_ops	*sensor;
>+	const struct v4l2_subdev_pad_ops	*pad;
> };
>
> #define V4L2_SUBDEV_NAME_SIZE 32
>--
>1.7.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
