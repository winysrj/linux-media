Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55015 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbeGKKnr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 06:43:47 -0400
Date: Wed, 11 Jul 2018 12:39:58 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Javier Martinez Canillas <javierm@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
Message-ID: <20180711103958.gd6szkgfljjnr44w@pengutronix.de>
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
 <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
 <20180705094421.0bad52e2@coco.lan>
 <2f4121bb-1774-410c-5425-f9977d38a02e@xs4all.nl>
 <7efd92ca-1891-4054-29d5-dca5813b37d6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7efd92ca-1891-4054-29d5-dca5813b37d6@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 18-07-08 15:11, Javier Martinez Canillas wrote:
> [adding Marco Felsch since he has been working on this driver]
> 
> On 07/05/2018 03:12 PM, Hans Verkuil wrote:
> > On 05/07/18 14:44, Mauro Carvalho Chehab wrote:
> >> Javier,
> >>
> >> How standard settings work with the current OMAP3 drivers with tvp5150?
> > 
> > It looks like tvp5150 uses autodetect of the standard, which in general is
> 
> That's correct, the driver uses standard autodetect.
> 
> > not a good thing to do since different standards have different buffer
> > sizes. But this chip can scale, so it might scale PAL to NTSC or vice versa
> > if the standard switches mid-stream. Or it only detects the standard when
> > it starts streaming, I'm not sure.
> >
> 
> Not sure about this either, IIUC switching the standard mid-stream won't work.

As far as I know, the detection happens after a sync lost event.

> > In any case, this is not normal behavior, for almost all analog video
> > receivers you need to be able to set the std explicitly.
> >
> 
> Indeed. I see that Marco's recent series [0] add supports for the .querystd [1]
> and .g_std [2] callbacks to the tvp5150 driver, so that way user-space can get
> back the detected standard.
> 
> [0]: https://www.spinics.net/lists/linux-media/msg136869.html
> [1]: https://www.spinics.net/lists/linux-media/msg136872.html
> [2]: https://www.spinics.net/lists/linux-media/msg136875.html

I tought the std will be set by the v4l2_subdev_video_ops.s_std()
operation. If the user change the std manually, the autodection is
disabled.

> > Regards,
> > 
> > 	Hans
> >
> 
> Best regards,

Best regards,
Marco

> -- 
> Javier Martinez Canillas
> Software Engineer - Desktop Hardware Enablement
> Red Hat
> 
> >>
> >> Regards,
> >> Mauro
> >>
> >>
> >> Em Thu, 17 May 2018 16:30:16 +0200
> >> Niklas Söderlund         <niklas.soderlund+renesas@ragnatech.se> escreveu:
> >>
> >>> There is no way to control the standard of subdevices which are part of
> >>> a media device. The ioctls which exists all target video devices
> >>> explicitly and the idea is that the video device should talk to the
> >>> subdevice. For subdevices part of a media graph this is not possible and
> >>> the standard must be controlled on the subdev device directly.
> >>>
> >>> Add four new ioctls to be able to directly interact with subdevices and
> >>> control the video standard; VIDIOC_SUBDEV_ENUMSTD, VIDIOC_SUBDEV_G_STD,
> >>> VIDIOC_SUBDEV_S_STD and VIDIOC_SUBDEV_QUERYSTD.
> >>>
> >>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >>>
> >>> ---
> >>>
> >>> * Changes since v1
> >>> - Added VIDIOC_SUBDEV_ENUMSTD.
> >>> ---
> >>>  .../media/uapi/v4l/vidioc-enumstd.rst         | 11 ++++++----
> >>>  Documentation/media/uapi/v4l/vidioc-g-std.rst | 14 ++++++++----
> >>>  .../media/uapi/v4l/vidioc-querystd.rst        | 11 ++++++----
> >>>  drivers/media/v4l2-core/v4l2-subdev.c         | 22 +++++++++++++++++++
> >>>  include/uapi/linux/v4l2-subdev.h              |  4 ++++
> >>>  5 files changed, 50 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
> >>> index b7fda29f46a139a0..2644a62acd4b6822 100644
> >>> --- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
> >>> +++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
> >>> @@ -2,14 +2,14 @@
> >>>  
> >>>  .. _VIDIOC_ENUMSTD:
> >>>  
> >>> -********************
> >>> -ioctl VIDIOC_ENUMSTD
> >>> -********************
> >>> +*******************************************
> >>> +ioctl VIDIOC_ENUMSTD, VIDIOC_SUBDEV_ENUMSTD
> >>> +*******************************************
> >>>  
> >>>  Name
> >>>  ====
> >>>  
> >>> -VIDIOC_ENUMSTD - Enumerate supported video standards
> >>> +VIDIOC_ENUMSTD - VIDIOC_SUBDEV_ENUMSTD - Enumerate supported video standards
> >>>  
> >>>  
> >>>  Synopsis
> >>> @@ -18,6 +18,9 @@ Synopsis
> >>>  .. c:function:: int ioctl( int fd, VIDIOC_ENUMSTD, struct v4l2_standard *argp )
> >>>      :name: VIDIOC_ENUMSTD
> >>>  
> >>> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_ENUMSTD, struct v4l2_standard *argp )
> >>> +    :name: VIDIOC_SUBDEV_ENUMSTD
> >>> +
> >>>  
> >>>  Arguments
> >>>  =========
> >>> diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
> >>> index 90791ab51a5371b8..8d94f0404df270db 100644
> >>> --- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
> >>> +++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
> >>> @@ -2,14 +2,14 @@
> >>>  
> >>>  .. _VIDIOC_G_STD:
> >>>  
> >>> -********************************
> >>> -ioctl VIDIOC_G_STD, VIDIOC_S_STD
> >>> -********************************
> >>> +**************************************************************************
> >>> +ioctl VIDIOC_G_STD, VIDIOC_S_STD, VIDIOC_SUBDEV_G_STD, VIDIOC_SUBDEV_S_STD
> >>> +**************************************************************************
> >>>  
> >>>  Name
> >>>  ====
> >>>  
> >>> -VIDIOC_G_STD - VIDIOC_S_STD - Query or select the video standard of the current input
> >>> +VIDIOC_G_STD - VIDIOC_S_STD - VIDIOC_SUBDEV_G_STD - VIDIOC_SUBDEV_S_STD - Query or select the video standard of the current input
> >>>  
> >>>  
> >>>  Synopsis
> >>> @@ -21,6 +21,12 @@ Synopsis
> >>>  .. c:function:: int ioctl( int fd, VIDIOC_S_STD, const v4l2_std_id *argp )
> >>>      :name: VIDIOC_S_STD
> >>>  
> >>> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_STD, v4l2_std_id *argp )
> >>> +    :name: VIDIOC_SUBDEV_G_STD
> >>> +
> >>> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_STD, const v4l2_std_id *argp )
> >>> +    :name: VIDIOC_SUBDEV_S_STD
> >>> +
> >>>  
> >>>  Arguments
> >>>  =========
> >>> diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
> >>> index cf40bca19b9f8665..a8385cc7481869dd 100644
> >>> --- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
> >>> +++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
> >>> @@ -2,14 +2,14 @@
> >>>  
> >>>  .. _VIDIOC_QUERYSTD:
> >>>  
> >>> -*********************
> >>> -ioctl VIDIOC_QUERYSTD
> >>> -*********************
> >>> +*********************************************
> >>> +ioctl VIDIOC_QUERYSTD, VIDIOC_SUBDEV_QUERYSTD
> >>> +*********************************************
> >>>  
> >>>  Name
> >>>  ====
> >>>  
> >>> -VIDIOC_QUERYSTD - Sense the video standard received by the current input
> >>> +VIDIOC_QUERYSTD - VIDIOC_SUBDEV_QUERYSTD - Sense the video standard received by the current input
> >>>  
> >>>  
> >>>  Synopsis
> >>> @@ -18,6 +18,9 @@ Synopsis
> >>>  .. c:function:: int ioctl( int fd, VIDIOC_QUERYSTD, v4l2_std_id *argp )
> >>>      :name: VIDIOC_QUERYSTD
> >>>  
> >>> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_QUERYSTD, v4l2_std_id *argp )
> >>> +    :name: VIDIOC_SUBDEV_QUERYSTD
> >>> +
> >>>  
> >>>  Arguments
> >>>  =========
> >>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> >>> index f9eed938d3480b74..27a2c633f2323f5f 100644
> >>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> >>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> >>> @@ -494,6 +494,28 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> >>>  
> >>>  	case VIDIOC_SUBDEV_S_DV_TIMINGS:
> >>>  		return v4l2_subdev_call(sd, video, s_dv_timings, arg);
> >>> +
> >>> +	case VIDIOC_SUBDEV_G_STD:
> >>> +		return v4l2_subdev_call(sd, video, g_std, arg);
> >>> +
> >>> +	case VIDIOC_SUBDEV_S_STD: {
> >>> +		v4l2_std_id *std = arg;
> >>> +
> >>> +		return v4l2_subdev_call(sd, video, s_std, *std);
> >>> +	}
> >>> +
> >>> +	case VIDIOC_SUBDEV_ENUMSTD: {
> >>> +		struct v4l2_standard *p = arg;
> >>> +		v4l2_std_id id;
> >>> +
> >>> +		if (v4l2_subdev_call(sd, video, g_tvnorms, &id))
> >>> +			return -EINVAL;
> >>> +
> >>> +		return v4l_video_std_enumstd(p, id);
> >>> +	}
> >>> +
> >>> +	case VIDIOC_SUBDEV_QUERYSTD:
> >>> +		return v4l2_subdev_call(sd, video, querystd, arg);
> >>>  #endif
> >>>  	default:
> >>>  		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> >>> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
> >>> index c95a53e6743cb040..03970ce3074193e6 100644
> >>> --- a/include/uapi/linux/v4l2-subdev.h
> >>> +++ b/include/uapi/linux/v4l2-subdev.h
> >>> @@ -170,8 +170,12 @@ struct v4l2_subdev_selection {
> >>>  #define VIDIOC_SUBDEV_G_SELECTION		_IOWR('V', 61, struct v4l2_subdev_selection)
> >>>  #define VIDIOC_SUBDEV_S_SELECTION		_IOWR('V', 62, struct v4l2_subdev_selection)
> >>>  /* The following ioctls are identical to the ioctls in videodev2.h */
> >>> +#define VIDIOC_SUBDEV_G_STD			_IOR('V', 23, v4l2_std_id)
> >>> +#define VIDIOC_SUBDEV_S_STD			_IOW('V', 24, v4l2_std_id)
> >>> +#define VIDIOC_SUBDEV_ENUMSTD			_IOWR('V', 25, struct v4l2_standard)
> >>>  #define VIDIOC_SUBDEV_G_EDID			_IOWR('V', 40, struct v4l2_edid)
> >>>  #define VIDIOC_SUBDEV_S_EDID			_IOWR('V', 41, struct v4l2_edid)
> >>> +#define VIDIOC_SUBDEV_QUERYSTD			_IOR('V', 63, v4l2_std_id)
> >>>  #define VIDIOC_SUBDEV_S_DV_TIMINGS		_IOWR('V', 87, struct v4l2_dv_timings)
> >>>  #define VIDIOC_SUBDEV_G_DV_TIMINGS		_IOWR('V', 88, struct v4l2_dv_timings)
> >>>  #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum_dv_timings)
> >>
> >>
> >>
> >> Thanks,
> >> Mauro
> >>
> > 
