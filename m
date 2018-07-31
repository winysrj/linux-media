Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:45074 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbeGaJZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 05:25:23 -0400
Date: Tue, 31 Jul 2018 10:46:18 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Satendra Singh Thakur <satendra.t@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, vineet.j@samsung.com,
        hemanshu.s@samsung.com, sst2005@gmail.com
Subject: Re: [PATCH] videobuf2/vb2_buffer_done: Changing the position of
 spinlock to protect only the required code
Message-ID: <20180731074618.ef6n7qulhlhoqwxb@paasikivi.fi.intel.com>
References: <CGME20180727082146epcas5p10374c04f0767dbbe409c8171c49d7c9a@epcas5p1.samsung.com>
 <20180727082146epcas5p10374c04f0767dbbe409c8171c49d7c9a~FLBKL7utW2249922499epcas5p1c@epcas5p1.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180727082146epcas5p10374c04f0767dbbe409c8171c49d7c9a~FLBKL7utW2249922499epcas5p1c@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satendra,

Thanks for the patch.

On Fri, Jul 27, 2018 at 01:51:36PM +0530, Satendra Singh Thakur wrote:
> 1.Currently, in the func vb2_buffer_done, spinlock protects
> following code
> vb->state = VB2_BUF_STATE_QUEUED;
> list_add_tail(&vb->done_entry, &q->done_list);
> spin_unlock_irqrestore(&q->done_lock, flags);
> vb->state = state;
> atomic_dec(&q->owned_by_drv_count);
> 2.The spinlock is mainly needed to protect list related ops and
> vb->state = STATE_ERROR or STATE_DONE as in other funcs
> vb2_discard_done
> __vb2_get_done_vb
> vb2_core_poll.
> 3. Therefore, spinlock is mainly needed for
>    list_add, list_del, list_first_entry ops
>    and state = STATE_DONE and STATE_ERROR to protect
>    done_list queue.
> 3. Hence, state = STATE_QUEUED doesn't need spinlock protection.
> 4. Also atomic_dec dones't require the same as its already atomic.
> 
> Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index f32ec73..968b403 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -923,17 +923,17 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
>  	}
>  
> -	spin_lock_irqsave(&q->done_lock, flags);
>  	if (state == VB2_BUF_STATE_QUEUED ||
>  	    state == VB2_BUF_STATE_REQUEUEING) {
>  		vb->state = VB2_BUF_STATE_QUEUED;
>  	} else {

You could move flags here as well. I wonder what others think.

>  		/* Add the buffer to the done buffers list */
> +		spin_lock_irqsave(&q->done_lock, flags);
>  		list_add_tail(&vb->done_entry, &q->done_list);
>  		vb->state = state;

The state could be assigned without holding the lock here.

> +		spin_unlock_irqrestore(&q->done_lock, flags);
>  	}
>  	atomic_dec(&q->owned_by_drv_count);
> -	spin_unlock_irqrestore(&q->done_lock, flags);
>  
>  	trace_vb2_buf_done(q, vb);
>  

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
