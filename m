Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36917 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaOfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 10:35:45 -0400
Date: Fri, 31 Oct 2014 17:35:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: staging: media: lirc: lirc_zilog.c: replace custom print macros
 with dev_* and pr_*
Message-ID: <20141031143541.GM6890@mwanda>
References: <20141031130600.GA16310@mwanda>
 <20141031142644.GA4166@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031142644.GA4166@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 31, 2014 at 04:26:45PM +0200, Aya Mahfouz wrote:
> On Fri, Oct 31, 2014 at 04:06:00PM +0300, Dan Carpenter wrote:
> > drivers/staging/media/lirc/lirc_zilog.c
> >   1333  /* Close the IR device */
> >   1334  static int close(struct inode *node, struct file *filep)
> >   1335  {
> >   1336          /* find our IR struct */
> >   1337          struct IR *ir = filep->private_data;
> >   1338  
> >   1339          if (ir == NULL) {
> >                     ^^^^^^^^^^
> >   1340                  dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
> >                                 ^^^^^^^^^
> > 
> > I suggest you just delete the error message.  Can "ir" actually be NULL
> > here anyway?
> >
> 
> Since I'm a newbie and this is not my code, I prefer to use pr_err().

This driver doesn't belong to anyone.  Go ahead and take ownership.  The
message is fairly worthless and no one will miss it.

> 
> In general, I can send a new patch to fix the aforementioned warnings.
> Kindly let me know if you prefer that I send a second version of this
> patch.

No.  The first patch was already applied so send a new patch.

regards,
dan carpenter

