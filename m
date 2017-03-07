Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63147 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932848AbdCGOsw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Mar 2017 09:48:52 -0500
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
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
Subject: RE: [PATCH 13/29] drivers, media: convert
 vb2_vmarea_handler.refcount from atomic_t to refcount_t
Date: Tue, 7 Mar 2017 14:48:43 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C558E6@IRSMSX102.ger.corp.intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
 <1488810076-3754-14-git-send-email-elena.reshetova@intel.com>
 <20170307085005.GH3220@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170307085005.GH3220@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi Elena,
> 
> On Mon, Mar 06, 2017 at 04:21:00PM +0200, Elena Reshetova wrote:
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
> >  drivers/media/v4l2-core/videobuf2-memops.c | 6 +++---
> >  include/media/videobuf2-memops.h           | 3 ++-
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-
> core/videobuf2-memops.c
> > index 1cd322e..4bb8424 100644
> > --- a/drivers/media/v4l2-core/videobuf2-memops.c
> > +++ b/drivers/media/v4l2-core/videobuf2-memops.c
> > @@ -96,10 +96,10 @@ static void vb2_common_vm_open(struct
> vm_area_struct *vma)
> >  	struct vb2_vmarea_handler *h = vma->vm_private_data;
> >
> >  	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
> > -	       __func__, h, atomic_read(h->refcount), vma->vm_start,
> > +	       __func__, h, refcount_read(h->refcount), vma->vm_start,
> >  	       vma->vm_end);
> >
> > -	atomic_inc(h->refcount);
> > +	refcount_inc(h->refcount);
> >  }
> >
> >  /**
> > @@ -114,7 +114,7 @@ static void vb2_common_vm_close(struct
> vm_area_struct *vma)
> >  	struct vb2_vmarea_handler *h = vma->vm_private_data;
> >
> >  	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
> > -	       __func__, h, atomic_read(h->refcount), vma->vm_start,
> > +	       __func__, h, refcount_read(h->refcount), vma->vm_start,
> >  	       vma->vm_end);
> >
> >  	h->put(h->arg);
> > diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-
> memops.h
> > index 36565c7a..a6ed091 100644
> > --- a/include/media/videobuf2-memops.h
> > +++ b/include/media/videobuf2-memops.h
> > @@ -16,6 +16,7 @@
> >
> >  #include <media/videobuf2-v4l2.h>
> >  #include <linux/mm.h>
> > +#include <linux/refcount.h>
> >
> >  /**
> >   * struct vb2_vmarea_handler - common vma refcount tracking handler
> > @@ -25,7 +26,7 @@
> >   * @arg:	argument for @put callback
> >   */
> >  struct vb2_vmarea_handler {
> > -	atomic_t		*refcount;
> > +	refcount_t		*refcount;
> 
> This is a pointer to refcount, not refcount itself. The refcount is part of
> a memory type specific struct, the types that you change in the following
> three patches. I guess it would still compile and work as separate patches
> but you'd sure get warnings at least.

Actually it doesn't compile without this patch if I remember it correctly back in past when I was initially splitting the patches per variable. 

> 
> How about merging this and the three following patches that change the memop
> refcount types?

Sounds good!

Best Regards,
Elena.
> 
> >  	void			(*put)(void *arg);
> >  	void			*arg;
> >  };
> 
> --
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
