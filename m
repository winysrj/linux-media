Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45052 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbeCUKEM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 06:04:12 -0400
Date: Wed, 21 Mar 2018 13:03:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Yavuz, Tuba" <tuba@ece.ufl.edu>,
        Antoine Jacquet <royale@zerezo.com>
Cc: "security@kernel.org" <security@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: Double-free in /drivers/media/usb/zr364xx driver
Message-ID: <20180321100346.rcjqgy52brzebmvl@mwanda>
References: <1521556244925.19981@ece.ufl.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1521556244925.19981@ece.ufl.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linux Media Devs,

There is a double free on error in zr364xx_probe().  The bug report
explains it pretty well.  v4l2_device_unregister() calls
zr364xx_release() which frees "cam" but we also to another kfree(cam);
before the "return err;".

Please give reported by credit to:

Reported-by: "Yavuz, Tuba" <tuba@ece.ufl.edu>

regards,
dan carpenter

On Tue, Mar 20, 2018 at 02:30:45PM +0000, Yavuz, Tuba wrote:
> Hello,
> 
> 
> It looks like there is a double-free on an error path in the zr364xx_probe function of the zr364xx driver.
> 
> fail:
>     v4l2_ctrl_handler_free(hdl);
>     v4l2_device_unregister(&cam->v4l2_dev);
>     =>
>         v4l2_device_disconnect
>        =>
>           put_device
>           =>
>               kobject_put
>               =>
>                   kref_put
>                   =>
>                       v4l2_device_release
>                       =>
>                           zr364xx_release (CALLBACK)
>                           =>
>                              kfree(cam)
>     kfree(cam);
> 
> The vulnerability exists since the initial commit<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/media/usb/zr364xx?id=0aa77f6c2954896b132f8b6f2e9f063c52800913> 0aa77f6c2954896b132f8b6f2e9f063c52800913 of the driver.
> 
> 
> Best,
> 
> Tuba Yavuz, Ph.D.
> Assistant Professor
> Electrical and Computer Engineering Department
> University of Florida
> Gainesville, FL 32611
> Webpage: http://www.tuba.ece.ufl.edu/
> Email: tuba@ece.ufl.edu
> Phone: (352) 846 0202
