Return-path: <linux-media-owner@vger.kernel.org>
Received: from microschulz.de ([79.140.41.212]:44252 "EHLO microschulz.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab2FWTBy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 15:01:54 -0400
Date: Sat, 23 Jun 2012 20:32:35 +0200
From: Nikolaus Schulz <mail@microschulz.de>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	viro@zeniv.linux.org.uk, kernel-janitors@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] dvb-core: Release semaphore on error path
 dvb_register_device().
Message-ID: <20120623183235.GA16700@zorro.zusammrottung.local>
References: <1340452794-8117-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340452794-8117-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC'ing stable@kernel.org, this bugfix applies to all kernels >> 2.6.28.

The patch should also be tagged accordingly.

On Sat, Jun 23, 2012 at 05:29:54PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> There is a missing "up_write()" here. Semaphore should be released
> before returning error value.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
> Destination tree "linux-next"
> 
>  drivers/media/dvb/dvb-core/dvbdev.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
> index 00a6732..39eab73 100644
> --- a/drivers/media/dvb/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb/dvb-core/dvbdev.c
> @@ -243,6 +243,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
>  	if (minor == MAX_DVB_MINORS) {
>  		kfree(dvbdevfops);
>  		kfree(dvbdev);
> +		up_write(&minor_rwsem);
>  		mutex_unlock(&dvbdev_register_lock);
>  		return -EINVAL;
>  	}
> -- 
> 1.7.4.4
