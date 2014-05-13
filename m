Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59936 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaEMVX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 17:23:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v4 05/49] v4l: Add pad-level DV timings subdev operations
Date: Tue, 13 May 2014 23:23:51 +0200
Message-ID: <6251976.q2Uf8KkvMI@avalon>
In-Reply-To: <20140513135120.3545bfad@recife.lan>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com> <1397744000-23967-6-git-send-email-laurent.pinchart@ideasonboard.com> <20140513135120.3545bfad@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 13 May 2014 13:51:20 Mauro Carvalho Chehab wrote:
> Em Thu, 17 Apr 2014 16:12:36 +0200 Laurent Pinchart escreveu:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> > 
> >  include/media/v4l2-subdev.h    |  4 ++++
> >  include/uapi/linux/videodev2.h | 10 ++++++++--
> >  2 files changed, 12 insertions(+), 2 deletions(-)

[snip]

> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index ea468ee..8e5077e 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h

[snip]

> > @@ -1150,11 +1153,14 @@ struct v4l2_bt_timings_cap {
> >
> >  /** struct v4l2_dv_timings_cap - DV timings capabilities
> >   * @type:	the type of the timings (same as in struct v4l2_dv_timings)
> > + * @pad:	the pad number for which to query capabilities (used with
> > + *		v4l-subdev nodes only)
> >   * @bt:		the BT656/1120 timings capabilities
> >   */
> >  
> >  struct v4l2_dv_timings_cap {
> >  	__u32 type;
> > -	__u32 reserved[3];
> > +	__u32 pad;
> 
> Please document its usage at the media DocBook.

Please have a look at "[PATCH v4 25/49] v4l: Add support for DV timings ioctls 
on subdev nodes" :-)

> > +	__u32 reserved[2];
> >  	union {
> >  		struct v4l2_bt_timings_cap bt;
> >  		__u32 raw_data[32];

-- 
Regards,

Laurent Pinchart

