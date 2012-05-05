Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab2EEPJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 11:09:04 -0400
Date: Sat, 5 May 2012 17:09:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, Qing Xu <qingx@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] v4l: soc-camera: Add support for enum_frameintervals
 ioctl
In-Reply-To: <CAKnK67SLmeU869TsW3Ls+gs4iX_DvYo32_2rKmtKE-mCMtzpzg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1205051642210.28277@axis700.grange>
References: <CAKnK67SK+CKBL-Dx0V0nyYtEWN3wp3D90M9irFCQOmqiX2fKPw@mail.gmail.com>
 <Pine.LNX.4.64.1205041541100.21890@axis700.grange>
 <CAKnK67SLmeU869TsW3Ls+gs4iX_DvYo32_2rKmtKE-mCMtzpzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 4 May 2012, Aguirre, Sergio wrote:

> Hi Guennadi,
> 
> No problem.
> 
> On Fri, May 4, 2012 at 10:05 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi Sergio
> >
> > Sorry about the delay.
> >
> > On Wed, 18 Apr 2012, Aguirre, Sergio wrote:
> >
> >> From: Sergio Aguirre <saaguirre@ti.com>
> >>
> >> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> >> ---
> >>  drivers/media/video/soc_camera.c |   37 +++++++++++++++++++++++++++++++++++++
> >>  include/media/soc_camera.h       |    1 +
> >>  2 files changed, 38 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> >> index eb25756..62c8956 100644
> >> --- a/drivers/media/video/soc_camera.c
> >> +++ b/drivers/media/video/soc_camera.c
> >> @@ -266,6 +266,15 @@ static int soc_camera_enum_fsizes(struct file
> >> *file, void *fh,
> >>       return ici->ops->enum_fsizes(icd, fsize);
> >>  }
> >>
> >> +static int soc_camera_enum_fivals(struct file *file, void *fh,
> >
> > "fivals" is a bit short for my taste. Yes, I know about the
> > *_enum_fsizes() precedent in soc_camera.c, we should have used a more
> > descriptive name for that too. So, maybe I'll push a patch to change that
> > to enum_frmsizes() or enum_framesizes().
> 
> Agreed.
> 
> >
> > But that brings in a larger question, which is also the reason, why I
> > added a couple more people to the CC: the following 3 operations in struct
> > v4l2_subdev_video_ops don't make me particularly happy:
> >
> >        int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
> >        int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
> >        int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
> >                             struct v4l2_frmsizeenum *fsize);
> >
> > The problems are:
> >
> > 1. enum_framesizes and enum_mbus_fsizes seem to be identical (yes, I see
> > my Sob under the latter:-()
> 
> Yeah, IMHO, the mbus one should go, since there's no mbus specific structure
> being handed as a parameter.

Right, we can do that.

> > 2. both struct v4l2_frmsizeenum and struct v4l2_frmivalenum are the
> > structs, used in the respective V4L2 ioctl()s, and they both contain a
> > field for a fourcc value, which doesn't make sense to subdevice drivers.
> > So far the only driver combination in the mainline, that I see, that uses
> > these operations is marvell-ccic & ov7670. These drivers just ignore the
> > pixel format. Relatively recently enum_mbus_fsizes() has been added to
> > soc-camera, and this patch is adding enum_frameintervals(). Both these
> > implementations abuse the .pixel_format field to pass a media-bus code
> > value in it to subdevice drivers. This sends meaningful information to
> > subdevice drivers, but is really a hack, rather than a proper
> > implementation.
> 
> True.
> 
> >
> > Any idea how to improve this? Shall we create mediabus clones of those
> > structs with an mbus code instead of fourcc, and drop one of the above
> > enum_framesizes() operations?
> 
> Well, to add more confusion to this.. :)
> 
> We have this v4l2-subdev IOCTLs exported to userspace:
> 
> #define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
> 			_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)
> #define VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
> 			_IOWR('V', 75, struct v4l2_subdev_frame_interval_enum)
> 
> Which in "drivers/media/video/v4l2-subdev.c", are translated to pad ops:
> - v4l2_subdev_call(... enum_frame_size ...);
> - v4l2_subdev_call(... enum_frame_interval ...);
> 
> respectively.
> 
> So, this is also another thing that's causing some confusion.

Wow, didn't know about those. I was about to propose to use those in video 
subdev ops, but then I noticed: pad operations don't support stepwise 
enumerations. struct v4l2_subdev_frame_size_enum seems to implement 
continuous enumeration implicitly, with discrete being a particular 
degenerate case of it. struct v4l2_subdev_frame_interval_enum only 
implements discrete enumeration only. I personally don't have a problem 
with that, I'm not a big fan of these enumeration operations anyway, and 
AFAICS, the only subdevice driver, implementing those video operations is 
ov7670, and it implements only DISCRETE.

So, would it be good enough for everyone to drop enum_mbus_fsizes() and to 
convert enum_frameintervals() and enum_framesizes() video operations to 
use structs from pad operations and just ignore the pad field? Any 
objections?

> Does soc_camera use pad ops?

No, not yet.

> Regards,
> Sergio

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
