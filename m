Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35365 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdBUAS6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 19:18:58 -0500
Subject: Re: [PATCH v4 29/36] media: imx: mipi-csi2: enable setting and
 getting of frame rates
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-30-git-send-email-steve_longerbeam@mentor.com>
 <20170220220409.GX16975@valkosipuli.retiisi.org.uk>
 <20170221001332.GS21222@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <25596b21-70de-5e46-f149-f9ce3a86ecb7@gmail.com>
Date: Mon, 20 Feb 2017 16:18:53 -0800
MIME-Version: 1.0
In-Reply-To: <20170221001332.GS21222@n2100.armlinux.org.uk>
Content-Type: multipart/mixed;
 boundary="------------9BF81ECCD238175A2E1BCC1C"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------9BF81ECCD238175A2E1BCC1C
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit



On 02/20/2017 04:13 PM, Russell King - ARM Linux wrote:
> On Tue, Feb 21, 2017 at 12:04:10AM +0200, Sakari Ailus wrote:
>> On Wed, Feb 15, 2017 at 06:19:31PM -0800, Steve Longerbeam wrote:
>>> From: Russell King <rmk+kernel@armlinux.org.uk>
>>>
>>> Setting and getting frame rates is part of the negotiation mechanism
>>> between subdevs.  The lack of support means that a frame rate at the
>>> sensor can't be negotiated through the subdev path.
>>
>> Just wondering --- what do you need this for?
>
> The v4l2 documentation contradicts the media-ctl implementation.
>
> While v4l2 documentation says:
>
>   These ioctls are used to get and set the frame interval at specific
>   subdev pads in the image pipeline. The frame interval only makes sense
>   for sub-devices that can control the frame period on their own. This
>   includes, for instance, image sensors and TV tuners. Sub-devices that
>   don't support frame intervals must not implement these ioctls.
>
> However, when trying to configure the pipeline using media-ctl, eg:
>
> media-ctl -d /dev/media1 --set-v4l2 '"imx219 pixel 0-0010":0[crop:(0,0)/3264x2464]'
> media-ctl -d /dev/media1 --set-v4l2 '"imx219 0-0010":1[fmt:SRGGB10/3264x2464@1/30]'
> media-ctl -d /dev/media1 --set-v4l2 '"imx219 0-0010":0[fmt:SRGGB8/816x616@1/30]'
> media-ctl -d /dev/media1 --set-v4l2 '"imx6-mipi-csi2":1[fmt:SRGGB8/816x616@1/30]'
> Unable to setup formats: Inappropriate ioctl for device (25)
> media-ctl -d /dev/media1 --set-v4l2 '"ipu1_csi0_mux":2[fmt:SRGGB8/816x616@1/30]'
> media-ctl -d /dev/media1 --set-v4l2 '"ipu1_csi0":2[fmt:SRGGB8/816x616@1/30]'
>
> The problem there is that the format setting for the csi2 does not get
> propagated forward:
>
> $ strace media-ctl -d /dev/media1 --set-v4l2 '"imx6-mipi-csi2":1[fmt:SRGGB8/816x616@1/30]'
> ...
> open("/dev/v4l-subdev16", O_RDWR)       = 3
> ioctl(3, VIDIOC_SUBDEV_S_FMT, 0xbec16244) = 0
> ioctl(3, VIDIOC_SUBDEV_S_FRAME_INTERVAL, 0xbec162a4) = -1 ENOTTY (Inappropriate
> ioctl for device)
> fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 2), ...}) = 0
> write(1, "Unable to setup formats: Inappro"..., 61) = 61
> Unable to setup formats: Inappropriate ioctl for device (25)
> close(3)                                = 0
> exit_group(1)                           = ?
> +++ exited with 1 +++
>
> because media-ctl exits as soon as it encouters the error while trying
> to set the frame rate.
>
> This makes implementing setup of the media pipeline in shell scripts
> unnecessarily difficult - as you need to then know whether an entity
> is likely not to support the VIDIOC_SUBDEV_S_FRAME_INTERVAL call,
> and either avoid specifying a frame rate:
>
> $ strace media-ctl -d /dev/media1 --set-v4l2 '"imx6-mipi-csi2":1[fmt:SRGGB8/816x616]'
> ...
> open("/dev/v4l-subdev16", O_RDWR)       = 3
> ioctl(3, VIDIOC_SUBDEV_S_FMT, 0xbeb1a254) = 0
> open("/dev/v4l-subdev0", O_RDWR)        = 4
> ioctl(4, VIDIOC_SUBDEV_S_FMT, 0xbeb1a254) = 0
> close(4)                                = 0
> close(3)                                = 0
> exit_group(0)                           = ?
> +++ exited with 0 +++
>
> or manually setting the format on the sink.
>
> Allowing the S_FRAME_INTERVAL call seems to me to be more in keeping
> with the negotiation mechanism that is implemented in subdevs, and
> IMHO should be implemented inside the kernel as a pad operation along
> with the format negotiation, especially so as frame skipping is
> defined as scaling, in just the same way as the frame size is also
> scaling:
>
>        -  ``MEDIA_ENT_F_PROC_VIDEO_SCALER``
>
>        -  Video scaler. An entity capable of video scaling must have
>           at least one sink pad and one source pad, and scale the
>           video frame(s) received on its sink pad(s) to a different
>           resolution output on its source pad(s). The range of
>           supported scaling ratios is entity-specific and can differ
>           between the horizontal and vertical directions (in particular
>           scaling can be supported in one direction only). Binning and
>           skipping are considered as scaling.
>
> Although, this is vague, as it doesn't define what it means by "skipping",
> whether that's skipping pixels (iow, sub-sampling) or whether that's
> frame skipping.
>
> Then there's the issue where, if you have this setup:
>
>  camera --> csi2 receiver --> csi --> capture
>
> and the "csi" subdev can skip frames, you need to know (a) at the CSI
> sink pad what the frame rate is of the source (b) what the desired
> source pad frame rate is, so you can configure the frame skipping.
> So, does the csi subdev have to walk back through the media graph
> looking for the frame rate?  Does the capture device have to walk back
> through the media graph looking for some subdev to tell it what the
> frame rate is - the capture device certainly can't go straight to the
> sensor to get an answer to that question, because that bypasses the
> effect of the CSI frame skipping (which will lower the frame rate.)
>
> IMHO, frame rate is just another format property, just like the
> resolution and data format itself, and v4l2 should be treating it no
> differently.
>

I agree, frame rate, if indicated/specified by both sides of a link,
should match. So maybe this should be part of v4l2 link validation.

This might be a good time to propose the following patch.

Steve


--------------9BF81ECCD238175A2E1BCC1C
Content-Type: text/x-patch;
 name="0015-media-v4l-subdev-Add-function-to-validate-frame-inte.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0015-media-v4l-subdev-Add-function-to-validate-frame-inte.pa";
 filename*1="tch"

>From 82fbf487ba9ca0dfd2d624c73a78f3741c974d3e Mon Sep 17 00:00:00 2001
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 20 Feb 2017 15:13:15 -0800
Subject: [PATCH 15/37] [media] v4l: subdev: Add function to validate frame
 interval

If the pads on both sides of a link specify a frame interval, then
those frame intervals should match. Create the exported function
v4l2_subdev_link_validate_frame_interval() for this purpose. This
function is also added to v4l2_subdev_link_validate_default().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 Documentation/media/kapi/v4l2-subdev.rst |  5 ++--
 drivers/media/v4l2-core/v4l2-subdev.c    | 50 +++++++++++++++++++++++++++++++-
 include/media/v4l2-subdev.h              | 10 +++++++
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index e1f0b72..5e424f6 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -132,8 +132,9 @@ of the format configuration between sub-devices and video nodes.
 
 If link_validate op is not set, the default function
 :c:func:`v4l2_subdev_link_validate_default` is used instead. This function
-ensures that width, height and the media bus pixel code are equal on both source
-and sink of the link. Subdev drivers are also free to use this function to
+ensures that width, height, the media bus pixel code, and the frame
+interval (if indicated by both sides), are equal on both source and
+sink of the link. Subdev drivers are also free to use this function to
 perform the checks mentioned above in addition to their own checks.
 
 There are currently two ways to register subdevices with the V4L2 core. The
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index da78497..23a3e74 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -497,6 +497,50 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
 };
 
 #ifdef CONFIG_MEDIA_CONTROLLER
+static int
+v4l2_subdev_link_validate_get_fi(struct media_pad *pad,
+				 struct v4l2_subdev_frame_interval *fi)
+{
+	if (is_media_entity_v4l2_subdev(pad->entity)) {
+		struct v4l2_subdev *sd =
+			media_entity_to_v4l2_subdev(pad->entity);
+
+		fi->pad = pad->index;
+		return v4l2_subdev_call(sd, video, g_frame_interval, fi);
+	}
+
+	WARN(pad->entity->function != MEDIA_ENT_F_IO_V4L,
+	     "Driver bug! Wrong media entity type 0x%08x, entity %s\n",
+	     pad->entity->function, pad->entity->name);
+
+	return -EINVAL;
+}
+
+int v4l2_subdev_link_validate_frame_interval(struct media_link *link)
+{
+	struct v4l2_subdev_frame_interval src_fi, sink_fi;
+	unsigned long src_usec, sink_usec;
+	int rval;
+
+	rval = v4l2_subdev_link_validate_get_fi(link->source, &src_fi);
+	if (rval < 0)
+		return 0;
+
+	rval = v4l2_subdev_link_validate_get_fi(link->sink, &sink_fi);
+	if (rval < 0)
+		return 0;
+
+	src_usec = DIV_ROUND_CLOSEST_ULL(
+		(u64)src_fi.interval.numerator * USEC_PER_SEC,
+		src_fi.interval.denominator);
+	sink_usec = DIV_ROUND_CLOSEST_ULL(
+		(u64)sink_fi.interval.numerator * USEC_PER_SEC,
+		sink_fi.interval.denominator);
+
+	return (src_usec != sink_usec) ? -EPIPE : 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_frame_interval);
+
 int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct media_link *link,
 				      struct v4l2_subdev_format *source_fmt,
@@ -516,7 +560,11 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 	    sink_fmt->format.field != V4L2_FIELD_NONE)
 		return -EPIPE;
 
-	return 0;
+	/*
+	 * The frame interval must match if specified on both ends
+	 * of the link.
+	 */
+	return v4l2_subdev_link_validate_frame_interval(link);
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_default);
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 0ab1c5d..60c941d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -929,6 +929,16 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_format *sink_fmt);
 
 /**
+ * v4l2_subdev_link_validate_frame_interval - validates a media link
+ *
+ * @link: pointer to &struct media_link
+ *
+ * This function ensures that the frame intervals, if specified by
+ * both the source and sink subdevs of the link, are equal.
+ */
+int v4l2_subdev_link_validate_frame_interval(struct media_link *link);
+
+/**
  * v4l2_subdev_link_validate - validates a media link
  *
  * @link: pointer to &struct media_link
-- 
2.7.4


--------------9BF81ECCD238175A2E1BCC1C--
