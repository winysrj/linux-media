Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:59239 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2B0A5w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 19:57:52 -0500
Date: Mon, 27 Feb 2012 02:57:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 04/33] v4l: VIDIOC_SUBDEV_S_SELECTION and
 VIDIOC_SUBDEV_G_SELECTION IOCTLs
Message-ID: <20120227005747.GI12602@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <1429308.tLqNDhgYvj@avalon>
 <4F45D633.7080008@iki.fi>
 <1411719.Jn3cQENcA7@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411719.Jn3cQENcA7@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Feb 27, 2012 at 01:22:34AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday 23 February 2012 08:01:23 Sakari Ailus wrote:
> > Laurent Pinchart wrote:
> > > [snip]
> > > 
> > >> +/* active cropping area */
> > >> +#define V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE			0x0000
> > >> +/* cropping bounds */
> > >> +#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
> > >> +/* current composing area */
> > >> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		0x0100
> > >> +/* composing bounds */
> > > 
> > > I'm not sure if ACTIVE is a good name here. It sounds confusing as we
> > > already have V4L2_SUBDEV_FORMAT_ACTIVE.
> > 
> > We are using V4L2_SEL_TGT_COMPOSE_ACTIVE on V4L2 nodes already --- the
> > name I'm using here just mirrors the naming on V4L2 device nodes. If I
> > choose a different name here, some of that analogy is lost.
> > 
> > That said, I'm not against changing this but the equivalent change
> > should then be made on V4L2 selection API for consistency.
> 
> I'm not against changing the V4L2 selection API either :-) Just think about 
> developers talking about "try crop active" or "active crop bounds". Even 
> worse, will "active crop" refer to the active target or the active "which" ? 
> That will be very confusing.

I think I understand your concern. An easy solution would be to rename
active targets to something else, but what would that be exactly?

Also I can't currently think non-active rectangles would have use with which
== try as they're not (typically) changeable. I guess this doesn't matter in
resolving the issue.

Current?
Effective?
Real?
Brisk?

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
