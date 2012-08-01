Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55283 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752295Ab2HAH60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 03:58:26 -0400
Date: Wed, 1 Aug 2012 10:58:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 1/1] libv4l2subdev: Add
 v4l2_subdev_enum_mbus_code()
Message-ID: <20120801075821.GK26642@valkosipuli.retiisi.org.uk>
References: <1343686560-31983-1-git-send-email-sakari.ailus@iki.fi>
 <1370725.tme9eTgAke@avalon>
 <20120731121704.GJ26642@valkosipuli.retiisi.org.uk>
 <2005128.VGn1ZReBNM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2005128.VGn1ZReBNM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Jul 31, 2012 at 11:50:53PM +0200, Laurent Pinchart wrote:
> On Tuesday 31 July 2012 15:17:04 Sakari Ailus wrote:
> > On Tue, Jul 31, 2012 at 01:38:41PM +0200, Laurent Pinchart wrote:
> > > On Tuesday 31 July 2012 01:16:00 Sakari Ailus wrote:
> > > > v4l2_subdev_enum_mbus_code() enumerates over supported media bus formats
> > > > on a pad.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > > ---
> > > > 
> > > >  src/v4l2subdev.c |   23 +++++++++++++++++++++++
> > > >  src/v4l2subdev.h |   14 ++++++++++++++
> > > >  2 files changed, 37 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> > > > index d60bd7e..6b6df0a 100644
> > > > --- a/src/v4l2subdev.c
> > > > +++ b/src/v4l2subdev.c
> > > > @@ -58,6 +58,29 @@ void v4l2_subdev_close(struct media_entity *entity)
> > > > 
> > > >  	entity->fd = -1;
> > > >  
> > > >  }
> > > > 
> > > > +int v4l2_subdev_enum_mbus_code(struct media_entity *entity,
> > > > +			       uint32_t *code, uint32_t pad, uint32_t index)
> > > 
> > > I would use unsigned int for the pad and index arguments to match the
> > > other functions. We could then fix all of them in one go to use stdint
> > > types to match the kernel API types.
> > 
> > I'm fine with that.
> > 
> > > > +{
> > > > +	struct v4l2_subdev_mbus_code_enum c;
> > > > +	int ret;
> > > > +
> > > > +	ret = v4l2_subdev_open(entity);
> > > > +	if (ret < 0)
> > > > +		return ret;
> > > > +
> > > > +	memset(&c, 0, sizeof(c));
> > > > +	c.pad = pad;
> > > > +	c.index = index;
> > > > +
> > > > +	ret = ioctl(entity->fd, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &c);
> > > > +	if (ret < 0)
> > > > +		return -errno;
> > > > +
> > > > +	*code = c.code;
> > > > +
> > > > +	return 0;
> > > > +}
> > > 
> > > What about a higher-level API that would enumerate all formats and return
> > > a list/array ?
> > 
> > The information could be stored to media entities. We could add a V4L2
> > subdev pointer to media entities, and have the information stored there the
> > first time this function is called. How about that?
> > 
> > On source pads the pixel code is obviously possibly dependent on the pixel
> > code on the sink pad so I need to store mappings from sink pad pixel code to
> > a list of source pad pixel code, but can it have other dependencies? None
> > come to mind right now, though.
> 
> I would make this function store the enumerated mbus codes in the media 
> entity, as the codes on a source pad could depend on the selected code on a 
> sink pad. I would instead make the function allocate an array, fill it with 

(After a short discussion it has been confirmed that " not" should be added
somewhere to the above sentence.)

> media bus codes and return it. The caller would be responsible for freeing it 
> (possibly later, after storing it).

I like this option better as it forces the user to make a decision how long
to keep the enumeration around. Changing the sink pad's try format is one
thing that may invalidate the enumeration on a source pad, but that doesn't
rule out other reasons since they may be hardware dependent.

So I'll change it so.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
