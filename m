Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56952 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2HGQKX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 12:10:23 -0400
Date: Tue, 7 Aug 2012 13:10:14 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Douglas Bagnall <douglas@paradise.net.nz>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [3.0.y+] [media] Avoid sysfs oops when an rc_dev's raw device is
 absent
Message-ID: <20120807161013.GC3922@herton-Z68MA-D2H-B3>
References: <20120806173851.GE2979@herton-Z68MA-D2H-B3>
 <1344304698.13142.154.camel@deadeye.wl.decadent.org.uk>
 <5020CAB4.2080607@paradise.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5020CAB4.2080607@paradise.net.nz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 07, 2012 at 07:58:44PM +1200, Douglas Bagnall wrote:
> Ben Hutchings wrote: 
> > This returns without unlocking dev->lock, which isn't much of an
> > improvement.  Please get that fixed in mainline, and then I can apply
> > both of the changes to 3.2.y at once.

Thanks for reviewing it Ben.

> 
> Oh dear. Quite right. Sorry. Thanks.
> 
> Douglas

> From c1d4df58efb2d13551586d177bcbb4e9af588618 Mon Sep 17 00:00:00 2001
> From: Douglas Bagnall <douglas@paradise.net.nz>
> Date: Tue, 7 Aug 2012 19:30:36 +1200
> Subject: [PATCH] Unlock the rc_dev lock when the raw device is missing
> 
> As pointed out by Ben Hutchings, after commit 720bb6436, the lock was
> being taken and not released when an rc_dev has a NULL raw device.
> 
> Signed-off-by: Douglas Bagnall <douglas@paradise.net.nz>

As it's desired for stable, this could also have
"Cc: stable@vger.kernel.org" when applied, so it's picked up
"automatically" when lands in mainline. Also nitpicking some more,
may be the patch could have a Reported-by line added.

Acked-by: Herton R. Krzesinski <herton.krzesinski@canonical.com>

> ---
>  drivers/media/rc/rc-main.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index cabc19c..dcd45d0 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -778,9 +778,10 @@ static ssize_t show_protocols(struct device *device,
>  	} else if (dev->raw) {
>  		enabled = dev->raw->enabled_protocols;
>  		allowed = ir_raw_get_allowed_protocols();
> -	} else
> +	} else {
> +		mutex_unlock(&dev->lock);
>  		return -ENODEV;
> -
> +	}
>  	IR_dprintk(1, "allowed - 0x%llx, enabled - 0x%llx\n",
>  		   (long long)allowed,
>  		   (long long)enabled);
> -- 
> 1.7.9.5
> 


-- 
[]'s
Herton
