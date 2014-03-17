Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39309 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906AbaCQMjh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 08:39:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [REVIEWv2 PATCH for v3.15 2/4] videobuf2-core: fix sparse errors.
Date: Mon, 17 Mar 2014 13:41:19 +0100
Message-ID: <6449458.ttdRkGWNIv@avalon>
In-Reply-To: <5326EB6C.9090508@xs4all.nl>
References: <5326D540.7080805@xs4all.nl> <4203879.N4NqSdO3mH@avalon> <5326EB6C.9090508@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 17 March 2014 13:32:44 Hans Verkuil wrote:
> On 03/17/2014 01:26 PM, Laurent Pinchart wrote:
> > On Monday 17 March 2014 11:58:08 Hans Verkuil wrote:
> >> (Fixed typo pointed out by Pawel, but more importantly made an additional
> >> change to __qbuf_dmabuf. See last paragraph in the commit log)
> > 
> > [snip]
> > 
> >> I made one other change: in __qbuf_dmabuf the result of the memop call
> >> attach_dmabuf() is checked by IS_ERR() instead of IS_ERR_OR_NULL(). Since
> >> the call_ptr_memop macro checks for IS_ERR_OR_NULL and since a NULL
> >> pointer makes no sense anyway, I've changed the IS_ERR to IS_ERR_OR_NULL
> >> to remain consistent, both with the call_ptr_memop macro, but also with
> >> all other cases where a pointer is checked.
> > 
> > Could you please split this to a separate patch ?
> > 
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/videobuf2-core.c | 215 +++++++++++++++----------
> >>  1 file changed, 132 insertions(+), 83 deletions(-)
> >> 
> >> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> >> b/drivers/media/v4l2-core/videobuf2-core.c index f9059bb..fb1ee86 100644
> >> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > 
> > [snip]
> > 
> >> @@ -1401,12 +1458,11 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb,
> >> const struct v4l2_buffer *b) memset(&vb->v4l2_planes[plane], 0,
> >> sizeof(struct v4l2_plane));
> >> 
> >>  		/* Acquire each plane's memory */
> >> 
> >> -		mem_priv = call_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
> >> +		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
> >> 
> >>  			dbuf, planes[plane].length, write);
> >> 
> >> -		if (IS_ERR(mem_priv)) {
> >> +		if (IS_ERR_OR_NULL(mem_priv)) {
> >> 
> >>  			dprintk(1, "qbuf: failed to attach dmabuf\n");
> >> 
> >> -			fail_memop(vb, attach_dmabuf);
> >> -			ret = PTR_ERR(mem_priv);
> >> +			ret = mem_priv ? PTR_ERR(mem_priv) : -EINVAL;
> > 
> > That gets confusing. Wouldn't it be better to switch the other memop calls
> > that return pointers to return an ERR_PTR() in error cases instead of NULL
> > ?
>
> I don't see why it is confusing as long as everyone sticks to the same
> scheme.

Because that would be mixing two schemes. For one thing, the -EINVAL error 
code above is arbitrary. The construct is also confusing, and it would be easy 
to write

	if (IS_ERR_OR_NULL(foo)) {
		...
		ret = PTR_ERR(foo);
		...

which would return success even though an error occurs. That error will be 
more difficult to debug than accepting a NULL pointer by mistake, which would 
result in an oops pretty soon.

> I actually prefer this way, since it is more robust as it will catch cases
> where the memop unintentionally returned NULL. If I would just check for
> IS_ERR, then that would be missed. Especially in a core piece of code like
> this I'd like to err on the robust side.

You can always add a WARN_ON(mem_priv == NULL) if you really want to catch 
that.

> >>  			dma_buf_put(dbuf);
> >>  			goto err;
> >>  		
> >>  		}

-- 
Regards,

Laurent Pinchart

