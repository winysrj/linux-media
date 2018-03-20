Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbeCTO6U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 10:58:20 -0400
Date: Tue, 20 Mar 2018 17:57:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Yavuz, Tuba" <tuba@ece.ufl.edu>
Cc: "security@kernel.org" <security@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: Double-free in /drivers/media/usb/hackrf driver
Message-ID: <20180320145752.h22fsawasmnigzmj@mwanda>
References: <1521553696964.462@ece.ufl.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1521553696964.462@ece.ufl.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linux Media Devs,

This is similar to the one before.  Please give reported-by credit to
Reported-by: "Yavuz, Tuba" <tuba@ece.ufl.edu>
Or maybe flip the names around?

The hackrf_probe() function has a double free on error after we set up:
	dev->v4l2_dev.release = hackrf_video_release;
then the calls to:
	video_unregister_device(&dev->rx_vdev);
and
	kfree(dev);
are a double free.

regards,
dan carpenter

On Tue, Mar 20, 2018 at 01:48:17PM +0000, Yavuz, Tuba wrote:
> Hello,
> 
> 
> It looks like there is a double-free vulnerability on an error path in the hackrf_probe function of the hackrf driver.
> 
> err_video_unregister_device_rx:
>        video_unregister_device(&dev->rx_vdev);
>        =>
>           v4l2_device_disconnect
>           =>
>               put_device
>               =>
>                  kobject_put
>                  =>
>                     kref_put
>                      =>
>                         v4l2_device_release
>                         =>
>                             hackrf_video_release (CALLBACK)
>                             =>
>                                 kfree(dev)
> ...
> err_kfree:
>     kfree(dev);
> 
> The vulnerability has been introduced with commit 8bc4a9ed85046c214458c9e82aea75d2f46cfffd, which added support for transmitter<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/media/usb/hackrf?id=8bc4a9ed85046c214458c9e82aea75d2f46cfffd>.
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
