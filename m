Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57179 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdL1Mja (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 07:39:30 -0500
Date: Thu, 28 Dec 2017 13:39:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] uvcvideo: add a D4M camera description
In-Reply-To: <20171227182349.qeik22bnuwbsahtv@valkosipuli.retiisi.org.uk>
Message-ID: <alpine.DEB.2.20.1712281336070.31327@axis700.grange>
References: <alpine.DEB.2.20.1712231208440.21222@axis700.grange> <20171227182349.qeik22bnuwbsahtv@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wed, 27 Dec 2017, Sakari Ailus wrote:

> Hi Guennadi,
> 
> Thanks for the patch!
> 
> On Sat, Dec 23, 2017 at 12:11:00PM +0100, Guennadi Liakhovetski wrote:
> > From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > 
> > D4M is a mobile model from the D4XX family of Intel RealSense cameras.
> > This patch adds a descriptor for it, which enables reading per-frame
> > metadata from it.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> >  Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst | 202 ++++++++++++++++++++++
> >  drivers/media/usb/uvc/uvc_driver.c                |  11 ++
> >  include/uapi/linux/videodev2.h                    |   1 +
> >  3 files changed, 214 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> > 
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> > new file mode 100644
> > index 0000000..950780d
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
> > @@ -0,0 +1,202 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _v4l2-meta-fmt-d4xx:
> > +
> > +*******************************
> > +V4L2_META_FMT_D4XX ('D4XX')
> > +*******************************
> > +
> > +D4XX Metadata
> > +
> > +
> > +Description
> > +===========
> > +
> > +D4XX (D435 and other) cameras include per-frame metadata in their UVC payload
> 
> If this is D435 and some others, I'd simply call this D435. Say, if you get
> another device in D4xx series that implements a different format, how do
> you call that? Up to you.

As far as I understand, all D4XX cameras are using this format, but they 
might use different sets of metadata blocks, in which case any new such 
blocks should be added to this documentation. The format remains the same 
though, hence the name.

> Is there a specific list of devices that use this format? The driver patch
> only appears to introduce one USB ID.

I don't have such a list, sorry. I think any D4XX camera should work with 
this, so it would be a matter of adding those product ID values.

Thanks
Guennadi
