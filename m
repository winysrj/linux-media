Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37511 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbdCHJmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 04:42:33 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Shaohua Li <shli@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net"
        <linux1394-devel@lists.sourceforge.net>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: RE: [PATCH 08/29] drivers, md: convert mddev.active from atomic_t
 to refcount_t
Date: Wed, 8 Mar 2017 09:42:09 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C5606B@IRSMSX102.ger.corp.intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-9-git-send-email-elena.reshetova@intel.com>
 <20170307190449.baceyzzngsz776x7@kernel.org>
In-Reply-To: <20170307190449.baceyzzngsz776x7@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Mon, Mar 06, 2017 at 04:20:55PM +0200, Elena Reshetova wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> 
> Looks good. Let me know how do you want to route the patch to upstream.

Greg, you previously mentioned that driver's conversions can go via your tree. Does this still apply?
Or should I be asking maintainers to merge these patches via their trees? 
I am not sure about the correct (and easier for everyone) way, please suggest.  

Best Regards,
Elena.
> 
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > ---
> >  drivers/md/md.c | 6 +++---
> >  drivers/md/md.h | 3 ++-
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 985374f..94c8ebf 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -449,7 +449,7 @@ EXPORT_SYMBOL(md_unplug);
> >
> >  static inline struct mddev *mddev_get(struct mddev *mddev)
> >  {
> > -	atomic_inc(&mddev->active);
> > +	refcount_inc(&mddev->active);
> >  	return mddev;
> >  }
> >
> > @@ -459,7 +459,7 @@ static void mddev_put(struct mddev *mddev)
> >  {
> >  	struct bio_set *bs = NULL;
> >
> > -	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
> > +	if (!refcount_dec_and_lock(&mddev->active, &all_mddevs_lock))
> >  		return;
> >  	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
> >  	    mddev->ctime == 0 && !mddev->hold_active) {
> > @@ -495,7 +495,7 @@ void mddev_init(struct mddev *mddev)
> >  	INIT_LIST_HEAD(&mddev->all_mddevs);
> >  	setup_timer(&mddev->safemode_timer, md_safemode_timeout,
> >  		    (unsigned long) mddev);
> > -	atomic_set(&mddev->active, 1);
> > +	refcount_set(&mddev->active, 1);
> >  	atomic_set(&mddev->openers, 0);
> >  	atomic_set(&mddev->active_io, 0);
> >  	spin_lock_init(&mddev->lock);
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index b8859cb..4811663 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -22,6 +22,7 @@
> >  #include <linux/list.h>
> >  #include <linux/mm.h>
> >  #include <linux/mutex.h>
> > +#include <linux/refcount.h>
> >  #include <linux/timer.h>
> >  #include <linux/wait.h>
> >  #include <linux/workqueue.h>
> > @@ -360,7 +361,7 @@ struct mddev {
> >  	 */
> >  	struct mutex			open_mutex;
> >  	struct mutex			reconfig_mutex;
> > -	atomic_t			active;
> 	/* general refcount */
> > +	refcount_t			active;
> 	/* general refcount */
> >  	atomic_t			openers;	/*
> number of active opens */
> >
> >  	int
> 	changed;	/* True if we might need to
> > --
> > 2.7.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
