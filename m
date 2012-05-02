Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60115 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2EBXiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 19:38:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com,
	Mike Isely <isely@pobox.com>
Subject: Re: [RFC v3 2/2] v4l: Implement compat functions for enum to __u32 change
Date: Thu, 03 May 2012 01:38:42 +0200
Message-ID: <5025043.7iaR9beiqz@avalon>
In-Reply-To: <4FA1B5F7.8050608@redhat.com>
References: <20120502191324.GE852@valkosipuli.localdomain> <1335986028-23618-2-git-send-email-sakari.ailus@iki.fi> <4FA1B5F7.8050608@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 02 May 2012 19:32:23 Mauro Carvalho Chehab wrote:
> Em 02-05-2012 16:13, Sakari Ailus escreveu:
> > Implement compat functions to provide conversion between structs
> > containing enums and those not. The functions are intended to be removed
> > when the support for such old binaries is no longer necessary.
> 
> This is not a full review of this patch, as checking the full logic
> will consume some time.
> 
> This is just a few points to consider.

[snip]

> > -video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
> > +video_usercopy(struct file *file, unsigned int compat_cmd, unsigned long
> > arg,> 
> >  	       v4l2_kioctl func)
> >  
> >  {
> >  
> >  	char	sbuf[128];
> > 
> > @@ -2401,6 +3048,7 @@ video_usercopy(struct file *file, unsigned int cmd,
> > unsigned long arg,> 
> >  	size_t  array_size = 0;
> >  	void __user *user_ptr = NULL;
> >  	void	**kernel_ptr = NULL;
> > 
> > +	unsigned int cmd = get_non_compat_cmd(compat_cmd);
> 
> This will put a penalty on archs where sizeof(u32) == sizeof(enum), with
> covers most of the cases.
> 
> My suggestion is to, instead, call it at the end of  __video_do_ioctl, at
> the "default" clause, with a recursive call to __video_do_ioctl().

Would that work for "has_array_args" ioctls ? video_usercopy() won't copy the 
array. The compat code could possibly handle that though.

What about making get_non_compat_cmd() return its argument directly when 
sizeof(__u32) == sizeof(enum) ? The performance impact should be negligible.

> It should be noticed that UVC driver and pvrusb2 are the only two drivers
> that don't use __video_do_ioctl(). So, a logic similar to it should be
> implemented there.
> 
> >  	/*  Copy arguments into temp kernel buffer  */
> >  	if (_IOC_DIR(cmd) != _IOC_NONE) {
> > 
> > @@ -2418,12 +3066,23 @@ video_usercopy(struct file *file, unsigned int
> > cmd, unsigned long arg,> 
> >  		if (_IOC_DIR(cmd) & _IOC_WRITE) {
> >  		
> >  			unsigned long n = cmd_input_size(cmd);
> > 
> > -			if (copy_from_user(parg, (void __user *)arg, n))
> > -				goto out;
> > -
> > -			/* zero out anything we don't copy from userspace */
> > -			if (n < _IOC_SIZE(cmd))
> > -				memset((u8 *)parg + n, 0, _IOC_SIZE(cmd) - n);
> > +			if (cmd == compat_cmd) {
> > +				if (copy_from_user(
> > +					    parg, (void __user *)arg, n))
> > +					goto out;
> > +
> > +				/*
> > +				 * zero out anything we don't copy
> > +				 * from userspace
> > +				 */
> > +				if (n < _IOC_SIZE(cmd))
> > +					memset((u8 *)parg + n, 0,
> > +					       _IOC_SIZE(cmd) - n);
> > +			} else {
> > +				if (copy_compat_from_user(compat_cmd, parg,
> > +							  (void __user *)arg))
> > +					goto out;
> > +			}
> > 
> >  		} else {
> >  		
> >  			/* read-only ioctl */
> >  			memset(parg, 0, _IOC_SIZE(cmd));
> > 
> > @@ -2471,8 +3130,15 @@ out_array_args:
> >  	switch (_IOC_DIR(cmd)) {
> >  	case _IOC_READ:
> > 
> >  	case (_IOC_WRITE | _IOC_READ):
> > -		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
> > -			err = -EFAULT;
> > +		if (cmd == compat_cmd) {
> > +			if (copy_to_user((void __user *)arg, parg,
> > +					 _IOC_SIZE(cmd)))
> > +				err = -EFAULT;
> > +		} else {
> > +			if (copy_compat_to_user(compat_cmd, (void __user *)arg,
> > +						parg))
> > +				err = -EFAULT;
> > +		}
> > 
> >  		break;
> >  	
> >  	}

-- 
Regards,

Laurent Pinchart

