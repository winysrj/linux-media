Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39613 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751055AbcKZL0R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 06:26:17 -0500
Date: Sat, 26 Nov 2016 11:26:14 +0000
From: Sean Young <sean@mess.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [bug report] [media] lirc: prevent use-after free
Message-ID: <20161126112614.GA18806@gofer.mess.org>
References: <20161126095717.GA3150@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161126095717.GA3150@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Sat, Nov 26, 2016 at 12:57:17PM +0300, Dan Carpenter wrote:
> Hello Sean Young,
> 
> The patch afbb110172b9: "[media] lirc: prevent use-after free" from
> Oct 31, 2016, leads to the following static checker warning:
> 
> 	drivers/media/rc/lirc_dev.c:190 lirc_cdev_add()
> 	error: potential null dereference 'cdev'.  (cdev_alloc returns null)
> 
> drivers/media/rc/lirc_dev.c
>    158  static int lirc_cdev_add(struct irctl *ir)
>    159  {
>    160          int retval = -ENOMEM;
>    161          struct lirc_driver *d = &ir->d;
>    162          struct cdev *cdev;
>    163  
>    164          cdev = cdev_alloc();
>    165          if (!cdev)
>    166                  goto err_out;
> 
> Classic one err bug.  Just return directly here.  return -ENOMEM is 100%
> readable but goto err_out is opaque because you first have to scroll
> down to see what err_out does then you have to scroll to the start of
> the function to verify that retval is set.
> 
>    167  
>    168          if (d->fops) {
>    169                  cdev->ops = d->fops;
>    170                  cdev->owner = d->owner;
>    171          } else {
>    172                  cdev->ops = &lirc_dev_fops;
>    173                  cdev->owner = THIS_MODULE;
>    174          }
>    175          retval = kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
>    176          if (retval)
>    177                  goto err_out;
>    178  
>    179          retval = cdev_add(cdev, MKDEV(MAJOR(lirc_base_dev), d->minor), 1);
>    180          if (retval) {
>    181                  kobject_put(&cdev->kobj);
> 
> This is a double free, isn't it?  It should just be goto del_cdev;
> 
>    182                  goto err_out;
>    183          }
>    184  
>    185          ir->cdev = cdev;
>    186  
>    187          return 0;
>    188  
>    189  err_out:
>    190          cdev_del(cdev);
> 
> Can't pass NULLs to this function.
> 
>    191          return retval;
>    192  }

Oh dear! Thanks for reporting this, you're absolutely right. I'll send
out a patch shortly.

Thanks
Sean
