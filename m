Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7021 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbbLJEdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 23:33:43 -0500
From: "Wu, Xia" <xia.wu@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: "mchehab@infradead.org" <mchehab@infradead.org>,
	"horms+renesas@verge.net.au" <horms+renesas@verge.net.au>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"Hans Verkuil" <hverkuil@xs4all.nl>
Subject: RE: [PATCH] media: videobuf2-core: Fix one __qbuf_dmabuf() error
 path
Date: Thu, 10 Dec 2015 04:33:39 +0000
Message-ID: <05B4341E5F09BF4E97AEC15A9DBEC11A1194513A@shsmsx102.ccr.corp.intel.com>
References: <05B4341E5F09BF4E97AEC15A9DBEC11A1193CA21@shsmsx102.ccr.corp.intel.com>
 <5667E589.3090108@linux.intel.com>
In-Reply-To: <5667E589.3090108@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Sakari,
On Wed, Dec 09, 2015 at 4:26PM, Sakari wrote:

> Hi Wu,
> 
> Wu, Xia wrote:
> > Add dma_buf_put() to decrease refcount of the dmabuf in error path if
> DMABUF size is smaller than the requirement.
> >
> > Signed-off-by: wu xia <xia.wu@intel.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-core.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c
> > index 33bdd81..1f232e7 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -1084,6 +1084,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb,
> const void *pb)
> >  		if (planes[plane].length < q->plane_sizes[plane]) {
> >  			dprintk(1, "invalid dmabuf length for plane %d\n",
> >  				plane);
> > +			dma_buf_put(dbuf);
> >  			ret = -EINVAL;
> >  			goto err;
> >  		}
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Looks like the bug has been also in the original implementation, and the code
> has been in a bit of flux since, yet the bug has remained...
> 
> I think it'd be nice to have this in stable kernels. Mauro, Hans, what do you
> think?

Thank you for your feedback. Yes, it seems that the bug is there for a long time.
It's better to have this fix in stable kernels.

> 
> --
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
