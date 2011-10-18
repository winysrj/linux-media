Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab1JRU5U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 16:57:20 -0400
Date: Tue, 18 Oct 2011 13:56:57 -0700
From: Greg KH <gregkh@suse.de>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Joe Perches <joe@perches.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	devel@driverdev.osuosl.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [RESEND PATCH 10/14] staging/media/as102: properly handle
 multiple product names
Message-ID: <20111018205657.GA31243@suse.de>
References: <4E999733.2010802@poczta.onet.pl>
 <4E99F2FC.5030200@poczta.onet.pl>
 <20111016105731.09d66f03@stein>
 <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
 <4E9ADFAE.8050208@redhat.com>
 <20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
 <20111018111251.d7978be8.chmooreck@poczta.onet.pl>
 <20111018220230.13c8436e@darkstar>
 <1318969719.7985.4.camel@Joe-Laptop>
 <20111018225408.4fcd8ec9@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018225408.4fcd8ec9@darkstar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 18, 2011 at 10:54:08PM +0200, Piotr Chmura wrote:
> On Tue, 18 Oct 2011 13:28:39 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Tue, 2011-10-18 at 22:02 +0200, Piotr Chmura wrote:
> > > Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> > []
> > > diff --git linux/drivers/staging/media/as102/as102_fe.c linuxb/drivers/staging/media/as102/as102_fe.c
> > []
> > > @@ -408,6 +408,8 @@
> > >  
> > >  	/* init frontend callback ops */
> > >  	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
> > > +	strncpy(dvb_fe->ops.info.name, as102_dev->name,
> > > +		sizeof(dvb_fe->ops.info.name));
> > 
> > strlcpy?
> > 
> > 
> 
> Can be, but not during moving from another repo.
> There will be time for such fixes in kernel tree.
> Am I right ?

Yes, you are correct, focus on getting the code into the tree first,
then work on fixing up the issues.

greg k-h
