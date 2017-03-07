Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756048AbdCGTLU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Mar 2017 14:11:20 -0500
Date: Tue, 7 Mar 2017 11:04:49 -0800
From: Shaohua Li <shli@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: Re: [PATCH 08/29] drivers, md: convert mddev.active from atomic_t to
 refcount_t
Message-ID: <20170307190449.baceyzzngsz776x7@kernel.org>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-9-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488810076-3754-9-git-send-email-elena.reshetova@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 06, 2017 at 04:20:55PM +0200, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.

Looks good. Let me know how do you want to route the patch to upstream.
 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  drivers/md/md.c | 6 +++---
>  drivers/md/md.h | 3 ++-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 985374f..94c8ebf 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -449,7 +449,7 @@ EXPORT_SYMBOL(md_unplug);
>  
>  static inline struct mddev *mddev_get(struct mddev *mddev)
>  {
> -	atomic_inc(&mddev->active);
> +	refcount_inc(&mddev->active);
>  	return mddev;
>  }
>  
> @@ -459,7 +459,7 @@ static void mddev_put(struct mddev *mddev)
>  {
>  	struct bio_set *bs = NULL;
>  
> -	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
> +	if (!refcount_dec_and_lock(&mddev->active, &all_mddevs_lock))
>  		return;
>  	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
>  	    mddev->ctime == 0 && !mddev->hold_active) {
> @@ -495,7 +495,7 @@ void mddev_init(struct mddev *mddev)
>  	INIT_LIST_HEAD(&mddev->all_mddevs);
>  	setup_timer(&mddev->safemode_timer, md_safemode_timeout,
>  		    (unsigned long) mddev);
> -	atomic_set(&mddev->active, 1);
> +	refcount_set(&mddev->active, 1);
>  	atomic_set(&mddev->openers, 0);
>  	atomic_set(&mddev->active_io, 0);
>  	spin_lock_init(&mddev->lock);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b8859cb..4811663 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -22,6 +22,7 @@
>  #include <linux/list.h>
>  #include <linux/mm.h>
>  #include <linux/mutex.h>
> +#include <linux/refcount.h>
>  #include <linux/timer.h>
>  #include <linux/wait.h>
>  #include <linux/workqueue.h>
> @@ -360,7 +361,7 @@ struct mddev {
>  	 */
>  	struct mutex			open_mutex;
>  	struct mutex			reconfig_mutex;
> -	atomic_t			active;		/* general refcount */
> +	refcount_t			active;		/* general refcount */
>  	atomic_t			openers;	/* number of active opens */
>  
>  	int				changed;	/* True if we might need to
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
