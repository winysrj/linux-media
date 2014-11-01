Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54459 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848AbaKAUFc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 16:05:32 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so7973989wgh.25
        for <linux-media@vger.kernel.org>; Sat, 01 Nov 2014 13:05:30 -0700 (PDT)
Date: Sat, 1 Nov 2014 22:05:26 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: staging: media: lirc: lirc_zilog.c: replace custom print macros
 with dev_* and pr_*
Message-ID: <20141101200526.GA2098@localhost.localdomain>
References: <20141031130600.GA16310@mwanda>
 <20141031142644.GA4166@localhost.localdomain>
 <20141031143541.GM6890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031143541.GM6890@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 31, 2014 at 05:35:41PM +0300, Dan Carpenter wrote:
> On Fri, Oct 31, 2014 at 04:26:45PM +0200, Aya Mahfouz wrote:
> > On Fri, Oct 31, 2014 at 04:06:00PM +0300, Dan Carpenter wrote:
> > > drivers/staging/media/lirc/lirc_zilog.c
> > >   1333  /* Close the IR device */
> > >   1334  static int close(struct inode *node, struct file *filep)
> > >   1335  {
> > >   1336          /* find our IR struct */
> > >   1337          struct IR *ir = filep->private_data;
> > >   1338  
> > >   1339          if (ir == NULL) {
> > >                     ^^^^^^^^^^
> > >   1340                  dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
> > >                                 ^^^^^^^^^
> > > 
> > > I suggest you just delete the error message.  Can "ir" actually be NULL
> > > here anyway?
> > >
> > 
> > Since I'm a newbie and this is not my code, I prefer to use pr_err().
> 
> This driver doesn't belong to anyone.  Go ahead and take ownership.  The
> message is fairly worthless and no one will miss it.
> 
ok.
> > 
> > In general, I can send a new patch to fix the aforementioned warnings.
> > Kindly let me know if you prefer that I send a second version of this
> > patch.
> 
> No.  The first patch was already applied so send a new patch.
> 
I will fix the static errors that my patch caused. The warning concerning
the double free will require rewriting some parts of the function and was
not caused by my patch. I have a couple of ideas in mind but I need
sometime to apply them. Greg too is not happy about the coding style of
this driver in general.

> regards,
> dan carpenter
> 

Kind Regards,
Aya Saif El-yazal Mahfouz
