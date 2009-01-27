Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60262 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbZA0NCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 08:02:55 -0500
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 27 Jan 2009 18:32:30 +0530
Subject: RE: [PATCH] New V4L2 ioctls for OMAP class of Devices
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EFE5@dbde02.ent.ti.com>
In-Reply-To: <200901271010.12030.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, January 27, 2009 2:40 PM
> To: Shah, Hardik
> Cc: video4linux-list@redhat.com; linux-media@vger.kernel.org
> Subject: Re: [PATCH] New V4L2 ioctls for OMAP class of Devices
> 
> On Tuesday 27 January 2009 05:43:25 Shah, Hardik wrote:
> > > -----Original Message-----
> > > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > > Sent: Sunday, January 25, 2009 3:06 PM
> > > To: Shah, Hardik
> > > Cc: video4linux-list@redhat.com; linux-media@vger.kernel.org
> > > Subject: Re: [PATCH] New V4L2 ioctls for OMAP class of Devices
> > >
> > > On Saturday 24 January 2009 18:03:51 Shah, Hardik wrote:
> > > > > -----Original Message-----
> > > > > From: Shah, Hardik
> > > > > Sent: Wednesday, January 21, 2009 5:24 PM
> > > > > To: video4linux-list@redhat.com; linux-media@vger.kernel.org
> > > > > Cc: Shah, Hardik; Jadav, Brijesh R; Nagalla, Hari; Hadli,
> > > > > Manjunath; R, Sivaraj; Hiremath, Vaibhav
> > > > > Subject: [PATCH] New V4L2 ioctls for OMAP class of Devices
> > > > >
> > > > > 1.  Control ID added for rotation.  Same as HFLIP.
> > > > > 2.  Control ID added for setting background color on
> > > > >     output device.
> > > > > 3.  New ioctl added for setting the color space conversion from
> > > > >     YUV to RGB.
> > > > >
> > > > > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > > > > Signed-off-by: Hari Nagalla <hnagalla@ti.com>
> > > > > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > > > > Signed-off-by: Manjunath Hadli <mrh@ti.com>
> > > > > Signed-off-by: R Sivaraj <sivaraj@ti.com>
> > > > > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > > > > ---
> > > > >  linux/drivers/media/video/v4l2-ioctl.c |   19 ++++++++++++++++++-
> > > > >  linux/include/linux/videodev2.h        |   19 ++++++++++++++++++-
> > > > >  linux/include/media/v4l2-ioctl.h       |    4 ++++
> > > > >  3 files changed, 40 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/linux/drivers/media/video/v4l2-ioctl.c
> > > > > b/linux/drivers/media/video/v4l2-ioctl.c
> > > > > index 165bc90..7599da8 100644
> > > > > --- a/linux/drivers/media/video/v4l2-ioctl.c
> > > > > +++ b/linux/drivers/media/video/v4l2-ioctl.c
> > > > > @@ -270,6 +270,8 @@ static const char *v4l2_ioctls[] = {
> > > > >  	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
> > > > >  	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
> > > > >  #endif
> > > > > +	[_IOC_NR(VIDIOC_S_COLOR_SPACE_CONV)]   =
> > > > > "VIDIOC_S_COLOR_SPACE_CONV", +	[_IOC_NR(VIDIOC_G_COLOR_SPACE_CONV)]
> > > > >   = "VIDIOC_G_COLOR_SPACE_CONV", };
> > > > >  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
> > > > >
> > > > > @@ -1838,7 +1840,22 @@ static long __video_do_ioctl(struct file
> > > > > *file, }
> > > > >  		break;
> > > > >  	}
> > > > > -
> > > > > +	case VIDIOC_S_COLOR_SPACE_CONV:
> > > > > +	{
> > > > > +		struct v4l2_color_space_conversion *p = arg;
> > > > > +		if (!ops->vidioc_s_color_space_conv)
> > > > > +			break;
> > > > > +		ret = ops->vidioc_s_color_space_conv(file, fh, p);
> > > > > +		break;
> > > > > +	}
> > > > > +	case VIDIOC_G_COLOR_SPACE_CONV:
> > > > > +	{
> > > > > +		struct v4l2_color_space_conversion *p = arg;
> > > > > +		if (!ops->vidioc_g_color_space_conv)
> > > > > +			break;
> > > > > +		ret = ops->vidioc_g_color_space_conv(file, fh, p);
> > > > > +		break;
> > > > > +	}
> > > > >  	default:
> > > > >  	{
> > > > >  		if (!ops->vidioc_default)
> > > > > diff --git a/linux/include/linux/videodev2.h
> > > > > b/linux/include/linux/videodev2.h index b0c5010..9fbc3b0 100644
> > > > > --- a/linux/include/linux/videodev2.h
> > > > > +++ b/linux/include/linux/videodev2.h
> > > > > @@ -879,8 +879,10 @@ enum v4l2_power_line_frequency {
> > > > >  #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
> > > > >  #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
> > > > >  #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
> > > > > +#define V4L2_CID_ROTATION			(V4L2_CID_BASE+31)
> > > > > +#define V4L2_CID_BG_COLOR			(V4L2_CID_BASE+32)
> > > > >  /* last CID + 1 */
> > > > > -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+31)
> > > > > +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+33)
> > > > >
> > > > >  /*  MPEG-class control IDs defined by V4L2 */
> > > > >  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG |
> 0x900)
> > > > > @@ -1192,6 +1194,17 @@ struct v4l2_hw_freq_seek {
> > > > >  };
> > > > >
> > > > >  /*
> > > > > + * Color conversion
> > > > > + * User needs to pass pointer to color conversion matrix
> > > > > + * defined by hardware
> > > > > + */
> > > > > +struct v4l2_color_space_conversion {
> > > > > +	__s32 coefficients[3][3];
> > > > > +	__s32 const_factor;
> > > > > +	__s32 offsets[3];
> > > > > +};
> > > > > +
> > > > > +/*
> > > > >   *	A U D I O
> > > > >   */
> > > > >  struct v4l2_audio {
> > > > > @@ -1493,9 +1506,13 @@ struct v4l2_chip_ident_old {
> > > > >  #endif
> > > > >
> > > > >  #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct
> > > > > v4l2_hw_freq_seek) +
> > > > > +#define VIDIOC_S_COLOR_SPACE_CONV      _IOW('V', 83, struct
> > > > > v4l2_color_space_conversion)
> > > > > +#define VIDIOC_G_COLOR_SPACE_CONV      _IOR('V', 84, struct
> > > > > v4l2_color_space_conversion)
> > > > >  /* Reminder: when adding new ioctls please add support for them to
> > > > >     drivers/media/video/v4l2-compat-ioctl32.c as well! */
> > > > >
> > > > > +
> > > > >  #ifdef __OLD_VIDIOC_
> > > > >  /* for compatibility, will go away some day */
> > > > >  #define VIDIOC_OVERLAY_OLD     	_IOWR('V', 14, int)
> > > > > diff --git a/linux/include/media/v4l2-ioctl.h
> > > > > b/linux/include/media/v4l2- ioctl.h
> > > > > index b01c044..0c44ecf 100644
> > > > > --- a/linux/include/media/v4l2-ioctl.h
> > > > > +++ b/linux/include/media/v4l2-ioctl.h
> > > > > @@ -241,6 +241,10 @@ struct v4l2_ioctl_ops {
> > > > >  	/* For other private ioctls */
> > > > >  	long (*vidioc_default)	       (struct file *file, void *fh,
> > > > >  					int cmd, void *arg);
> > > > > +	int (*vidioc_s_color_space_conv)     (struct file *file, void
> > > > > *fh, +					struct v4l2_color_space_conversion
> *a);
> > > > > +	int (*vidioc_g_color_space_conv)     (struct file *file, void
> > > > > *fh, +					struct v4l2_color_space_conversion
> *a);
> > > > >  };
> > > > >
> > > > >
> > > > > --
> > > > > 1.5.6
> > > >
> > > > [Shah, Hardik] Hi,
> > > > Any comments on this patch.
> > > > Hans/Mauro,
> > > > If possible can you integrate this onto your development branch.
> > >
> > > Hi Hardik,
> > >
> > > I've one question regarding the rotation control: I assume that this is
> > > limited to 0, 90, 180 and 270 degrees? I think it might be better to
> > > implement this as an enum in that case.
> >
> > Hi Hans,
> > The rotation values are 0, 90, 180 and 270 degree but to disable rotation
> > the value passed should be -1 and this is one more value.  I know 0
> > degree rotation corresponds to rotation disabled but DSS hardware
> > requires 0 degree rotation to be enabled for mirroring.  The difference
> > between the 0 degree rotation and no rotation(-1) is that 0 degree
> > rotation will use the rotation engine in OMAP and then do the mirroring
> > while -1 degree rotation will not use rotation engine.  There is more
> > bandwidth utilization while using the rotation engine.  So people may
> > want to completely disable rotation and people may want 0 degree rotation
> > for mirroring support.  That's why I prefer not to use enum.  Is that ok
> > for
> 
> Yuck. Why not do this in the driver:
> 
> if (degrees == 0) {
> 	if (mirroring)
> 		disable_rotation_engine();
> 	else
> 		enable_rotation_engine();
> }
> 
> You are exporting an internal hack to the user API. That's not right. It
> seems to me that you have all the information needed in the driver.
> 
> If that is not the case, then the fallback scenario is to implement this as
> a private control: USE_ROTATION_ENGINE.
[Shah, Hardik] Hi Hans,
I got your above point.  Now regarding the enum I am not sure about how to implement it.  Are you suggesting me to remove the control ID for rotation and implement in some other way.  Please let me know if I am missing something.
Currently in driver I have implemented the rotation in below way
{
                .id            = V4L2_CID_ROTATION,
                .name          = "Rotation",
                .minimum       = 0,
                .maximum       = 270,
                .step          = 90,
                .default_value = -1,
                .flags         = 0,
                .type          = V4L2_CTRL_TYPE_INTEGER, 
You want me to change V4L2_CTRL_TYPE_INTEGER to some enum or something.

Regards,
Hardik Shah
> 
> Regards,
> 
> 	Hans
> 
> > I will update the documentation on the new ioctls soon.
> >
> > you?
> >
> > > Regards,
> > >
> > > 	Hans
> > >
> > > --
> > > Hans Verkuil - video4linux developer - sponsored by TANDBERG
> 
> 
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

