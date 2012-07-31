Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54837 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756026Ab2GaMRI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 08:17:08 -0400
Date: Tue, 31 Jul 2012 15:17:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 1/1] libv4l2subdev: Add
 v4l2_subdev_enum_mbus_code()
Message-ID: <20120731121704.GJ26642@valkosipuli.retiisi.org.uk>
References: <1343686560-31983-1-git-send-email-sakari.ailus@iki.fi>
 <1370725.tme9eTgAke@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370725.tme9eTgAke@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Jul 31, 2012 at 01:38:41PM +0200, Laurent Pinchart wrote:
> Thanks for the patch.

Thanks for the comments!

> On Tuesday 31 July 2012 01:16:00 Sakari Ailus wrote:
> > v4l2_subdev_enum_mbus_code() enumerates over supported media bus formats on
> > a pad.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  src/v4l2subdev.c |   23 +++++++++++++++++++++++
> >  src/v4l2subdev.h |   14 ++++++++++++++
> >  2 files changed, 37 insertions(+), 0 deletions(-)
> > 
> > diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> > index d60bd7e..6b6df0a 100644
> > --- a/src/v4l2subdev.c
> > +++ b/src/v4l2subdev.c
> > @@ -58,6 +58,29 @@ void v4l2_subdev_close(struct media_entity *entity)
> >  	entity->fd = -1;
> >  }
> > 
> > +int v4l2_subdev_enum_mbus_code(struct media_entity *entity,
> > +			       uint32_t *code, uint32_t pad, uint32_t index)
> 
> I would use unsigned int for the pad and index arguments to match the other 
> functions. We could then fix all of them in one go to use stdint types to 
> match the kernel API types.

I'm fine with that.

> > +{
> > +	struct v4l2_subdev_mbus_code_enum c;
> > +	int ret;
> > +
> > +	ret = v4l2_subdev_open(entity);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	memset(&c, 0, sizeof(c));
> > +	c.pad = pad;
> > +	c.index = index;
> > +
> > +	ret = ioctl(entity->fd, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &c);
> > +	if (ret < 0)
> > +		return -errno;
> > +
> > +	*code = c.code;
> > +
> > +	return 0;
> > +}
> 
> What about a higher-level API that would enumerate all formats and return a 
> list/array ?

The information could be stored to media entities. We could add a V4L2
subdev pointer to media entities, and have the information stored there the
first time this function is called. How about that?

On source pads the pixel code is obviously possibly dependent on the pixel
code on the sink pad so I need to store mappings from sink pad pixel code to
a list of source pad pixel code, but can it have other dependencies? None
come to mind right now, though.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
