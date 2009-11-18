Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2479 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZKRTXc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 14:23:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH v2] V4L - Adding Digital Video Timings APIs
Date: Wed, 18 Nov 2009 20:23:33 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1258563824-1310-1-git-send-email-m-karicheri2@ti.com> <200911181908.51793.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE401559C6120@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401559C6120@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1mEBLJ3v4P+9b4Y"
Message-Id: <200911182023.34005.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_1mEBLJ3v4P+9b4Y
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 18 November 2009 20:01:43 Karicheri, Muralidharan wrote:
> Hans,
> 
> Thanks for reviewing this. I will try to send an updated patch today.
> 
> BTW, I have posted the documentation patch to the list for review.

I did some quick 64-bit tests and discovered that we need to add the packed
attribute to struct v4l2_bt_timings and struct v4l2_dv_timings in order to
prevent nasty 32-bit to 64-bit conversions in v4l2-compat-ioctl32.c.

See below:

> >> +/*
> >> + *  D V     B T     T I M I N G S
> >> + */
> >> +
> >> +/* BT.656/BT.1120 timing data */
> >> +struct v4l2_bt_timings {
> >> +    __u32   width;          /* width in pixels */
> >> +    __u32   height;         /* height in lines */
> >> +    __u32   interlaced;     /* Interlaced or progressive */
> >> +    __u32   polarities;     /* Positive or negative polarity */
> >> +    __u64   pixelclock;     /* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
> >> +    __u32   hfrontporch;    /* Horizpontal front porch in pixels */
> >> +    __u32   hsync;          /* Horizontal Sync length in pixels */
> >> +    __u32   hbackporch;     /* Horizontal back porch in pixels */
> >> +    __u32   vfrontporch;    /* Vertical front porch in pixels */
> >> +    __u32   vsync;          /* Vertical Sync length in lines */
> >> +    __u32   vbackporch;     /* Vertical back porch in lines */
> >> +    __u32   il_vfrontporch; /* Vertical front porch for bottom field of
> >> +                             * interlaced field formats
> >> +                             */
> >> +    __u32   il_vsync;       /* Vertical sync length for bottom field of
> >> +                             * interlaced field formats
> >> +                             */
> >> +    __u32   il_vbackporch;  /* Vertical back porch for bottom field of
> >> +                             * interlaced field formats
> >> +                             */
> >> +    __u32   reserved[16];
> >> +};

End with:

} __attribute__ ((packed));

> >> +
> >> +/* Interlaced or progressive format */
> >> +#define     V4L2_DV_PROGRESSIVE     0
> >> +#define     V4L2_DV_INTERLACED      1
> >> +
> >> +/* Polarities. If bit is not set, it is assumed to be negative polarity
> >*/
> >> +#define V4L2_DV_VSYNC_POS_POL       0x00000001
> >> +#define V4L2_DV_HSYNC_POS_POL       0x00000002
> >> +
> >> +/* BT.656/1120 timing type */
> >> +enum v4l2_dv_timings_type {
> >> +    V4L2_DV_BT_656_1120,
> >> +};
> >
> >I forgot something: we shouldn't use enums as that can give problems on
> >some
> >architectures (ARM being one of them, I believe). So this should become a
> >define and the type field below a __u32.
> >
> >> +
> >> +/* DV timings */
> >> +struct v4l2_dv_timings {
> >> +    enum v4l2_dv_timings_type type;
> >> +    union {
> >> +            struct v4l2_bt_timings  bt;
> >> +            __u32   reserved[32];
> >> +    };
> >> +};

Ditto.

I also attached a small diff for the v4l2-apps/test/ioctl-test.c source which
I used to test this.

The patch is Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

You can include this when you post the v4l2-apps patches.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

--Boundary-00=_1mEBLJ3v4P+9b4Y
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="ioctl.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ioctl.diff"

diff -r 19ac1f4cde54 v4l2-apps/test/ioctl-test.c
--- a/v4l2-apps/test/ioctl-test.c	Tue Nov 17 20:30:42 2009 -0200
+++ b/v4l2-apps/test/ioctl-test.c	Wed Nov 18 19:30:38 2009 +0100
@@ -91,6 +91,8 @@
 	struct v4l2_dbg_register p_v4l2_dbg_register;
 	struct v4l2_dbg_chip_ident p_v4l2_dbg_chip_ident;
 	struct v4l2_hw_freq_seek p_v4l2_hw_freq_seek;
+	struct v4l2_dv_preset p_v4l2_dv_preset;
+	struct v4l2_dv_timings p_v4l2_dv_timings;
 };
 
 #define ioc(cmd) { cmd, #cmd }
@@ -197,6 +199,12 @@
 	ioc(VIDIOC_DBG_G_REGISTER),	/* struct v4l2_register */
 	ioc(VIDIOC_DBG_G_CHIP_IDENT),	/* struct v4l2_dbg_chip_ident */
 	ioc(VIDIOC_S_HW_FREQ_SEEK),	/* struct v4l2_hw_freq_seek */
+	ioc(VIDIOC_ENUM_DV_PRESETS),	/* struct v4l2_dv_enum_preset */
+	ioc(VIDIOC_S_DV_PRESET),	/* struct v4l2_dv_preset */
+	ioc(VIDIOC_G_DV_PRESET),	/* struct v4l2_dv_preset */
+	ioc(VIDIOC_QUERY_DV_PRESET),	/* struct v4l2_dv_preset */
+	ioc(VIDIOC_S_DV_TIMINGS),	/* struct v4l2_dv_timings */
+	ioc(VIDIOC_G_DV_TIMINGS),	/* struct v4l2_dv_timings */
 #ifdef __OLD_VIDIOC_
 	ioc(VIDIOC_OVERLAY_OLD),	/* int */
 	ioc(VIDIOC_S_PARM_OLD),		/* struct v4l2_streamparm */

--Boundary-00=_1mEBLJ3v4P+9b4Y--
