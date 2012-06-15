Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40799 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932125Ab2FOPb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 11:31:57 -0400
Date: Fri, 15 Jun 2012 18:31:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl, snjw23@gmail.com,
	t.stanislaws@samsung.com
Subject: Re: [PATCH v4 7/7] v4l: Correct conflicting V4L2 subdev selection
 API documentation
Message-ID: <20120615153150.GJ12505@valkosipuli.retiisi.org.uk>
References: <4FDB3C2E.9060502@iki.fi>
 <1339767880-8412-7-git-send-email-sakari.ailus@iki.fi>
 <1580520.TYuvdPHuRK@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580520.TYuvdPHuRK@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments!

On Fri, Jun 15, 2012 at 04:14:21PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Friday 15 June 2012 16:44:40 Sakari Ailus wrote:
> > The API reference documents that the KEEP_CONFIG flag tells the
> > configuration should not be propatgated by the driver whereas the interface
> 
> s/propatgated/propagated/
> 
> > documentation (dev-subdev.xml) categorically prohibited any changes to the
> > rest of the pipeline. The latter makes no sense, since it would severely
> > limit the usefulness of the KEEP_CONFIG flag.
> > 
> > Correct the documentation in dev-subddev.xml.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  Documentation/DocBook/media/v4l/dev-subdev.xml |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
> > b/Documentation/DocBook/media/v4l/dev-subdev.xml index 8c44b3f..95ebf87
> > 100644
> > --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> > +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> > @@ -361,11 +361,11 @@
> >        performed by the user: the changes made will be propagated to
> >        any subsequent stages. If this behaviour is not desired, the
> >        user must set
> > -      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag. This
> > -      flag causes no propagation of the changes are allowed in any
> > -      circumstances. This may also cause the accessed rectangle to be
> > -      adjusted by the driver, depending on the properties of the
> > -      underlying hardware.</para>
> > +      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag,
> 
> This should be V4L2_SEL_FLAG_KEEP_CONFIG.
> 
> > +      which tells the driver to make minimum changes to the rest of
> > +      the subdev's configuration.
> 
> I'm not sure to like this. "minimum changes" is not clearly defined. Isn't the 
> point of the KEEP_CONFIG flag is to avoid propagating *any* change down the 
> pipeline inside the subdev ?

Yes, but the hardware may have restrictions that essentially makes the
configuration static is absolutely no changes are allowed elsewhere. In
those cases it should be possible to allow changes elsewhere.

Or do you think we should just completely disallow them? Would that work
e.g. for the OMAP 3 ISP resizer?

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
