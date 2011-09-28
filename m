Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59920 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1I1Ubl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 16:31:41 -0400
Date: Wed, 28 Sep 2011 22:31:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	mchehab@infradead.org, m.szyprowski@samsung.com
Subject: Re: [PATCH 1/1] v4l: Add note on buffer locking to memory and DMA
 mapping to PREPARE_BUF
In-Reply-To: <20110928202035.GE6180@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1109282227300.21237@axis700.grange>
References: <Pine.LNX.4.64.1109010904300.21309@axis700.grange>
 <1314875336-21811-1-git-send-email-sakari.ailus@iki.fi>
 <20110928202035.GE6180@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Sep 2011, Sakari Ailus wrote:

> Hi Guennadi,
> 
> What's your opinion on this? I was intended to complement the PREPARE_BUF
> documentation.

I don't think I have a very strong opinion about this. AFAIU this is so 
far just a (yet another) speculation about what the driver might want or 
need to do in PREPARE_BUF. Let's wait until the author of these patches 
manages to get them straight (...) and until all the reviewers are 
satisfied:-) Then you're certainly welcome to submit any improvement you 
see fit, then the usual suspects will express their opinions on them. So, 
business as usual, I would say;-)

Thanks
Guennadi

> 
> On Thu, Sep 01, 2011 at 02:08:56PM +0300, Sakari Ailus wrote:
> > Add note to documentation of VIDIOC_PREPARE_BUF that the preparation done by
> > the IOCTL may include locking buffers to system memory and creating DMA
> > mappings for them.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > index 509e752..7177c2f 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > @@ -52,9 +52,11 @@
> >  <constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
> >  to the driver before actually enqueuing it, using the
> >  <constant>VIDIOC_QBUF</constant> ioctl, and to prepare it for future I/O.
> > -Such preparations may include cache invalidation or cleaning. Performing them
> > -in advance saves time during the actual I/O. In case such cache operations are
> > -not required, the application can use one of
> > +Such preparations may include locking the buffer to system memory and
> > +creating DMA mapping for it (on the first time
> > +<constant>VIDIOC_PREPARE_BUF</constant> is called), cache invalidation or
> > +cleaning. Performing them in advance saves time during the actual I/O. In
> > +case such cache operations are not required, the application can use one of
> >  <constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
> >  <constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
> >  step.</para>
> > -- 
> > 1.7.2.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
