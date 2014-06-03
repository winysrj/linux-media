Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49586 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714AbaFCRKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 13:10:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] media-ctl: libv4l2subdev: Add DV timings support
Date: Tue, 03 Jun 2014 19:10:58 +0200
Message-ID: <1895886.LJyZrLTVV4@avalon>
In-Reply-To: <20140603123224.GI2073@valkosipuli.retiisi.org.uk>
References: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com> <1401721804-30133-2-git-send-email-laurent.pinchart@ideasonboard.com> <20140603123224.GI2073@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 03 June 2014 15:32:24 Sakari Ailus wrote:
> On Mon, Jun 02, 2014 at 05:10:02PM +0200, Laurent Pinchart wrote:
> > Expose the pad-level get caps, query, get and set DV timings ioctls.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  utils/media-ctl/libv4l2subdev.c | 72 ++++++++++++++++++++++++++++++++++++
> >  utils/media-ctl/v4l2subdev.h    | 53 ++++++++++++++++++++++++++++++
> >  2 files changed, 125 insertions(+)
> > 
> > diff --git a/utils/media-ctl/libv4l2subdev.c
> > b/utils/media-ctl/libv4l2subdev.c index 14daffa..8015330 100644
> > --- a/utils/media-ctl/libv4l2subdev.c
> > +++ b/utils/media-ctl/libv4l2subdev.c
> > @@ -189,6 +189,78 @@ int v4l2_subdev_set_selection(struct media_entity
> > *entity,
> >  	return 0;
> >  }
> > 
> > +int v4l2_subdev_get_dv_timings_caps(struct media_entity *entity,
> > +	struct v4l2_dv_timings_cap *caps)
> > +{
> > +	unsigned int pad = caps->pad;
> > +	int ret;
> > +
> > +	ret = v4l2_subdev_open(entity);
> > +	if (ret < 0)
> > +		return ret;
> 
> In every function v4l2_subdev_open() is called before the ioctl command. How
> about implementing a wrapper which does both, and using that before this
> patch?

I'm not too fond of the current subdev API. Subdevs are opened implicitly but 
must be closed explicitly. Implicit open is of course easy, but the unbalanced 
API makes me feel uneasy. I'm open to ideas for better alternatives :-)

-- 
Regards,

Laurent Pinchart

