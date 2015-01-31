Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49764 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbbAaAeT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2015 19:34:19 -0500
Message-ID: <1422662484.1891.10.camel@palomino.walls.org>
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog: Fix for possible null
 pointer dereference
From: Andy Walls <awalls@md.metrocast.net>
To: Valdis.Kletnieks@vt.edu
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	devel@driverdev.osuosl.org, Gulsah Kose <gulsah.1004@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org,
	Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
	Martin Kaiser <martin@kaiser.cx>, linux-media@vger.kernel.org,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Date: Fri, 30 Jan 2015 19:01:24 -0500
In-Reply-To: <32395.1422623364@turing-police.cc.vt.edu>
References: <1422557288-3617-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <21497.1422569560@turing-police.cc.vt.edu> <20150130130001.GZ6456@mwanda>
	 <32395.1422623364@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2015-01-30 at 08:09 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 30 Jan 2015 16:00:02 +0300, Dan Carpenter said:
> 
> > > > -	if (ir == NULL) {
> > > > -		dev_err(ir->l.dev, "close: no private_data attached to the file
> !\n");
> > >

commit be4aa8157c981a8bb9634b886bf1180f97205259
removed the dprintk(), which didn't depend on ir->l.dev, with this
dev_err() call.  That was the wrong thing to do. pr_info() is probably
the right thing to use, if one doesn't have a struct device instance.  

> > > Yes, the dev_err() call is an obvious thinko.
> > >
> > > However, I'm not sure whether removing it entirely is right either.  If
> > > there *should* be a struct IR * passed there, maybe some other printk()
> > > should be issued, or even a WARN_ON(!ir), or something?
> >
> > We set filep->private_data to non-NULL in open() so I don't think it can
> > be NULL here.
> 
> Then probably the *right* fix is to remove the *entire* if statement, as
> we can't end up doing the 'return -ENODEV'....

The if() clause is here as an artifact of being part of a mass port of
lirc drivers from userspace.  I never removed it, because I needed it
when fixing all the lirc_zilog.c ref counting.

IF I got all the lirc_zilog ref counting right, and the upper layers of
the kernel never call close() in error, then this if() statement is not
needed.

I welcome anyone wishing to audit the ref-counting in lirc_zilog.  It
was mentally exhausting to get to what I think is right.  Maybe I just
tire easily mentally though. :)

-Andy

