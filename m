Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41460 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbbA3NBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2015 08:01:04 -0500
Date: Fri, 30 Jan 2015 16:00:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	devel@driverdev.osuosl.org, Gulsah Kose <gulsah.1004@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org,
	Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
	Martin Kaiser <martin@kaiser.cx>, linux-media@vger.kernel.org,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog: Fix for possible null
 pointer dereference
Message-ID: <20150130130001.GZ6456@mwanda>
References: <1422557288-3617-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <21497.1422569560@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21497.1422569560@turing-police.cc.vt.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 29, 2015 at 05:12:40PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 29 Jan 2015 19:48:08 +0100, Rickard Strandqvist said:
> > Fix a possible null pointer dereference, there is
> > otherwise a risk of a possible null pointer dereference.
> >
> > This was found using a static code analysis program called cppcheck
> >
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > ---
> >  drivers/staging/media/lirc/lirc_zilog.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> >  	/* find our IR struct */
> >  	struct IR *ir = filep->private_data;
> >
> > -	if (ir == NULL) {
> > -		dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
> 
> Yes, the dev_err() call is an obvious thinko.
> 
> However, I'm not sure whether removing it entirely is right either.  If
> there *should* be a struct IR * passed there, maybe some other printk()
> should be issued, or even a WARN_ON(!ir), or something?

We set filep->private_data to non-NULL in open() so I don't think it can
be NULL here.

regards,
dan carpenter


