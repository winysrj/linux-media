Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40146 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751972AbdCHJmj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 04:42:39 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Shaohua Li <shli@kernel.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: RE: [PATCH 10/29] drivers, md: convert stripe_head.count from
 atomic_t to refcount_t
Date: Wed, 8 Mar 2017 09:39:30 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C56050@IRSMSX102.ger.corp.intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-11-git-send-email-elena.reshetova@intel.com>
 <20170307190759.jnrq66kfpkr4m7zl@kernel.org>
In-Reply-To: <20170307190759.jnrq66kfpkr4m7zl@kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Mon, Mar 06, 2017 at 04:20:57PM +0200, Elena Reshetova wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> >
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > ---
> >  drivers/md/raid5-cache.c |  8 +++---
> >  drivers/md/raid5.c       | 66 ++++++++++++++++++++++++------------------------
> >  drivers/md/raid5.h       |  3 ++-
> >  3 files changed, 39 insertions(+), 38 deletions(-)
> >
> > diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> > index 3f307be..6c05e12 100644
> > --- a/drivers/md/raid5-cache.c
> > +++ b/drivers/md/raid5-cache.c
> 
> snip
> >  	       sh->check_state, sh->reconstruct_state);
> >
> >  	analyse_stripe(sh, &s);
> > @@ -4924,7 +4924,7 @@ static void activate_bit_delay(struct r5conf *conf,
> >  		struct stripe_head *sh = list_entry(head.next, struct
> stripe_head, lru);
> >  		int hash;
> >  		list_del_init(&sh->lru);
> > -		atomic_inc(&sh->count);
> > +		refcount_inc(&sh->count);
> >  		hash = sh->hash_lock_index;
> >  		__release_stripe(conf, sh,
> &temp_inactive_list[hash]);
> >  	}
> > @@ -5240,7 +5240,7 @@ static struct stripe_head *__get_priority_stripe(struct
> r5conf *conf, int group)
> >  		sh->group = NULL;
> >  	}
> >  	list_del_init(&sh->lru);
> > -	BUG_ON(atomic_inc_return(&sh->count) != 1);
> > +	BUG_ON(refcount_inc_not_zero(&sh->count));
> 
> This changes the behavior. refcount_inc_not_zero doesn't inc if original value is 0

Hm.. So, you want to inc here in any case and BUG if the end result differs from 1. 
So essentially you want to only increment here from zero to one under normal conditions... This is a challenge for refcount_t and against the design.
Is it ok just to maybe do this here:

-	BUG_ON(atomic_inc_return(&sh->count) != 1);
+	BUG_ON(refcount_read(&sh->count) != 0);
+	refcount_set((&sh->count, 1);

Do we have an issue with locking in this case? Or maybe it is then better to leave this one to be atomic_t without protection since it isn't a real refcounter as it turns out. 

Best Regards,
Elena. 

> 
> Thanks,
> Shaohua
