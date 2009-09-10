Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbZIJTFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 15:05:35 -0400
Date: Thu, 10 Sep 2009 15:05:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: iceberg <strakh@ispras.ru>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix lock imbalances in /drivers/media/video/cafe_ccic.c
Message-ID: <20090910190537.GA10904@goodmis.org>
References: <200909101837.34472.strakh@ispras.ru>
 <20090910093003.194c300f@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910093003.194c300f@bike.lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 09:30:03AM -0600, Jonathan Corbet wrote:
> On Thu, 10 Sep 2009 18:37:34 +0000
> iceberg <strakh@ispras.ru> wrote:
> 
> > In ./drivers/media/video/cafe_ccic.c, in function cafe_pci_probe: 
> > Mutex must be unlocked before exit
> > 	1. On paths starting with mutex lock in line 1912, then continuing in lines: 
> > 1929, 1936 (goto unreg) and 1940 (goto iounmap) . 
> > 	2. On path starting in line 1971 mutex lock, and then continuing in line 1978 
> > (goto out_smbus) mutex.
> 
> That's a definite bug, but I hate all those unlocks in the error
> branches.  As it happens, we don't really need the mutex until the
> device has been exposed to the rest of the kernel, so I propose the
> following as a better patch.
> 
> Thanks for pointing this out,

Actually, for something like this, I would put the mutex_unlock in the error path,
and just add a local variable to tell that it is locked.

	int is_locked = 0;

[...]

	mutex_lock(&cam->s_mutex);
	is_locked = 1;

[...]

	mutex_unlock(&cam->s_mutex);
	is_locked = 0;

[...]

out_iounmap:
	pci_iounmap(pdev, cam->regs);
	if (is_locked)
		mutex_unlock(&cam->s_mutex);
out_free:

[...]

Or something similar. I hate the multiple unlocks too.

-- Steve

> 
> jon
> 
> ---
> Fix a mutex leak
> 
> Certain error exits from cafe_pci_probe() can leave the camera mutex
> locked.  For much of the time, we didn't need the mutex anyway; take it out
> and add an unlock in the path where it is needed.
> 
> Reported-by: Alexander Strakh <strakh@ispras.ru>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/cafe_ccic.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
> index c4d181d..0f62b5e 100644
> --- a/drivers/media/video/cafe_ccic.c
> +++ b/drivers/media/video/cafe_ccic.c
> @@ -1909,7 +1909,6 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  		goto out_free;
>  
>  	mutex_init(&cam->s_mutex);
> -	mutex_lock(&cam->s_mutex);
>  	spin_lock_init(&cam->dev_lock);
>  	cam->state = S_NOTREADY;
>  	cafe_set_config_needed(cam, 1);
> @@ -1949,7 +1948,6 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  	 * because the sensor could attach in this call chain, leading to
>  	 * unsightly deadlocks.
>  	 */
> -	mutex_unlock(&cam->s_mutex);  /* attach can deadlock */
>  	ret = cafe_smbus_setup(cam);
>  	if (ret)
>  		goto out_freeirq;
> @@ -1991,6 +1989,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  out_smbus:
> +	mutex_unlock(&cam->s_mutex);
>  	cafe_smbus_shutdown(cam);
>  out_freeirq:
>  	cafe_ctlr_power_down(cam);
> -- 
> 1.6.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
