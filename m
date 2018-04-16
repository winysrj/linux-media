Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54569 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753638AbeDPUJN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 16:09:13 -0400
Date: Mon, 16 Apr 2018 23:09:09 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Daniel Mentz <danielmentz@google.com>
Subject: Re: [PATCH] media: v4l2-compat-ioctl32: better name userspace
 pointers
Message-ID: <20180416200909.h6d3okivaltjkuhg@kekkonen.localdomain>
References: <eb0a0899d1763de662cd5d58257d2f29a14f501b.1523891464.git.mchehab@s-opensource.com>
 <e5681686-a9f5-132c-7770-5019df0b794d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5681686-a9f5-132c-7770-5019df0b794d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 16, 2018 at 06:00:12PM +0200, Hans Verkuil wrote:
> On 04/16/2018 05:11 PM, Mauro Carvalho Chehab wrote:
> > In the past, "up" were an acronym for "user pointer" and "kp" for
> > "kernel pointer". However, since a1dfb4c48cc1 ("media:
> > v4l2-compat-ioctl32.c: refactor compat ioctl32 logic"), both
> > are now __user pointers.
> > 
> > So, the usage of "kp" is really misleading there. So, rename
> > both to just "p32" and "p64" everywhere it occurs, in order to
> > make peace with this file's namespace.
> > 
> > There are two exceptions to "up/kp" nomenclature: at
> > alloc_userspace() and at do_video_ioctl().
> > 
> > There, a new userspace pointer were allocated, in order to store
> > the 64 bits version of the ioctl. Those were called as "up_native",
> > with is, IMHO, an even worse name, as "native" could mislead of
> > being the arguments that were filled from userspace. I almost
> > renamed it to just "p64", but, after thinking more about that,
> > it sounded better to call it as "new_p64", as this makes clearer
> > that this is the data structure that was allocated inside this
> > file in order to be used to pass/retrieve data when calling the
> > 64-bit ready file->f_op->unlocked_ioctl() function.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 578 +++++++++++++-------------
> >  1 file changed, 289 insertions(+), 289 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > index 5c3408bdfd89..064e4a2bdba3 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> 
> <snip>
> 
> > @@ -392,31 +392,31 @@ struct v4l2_buffer32 {
> >  	__u32			reserved;
> >  };
> >  
> > -static int get_v4l2_plane32(struct v4l2_plane __user *up,
> > +static int get_v4l2_plane32(struct v4l2_plane __user *p32,
> >  			    struct v4l2_plane32 __user *up32,
> 
> This is confusing: there is now a p32 and a up32 pointer. In all
> fairness, this was already confusing. In this specific case 'up' should
> be 'p64' and 'up32' should be 'p32'.
> 
> >  			    enum v4l2_memory memory)
> >  {
> >  	compat_ulong_t p;
> >  
> > -	if (copy_in_user(up, up32, 2 * sizeof(__u32)) ||
> > -	    copy_in_user(&up->data_offset, &up32->data_offset,
> > -			 sizeof(up->data_offset)))
> > +	if (copy_in_user(p32, up32, 2 * sizeof(__u32)) ||
> > +	    copy_in_user(&p32->data_offset, &up32->data_offset,
> > +			 sizeof(p32->data_offset)))
> >  		return -EFAULT;
> >  
> >  	switch (memory) {
> >  	case V4L2_MEMORY_MMAP:
> >  	case V4L2_MEMORY_OVERLAY:
> > -		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
> > +		if (copy_in_user(&p32->m.mem_offset, &up32->m.mem_offset,
> >  				 sizeof(up32->m.mem_offset)))
> >  			return -EFAULT;
> >  		break;
> >  	case V4L2_MEMORY_USERPTR:
> >  		if (get_user(p, &up32->m.userptr) ||
> > -		    put_user((unsigned long)compat_ptr(p), &up->m.userptr))
> > +		    put_user((unsigned long)compat_ptr(p), &p32->m.userptr))
> >  			return -EFAULT;
> >  		break;
> >  	case V4L2_MEMORY_DMABUF:
> > -		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(up32->m.fd)))
> > +		if (copy_in_user(&p32->m.fd, &up32->m.fd, sizeof(up32->m.fd)))
> >  			return -EFAULT;
> >  		break;
> >  	}
> > @@ -424,32 +424,32 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up,
> >  	return 0;
> >  }
> >  
> > -static int put_v4l2_plane32(struct v4l2_plane __user *up,
> > +static int put_v4l2_plane32(struct v4l2_plane __user *p32,
> >  			    struct v4l2_plane32 __user *up32,
> >  			    enum v4l2_memory memory)
> 
> Same here. up -> p64 and up32 -> p32.
> 
> >  {
> >  	unsigned long p;
> >  
> > -	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
> > -	    copy_in_user(&up32->data_offset, &up->data_offset,
> > -			 sizeof(up->data_offset)))
> > +	if (copy_in_user(up32, p32, 2 * sizeof(__u32)) ||
> > +	    copy_in_user(&up32->data_offset, &p32->data_offset,
> > +			 sizeof(p32->data_offset)))
> >  		return -EFAULT;
> >  
> >  	switch (memory) {
> >  	case V4L2_MEMORY_MMAP:
> >  	case V4L2_MEMORY_OVERLAY:
> > -		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
> > -				 sizeof(up->m.mem_offset)))
> > +		if (copy_in_user(&up32->m.mem_offset, &p32->m.mem_offset,
> > +				 sizeof(p32->m.mem_offset)))
> >  			return -EFAULT;
> >  		break;
> >  	case V4L2_MEMORY_USERPTR:
> > -		if (get_user(p, &up->m.userptr)||
> > +		if (get_user(p, &p32->m.userptr)||
> >  		    put_user((compat_ulong_t)ptr_to_compat((void __user *)p),
> >  			     &up32->m.userptr))
> >  			return -EFAULT;
> >  		break;
> >  	case V4L2_MEMORY_DMABUF:
> > -		if (copy_in_user(&up32->m.fd, &up->m.fd, sizeof(up->m.fd)))
> > +		if (copy_in_user(&up32->m.fd, &p32->m.fd, sizeof(p32->m.fd)))
> >  			return -EFAULT;
> >  		break;
> >  	}
> > @@ -457,14 +457,14 @@ static int put_v4l2_plane32(struct v4l2_plane __user *up,
> >  	return 0;
> >  }
> >  
> 
> After fixing these two functions you can add my:
> 
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> One note: this patch does not update variables like uplane and [ku]controls. But
> I think it would be better to change those in follow-up patches.
> 
> I really like the new p32/p64/new_p64 names. Much more descriptive.

With p32/p64 naming,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
