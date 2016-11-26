Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18291 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbcKZJ5o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Nov 2016 04:57:44 -0500
Date: Sat, 26 Nov 2016 12:57:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sean@mess.org
Cc: linux-media@vger.kernel.org
Subject: [bug report] [media] lirc: prevent use-after free
Message-ID: <20161126095717.GA3150@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sean Young,

The patch afbb110172b9: "[media] lirc: prevent use-after free" from
Oct 31, 2016, leads to the following static checker warning:

	drivers/media/rc/lirc_dev.c:190 lirc_cdev_add()
	error: potential null dereference 'cdev'.  (cdev_alloc returns null)

drivers/media/rc/lirc_dev.c
   158  static int lirc_cdev_add(struct irctl *ir)
   159  {
   160          int retval = -ENOMEM;
   161          struct lirc_driver *d = &ir->d;
   162          struct cdev *cdev;
   163  
   164          cdev = cdev_alloc();
   165          if (!cdev)
   166                  goto err_out;

Classic one err bug.  Just return directly here.  return -ENOMEM is 100%
readable but goto err_out is opaque because you first have to scroll
down to see what err_out does then you have to scroll to the start of
the function to verify that retval is set.

   167  
   168          if (d->fops) {
   169                  cdev->ops = d->fops;
   170                  cdev->owner = d->owner;
   171          } else {
   172                  cdev->ops = &lirc_dev_fops;
   173                  cdev->owner = THIS_MODULE;
   174          }
   175          retval = kobject_set_name(&cdev->kobj, "lirc%d", d->minor);
   176          if (retval)
   177                  goto err_out;
   178  
   179          retval = cdev_add(cdev, MKDEV(MAJOR(lirc_base_dev), d->minor), 1);
   180          if (retval) {
   181                  kobject_put(&cdev->kobj);

This is a double free, isn't it?  It should just be goto del_cdev;

   182                  goto err_out;
   183          }
   184  
   185          ir->cdev = cdev;
   186  
   187          return 0;
   188  
   189  err_out:
   190          cdev_del(cdev);

Can't pass NULLs to this function.

   191          return retval;
   192  }

regards,
dan carpenter
