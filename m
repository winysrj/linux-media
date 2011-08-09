Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42572 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1HIMSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 08:18:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Possible issue in videobuf2 with buffer length check at QBUF time
Date: Tue, 9 Aug 2011 14:17:59 +0200
Cc: "'Pawel Osciak'" <pawel@osciak.com>, linux-media@vger.kernel.org
References: <201108051055.08641.laurent.pinchart@ideasonboard.com> <201108091351.44916.laurent.pinchart@ideasonboard.com> <025001cc568c$df347930$9d9d6b90$%szyprowski@samsung.com>
In-Reply-To: <025001cc568c$df347930$9d9d6b90$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108091418.00285.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On Tuesday 09 August 2011 14:07:12 Marek Szyprowski wrote:
> On Tuesday, August 09, 2011 1:52 PM Laurent Pinchart wrote:
> > On Tuesday 09 August 2011 11:14:43 Marek Szyprowski wrote:
> > > On Monday, August 08, 2011 12:11 PM Laurent Pinchart wrote:
> > > > On Friday 05 August 2011 17:01:09 Pawel Osciak wrote:
> > > > > On Fri, Aug 5, 2011 at 01:55, Laurent Pinchart wrote:
> > > > > > Hi Marek and Pawel,
> > > > > > 
> > > > > > While reviewing an OMAP3 ISP patch, I noticed that videobuf2
> > > > > > doesn't verify the buffer length field value when a new USERPTR
> > > > > > buffer is queued.
> > > > > 
> > > > > That's a good catch. We should definitely do something about it.
> > > > > 
> > > > > > The length given by userspace is copied to the internal buffer
> > > > > > length field. It seems to be up to drivers to verify that the
> > > > > > value is equal to or higher than the minimum required to store
> > > > > > the image, but that's not clearly documented. Should the
> > > > > > buf_init operation be made mandatory for drivers that support
> > > > > > USERPTR, and documented as required to implement a length check
> > > > > > ?
> > > > > 
> > > > > Technically, drivers can do the length checks on buf_prepare if
> > > > > they don't allow format changes after REQBUFS. On the other hand
> > > > > though, if a driver supports USERPTR, the buffers queued from
> > > > > userspace have to be verified on qbuf and the only place to do
> > > > > that would be buf_init. So every driver that supports USERPTR
> > > > > would have to implement buf_init, as you said.
> > > > > 
> > > > > > Alternatively the check could be performed in videobuf2-core,
> > > > > > which would probably make sense as the check is required.
> > > > > > videobuf2 doesn't store the minimum size for USERPTR buffers
> > > > > > though (but that can of course be changed).
> > > > > 
> > > > > Let's say we make vb2 save minimum buffer size. This would have to
> > > > > be done on queue_setup I imagine. We could add a new field to
> > > > > vb2_buffer for that. One problem is that if the driver actually
> > > > > supports changing format after REQBUFS, we would need a new
> > > > > function in vb2 to change minimum buffer size. Actually, this has
> > > > > to be minimum plane sizes. So the alternatives are:
> > > > > 
> > > > > 1. Make buf_init required for drivers that support USERPTR; or
> > > > > 2. Add minimum plane sizes to vb2_buffer,add a new return array
> > > > > argument to queue_setup to return minimum plane sizes that would be
> > > > > stored in vb2. Make vb2 verify sizes on qbuf of USERPTR. Add a new
> > > > > vb2 function for drivers to call when minimum sizes have to be
> > > > > changed.
> > > > > 
> > > > > The first solution is way simpler for drivers that require this.
> > > > > The second solution is maybe a bit simpler for drivers that do
> > > > > not, as they would only have to return the sizes in queue_setup,
> > > > > but implementing buf_init instead wouldn't be a big of a
> > > > > difference I think. So I'm leaning towards the second solution.
> > > > > Any comments, did I miss something?
> > > > 
> > > > Thanks for the analysis. I would go for the second solution as well.
> > > > 
> > > > Do we have any driver that supports changing the format after REQBUFS
> > > > ? If not we can delay adding the new vb2 function until we get such
> > > > a driver.
> > > 
> > > I really wonder if we should support changing the format which results
> > > in buffer/plane size change after REQBUFS. Please notice that it
> > > causes additional problems with mmap-style buffers, which are
> > > allocated once during the REQBUFS call. Also none driver support it
> > > right now and I doubt that changing buffer size after REQBUFS can be
> > > implemented without breaking anything other (there are a lot of things
> > > that depends on buffer size, both in vb2 and the drivers).
> > 
> > I wasn't awake enough when I sent my previous reply. We probably have no
> > driver that supports this feature at the moment, but changing the format
> > after REQBUFS is the whole point of the CREATE_BUFS and PREPARE_BUF
> > ioctls, so I think we definitely need to support that :-)
> 
> Right, but this is an extension that will come with CRATE_BUFS/PREPARE_BUF
> calls. Until that, to handle buffers correctly we only need to add min_size
> entry to the queue and check if queued buffers are large enough.

I'm fine with that, but that's not a reason to ignore the bigger picture, 
especially as it will come back to bite us pretty soon :-)

-- 
Regards,

Laurent Pinchart
