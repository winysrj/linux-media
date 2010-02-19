Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43396 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0BSWed (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 17:34:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [PATCH v5 1/6] V4L: File handles
Date: Fri, 19 Feb 2010 23:34:56 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"iivanov@mm-sol.com" <iivanov@mm-sol.com>,
	"gururaj.nagendra@intel.com" <gururaj.nagendra@intel.com>,
	"david.cohen@nokia.com" <david.cohen@nokia.com>
References: <4B7EE4A4.3080202@maxwell.research.nokia.com> <1266607320-9974-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <A24693684029E5489D1D202277BE894453691587@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894453691587@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002192335.00784.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Friday 19 February 2010 23:29:54 Aguirre, Sergio wrote:
> Heippa!
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Sakari Ailus
> > Sent: Friday, February 19, 2010 1:22 PM
> > To: linux-media@vger.kernel.org
> > Cc: hverkuil@xs4all.nl; laurent.pinchart@ideasonboard.com; iivanov@mm-
> > sol.com; gururaj.nagendra@intel.com; david.cohen@nokia.com; Sakari Ailus
> > Subject: [PATCH v5 1/6] V4L: File handles
> > 
> > This patch adds a list of v4l2_fh structures to every video_device.
> > It allows using file handle related information in V4L2. The event
> > interface
> > is one example of such use.
> > 
> > Video device drivers should use the v4l2_fh pointer as their
> > file->private_data.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > ---
> > 
> >  drivers/media/video/Makefile   |    2 +-
> >  drivers/media/video/v4l2-dev.c |    4 ++
> >  drivers/media/video/v4l2-fh.c  |   64
> > 
> > ++++++++++++++++++++++++++++++++++++++++
> > 
> >  include/media/v4l2-dev.h       |    5 +++
> >  include/media/v4l2-fh.h        |   42 ++++++++++++++++++++++++++
> >  5 files changed, 116 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/media/video/v4l2-fh.c
> >  create mode 100644 include/media/v4l2-fh.h

[snip]

> > diff --git a/drivers/media/video/v4l2-fh.c
> > b/drivers/media/video/v4l2-fh.c new file mode 100644
> > index 0000000..c707930
> > --- /dev/null
> > +++ b/drivers/media/video/v4l2-fh.c
> > @@ -0,0 +1,64 @@
> > +/*
> > + * drivers/media/video/v4l2-fh.c
> 
> [1] AFAIK, putting file paths is frowned upon.
> 
> Makes maintenance harder if in the future, this files get moved somewhere
> else.
> 
> > + *
> > + * V4L2 file handles.
> > + *
> > + * Copyright (C) 2009 Nokia Corporation.
> 
> [2] Shouldn't it be "(C) 2010" already? :)

That shows how long the V4L2 events API review is taking ;-)
 
[snip]

> > diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> > new file mode 100644
> > index 0000000..6b486aa
> > --- /dev/null
> > +++ b/include/media/v4l2-fh.h
> > @@ -0,0 +1,42 @@
> > +/*
> > + * include/media/v4l2-fh.h
> 
> Same as [1]
> 
> > + *
> > + * V4L2 file handle.
> > + *
> > + * Copyright (C) 2009 Nokia Corporation.
> 
> Same as [2]
> 
> > + *
> > + * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> > + * 02110-1301 USA
> > + */
> > +
> > +#ifndef V4L2_FH_H
> > +#define V4L2_FH_H
> > +
> > +#include <linux/list.h>
> 
> Shouldn't you add one more header here?:
> 
> #include <media/v4l2-dev.h>
> 
> (for struct video_device)

This header only needs struct video_device *, not struct video_device, so 
adding a forward definition will be more efficient (lower compilation time for 
compilation units that include v4l2-fh.h but not v4l2-dev.h).

> > +
> > +struct video_device;
> > +
> > +struct v4l2_fh {
> > +	struct list_head	list;
> > +	struct video_device	*vdev;
> > +};
> > +
> > +void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev);
> > +void v4l2_fh_add(struct v4l2_fh *fh);
> > +void v4l2_fh_del(struct v4l2_fh *fh);
> > +void v4l2_fh_exit(struct v4l2_fh *fh);
> > +
> > +#endif /* V4L2_EVENT_H */

-- 
Regards,

Laurent Pinchart
