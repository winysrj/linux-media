Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46087 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751398AbeDPR1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 13:27:06 -0400
Date: Mon, 16 Apr 2018 14:26:59 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: [PATCHv2 17/17] media: v4l2-compat-ioctl32: fix several __user
 annotations
Message-ID: <20180416142555.5c8e698d@vento.lan>
In-Reply-To: <15d2a218-ea3d-1732-acaa-2f4c189fabab@xs4all.nl>
References: <55ced09a79ad9947c73187bfbcf85fac220a6d27.1523546545.git.mchehab@s-opensource.com>
        <a9fa4b6baa0d4f2ae05f5a03acb7c593563049b5.1523642814.git.mchehab@s-opensource.com>
        <5c0bb6fe-3148-b5ad-7b78-2a425369c48d@xs4all.nl>
        <20180416115027.2fbca161@vento.lan>
        <15d2a218-ea3d-1732-acaa-2f4c189fabab@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> >>> @@ -898,7 +899,8 @@ static int put_v4l2_ext_controls32(struct file *file,
> >>>  		if (ctrl_is_pointer(file, id))
> >>>  			size -= sizeof(ucontrols->value64);
> >>>  
> >>> -		if (copy_in_user(ucontrols, kcontrols, size))
> >>> +		if (copy_in_user(ucontrols,
> >>> +			         (unsigned int __user *)kcontrols, size))    
> >>
> >> This is rather ugly. Would it be better to do something like this:
> >>
> >> 	struct v4l2_ext_control __user *kcontrols
> >> 	struct v4l2_ext_control *kcontrols_tmp;
> >>
> >> 	get_user(kcontrols_tmp, &kp->controls);
> >> 	kcontrols = (void __user __force *)kcontrols_tmp;  
> > 
> > Nah, having two pointers with the same value, one with __user and another
> > one without it will make it really hard for people to review.
> >   
> >>
> >> And then there is no need to change anything else.
> >>
> >> Regardless of the chosen solution, this needs comments to explain what is going
> >> on here, just as with v4l2_buffer above.  
> > 
> > Actually, the problem here happens before that. The problem
> > here (and on the previous one) is that get_user() expects that
> > the second argument to be a Kernelspace pointer.  
> 
> You mean the first argument? I'm actually not entirely sure if this is
> correct since __get_user calls __typeof__, but that might not know about
> __user. Anyway, it does not really matter for this patch and the uaccess.h
> code gives me a headache :-)

__typeof__ gets the type of the var, but __user is not a type. it is
something else (see include/linux/compiler_types.h):

	#ifdef __CHECKER__
	# define __user		__attribute__((noderef, address_space(1)))
	...
	#else /* __CHECKER__ */
	# ifdef STRUCTLEAK_PLUGIN
	#  define __user __attribute__((user))
	# else
	#  define __user
	# endif
	...
	#endif /* __CHECKER__ */

It is only built for sparse/smatch and uses __attribute__ definition,
with I guess __type_of__() won't parse.

Also, on almost all places where get_user() is called, what you expect
is to fill a Kernelspace var with something that came from userspace.

So, it expects that the first argument to be a pointer to an area
that is at Kernelspace.

> 
> > 
> > So, in this routine, it does (simplified):
> > 
> >         struct v4l2_ext_control32 __user *ucontrols;
> >         struct v4l2_ext_control *kcontrols;
> > 
> > ...
> > 	get_user(kcontrols, &kp->controls);
> > 
> > Then, every time it needs to get something related to it,
> > it needs the __user, like here:
> > 
> > 	if (get_user(id, (unsigned int __user *)&kcontrols->id)
> > 	...
> > 
> > In this specific case, only copy_in_user() was missing it; all the other
> > __user casts are there already.
> > 
> >   
> >> Note: the whole 'u<foo>' and 'k<foo>' naming is now hopelessly out of date and
> >> confusing. It should really be '<foo>32' and '<foo>64' to denote 32 bit vs
> >> 64 bit layout. The pointers are now always in userspace, so 'k<foo>' no longer
> >> makes sense.  
> > 
> > Yes, we need this change, but this should be at a separate patch.
> > 
> > I can do it, after we cleanup v4l2-compat-ioctl32.c from their namespace
> > mess.  
> 
> Of course, this is a separate patch.
> 
> > 
> >   
> >>  
> >>>  			return -EFAULT;
> >>>  
> >>>  		ucontrols++;
> >>> @@ -954,7 +956,7 @@ static int get_v4l2_edid32(struct v4l2_edid __user *kp,
> >>>  	    assign_in_user(&kp->start_block, &up->start_block) ||
> >>>  	    assign_in_user(&kp->blocks, &up->blocks) ||
> >>>  	    get_user(tmp, &up->edid) ||
> >>> -	    put_user(compat_ptr(tmp), &kp->edid) ||
> >>> +	    put_user((void __force *)compat_ptr(tmp), &kp->edid) ||
> >>>  	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
> >>>  		return -EFAULT;
> >>>  	return 0;
> >>> @@ -970,7 +972,7 @@ static int put_v4l2_edid32(struct v4l2_edid __user *kp,
> >>>  	    assign_in_user(&up->start_block, &kp->start_block) ||
> >>>  	    assign_in_user(&up->blocks, &kp->blocks) ||
> >>>  	    get_user(edid, &kp->edid) ||
> >>> -	    put_user(ptr_to_compat(edid), &up->edid) ||
> >>> +	    put_user(ptr_to_compat((void __user *)edid), &up->edid) ||
> >>>  	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)))
> >>>  		return -EFAULT;
> >>>  	return 0;
> >>>     
> >>
> >> Otherwise this patch looks good.
> >>
> >> Regards,
> >>
> >> 	Hans  
> > 
> > Would be ok if I fold (or add as a separate patch) the enclosed diff?
> > 
> > Thanks,
> > Mauro
> > 
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > index 1057ab8ce2b6..5c3408bdfd89 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > @@ -617,6 +617,15 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
> >  
> >  		if (num_planes == 0)
> >  			return 0;
> > +		/*
> > +		 * We needed to define uplane without user.
> > +		 * The reason is that v4l2-ioctl.c copies it from userspace
> > +		 * into Kernelspace, so it's definition at videodev2.h doesn't
> > +		 * have an __user markup. That makes get_user() to do wrong
> > +		 * casts, as pointed by smatch.
> > +		 * So, instead, declare it as ks, and pass it as an userspace
> > +		 * pointer to put_v4l2_plane32().
> > +		 */  
> 
> I would propose this text:
> 
> "We need to define uplane without __user, even though it does point
> to data in userspace here. The reason is that v4l2-ioctl.c copies it from
> userspace to kernelspace, so its definition in videodev2.h doesn't have a
> __user markup. Defining uplane with __user causes smatch warnings, so
> instead declare it without __user and cast it as a userspace pointer to
> put_v4l2_plane32()."
> 
> (yes, it's 'a user'. See https://ell.stackexchange.com/questions/26986/why-a-user-instead-of-an-user)
> 
> >  		if (get_user(uplane, &kp->m.planes))
> >  			return -EFAULT;
> >  		if (get_user(p, &up->m.planes))
> > @@ -861,6 +870,15 @@ static int put_v4l2_ext_controls32(struct file *file,
> >  	u32 n;
> >  	compat_caddr_t p;
> >  
> > +	/*
> > +	 * We needed to define kcontrols without user.
> > +	 * The reason is that v4l2-ioctl.c copies it from userspace
> > +	 * into Kernelspace, so it's definition at videodev2.h doesn't
> > +	 * have an __user markup. That makes get_user() & friends to do
> > +	 * wrong casts, as pointed by smatch.
> > +	 * So, instead, declare it as ks, and pass it as an userspace
> > +	 * pointer where needed.
> > +	 */  
> 
> "We need to define kcontrols without __user, even though it does point
> to data in userspace here. The reason is that v4l2-ioctl.c copies it from
> userspace to kernelspace, so its definition in videodev2.h doesn't have a
> __user markup. Defining kcontrols with __user causes smatch warnings, so
> instead declare it without __user and cast it as a userspace pointer where
> needed."

Works for me. I'll send patch 17/17 as a separate series, with the above
merged on the first patch.

Regards,
Mauro
