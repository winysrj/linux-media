Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab3CRXt5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 19:49:57 -0400
Date: Mon, 18 Mar 2013 20:49:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: John Sheu <sheu@google.com>, linux-media@vger.kernel.org,
	John Sheu <sheu@chromium.org>
Subject: Re: [PATCH 3/3] dma-buf: restore args on failure of dma_buf_mmap
Message-ID: <20130318204948.6deeb166@redhat.com>
In-Reply-To: <511380F4.2070806@linaro.org>
References: <1360195382-32317-1-git-send-email-sheu@google.com>
	<1360195382-32317-3-git-send-email-sheu@google.com>
	<511380F4.2070806@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 07 Feb 2013 15:54:52 +0530
Sumit Semwal <sumit.semwal@linaro.org> escreveu:

> Hi John,
> 
> On Thursday 07 February 2013 05:33 AM, John Sheu wrote:
> > From: John Sheu <sheu@chromium.org>
> >
> > Callers to dma_buf_mmap expect to fput() the vma struct's vm_file
> > themselves on failure.  Not restoring the struct's data on failure
> > causes a double-decrement of the vm_file's refcount.
> Thanks for your patch; could you please re-send it to the correct, 
> relevant lists and me (as the maintainer of dma-buf) rather than just to 
> linux-media ml?

Yes, it doesn't make sense to apply this one via the media tree ;)

I'm applying patches 1 and 2, as they should go through the media tree.

Thanks!
Mauro
> 
> I just chanced to see this patch, otherwise it could easily have slipped 
> past me (and other interested parties).
> 
> You could run scripts/get_maintainer.pl on your patch to find out the 
> right lists / email IDs to CC.
> 
> Thanks and best regards,
> ~Sumit.
> >
> > Signed-off-by: John Sheu <sheu@google.com>
> > ---
> >   drivers/base/dma-buf.c | 18 ++++++++++++++----
> >   1 file changed, 14 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> > index a3f79c4..01daf9c 100644
> > --- a/drivers/base/dma-buf.c
> > +++ b/drivers/base/dma-buf.c
> > @@ -446,6 +446,9 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
> >   int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
> >   		 unsigned long pgoff)
> >   {
> > +	struct file *oldfile;
> > +	int ret;
> > +
> >   	if (WARN_ON(!dmabuf || !vma))
> >   		return -EINVAL;
> >
> > @@ -459,14 +462,21 @@ int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
> >   		return -EINVAL;
> >
> >   	/* readjust the vma */
> > -	if (vma->vm_file)
> > -		fput(vma->vm_file);
> > -
> > +	oldfile = vma->vm_file;
> >   	vma->vm_file = get_file(dmabuf->file);
> >
> >   	vma->vm_pgoff = pgoff;
> >
> > -	return dmabuf->ops->mmap(dmabuf, vma);
> > +	ret = dmabuf->ops->mmap(dmabuf, vma);
> > +	if (ret) {
> > +		/* restore old parameters on failure */
> > +		vma->vm_file = oldfile;
> > +		fput(dmabuf->file);
> > +	} else {
> > +		if (oldfile)
> > +			fput(oldfile);
> > +	}
> > +	return ret;
> >   }
> >   EXPORT_SYMBOL_GPL(dma_buf_mmap);
> >
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
