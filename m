Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48326 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S977705AbdDXUkd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 16:40:33 -0400
Date: Mon, 24 Apr 2017 23:39:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] vb2: Fix error handling in
 '__vb2_buf_mem_alloc'
Message-ID: <20170424203959.GX7456@valkosipuli.retiisi.org.uk>
References: <20170423214030.14854-1-christophe.jaillet@wanadoo.fr>
 <20170424142335.GR7456@valkosipuli.retiisi.org.uk>
 <030bab0d-0c5d-b65e-a7aa-54662bf42eb1@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <030bab0d-0c5d-b65e-a7aa-54662bf42eb1@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christophe,

On Mon, Apr 24, 2017 at 10:25:18PM +0200, Christophe JAILLET wrote:
> Le 24/04/2017 à 16:23, Sakari Ailus a écrit :
> >Hi Christophe,
> >
> >On Sun, Apr 23, 2017 at 11:40:30PM +0200, Christophe JAILLET wrote:
> >>'call_ptr_memop' can return NULL, so we must test its return value with
> >>'IS_ERR_OR_NULL'. Otherwise, the test 'if (mem_priv)' is meaningless.
> >>
> >>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >>---
> >>Note that error checking after 'call_ptr_memop' calls is not consistent
> >>in this file. I guess that 'IS_ERR_OR_NULL' should be used everywhere
> >>and that the corresponding error handling code should be tweaked just as
> >>the code in this function.
> >>---
> >>  drivers/media/v4l2-core/videobuf2-core.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> >>index c0175ea7e7ad..d1d3f5dd57b9 100644
> >>--- a/drivers/media/v4l2-core/videobuf2-core.c
> >>+++ b/drivers/media/v4l2-core/videobuf2-core.c
> >>@@ -210,7 +210,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> >>  		mem_priv = call_ptr_memop(vb, alloc,
> >>  				q->alloc_devs[plane] ? : q->dev,
> >>  				q->dma_attrs, size, dma_dir, q->gfp_flags);
> >>-		if (IS_ERR(mem_priv)) {
> >>+		if (IS_ERR_OR_NULL(mem_priv)) {
> >>  			if (mem_priv)
> >>  				ret = PTR_ERR(mem_priv);
> >>  			goto free;
> >If NULL will always equate -ENOMEM, shouldn't call_ptr_memop() be changed
> >instead to convert NULL to ERR_PTR(-ENOMEM)?
> >
> I agree with you, but in fact, I don't know if "NULL will always equate
> -ENOMEM"
> 
> The return value of 'call_ptr_memop' is likely the result of a function
> called via a function pointer. I don't know if this function can return NULL
> or not.
> I don't know the code enough to see if it would be safe and if this
> assertion is correct.
> 
> So the easiest for me is to just propose a fix to accept NULL.

Quite right. There actually seem to be a few callers that need NULL, e.g.
vb2_plane_vaddr().

Looking at the definition of call_ptr_memop():

#define call_ptr_memop(vb, op, args...)                                 \
        ((vb)->vb2_queue->mem_ops->op ?                                 \
                (vb)->vb2_queue->mem_ops->op(args) : NULL)

strongly suggests that the callers should expect that NULL is a possible
return value. I'd be a little surprised if that was an actual case right
now: it would require one of the ops not to be defined for a memtype. That
said, surprising things do happen as demonstrated by your previous patch.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
