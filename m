Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39270 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751116Ab2FLW1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 18:27:33 -0400
Date: Wed, 13 Jun 2012 01:27:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/4] v4l: Remove "_ACTUAL" from subdev selection API
 target definition names
Message-ID: <20120612222728.GH12505@valkosipuli.retiisi.org.uk>
References: <4FD4F6B6.1070605@iki.fi>
 <1339356878-2179-2-git-send-email-sakari.ailus@iki.fi>
 <4FD72016.5040001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD72016.5040001@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 12, 2012 at 12:55:18PM +0200, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> thanks for the patch.

Hi Sylwester,

Thanks for the review!

> On 06/10/2012 09:34 PM, Sakari Ailus wrote:
> > The string "_ACTUAL" does not say anything more about the target names. Drop
> > it. V4L2 selection API was changed by "V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
> > V4L2_SEL_TGT_[CROP/COMPOSE]" by Sylwester Nawrocki. This patch does the same
> > for the V4L2 subdev API.
> > 
> > Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
> > ---
> >   Documentation/DocBook/media/v4l/dev-subdev.xml     |   25 +++++++++----------
> >   .../media/v4l/vidioc-subdev-g-selection.xml        |   12 ++++----
> >   drivers/media/video/omap3isp/ispccdc.c             |    4 +-
> >   drivers/media/video/omap3isp/isppreview.c          |    4 +-
> >   drivers/media/video/omap3isp/ispresizer.c          |    4 +-
> >   drivers/media/video/smiapp/smiapp-core.c           |   22 ++++++++--------
> >   drivers/media/video/v4l2-subdev.c                  |    4 +-
> >   include/linux/v4l2-subdev.h                        |    4 +-
> >   8 files changed, 39 insertions(+), 40 deletions(-)
> > 
> <snip>
> > diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> > index db6e859..cd86f0c 100644
> > --- a/drivers/media/video/v4l2-subdev.c
> > +++ b/drivers/media/video/v4l2-subdev.c
> > @@ -245,7 +245,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> >   		memset(&sel, 0, sizeof(sel));
> >   		sel.which = crop->which;
> >   		sel.pad = crop->pad;
> > -		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL;
> > +		sel.target = V4L2_SUBDEV_SEL_TGT_CROP;
> > 
> >   		rval = v4l2_subdev_call(
> >   			sd, pad, get_selection, subdev_fh,&sel);
> > @@ -274,7 +274,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
> >   		memset(&sel, 0, sizeof(sel));
> >   		sel.which = crop->which;
> >   		sel.pad = crop->pad;
> > -		sel.target = V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL;
> > +		sel.target = V4L2_SUBDEV_SEL_TGT_CROP;
> >   		sel.r = crop->rect;
> > 
> >   		rval = v4l2_subdev_call(
> > diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
> > index 812019e..01eee06 100644
> > --- a/include/linux/v4l2-subdev.h
> > +++ b/include/linux/v4l2-subdev.h
> > @@ -128,11 +128,11 @@ struct v4l2_subdev_frame_interval_enum {
> >   #define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1<<  2)
> > 
> >   /* active cropping area */
> > -#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL			0x0000
> > +#define V4L2_SUBDEV_SEL_TGT_CROP			0x0000
> >   /* cropping bounds */
> >   #define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
> >   /* current composing area */
> > -#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL		0x0100
> > +#define V4L2_SUBDEV_SEL_TGT_COMPOSE			0x0100
> >   /* composing bounds */
> >   #define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0102
> 
> Unfortunately now there is little chance for these patches to make it 
> to v3.5. Thus we most likely need alias definitions like:
> 
> #define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL		V4L2_SUBDEV_SEL_TGT_CROP
> #define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL	V4L2_SUBDEV_SEL_TGT_COMPOSE
> 
> And then it might have been moved over to v4l2-common.h
> 
> What do you think ?

Yes --- if the patches won't make it to 3.5 we'll definitely need a
compatibility defines. Actually, even if they did, which however is
unlikely, there's no harm from these definitions.

I'll change this and resend.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
