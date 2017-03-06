Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59932
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753315AbdCFLPV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 06:15:21 -0500
Date: Mon, 6 Mar 2017 08:14:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Sims <jonathan.625266@earthlink.net>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, kpyle@austin.rr.com, ryleyjangus@gmail.com
Subject: Re: [PATCH 1/1] hdpvr: code cleanup
Message-ID: <20170306081424.59bc59c0@vento.lan>
In-Reply-To: <20170214201832.7a418b5a@earthlink.net>
References: <20170214201832.7a418b5a@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Feb 2017 20:18:32 -0500
Jonathan Sims <jonathan.625266@earthlink.net> escreveu:

> This is a code cleanup after recent changes introduced by commit a503ff812430e104f591287b512aa4e3a83f20b1.

Patch doesn't apply:

patch -p1 -i patches/lmml_39419_1_1_hdpvr_code_cleanup.patch --dry-run -t -N
checking file drivers/media/usb/hdpvr/hdpvr-video.c
patch: **** malformed patch at line 35: __user *buffer, size_t count, goto err;

Patch may be line wrapped
checking file drivers/media/usb/hdpvr/hdpvr-video.c
patch: **** unexpected end of file in patch


Your e-mailer is breaking long lines, causing it to not work.

Please either configure your e-mailer to not wrap long lines or
use git to send it.


> 
> Signed-off-by: Jonathan Sims <jonathan.625266@earthlink.net>
> ---
> 
>  drivers/media/usb/hdpvr/hdpvr-video.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index 7fb036d6a86e..b2ce5c0807fb 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -449,7 +449,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
>  
>  		if (buf->status != BUFSTAT_READY &&
>  		    dev->status != STATUS_DISCONNECTED) {
> -			int err;
> +
>  			/* return nonblocking */
>  			if (file->f_flags & O_NONBLOCK) {
>  				if (!ret)
> @@ -457,23 +457,19 @@ static ssize_t hdpvr_read(struct file *file, char
> __user *buffer, size_t count, goto err;
>  			}
>  
> -			err =
> wait_event_interruptible_timeout(dev->wait_data,
> +			ret =
> wait_event_interruptible_timeout(dev->wait_data, buf->status ==
> BUFSTAT_READY, msecs_to_jiffies(1000));
> -			if (err < 0) {
> -				ret = err;
> +			if (ret < 0)
>  				goto err;
> -			}
> -			if (!err) {
> +			if (!ret) {
>  				v4l2_dbg(MSG_INFO, hdpvr_debug,
> &dev->v4l2_dev, "timeout: restart streaming\n");
>  				hdpvr_stop_streaming(dev);
> -				msecs_to_jiffies(4000);
> -				err = hdpvr_start_streaming(dev);
> -				if (err) {
> -					ret = err;
> +				msleep(4000);
> +				ret = hdpvr_start_streaming(dev);
> +				if (ret)
>  					goto err;
> -				}
>  			}
>  		}
>  



Thanks,
Mauro
